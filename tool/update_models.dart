// Run by `prices` (devenv). Writes assets/models.json.
import "dart:convert";
import "dart:io";

/// models.dev provider id to GrammarGuard backend name.
const _providers = {
  "anthropic": "anthropic",
  "openai": "openai",
  "google": "google",
  "deepseek": "deepseek",
  "xai": "xai",
  "groq": "groq",
  "openrouter": "openrouter",
};

Future<void> main() async {
  final client = HttpClient();
  final request = await client.getUrl(Uri.parse("https://models.dev/api.json"));
  final body = await (await request.close()).transform(utf8.decoder).join();
  client.close();

  final all = jsonDecode(body) as Map<String, dynamic>;
  final out = <String, Map<String, Object>>{};
  for (final MapEntry(key: source, value: backend) in _providers.entries) {
    final models =
        (all[source]["models"] as Map<String, dynamic>).entries
            .where(
              (e) =>
                  e.value["cost"] is Map &&
                  // Only text in, text out models are useful for rewriting.
                  ((e.value["modalities"]?["output"] as List?)?.contains("text") ?? true),
            )
            .toList()
          // Cheapest first, newest first among equals: with no default model
          // set, the first one in the catalog is a fast, cheap pick.
          ..sort((a, b) {
            final byPrice = (a.value["cost"]["output"] as num).compareTo(b.value["cost"]["output"] as num);
            if (byPrice != 0) return byPrice;
            return "${b.value["release_date"]}".compareTo("${a.value["release_date"]}");
          });
    out[backend] = {
      for (final MapEntry(key: id, value: m) in models)
        id: {
          "label": m["name"],
          "in": m["cost"]["input"],
          "out": m["cost"]["output"],
          // The assistant needs tool calls; image and some reasoning models
          // have none.
          "tools": m["tool_call"] == true,
        },
    };
  }
  const encoder = JsonEncoder.withIndent("  ");
  await File("assets/models.json").writeAsString("${encoder.convert(out)}\n");
  stdout.writeln("Wrote ${out.values.fold(0, (n, m) => n + m.length)} models.");
}
