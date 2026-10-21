import "dart:typed_data";
import "dart:ui" as ui;

import "package:flutter_test/flutter_test.dart";

/// Golden comparison that ignores rounding. Images pass when every pixel's
/// color channels are within [tolerance] (out of 255), except at most
/// [outliers] of the pixels.
///
/// Renderers differ per OS and Flutter version in two small ways: they round
/// translucent fills by 1 over large areas (up to 2.6% of the pixels between
/// macOS and CI's Linux), and text can measure a fraction of a pixel wider,
/// moving one column of an edge (24 pixels). Counting differing pixels
/// cannot tell the first apart from a real change, and allowing it would let
/// real changes through; a changed word or color differs by far more, over
/// hundreds of pixels.
class TolerantComparator extends LocalFileComparator {
  TolerantComparator(super.testFile, {this.tolerance = 2, this.outliers = 0.0001});

  final int tolerance;

  /// The share of pixels that may differ by more than [tolerance]: 60 of
  /// the 600,000 in a screen.
  final double outliers;

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final goldenBytes = await getGoldenBytes(golden);
    final result = await GoldenFileComparator.compareLists(imageBytes, goldenBytes);
    if (result.passed || await withinTolerance(imageBytes, goldenBytes)) return true;
    await generateFailureOutput(result, golden, basedir);
    return false;
  }

  /// Whether two encoded images have the same size and all but [outliers]
  /// of their pixels within [tolerance].
  Future<bool> withinTolerance(List<int> a, List<int> b) async {
    final (first, second) = (await _rgba(a), await _rgba(b));
    if (first == null || second == null || first.$1 != second.$1 || first.$2.length != second.$2.length) {
      return false;
    }
    final (x, y) = (first.$2, second.$2);
    final pixels = x.length ~/ 4;
    var off = 0;
    for (var p = 0; p < pixels; p++) {
      for (var c = p * 4; c < p * 4 + 4; c++) {
        if ((x[c] - y[c]).abs() > tolerance) {
          if (++off > pixels * outliers) return false;
          break;
        }
      }
    }
    return true;
  }

  static Future<(ui.Size, Uint8List)?> _rgba(List<int> encoded) async {
    final codec = await ui.instantiateImageCodec(Uint8List.fromList(encoded));
    final image = (await codec.getNextFrame()).image;
    final bytes = await image.toByteData();
    final size = ui.Size(image.width.toDouble(), image.height.toDouble());
    image.dispose();
    return bytes == null ? null : (size, bytes.buffer.asUint8List());
  }
}
