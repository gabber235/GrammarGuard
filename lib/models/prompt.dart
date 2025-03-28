import 'package:grammar_guard/models/rewrite_intensity.dart';
import 'package:grammar_guard/models/styling_option.dart';

/// Generates a tailored prompt for an LLM based on user selections.
///
/// - [selectedText]: The text input by the user.
/// - [intensity]: The desired level of rewriting.
/// - [stylingOptions]: A set of desired styling formats (can be empty).
String generateLlmPrompt({
  required String selectedText,
  required RewriteIntensity intensity,
  required Set<StylingOption> stylingOptions,
}) {
  final promptBuffer = StringBuffer();

  promptBuffer.writeln(_buildRoleSettingPrompt());
  promptBuffer.writeln(_buildIntensityPrompt(intensity, stylingOptions));
  promptBuffer.writeln(_buildFormattingPrompt(stylingOptions, intensity));
  promptBuffer.writeln(_buildInputTextPrompt(selectedText));
  promptBuffer.writeln(
    _buildOutputInstructionsPrompt(stylingOptions, intensity),
  );

  return promptBuffer.toString();
}

// --- Private Helper Functions ---

String _buildRoleSettingPrompt() {
  return """
You are an expert writing assistant. Your task is to revise the following text according to the specified intensity and formatting instructions.
""";
}

String _buildIntensityPrompt(
  RewriteIntensity intensity,
  Set<StylingOption> stylingOptions,
) {
  final buffer = StringBuffer();
  buffer.writeln("## Revision Intensity:");
  switch (intensity) {
    case RewriteIntensity.fixOnly:
      buffer.writeln("- Goal: Correct only spelling and grammatical errors.");
      buffer.writeln(
        "- Constraints: Do NOT change phrasing, sentence structure, or meaning unless necessary for correctness. Maintain original style/tone.",
      );
      buffer.writeln(
        "- Styling: Strictly preserve all original formatting. Do NOT add any Markdown or LaTeX, regardless of other instructions.",
      ); // Added
      break;
    case RewriteIntensity.polish:
      buffer.writeln(
        "- Goal: Correct errors, make minor improvements for clarity, flow, word choice.",
      );
      buffer.writeln(
        "- Constraints: Subtle changes, preserve sentence structure, core meaning, tone.",
      );
      if (stylingOptions.isNotEmpty) {
        buffer.writeln(
          "- Styling: Apply requested ${stylingOptions.map((s) => s.label).join('/')} formatting conservatively (e.g., basic lists, emphasis, inline code).",
        );
      } else {
        buffer.writeln(
          "- Styling: Preserve existing formatting where possible. Do not add new formatting.",
        );
      }
      break;
    case RewriteIntensity.enhance:
      buffer.writeln(
        "- Goal: Correct errors, significantly improve clarity, conciseness, engagement.",
      );
      buffer.writeln(
        "- Constraints: Refine words/structure, ensure professional tone, preserve core meaning.",
      );
      if (stylingOptions.isNotEmpty) {
        buffer.writeln(
          "- Styling: Apply requested ${stylingOptions.map((s) => s.label).join('/')} formatting to improve readability/structure (lists, emphasis, code). Avoid introducing entirely new complex structures (like tables).",
        );
      } else {
        buffer.writeln(
          "- Styling: Preserve existing formatting where possible. Do not add new formatting.",
        );
      }
      break;
    case RewriteIntensity.rewrite:
      buffer.writeln(
        "- Goal: Correct errors, substantially rewrite for maximum clarity, impact, fluency.",
      );
      buffer.writeln(
        "- Constraints: Restructure/rephrase freely while preserving core meaning accurately.",
      );
      if (stylingOptions.isNotEmpty) {
        buffer.writeln(
          "- Styling: Apply requested ${stylingOptions.map((s) => s.label).join('/')} formatting liberally. Introduce structure (headings, lists, tables, math environments) as needed for clarity, even if not present originally.",
        );
      } else {
        buffer.writeln(
          "- Styling: Preserve existing formatting where possible. Do not add new formatting.",
        );
      }
      break;
  }
  return buffer.toString();
}

