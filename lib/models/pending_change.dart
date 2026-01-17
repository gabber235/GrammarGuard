enum ChangeStatus {
  pending,
  accepted,
  rejected,
}

class PendingChange {

  const PendingChange({
    required this.originalText,
    required this.newText,
    required this.position,
    this.status = ChangeStatus.pending,
  });

  factory PendingChange.insertion({
    required String text,
    required int position,
  }) {
    return PendingChange(
      originalText: "",
      newText: text,
      position: position,
    );
  }

  factory PendingChange.deletion({
    required String text,
    required int position,
  }) {
    return PendingChange(
      originalText: text,
      newText: "",
      position: position,
    );
  }

  factory PendingChange.replacement({
    required String originalText,
    required String newText,
    required int position,
  }) {
    return PendingChange(
      originalText: originalText,
      newText: newText,
      position: position,
    );
  }
  final String originalText;
  final String newText;
  final int position;
  final ChangeStatus status;

  bool get isInsertion => originalText.isEmpty && newText.isNotEmpty;
  bool get isDeletion => originalText.isNotEmpty && newText.isEmpty;
  bool get isReplacement => originalText.isNotEmpty && newText.isNotEmpty;
  bool get isPending => status == ChangeStatus.pending;

  int get originalLength => originalText.length;
  int get newLength => newText.length;

  int get totalDisplayLength {
    switch (status) {
      case ChangeStatus.pending:
        return originalLength + newLength;
      case ChangeStatus.accepted:
        return newLength;
      case ChangeStatus.rejected:
        return originalLength;
    }
  }

  int get endPosition => position + totalDisplayLength;

  bool containsPosition(int pos) {
    return pos >= position && pos < endPosition;
  }

  bool isInOriginalRegion(int pos) {
    if (originalText.isEmpty) return false;
    return pos >= position && pos < position + originalLength;
  }

  bool isInNewRegion(int pos) {
    if (newText.isEmpty) return false;
    final newStart = position + originalLength;
    return pos >= newStart && pos < newStart + newLength;
  }

  String? get resultText {
    switch (status) {
      case ChangeStatus.pending:
        return null;
      case ChangeStatus.accepted:
        return newText;
      case ChangeStatus.rejected:
        return originalText;
    }
  }

  PendingChange accept() {
    return copyWith(status: ChangeStatus.accepted);
  }

  PendingChange reject() {
    return copyWith(status: ChangeStatus.rejected);
  }

  PendingChange copyWith({
    String? originalText,
    String? newText,
    int? position,
    ChangeStatus? status,
  }) {
    return PendingChange(
      originalText: originalText ?? this.originalText,
      newText: newText ?? this.newText,
      position: position ?? this.position,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PendingChange &&
        other.originalText == originalText &&
        other.newText == newText &&
        other.position == position &&
        other.status == status;
  }

  @override
  int get hashCode {
    return Object.hash(originalText, newText, position, status);
  }

  @override
  String toString() {
    return "PendingChange(original: '$originalText', new: '$newText', pos: $position, status: $status)";
  }
}
