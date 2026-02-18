import "dart:async";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:grammar_guard/actions/grammar_intents.dart";
import "package:grammar_guard/config/theme.dart";
import "package:grammar_guard/models/diff_option.dart";
import "package:grammar_guard/models/rendering_mode.dart";
import "package:grammar_guard/models/rewrite_intensity.dart";
import "package:grammar_guard/models/styling_option.dart";
import "package:grammar_guard/pages/selection_editor_page.dart";
import "package:grammar_guard/state/ai_rewrite.dart";
import "package:grammar_guard/state/ai_rewrite_result.dart";
import "package:grammar_guard/state/grammar_state.dart";
import "package:grammar_guard/state/window_lifecycle.dart";
import "package:grammar_guard/widgets/always_focused.dart";
import "package:grammar_guard/widgets/api_key_checker.dart";
import "package:grammar_guard/widgets/footer.dart";
import "package:grammar_guard/widgets/model_selector.dart";
import "package:grammar_guard/widgets/options_group.dart";
import "package:grammar_guard/widgets/provider_configuration.dart";
import "package:grammar_guard/widgets/text_display.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:hotkey_manager/hotkey_manager.dart";
import "package:window_manager/window_manager.dart";

const bool _hideWindow = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await hotKeyManager.unregisterAll();

  await windowManager.ensureInitialized();

  final windowOptions = const WindowOptions(
    size: Size(1000, 600),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: true,
    titleBarStyle: TitleBarStyle.hidden,
    alwaysOnTop: true,
    title: "Grammar Guard",
    windowButtonVisibility: false,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const ProviderScope(child: GrammarGuard()));
}