String _buildFormattingPrompt(
  Set<StylingOption> stylingOptions,
  RewriteIntensity intensity,
) {
  final buffer = StringBuffer();
  buffer.writeln("## Formatting Instructions:");

  if (intensity == RewriteIntensity.fixOnly) {
    buffer.writeln(
      "- Intensity is 'Fix Only'. Apply NO new formatting (Markdown or LaTeX).",
    );
    buffer.writeln(
      "- IMPORTANT: Preserve any existing formatting (like code blocks, lists, bold/italics) exactly as found in the original text.",
    );
    return buffer.toString(); // Early exit for FixOnly
  }

  // --- Other Intensities ---
  final bool stylingRequested = stylingOptions.isNotEmpty;

  if (!stylingRequested) {
    buffer.writeln("- No specific styling requested.");
    buffer.writeln(
      "- Preserve any existing formatting from the original text where appropriate after revision.",
    );
    return buffer.toString();
  }
  List<String> stylesList = [];

  if (stylingOptions.contains(StylingOption.markdown)) {
    String markdownDesc =
        "Markdown (use for structure like headings (#), lists (* or -), emphasis (**bold**, *italics*), `inline code`, ```code blocks```)";
    stylesList.add(markdownDesc);
  }
  if (stylingOptions.contains(StylingOption.latex)) {
    String latexDesc =
        "LaTeX (use primarily for mathematical expressions like \$E=mc^2\$, equations (\\\\begin{equation}...\\\\end{equation}), citations (\\cite{...}), or specific commands like \\section{} where contextually relevant)";
    stylesList.add(latexDesc);
  }

  buffer.writeln(
    "- Apply formatting using: ${stylingOptions.map((s) => s.label).join(' AND ')}.",
  );
  buffer.writeln("- Details:");
  for (String desc in stylesList) {
    buffer.writeln("  - $desc");
  }
  if (stylingOptions.length > 1) {
    buffer.writeln(
      "- Prioritize Markdown for general text structure/emphasis and LaTeX for mathematical/technical notation.",
    );
  }

  // --- Intensity-Specific Application Guidance ---
  switch (intensity) {
    case RewriteIntensity.polish:
    case RewriteIntensity.enhance:
      buffer.writeln(
        "- Application Guidance: Apply formatting conservatively. Focus on enhancing existing structure or applying basic formatting where clearly appropriate (e.g., formatting existing lists, adding emphasis, marking inline code). Do NOT introduce major new structural elements like tables or complex LaTeX environments (e.g., \\begin{tabular}...) unless they were already present in a similar form.",
      );
      break;
    case RewriteIntensity.rewrite:
      buffer.writeln(
        "- Application Guidance: Apply formatting liberally to maximize clarity and structure. Feel free to INTRODUCE new structural elements like headings, lists, tables (using appropriate Markdown/LaTeX syntax), code blocks, or mathematical environments if they significantly improve the revised text's organization and readability, even if absent in the original.",
      );
      break;
    case RewriteIntensity.fixOnly:
      // This case is handled by the early exit, but included for completeness
      break;
  }
  buffer.writeln(
    "- Existing Formatting: If the original text contains formatting, maintain consistency or improve it using the specified style(s). Do not arbitrarily remove relevant existing formatting unless the rewrite makes it obsolete.",
  );
  return buffer.toString();
}

String _buildInputTextPrompt(String selectedText) {
  final buffer = StringBuffer();
  buffer.writeln("## Text to Revise:");
  buffer.writeln('"""');
  buffer.writeln(selectedText.trim()); // Trim whitespace
  buffer.writeln('"""');
  return buffer.toString();
}

String _buildOutputInstructionsPrompt(
  Set<StylingOption> stylingOptions,
  RewriteIntensity intensity,
) {
  final buffer = StringBuffer();
  buffer.writeln("## Output Requirements:");
  buffer.writeln(
    "- Provide ONLY the revised text. Do not include explanations, apologies, preambles, or any conversational text.",
  );
  buffer.writeln(
    "- Ensure the output adheres strictly to the intensity and formatting instructions provided above.",
  );

  // Reiterate formatting expectation based on final decision
  if (intensity == RewriteIntensity.fixOnly || stylingOptions.isEmpty) {
    buffer.writeln(
      "- Preserve original formatting as specified. Apply no new Markdown/LaTeX.",
    );
  } else {
    buffer.writeln(
      "- Apply ${stylingOptions.map((s) => s.label).join('/')} formatting appropriately, following the intensity-specific guidance (conservative for Polish/Enhance, liberal/introducing for Rewrite).",
    );
  }
  return buffer.toString();
}
