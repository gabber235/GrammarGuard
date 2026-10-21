import "package:flutter/material.dart";
import "package:grammar_guard/app/settings/settings_page.dart";
import "package:grammar_guard/assistant/assistant.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

/// Lets the tray and the session open pages without a BuildContext.
final appNavigator = GlobalKey<NavigatorState>();

Future<void> openSettings([SettingsSection section = SettingsSection.models]) async {
  await appNavigator.currentState?.push(MaterialPageRoute<void>(builder: (_) => SettingsPage(initial: section)));
}

/// The assistant from anywhere: back to the main window, where it opens.
Future<void> askAssistant(WidgetRef ref, [String message = ""]) async {
  appNavigator.currentState?.popUntil((route) => route.isFirst);
  await ref.read(assistantProvider.notifier).open(message);
}