class GrammarGuard extends StatelessWidget {
  const GrammarGuard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Grammar Guard",
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
      shortcuts: {
        ...WidgetsApp.defaultShortcuts,
        const SingleActivator(LogicalKeyboardKey.keyP, control: true):
            const PreviousFocusIntent(),
        const SingleActivator(LogicalKeyboardKey.keyN, control: true):
            const NextFocusIntent(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulHookConsumerWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with WindowListener {
  HotKey? _showHotKey;
  ProviderSubscription<bool>? _generationActivitySubscription;

  void _log(String message) {
    debugPrint("[window-flow] $message");
  }

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    unawaited(windowManager.setPreventClose(true));
    unawaited(_registerHotKey());
    _listenGenerationTransitions();
    unawaited(_syncClipboardText());
  }

  Future<void> _registerHotKey() async {
    final showHotKey = HotKey(
      key: PhysicalKeyboardKey.keyG,
      modifiers: [HotKeyModifier.alt, HotKeyModifier.shift],
      scope: HotKeyScope.system,
    );

    await hotKeyManager.register(
      showHotKey,
      keyDownHandler: (_) async {
        final isVisible = await windowManager.isVisible();
        _log("hotkey pressed. visible=$isVisible hideWindow=$_hideWindow");
        if (isVisible && _hideWindow) {
          _log("hotkey path hide window");
          await _hideWindowAndMarkHidden();
          return;
        }

        _log("hotkey path show window");
        await _showWindowAndRefreshIfNeeded();
      },
    );
    _showHotKey = showHotKey;
    _log("hotkey registered");
  }

  Future<void> _hideWindowAndMarkHidden() async {
    _log("hide window requested");
    await windowManager.hide();
    ref.read(windowLifecycleProvider.notifier).onWindowHidden();
    final lifecycle = ref.read(windowLifecycleProvider);
    _log(
      "hide completed. visible=${lifecycle.isVisible} refreshTrigger=${lifecycle.refreshTrigger.name}",
    );
  }

  Future<void> _showWindowAndRefreshIfNeeded() async {
    final isVisible = await windowManager.isVisible();
    _log("show requested. currentlyVisible=$isVisible");
    if (!isVisible) {
      await windowManager.show();
      _log("window shown");
      ref.read(windowLifecycleProvider.notifier).onWindowShown();
      final shownState = ref.read(windowLifecycleProvider);
      _log(
        "lifecycle marked shown. refreshTrigger=${shownState.refreshTrigger.name} lastHash=${shownState.lastClipboardHash}",
      );
      await _refreshClipboardOnOpenIfNeeded();
    }
    await windowManager.focus();
    _log("window focused");
  }

  void _listenGenerationTransitions() {
    _generationActivitySubscription = ref.listenManual<bool>(
      rewriteGenerationActivityProvider,
      (previous, next) {
        final notifier = ref.read(windowLifecycleProvider.notifier);
        _log("generation activity changed. previous=$previous next=$next");
        notifier.setGenerationActivity(isActive: next);
        final wasActive = previous ?? false;
        if (!wasActive || next) {
          final lifecycle = ref.read(windowLifecycleProvider);
          _log(
            "generation transition ignored. isGenerating=${lifecycle.isGenerating} closeAllowed=${lifecycle.closeAllowed}",
          );
          return;
        }

        notifier.onGenerationFinished();
        final lifecycle = ref.read(windowLifecycleProvider);
        _log(
          "generation finished transition applied. pendingHideAfterCompletion=${lifecycle.hideAfterCompletionOnBlur}",
        );
      },
    );
  }

  String _hashClipboardText(String text) {
    return text.trim().hashCode.toString();
  }

  Future<void> _syncClipboardText() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    final clipboardText = clipboardData?.text;
    if (clipboardText == null) {
      _log("initial clipboard sync skipped. clipboard is empty");
      return;
    }

    ref.read(grammarStateProvider.notifier).setInputText(clipboardText);
    ref.invalidate(aiRewriteProvider);

    final clipboardHash = _hashClipboardText(clipboardText);
    ref.read(windowLifecycleProvider.notifier).onClipboardSynced(clipboardHash);
    _log(
      "initial clipboard synced. chars=${clipboardText.length} hash=$clipboardHash",
    );
  }

  Future<void> _refreshClipboardOnOpenIfNeeded() async {
    _log("refresh on open check started");
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    final clipboardText = clipboardData?.text;
    if (clipboardText == null) {
      _log("refresh on open skipped. clipboard is empty");
      return;
    }

    final clipboardHash = _hashClipboardText(clipboardText);
    final notifier = ref.read(windowLifecycleProvider.notifier);
    final beforeState = ref.read(windowLifecycleProvider);
    _log(
      "refresh evaluate input. hash=$clipboardHash trigger=${beforeState.refreshTrigger.name} lastHash=${beforeState.lastClipboardHash} generating=${beforeState.isGenerating}",
    );
    notifier.evaluateRefresh(clipboardHash);

    final policy = ref.read(windowLifecyclePolicyProvider);
    if (!policy.shouldRefresh) {
      final afterState = ref.read(windowLifecycleProvider);
      _log(
        "refresh not applied. shouldRefresh=${policy.shouldRefresh} trigger=${afterState.refreshTrigger.name} lastHash=${afterState.lastClipboardHash} generating=${afterState.isGenerating}",
      );
      return;
    }

    ref.read(grammarStateProvider.notifier).setInputText(clipboardText);
    ref.invalidate(aiRewriteProvider);
    notifier.onClipboardSynced(clipboardHash);
    notifier.acknowledgeRefresh();
    _log("refresh applied. chars=${clipboardText.length} hash=$clipboardHash");
  }

  @override
  void dispose() {
    _generationActivitySubscription?.close();
    final showHotKey = _showHotKey;
    if (showHotKey != null) {
      unawaited(hotKeyManager.unregister(showHotKey));
    }
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowBlur() {
    super.onWindowBlur();
    final notifier = ref.read(windowLifecycleProvider.notifier);
    notifier.onWindowBlurred();

    final policy = ref.read(windowLifecyclePolicyProvider);
    final lifecycle = ref.read(windowLifecycleProvider);
    _log(
      "window blur. shouldHide=${policy.shouldHide} generating=${lifecycle.isGenerating} pendingHideAfterCompletion=${lifecycle.hideAfterCompletionOnBlur}",
    );
    if (!policy.shouldHide || !_hideWindow) {
      _log("window blur did not hide");
      return;
    }

    unawaited(_hideWindowAndMarkHidden());
    notifier.acknowledgeHide();
    _log("window blur hide requested and acknowledged");
  }

  @override
  void onWindowClose() {
    ref.read(windowLifecycleProvider.notifier).onCloseRequested();
    final policy = ref.read(windowLifecyclePolicyProvider);
    final lifecycle = ref.read(windowLifecycleProvider);
    _log(
      "window close requested. canClose=${policy.canClose} generating=${lifecycle.isGenerating}",
    );
    if (!policy.canClose) {
      _log("window close blocked because generation is active");
      return;
    }
    _log("window close allowed. destroying window");
    windowManager.destroy();
  }

  void _showModelSelector() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const ModelSelector(),
    );
  }

