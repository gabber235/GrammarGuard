import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:grammar_guard/actions/grammar_intents.dart";
import "package:grammar_guard/config/theme.dart";
import "package:grammar_guard/models/diff_option.dart";
import "package:grammar_guard/models/rendering_mode.dart";
import "package:grammar_guard/models/rewrite_intensity.dart";
import "package:grammar_guard/models/styling_option.dart";
import "package:grammar_guard/state/ai_rewrite.dart";
import "package:grammar_guard/state/ai_rewrite_result.dart";
import "package:grammar_guard/state/grammar_state.dart";
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

  // Register global hotkey to show the app (Alt+Shift+G)
  final showHotKey = HotKey(
    key: PhysicalKeyboardKey.keyG,
    modifiers: [HotKeyModifier.alt, HotKeyModifier.shift],
    scope: HotKeyScope.system,
  );

  await hotKeyManager.register(
    showHotKey,
    keyDownHandler: (_) async {
      if (await windowManager.isVisible() && _hideWindow) {
        await windowManager.hide();
      } else {
        await windowManager.show();
        await windowManager.focus();
      }
    },
  );

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
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _loadClipboard();
  }

  Future<void> _loadClipboard() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData?.text != null) {
      ref
          .read(grammarStateProvider.notifier)
          .setInputText(clipboardData!.text!);
      ref.invalidate(aiRewriteProvider);
    }
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowFocus() {
    super.onWindowFocus();
    _loadClipboard();
  }

  @override
  void onWindowBlur() {
    super.onWindowBlur();
    if (_hideWindow) {
      windowManager.hide();
    }
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
      MaterialPageRoute(
        builder: (context) => const ProviderConfiguration(),
      ),
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
                Future.delayed(const Duration(milliseconds: 150), () {
                  if (!mounted) return;
                  if (_hideWindow) {
                    windowManager.hide();
                  }
                });
                return null;
              },
            ),
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (intent) async {
                if (!mounted) return;
                Future.delayed(const Duration(milliseconds: 150), () async {
                  if (!mounted) return;
                  if (_hideWindow) {
                    await windowManager.hide();
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
