import "dart:async";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:grammar_guard/app/navigation.dart";
import "package:grammar_guard/app/rewrite_screen.dart";
import "package:grammar_guard/app/tray.dart";
import "package:grammar_guard/llm/catalog.dart";
import "package:grammar_guard/session/hotkey_binding.dart";
import "package:grammar_guard/session/session.dart";
import "package:grammar_guard/settings/hotkey_setting.dart";
import "package:grammar_guard/ui/glass.dart";
import "package:grammar_guard/ui/theme.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class GrammarGuardApp extends ConsumerWidget {
  const GrammarGuardApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref
      // Keeps the hotkey registered and the tray icon alive for the app's life.
      ..watch(hotkeyBindingProvider)
      ..watch(sessionActionsProvider) // listens to window blur and close
      ..watch(trayProvider)
      // Toasts from the session ("Copied", "Select some text first").
      ..listen(sessionProvider.select((s) => s.notice), (_, notice) {
        if (notice == null) return;
        _messenger.currentState?.showSnackBar(SnackBar(content: Text(notice), duration: const Duration(seconds: 2)));
      })
      // First launch, or every key removed: go straight to Settings.
      ..listen(modelCatalogProvider, (previous, next) {
        // Only on arriving at no models: a reload while Settings is open
        // (the first key just saved) briefly repeats the empty list.
        final arrived = !next.isLoading && (next.value?.isEmpty ?? false);
        final wasEmpty = previous?.value?.isEmpty ?? false;
        if (arrived && !wasEmpty) unawaited(openSettings());
      });

    final readingSize = ref.watch(readingSizeProvider).value ?? ReadingSize.standard;
    final popup = ref.watch(isPopupProvider);
    return MaterialApp(
      title: "GrammarGuard",
      navigatorKey: appNavigator,
      scaffoldMessengerKey: _messenger,
      theme: GgTheme.light.copyWith(textSize: readingSize).toThemeData(Brightness.light),
      darkTheme: GgTheme.dark.copyWith(textSize: readingSize).toThemeData(Brightness.dark),
      home: const RewriteScreen(),
      // One window surface for every page, dialog and toast. macOS keeps a
      // hidden title bar (window_setup.dart), so the normal window leaves
      // room for the traffic lights; the popup hides them.
      builder: (context, child) => GlassSurface(
        child: Padding(
          padding: EdgeInsets.only(top: defaultTargetPlatform == TargetPlatform.macOS && !popup ? 28 : 0),
          child: child,
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

final _messenger = GlobalKey<ScaffoldMessengerState>();
