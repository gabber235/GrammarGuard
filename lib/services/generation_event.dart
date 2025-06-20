import "package:grammar_guard/state/ai_usage.dart";

sealed class GenerationEvent {
  const GenerationEvent();
}

class LoadingEvent extends GenerationEvent {
  const LoadingEvent({required this.message});

  final String message;
}

class ThinkingDeltaEvent extends GenerationEvent {
  const ThinkingDeltaEvent({required this.delta});

  final String delta;
}

class TextDeltaEvent extends GenerationEvent {
  const TextDeltaEvent({required this.delta});

  final String delta;
}

class UsageEvent extends GenerationEvent {
  const UsageEvent({required this.usage});

  final RequestUsage usage;
}

class ErrorEvent extends GenerationEvent {
  const ErrorEvent({required this.error});

  final String error;
}
