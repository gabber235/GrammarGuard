// `just demo discord` runs the real app with a fake
// model and a fake source app: no key, no network, no permissions.
import "package:flutter/widgets.dart";
import "package:grammar_guard/app/app.dart";
import "package:grammar_guard/app/window_setup.dart";
import "package:grammar_guard/llm/gateway.dart";
import "package:grammar_guard/platform/fakes.dart";
import "package:grammar_guard/platform/platform_providers.dart";
import "package:grammar_guard/platform/ports.dart";
import "package:grammar_guard/platform/scripted_llm.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await prepareWindow();
  final scenario = args.firstOrNull ?? "discord";
  final bridge = FakeTextBridge(
    selection: "hey everyone, its release day! lmk if anything breaks",
    source: const SourceApp(id: "com.hnc.discord", name: "Discord", processId: 1),
  );
  final model = ScriptedLlm()..delay = Duration(milliseconds: scenario == "slow" ? 250 : 40);
  for (var i = 0; i < 50; i++) {
    switch (scenario) {
      case "error":
        model.fail("429: rate limit reached for this key.");
      case "long":
        model.reply([for (var p = 0; p < 40; p++) ..._words, "\n\n"]);
      case _:
        model.reply(_words);
    }
  }
  runApp(
    ProviderScope(
      overrides: [
        textBridgeProvider.overrideWithValue(bridge),
        llmGatewayProvider.overrideWithValue(model),
        // The real window and hotkey stay, so the demo feels like the app.
      ],
      child: const GrammarGuardApp(),
    ),
  );
}

const _words = ["hey everyone, ", "it's release day! ", "Let me know ", "if anything breaks."];
