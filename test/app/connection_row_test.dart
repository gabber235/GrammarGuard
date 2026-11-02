import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/app/settings/connection_tile.dart";
import "package:grammar_guard/llm/connections.dart";
import "package:grammar_guard/llm/llm.dart";
import "package:grammar_guard/ui/theme.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class _LateConnections extends Connections {
  _LateConnections(this.loaded, this.saves);

  final Completer<Map<Backend, Connection>> loaded;
  final List<Connection> saves;

  @override
  Future<Map<Backend, Connection>> build() => loaded.future;

  @override
  Future<void> save(Connection connection) async => saves.add(connection);
}

void main() {
  testWidgets("a row shown before the connections load keeps the saved key", (tester) async {
    final loaded = Completer<Map<Backend, Connection>>();
    final saves = <Connection>[];
    await tester.pumpWidget(
      ProviderScope(
        overrides: [connectionsProvider.overrideWith(() => _LateConnections(loaded, saves))],
        child: MaterialApp(
          theme: GgTheme.dark.toThemeData(Brightness.dark),
          home: const Scaffold(body: ConnectionRow(backend: Backend.openai)),
        ),
      ),
    );

    loaded.complete({Backend.openai: const Connection(backend: Backend.openai, enabled: true, apiKey: "sk-saved")});
    await tester.pump();
    await tester.pump();

    expect(tester.widget<TextField>(find.byType(TextField)).controller?.text, "sk-saved");

    // Leaving the page saves what the field holds.
    await tester.pumpWidget(const SizedBox());
    await tester.pump();

    expect(saves, isEmpty, reason: "an empty field would have deleted the key");
  });
}
