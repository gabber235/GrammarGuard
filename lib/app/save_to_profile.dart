// S in the main window.
import "package:flutter/material.dart";
import "package:grammar_guard/app/library_writes.dart";
import "package:grammar_guard/instructions/library_change.dart";
import "package:grammar_guard/instructions/library_store.dart";
import "package:grammar_guard/instructions/scopes.dart";
import "package:grammar_guard/session/session.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

/// Everything picked for now (instructions, words, model) becomes part of
/// this app's profile. Creates the profile when none matched.
Future<void> saveToProfile(BuildContext context, WidgetRef ref) async {
  final resolved = ref.read(resolvedProvider);
  final source = resolved?.source;
  final messenger = ScaffoldMessenger.of(context);
  if (resolved == null || source == null) {
    messenger.showSnackBar(const SnackBar(content: Text("No app to save a profile for.")));
    return;
  }
  final library = (await ref.read(libraryStoreProvider.future)).library;
  final changes = keepForApp(library, resolved, source);
  final saved = await writeLibrary(
    messenger,
    () => ref.read(libraryStoreProvider.notifier).apply(changes, author: ChangeAuthor.you),
  );
  if (!saved) return;
  final profile = changes.whereType<PutProfile>().last.profile;
  messenger.showSnackBar(SnackBar(content: Text("Saved to the ${profile.name} profile. >undo reverts it.")));
}
