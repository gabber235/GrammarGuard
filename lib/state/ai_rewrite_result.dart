sealed class AiRewriteResult {
  const AiRewriteResult();
}

class LoadingResult extends AiRewriteResult {
  const LoadingResult({required this.message});

  final String message;
}

class ErrorResult extends AiRewriteResult {
  const ErrorResult({required this.message});

  final String message;
}

class TextResult extends AiRewriteResult {
  const TextResult({required this.text});

  final String text;
}

class ThinkingTextResult extends AiRewriteResult {
  const ThinkingTextResult({
    required this.thinking,
    required this.text,
  });

  final String thinking;
  final String text;
}
