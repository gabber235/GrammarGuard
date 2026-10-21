import "package:flutter/widgets.dart";
import "package:grammar_guard/app/app.dart";
import "package:grammar_guard/app/window_setup.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await prepareWindow();
  runApp(const ProviderScope(child: GrammarGuardApp()));
}
