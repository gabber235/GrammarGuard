import "dart:ui" as ui;

import "package:flutter_test/flutter_test.dart";

import "../support/tolerant_comparator.dart";

void main() {
  /// A 100 by 100 PNG of one color, with an optional [spot] of 2 by 2
  /// pixels in another.
  Future<List<int>> png(ui.Color color, {ui.Color? spot}) async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder)..drawRect(const ui.Rect.fromLTWH(0, 0, 100, 100), ui.Paint()..color = color);
    if (spot != null) canvas.drawRect(const ui.Rect.fromLTWH(10, 10, 2, 2), ui.Paint()..color = spot);
    final image = await recorder.endRecording().toImage(100, 100);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    return bytes!.buffer.asUint8List();
  }

  final comparator = TolerantComparator(Uri.parse("test/goldens/tolerant_comparator_test.dart"));

  testWidgets("rounding differences pass, visible ones do not, even small", (tester) async {
    await tester.runAsync(() async {
      final base = await png(const ui.Color(0xFF808080));
      expect(await comparator.withinTolerance(base, await png(const ui.Color(0xFF818181))), isTrue);
      expect(await comparator.withinTolerance(base, await png(const ui.Color(0xFF8A8A8A))), isFalse);
      // One pixel of 10,000 may differ a lot (an edge a fraction wider), four may not.
      expect(
        await comparator.withinTolerance(base, await png(const ui.Color(0xFF808080), spot: const ui.Color(0xFFFFFFFF))),
        isFalse,
      );
    });
  });
}
