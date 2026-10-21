// One row for every backend, driven
// by Backend.key and Backend.defaultUrl instead of five config widgets.
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:grammar_guard/llm/connections.dart";
import "package:grammar_guard/llm/llm.dart";
import "package:grammar_guard/ui/surfaces.dart";
import "package:grammar_guard/ui/theme.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

/// Every backend in one panel, one row each: name and status, its key or
/// server address, and the switch.
class ConnectionList extends StatelessWidget {
  const ConnectionList({super.key});

  @override
  Widget build(BuildContext context) => Panel(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Column(
      children: [
        for (final (i, backend) in Backend.values.indexed) ...[
          if (i > 0) Divider(color: context.gg.hairline, indent: 16, endIndent: 16),
          ConnectionRow(backend: backend),
        ],
      ],
    ),
  );
}

class ConnectionRow extends HookConsumerWidget {
  const ConnectionRow({required this.backend, super.key});

  final Backend backend;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gg = context.gg;
    final connection = ref.watch(connectionsProvider).value?[backend];
    final key = useTextEditingController(text: connection?.apiKey ?? "");
    final url = useTextEditingController(text: connection?.baseUrl?.toString() ?? "");
    if (connection == null) return const SizedBox.shrink();

    Future<void> save({bool? enabled}) {
      final typedUrl = url.text.trim();
      return ref
          .read(connectionsProvider.notifier)
          .save(
            Connection(
              backend: backend,
              enabled: enabled ?? connection.enabled,
              apiKey: key.text,
              // llm_dart joins paths onto the base URL, so it must end in "/".
              baseUrl: typedUrl.isEmpty ? null : Uri.parse(typedUrl.endsWith("/") ? typedUrl : "$typedUrl/"),
            ),
          );
    }

    final (status, color) = switch (connection) {
      Connection(enabled: false) => ("Off", gg.pin),
      Connection(isUsable: true) => ("Ready", gg.added),
      _ => ("Needs a key", gg.muted),
    };
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
      child: Row(
        children: [
          SizedBox(
            width: 170,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(backend.label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 6),
                    Text(status, style: TextStyle(fontSize: 12, color: gg.muted)),
                  ],
                ),
              ],
            ),
          ),
          if (backend.key != KeyNeed.none)
            Expanded(
              child: TextField(
                controller: key,
                obscureText: true,
                enabled: connection.enabled,
                decoration: InputDecoration(
                  hintText: backend.key == KeyNeed.optional ? "API key (optional)" : "API key",
                ),
                onSubmitted: (_) => save(),
              ),
            ),
          if (backend.key != KeyNeed.none && backend.defaultUrl != null) const SizedBox(width: 8),
          if (backend.defaultUrl != null)
            Expanded(
              child: TextField(
                controller: url,
                enabled: connection.enabled,
                decoration: InputDecoration(hintText: backend.defaultUrl),
                onSubmitted: (_) => save(),
              ),
            ),
          if (backend.key == KeyNeed.none && backend.defaultUrl == null) const Spacer(),
          const SizedBox(width: 12),
          Switch(
            value: connection.enabled,
            onChanged: (on) => save(enabled: on),
          ),
        ],
      ),
    );
  }
}
