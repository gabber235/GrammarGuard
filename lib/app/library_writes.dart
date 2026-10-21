import "dart:io";

import "package:flutter/material.dart";
import "package:grammar_guard/instructions/library_file.dart";

/// Runs a write to library.yaml from the UI. A write that fails (an invalid
/// change, a broken file, a disk error) says why instead of vanishing.
/// Returns whether it was written.
Future<bool> writeLibrary(ScaffoldMessengerState messenger, Future<void> Function() write) async {
  try {
    await write();
    return true;
  } on LibraryProblem catch (problem) {
    messenger.showSnackBar(SnackBar(content: Text("Not saved. ${problem.message}")));
  } on FileSystemException catch (error) {
    messenger.showSnackBar(SnackBar(content: Text("Not saved. ${error.message}: ${error.path}")));
  }
  return false;
}
