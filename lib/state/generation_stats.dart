import "package:grammar_guard/state/ai_usage.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "generation_stats.g.dart";

enum GenerationStatsStatus { idle, loading, streaming, completed, error }

class GenerationStatsSnapshot {
  const GenerationStatsSnapshot({
    required this.status,
    required this.startedAt,
    required this.completedAt,
    required this.totalGenerationTime,
    required this.firstTextDeltaAt,
    required this.timeToFirstToken,
    required this.generatedCharacterCount,
    required this.estimatedCompletionTokenCount,
    required this.completionTokenCount,
    required this.finalTokensPerSecond,
  });

  const GenerationStatsSnapshot.initial()
    : status = GenerationStatsStatus.idle,
      startedAt = null,
      completedAt = null,
      totalGenerationTime = null,
      firstTextDeltaAt = null,
      timeToFirstToken = null,
      generatedCharacterCount = 0,
      estimatedCompletionTokenCount = 0,
      completionTokenCount = null,
      finalTokensPerSecond = null;

  final GenerationStatsStatus status;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final Duration? totalGenerationTime;
  final DateTime? firstTextDeltaAt;
  final Duration? timeToFirstToken;
  final int generatedCharacterCount;
  final int estimatedCompletionTokenCount;
  final int? completionTokenCount;
  final double? finalTokensPerSecond;

  bool get isActive {
    return status == GenerationStatsStatus.loading ||
        status == GenerationStatsStatus.streaming;
  }

  Duration elapsedAt(DateTime now) {
    final started = startedAt;
    if (isActive && started != null) {
      return now.difference(started);
    }

    return totalGenerationTime ?? Duration.zero;
  }

  double liveEstimatedTokensPerSecond(Duration elapsed) {
    final seconds = elapsed.inMilliseconds / 1000;
    if (seconds <= 0) {
      return 0;
    }

    return (generatedCharacterCount / 4) / seconds;
  }

  String loadingTimeTooltipText() {
    final loadingTime = timeToFirstToken;
    if (loadingTime == null) {
      return "Loading time not available yet";
    }

    return "Loading ${_formatDurationForTooltip(loadingTime)}";
  }

  GenerationStatsSnapshot copyWith({
    GenerationStatsStatus? status,
    DateTime? startedAt,
    DateTime? completedAt,
    Duration? totalGenerationTime,
    DateTime? firstTextDeltaAt,
    Duration? timeToFirstToken,
    int? generatedCharacterCount,
    int? estimatedCompletionTokenCount,
    int? completionTokenCount,
    double? finalTokensPerSecond,
  }) {
    return GenerationStatsSnapshot(
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      totalGenerationTime: totalGenerationTime ?? this.totalGenerationTime,
      firstTextDeltaAt: firstTextDeltaAt ?? this.firstTextDeltaAt,
      timeToFirstToken: timeToFirstToken ?? this.timeToFirstToken,
      generatedCharacterCount:
          generatedCharacterCount ?? this.generatedCharacterCount,
      estimatedCompletionTokenCount:
          estimatedCompletionTokenCount ?? this.estimatedCompletionTokenCount,
      completionTokenCount: completionTokenCount ?? this.completionTokenCount,
      finalTokensPerSecond: finalTokensPerSecond ?? this.finalTokensPerSecond,
    );
  }
}

@Riverpod(keepAlive: true)
class GenerationStats extends _$GenerationStats {
  Stopwatch? _stopwatch;

  @override
  GenerationStatsSnapshot build() {
    return const GenerationStatsSnapshot.initial();
  }

  void start() {
    final now = DateTime.now();
    _stopwatch = Stopwatch()..start();
    state = GenerationStatsSnapshot(
      status: GenerationStatsStatus.loading,
      startedAt: now,
      completedAt: null,
      totalGenerationTime: null,
      firstTextDeltaAt: null,
      timeToFirstToken: null,
      generatedCharacterCount: 0,
      estimatedCompletionTokenCount: 0,
      completionTokenCount: null,
      finalTokensPerSecond: null,
    );
  }

  void recordTextDelta(String delta) {
    final stopwatch = _stopwatch;
    if (stopwatch == null) {
      return;
    }

    final isFirstTextDelta = state.firstTextDeltaAt == null;
    final newCharacterCount = state.generatedCharacterCount + delta.length;
    final now = DateTime.now();

    state = state.copyWith(
      status: GenerationStatsStatus.streaming,
      firstTextDeltaAt: isFirstTextDelta ? now : state.firstTextDeltaAt,
      timeToFirstToken: isFirstTextDelta
          ? stopwatch.elapsed
          : state.timeToFirstToken,
      generatedCharacterCount: newCharacterCount,
      estimatedCompletionTokenCount: (newCharacterCount / 4).round(),
    );
  }

  void recordUsage(RequestUsage usage) {
    final elapsed = _stopwatch?.elapsed ?? state.totalGenerationTime;
    if (elapsed == null) {
      return;
    }

    final seconds = elapsed.inMilliseconds / 1000;
    final finalSpeed = seconds <= 0
        ? 0.0
        : usage.completionTokenCount / seconds;

    state = state.copyWith(
      status: GenerationStatsStatus.completed,
      totalGenerationTime: elapsed,
      completionTokenCount: usage.completionTokenCount,
      finalTokensPerSecond: finalSpeed,
    );
  }

  void markError() {
    final elapsed = _stopwatch?.elapsed ?? state.totalGenerationTime;
    state = state.copyWith(
      status: GenerationStatsStatus.error,
      totalGenerationTime: elapsed,
      completedAt: DateTime.now(),
    );
  }

  void finish() {
    final stopwatch = _stopwatch;
    if (stopwatch == null) {
      return;
    }

    final elapsed = stopwatch.elapsed;
    stopwatch.stop();
    _stopwatch = null;

    if (state.status == GenerationStatsStatus.completed ||
        state.status == GenerationStatsStatus.error) {
      state = state.copyWith(
        completedAt: state.completedAt ?? DateTime.now(),
        totalGenerationTime: state.totalGenerationTime ?? elapsed,
      );
      return;
    }

    state = state.copyWith(
      status: GenerationStatsStatus.completed,
      completedAt: DateTime.now(),
      totalGenerationTime: elapsed,
    );
  }

  Duration elapsedNow() {
    return _stopwatch?.elapsed ?? state.totalGenerationTime ?? Duration.zero;
  }
}

String _formatDurationForTooltip(Duration duration) {
  final seconds = duration.inMilliseconds / 1000;
  return "${seconds.toStringAsFixed(1)}s";
}
