import "package:flutter/widgets.dart";
import "package:grammar_guard/app/app.dart";
import "package:grammar_guard/app/window_setup.dart";
import "package:grammar_guard/platform/platform_providers.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await prepareWindow();
  runApp(
    ProviderScope(
      overrides: [launchedInBackgroundProvider.overrideWithValue(args.contains("--background"))],
      child: const GrammarGuardApp(),
    ),
  );
}