  void _showProviderConfiguration() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ProviderConfiguration()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(grammarStateProvider);
    final scrollController = useScrollController();

    return ConfigurationChecker(
      child: Shortcuts(
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.keyM): ToggleStylingIntent(
            StylingOption.markdown,
          ),
          LogicalKeySet(LogicalKeyboardKey.keyL): ToggleStylingIntent(
            StylingOption.latex,
          ),
          LogicalKeySet(LogicalKeyboardKey.digit1): SetIntensityIntent(
            RewriteIntensity.fixOnly,
          ),
          LogicalKeySet(LogicalKeyboardKey.digit2): SetIntensityIntent(
            RewriteIntensity.polish,
          ),
          LogicalKeySet(LogicalKeyboardKey.digit3): SetIntensityIntent(
            RewriteIntensity.enhance,
          ),
          LogicalKeySet(LogicalKeyboardKey.digit4): SetIntensityIntent(
            RewriteIntensity.rewrite,
          ),
          LogicalKeySet(LogicalKeyboardKey.keyH):
              const ToggleDiffOptionIntent(),
          LogicalKeySet(LogicalKeyboardKey.keyR): const ToggleRenderingIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowUp): const TextScrollIntent(
            TextScrollDirection.up,
          ),
          LogicalKeySet(LogicalKeyboardKey.arrowDown): const TextScrollIntent(
            TextScrollDirection.down,
          ),
          LogicalKeySet(LogicalKeyboardKey.keyJ): const TextScrollIntent(
            TextScrollDirection.down,
          ),
          LogicalKeySet(LogicalKeyboardKey.keyK): const TextScrollIntent(
            TextScrollDirection.up,
          ),
          LogicalKeySet(LogicalKeyboardKey.keyU): const TextScrollIntent(
            TextScrollDirection.up,
            amount: 0.5,
          ),
          LogicalKeySet(LogicalKeyboardKey.keyD): const TextScrollIntent(
            TextScrollDirection.down,
            amount: 0.5,
          ),
          LogicalKeySet(LogicalKeyboardKey.keyS):
              const ShowModelSelectorIntent(),
          LogicalKeySet(LogicalKeyboardKey.keyC):
              const ShowProviderConfigurationIntent(),
          LogicalKeySet(LogicalKeyboardKey.tab):
              const OpenSelectionEditorIntent(),
        },
        child: Actions(
          actions: {
            ToggleStylingIntent: CallbackAction<ToggleStylingIntent>(
              onInvoke: (intent) {
                if (!mounted) return;
                ref
                    .read(grammarStateProvider.notifier)
                    .toggleStyling(intent.option);
                return null;
              },
            ),
            SetIntensityIntent: CallbackAction<SetIntensityIntent>(
              onInvoke: (intent) {
                if (!mounted) return;
                ref
                    .read(grammarStateProvider.notifier)
                    .setRewriteIntensity(intent.intensity);
                return null;
              },
            ),
            DismissIntent: CallbackAction<DismissIntent>(
              onInvoke: (intent) {
                final notifier = ref.read(windowLifecycleProvider.notifier);
                notifier.onEscapePressed();
                final policy = ref.read(windowLifecyclePolicyProvider);
                _log("escape pressed. shouldHide=${policy.shouldHide}");
                if (policy.shouldHide && _hideWindow) {
                  unawaited(_hideWindowAndMarkHidden());
                  notifier.acknowledgeHide();
                  _log("escape hide requested and acknowledged");
                }
                return null;
              },
            ),
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (intent) async {
                if (!mounted) return;
                Future.delayed(const Duration(milliseconds: 150), () async {
                  if (!mounted) return;
                  if (_hideWindow) {
                    await _hideWindowAndMarkHidden();
                  }
                  final result = ref.read(aiRewriteProvider).value;
                  final outputText = switch (result) {
                    TextResult(text: final text) => text,
                    ThinkingTextResult(text: final text) => text,
                    _ => "",
                  };
                  if (outputText.isNotEmpty) {
                    await Clipboard.setData(ClipboardData(text: outputText));
                  }
                });
                return null;
              },
            ),
            ToggleDiffOptionIntent: CallbackAction<ToggleDiffOptionIntent>(
              onInvoke: (intent) {
                if (!mounted) return;
                ref.read(diffOptionProvider.notifier).toggle();
                return null;
              },
            ),
            ToggleRenderingIntent: CallbackAction<ToggleRenderingIntent>(
              onInvoke: (intent) {
                if (!mounted) return;
                ref.read(renderingModeProvider.notifier).toggle();
                return null;
              },
            ),
            TextScrollIntent: CallbackAction<TextScrollIntent>(
              onInvoke: (intent) {
                final currentPosition = scrollController.position.pixels;
                final viewportHeight =
                    scrollController.position.viewportDimension;
                final maxScroll = scrollController.position.maxScrollExtent;
                final scrollAmount = viewportHeight * intent.amount;

                double targetPosition;
                if (intent.direction == TextScrollDirection.up) {
                  targetPosition = (currentPosition - scrollAmount).clamp(
                    0,
                    maxScroll,
                  );
                } else {
                  targetPosition = (currentPosition + scrollAmount).clamp(
                    0,
                    maxScroll,
                  );
                }

                scrollController.animateTo(
                  targetPosition,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeInOut,
                );
                return null;
              },
            ),
            ShowModelSelectorIntent: CallbackAction<ShowModelSelectorIntent>(
              onInvoke: (intent) {
                if (!mounted) return;
                _showModelSelector();
                return null;
              },
            ),
            ShowProviderConfigurationIntent:
                CallbackAction<ShowProviderConfigurationIntent>(
                  onInvoke: (intent) {
                    if (!mounted) return;
                    _showProviderConfiguration();
                    return null;
                  },
                ),
            OpenSelectionEditorIntent:
                CallbackAction<OpenSelectionEditorIntent>(
                  onInvoke: (intent) {
                    if (!mounted) return;
                    final diffs = ref.read(diffsProvider);
                    if (diffs.isEmpty) return null;
                    SelectionEditorPage.show(context, diffs);
                    return null;
                  },
                ),
          },
          child: AlwaysFocused(
            child: Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 20,
                    right: 20,
                    bottom: 10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      OptionsGroup(
                        enabledStyling: state.enabledStyling,
                        selectedIntensity: state.rewriteIntensity,
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: TextDisplay(scrollController: scrollController),
                      ),
                      const SizedBox(height: 10),
                      const Footer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Map<String, dynamic> stringMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return value.map((key, value) => MapEntry(key.toString(), value));
  }
  return {};
}
