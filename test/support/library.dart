import "dart:io";

import "package:grammar_guard/instructions/instruction.dart";
import "package:grammar_guard/instructions/library_file.dart";

/// The bundled starter setup, as every new user gets it.
Library bundled() => parseLibrary(File("assets/library.yaml").readAsStringSync());
