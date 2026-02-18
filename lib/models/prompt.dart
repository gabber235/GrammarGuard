import "package:grammar_guard/models/rewrite_intensity.dart";
import "package:grammar_guard/models/styling_option.dart";

/// Generates a tailored prompt for an LLM based on user selections.
String generateLlmPrompt({
  required RewriteIntensity intensity,
  required Set<StylingOption> stylingOptions,
}) {
  final promptBuffer = StringBuffer()
    ..writeln("<rewrite_task>")
    ..writeln(_buildObjectiveSection())
    ..writeln(_buildGlobalConstraintsSection())
    ..writeln(_buildIntensityPolicySection(intensity))
    ..writeln(_buildFormattingPolicySection(stylingOptions, intensity))
    ..writeln(_buildOutputContractSection())
    ..write("</rewrite_task>");

  return promptBuffer.toString();
}

String _buildObjectiveSection() {
  return """
<objective>
Revise the user text according to the selected rewrite intensity and formatting policy.
Preserve the original meaning and factual content while improving quality within the allowed intensity scope.
</objective>
""";
}

String _buildGlobalConstraintsSection() {
  return """
<global_constraints>
Write in natural modern language.
Do not use em dash characters.
Avoid archaic phrasing and overly formal wording.
Do not include explanations, preambles, or conversational filler.
</global_constraints>
""";
}

String _buildIntensityPolicySection(RewriteIntensity intensity) {
  final buffer = StringBuffer()..writeln("<intensity_policy>");

  switch (intensity) {
    case RewriteIntensity.fixOnly:
      buffer.writeln("Selected intensity is Fix Only.");
      buffer.writeln("Correct spelling, grammar, and punctuation errors only.");
      buffer.writeln(
        "Do not change sentence structure, wording, or tone unless a change is required for correctness.",
      );
      buffer.writeln(
        "Keep the original voice and preserve meaning with minimal intervention.",
      );
    case RewriteIntensity.polish:
      buffer.writeln("Selected intensity is Polish.");
      buffer.writeln(
        "Correct all language errors and make minor clarity improvements.",
      );
      buffer.writeln(
        "Prefer small edits that improve flow and word choice while keeping the original structure mostly intact.",
      );
      buffer.writeln("Preserve the original meaning and tone.");
    case RewriteIntensity.enhance:
      buffer.writeln("Selected intensity is Enhance.");
      buffer.writeln(
        "Correct all language errors and improve clarity, concision, and readability with moderate rewriting.",
      );
      buffer.writeln(
        "You may refine sentence structure when it improves comprehension.",
      );
      buffer.writeln(
        "Preserve the original meaning and maintain a natural tone.",
      );
    case RewriteIntensity.rewrite:
      buffer.writeln("Selected intensity is Rewrite.");
      buffer.writeln(
        "Correct all language issues and substantially rewrite for maximum clarity, fluency, and impact.",
      );
      buffer.writeln(
        "You may restructure sentences and paragraphs freely when this improves the final result.",
      );
      buffer.writeln(
        "Preserve the original meaning accurately even when wording and structure change significantly.",
      );
  }
  buffer.writeln("</intensity_policy>");

  return buffer.toString();
}

String _buildFormattingPolicySection(
  Set<StylingOption> stylingOptions,
  RewriteIntensity intensity,
) {
  final buffer = StringBuffer()..writeln("<formatting_policy>");
  final markdownSelected = stylingOptions.contains(StylingOption.markdown);
  final latexSelected = stylingOptions.contains(StylingOption.latex);

  if (intensity == RewriteIntensity.fixOnly) {
    buffer
      ..writeln("Fix Only is active.")
      ..writeln("Do not introduce new Markdown or LaTeX formatting.")
      ..writeln(
        "Preserve existing formatting exactly as it appears in the source text.",
      )
      ..writeln("</formatting_policy>");
    return buffer.toString();
  }

  if (!markdownSelected && !latexSelected) {
    buffer
      ..writeln("No specific formatting style was selected.")
      ..writeln("Preserve existing formatting when appropriate.")
      ..writeln(
        "Do not add new Markdown or LaTeX markup unless the original text already requires it.",
      )
      ..writeln("</formatting_policy>");
    return buffer.toString();
  }

  if (markdownSelected) {
    buffer.writeln(
      "Markdown is requested. Use Markdown syntax directly in the output text for headings, lists, emphasis, and code when helpful.",
    );
  }

  if (latexSelected) {
    buffer.writeln(
      r"LaTeX is requested. Output LaTeX as literal source text only. Do not render, evaluate, or interpret equations.",
    );
    buffer.writeln(
      r"Use LaTeX only for mathematical or technical notation, such as $E=mc^2$ or \begin{equation}...\end{equation}.",
    );
  }

  if (markdownSelected && latexSelected) {
    buffer.writeln(
      "When both styles are selected, use Markdown for document structure and LaTeX for technical notation.",
    );
  }

  switch (intensity) {
    case RewriteIntensity.polish:
    case RewriteIntensity.enhance:
      buffer.writeln(
        "Apply formatting conservatively. Focus on readability improvements that stay close to the original structure.",
      );
    case RewriteIntensity.rewrite:
      buffer.writeln(
        "You may introduce new structure when it clearly improves readability and organization.",
      );
    case RewriteIntensity.fixOnly:
      break;
  }

  buffer.writeln(
    "Preserve relevant existing formatting unless it conflicts with clarity.",
  );
  buffer.writeln("</formatting_policy>");

  return buffer.toString();
}

String _buildOutputContractSection() {
  final buffer = StringBuffer()
    ..writeln("<output_contract>")
    ..writeln("Return only the revised text.")
    ..writeln("Do not add commentary, labels, metadata, or quotation wrappers.")
    ..writeln("Ensure the revised text follows all policies above.")
    ..writeln("</output_contract>");

  return buffer.toString();
}
