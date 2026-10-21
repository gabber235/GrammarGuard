import "package:freezed_annotation/freezed_annotation.dart";

part "pending_change.freezed.dart";

enum ChangeStatus { pending, accepted, rejected }

/// One suggestion from the model: [originalText] replaced by [newText].
/// Its position is always derived from the document it sits in.
@freezed
abstract class PendingChange with _$PendingChange {
  const PendingChange._();

  const factory PendingChange({
    required String originalText,
    required String newText,
    @Default(ChangeStatus.pending) ChangeStatus status,
  }) = _PendingChange;

  factory PendingChange.insertion(String text) => PendingChange(originalText: "", newText: text);

  factory PendingChange.deletion(String text) => PendingChange(originalText: text, newText: "");

  factory PendingChange.replacement({required String originalText, required String newText}) =>
      PendingChange(originalText: originalText, newText: newText);

  bool get isInsertion => originalText.isEmpty && newText.isNotEmpty;
  bool get isDeletion => originalText.isNotEmpty && newText.isEmpty;
  bool get isReplacement => originalText.isNotEmpty && newText.isNotEmpty;
  bool get isPending => status == ChangeStatus.pending;

  int get originalLength => originalText.length;
  int get newLength => newText.length;

  /// Characters this change takes up in the displayed text: both versions
  /// while pending, one once decided.
  int get totalDisplayLength => switch (status) {
    ChangeStatus.pending => originalLength + newLength,
    ChangeStatus.accepted => newLength,
    ChangeStatus.rejected => originalLength,
  };

  /// The text this change contributes once decided; null while pending.
  String? get resultText => switch (status) {
    ChangeStatus.pending => null,
    ChangeStatus.accepted => newText,
    ChangeStatus.rejected => originalText,
  };

  PendingChange accept() => copyWith(status: ChangeStatus.accepted);
  PendingChange reject() => copyWith(status: ChangeStatus.rejected);
}
