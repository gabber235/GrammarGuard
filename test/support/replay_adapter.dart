import "dart:convert";
import "dart:io";
import "dart:typed_data";

import "package:dio/dio.dart";

/// Answers HTTP requests from recorded files, including SSE streams, so
/// provider tests run offline and exactly the same every time.
/// Record a fixture once: curl -N ... > test/fixtures/claude/stream.sse
class ReplayAdapter implements HttpClientAdapter {
  ReplayAdapter(this.fixtures);

  /// Every request fails as if offline. For flow tests.
  ReplayAdapter.offline() : fixtures = const {};

  /// URL path to fixture file.
  final Map<String, String> fixtures;

  /// The bodies the code under test sent, for asserting on the request.
  final requests = <Map<String, dynamic>>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (requestStream != null) {
      final body = await utf8.decodeStream(requestStream.map((b) => b.toList()));
      requests.add(jsonDecode(body) as Map<String, dynamic>);
    }
    final fixture = fixtures[options.uri.path];
    if (fixture == null) {
      throw DioException.connectionError(requestOptions: options, reason: "No fixture for ${options.uri.path}");
    }
    final file = File(fixture);
    final isStream = fixture.endsWith(".sse");
    return ResponseBody(
      // Chunk by line so the parser sees the stream arrive in pieces.
      file
          .openRead()
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .map((line) => Uint8List.fromList(utf8.encode("$line\n"))),
      200,
      headers: {
        Headers.contentTypeHeader: [if (isStream) "text/event-stream" else "application/json"],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
