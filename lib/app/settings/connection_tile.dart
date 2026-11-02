// One row for every backend, driven
// by Backend.key and Backend.defaultUrl instead of five config widgets.
import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:grammar_guard/llm/catalog.dart";
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

/// One backend. What is typed saves itself: a key soon after it is pasted,
/// and anything on leaving the field or the page, because there is no save
/// button to tell anyone that Enter was needed.
class ConnectionRow extends HookConsumerWidget {
  const ConnectionRow({required this.backend, super.key});

  final Backend backend;

  /// Long enough that typing a key by hand does not save every letter.
  static const saveDelay = Duration(milliseconds: 800);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gg = context.gg;
    final connection = ref.watch(connectionsProvider).value?[backend];
    final check = ref.watch(connectionChecksProvider)[backend];
    final key = useTextEditingController(text: connection?.apiKey ?? "");
    final url = useTextEditingController(text: connection?.baseUrl?.toString() ?? "");
    // Shown before the connections loaded: fill in once they have, or saving
    // on leaving the page would delete the key.
    useEffect(() {
      if (connection != null) {
        key.text = connection.apiKey ?? "";
        url.text = connection.baseUrl?.toString() ?? "";
      }
      return null;
    }, [connection == null]);
    // Leaving the page runs after this widget's ref is gone.
    final store = ref.read(connectionsProvider.notifier);
    final saved = useRef(connection);
    saved.value = connection;
    final pending = useRef<Timer?>(null);

    Future<void> save({bool? enabled}) async {
      final current = saved.value;
      if (current == null) return;
      pending.value?.cancel();
      final typedUrl = url.text.trim();
      // llm_dart joins paths onto the base URL, so it must end in "/". A
      // half typed address keeps the last good one.
      final address = typedUrl.isEmpty ? null : Uri.tryParse(typedUrl.endsWith("/") ? typedUrl : "$typedUrl/");
      final next = Connection(
        backend: backend,
        enabled: enabled ?? current.enabled,
        apiKey: key.text.trim(),
        baseUrl: typedUrl.isEmpty ? null : address ?? current.baseUrl,
      );
      final unchanged =
          next.enabled == current.enabled &&
          next.apiKey == (current.apiKey ?? "").trim() &&
          next.baseUrl == current.baseUrl;
      if (!unchanged) await store.save(next);
    }

    useEffect(
      () => () {
        pending.value?.cancel();
        unawaited(save());
      },
      const [],
    );

    if (connection == null) return const SizedBox.shrink();

    final local = backend.defaultUrl != null;
    final (status, color) = switch ((connection, check)) {
      (Connection(enabled: false), _) => ("Off", gg.pin),
      (Connection(isUsable: false), _) => ("Needs a key", gg.muted),
      (_, CheckRunning()) => ("Checking…", gg.muted),
      (_, CheckRejected()) => ("Key rejected", gg.removed),
      (_, CheckUnknown()) => (local ? "Not reachable" : "Saved, not checked", gg.pin),
      (_, CheckWorking(:final models)) => ("Ready, $models ${models == 1 ? "model" : "models"}", gg.added),
      _ => ("Ready", gg.added),
    };

    Widget field(TextEditingController controller, String hint, {bool secret = false, VoidCallback? onChanged}) =>
        Expanded(
          child: Focus(
            skipTraversal: true,
            canRequestFocus: false,
            onFocusChange: (focused) {
              if (!focused) unawaited(save());
            },
            child: TextField(
              controller: controller,
              obscureText: secret,
              enabled: connection.enabled,
              decoration: InputDecoration(hintText: hint),
              onChanged: onChanged == null ? null : (_) => onChanged(),
              onSubmitted: (_) => save(),
            ),
          ),
        );

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
                    Flexible(
                      child: Text(
                        status,
                        style: TextStyle(fontSize: 12, color: gg.muted),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (backend.key != KeyNeed.none)
            field(
              key,
              backend.key == KeyNeed.optional ? "API key (optional)" : "API key",
              secret: true,
              onChanged: () {
                pending.value?.cancel();
                pending.value = Timer(saveDelay, () => unawaited(save()));
              },
            ),
          if (backend.key != KeyNeed.none && backend.defaultUrl != null) const SizedBox(width: 8),
          if (backend.defaultUrl case final hint?) field(url, hint),
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
