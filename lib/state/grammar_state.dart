import "package:freezed_annotation/freezed_annotation.dart";
import "package:grammar_guard/models/rewrite_intensity.dart";
import "package:grammar_guard/models/styling_option.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "grammar_state.freezed.dart";
part "grammar_state.g.dart";

@freezed
abstract class GrammarStateData with _$GrammarStateData {
  const factory GrammarStateData({
    @Default("") String inputText,
    @Default({}) Set<StylingOption> enabledStyling,
    @Default(RewriteIntensity.polish) RewriteIntensity rewriteIntensity,
  }) = _GrammarStateData;
}

@riverpod
class GrammarState extends _$GrammarState {
  @override
  GrammarStateData build() {
    return const GrammarStateData();
  }

  void setInputText(String text) {
    state = state.copyWith(inputText: text);
  }

  void toggleStyling(StylingOption option) {
    final newStyling = Set<StylingOption>.from(state.enabledStyling);
    if (newStyling.contains(option)) {
      newStyling.remove(option);
    } else {
      newStyling.add(option);
    }
    state = state.copyWith(enabledStyling: newStyling);
  }

  void setRewriteIntensity(RewriteIntensity intensity) {
    state = state.copyWith(rewriteIntensity: intensity);
  }
}
