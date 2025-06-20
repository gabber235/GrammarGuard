// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grammar_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GrammarStateData implements DiagnosticableTreeMixin {
  String get inputText;
  Set<StylingOption> get enabledStyling;
  RewriteIntensity get rewriteIntensity;

  /// Create a copy of GrammarStateData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GrammarStateDataCopyWith<GrammarStateData> get copyWith =>
      _$GrammarStateDataCopyWithImpl<GrammarStateData>(
          this as GrammarStateData, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'GrammarStateData'))
      ..add(DiagnosticsProperty('inputText', inputText))
      ..add(DiagnosticsProperty('enabledStyling', enabledStyling))
      ..add(DiagnosticsProperty('rewriteIntensity', rewriteIntensity));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GrammarStateData &&
            (identical(other.inputText, inputText) ||
                other.inputText == inputText) &&
            const DeepCollectionEquality()
                .equals(other.enabledStyling, enabledStyling) &&
            (identical(other.rewriteIntensity, rewriteIntensity) ||
                other.rewriteIntensity == rewriteIntensity));
  }

  @override
  int get hashCode => Object.hash(runtimeType, inputText,
      const DeepCollectionEquality().hash(enabledStyling), rewriteIntensity);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'GrammarStateData(inputText: $inputText, enabledStyling: $enabledStyling, rewriteIntensity: $rewriteIntensity)';
  }
}

/// @nodoc
abstract mixin class $GrammarStateDataCopyWith<$Res> {
  factory $GrammarStateDataCopyWith(
          GrammarStateData value, $Res Function(GrammarStateData) _then) =
      _$GrammarStateDataCopyWithImpl;
  @useResult
  $Res call(
      {String inputText,
      Set<StylingOption> enabledStyling,
      RewriteIntensity rewriteIntensity});
}

/// @nodoc
class _$GrammarStateDataCopyWithImpl<$Res>
    implements $GrammarStateDataCopyWith<$Res> {
  _$GrammarStateDataCopyWithImpl(this._self, this._then);

  final GrammarStateData _self;
  final $Res Function(GrammarStateData) _then;

  /// Create a copy of GrammarStateData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? inputText = null,
    Object? enabledStyling = null,
    Object? rewriteIntensity = null,
  }) {
    return _then(_self.copyWith(
      inputText: null == inputText
          ? _self.inputText
          : inputText // ignore: cast_nullable_to_non_nullable
              as String,
      enabledStyling: null == enabledStyling
          ? _self.enabledStyling
          : enabledStyling // ignore: cast_nullable_to_non_nullable
              as Set<StylingOption>,
      rewriteIntensity: null == rewriteIntensity
          ? _self.rewriteIntensity
          : rewriteIntensity // ignore: cast_nullable_to_non_nullable
              as RewriteIntensity,
    ));
  }
}

/// @nodoc

class _GrammarStateData
    with DiagnosticableTreeMixin
    implements GrammarStateData {
  const _GrammarStateData(
      {this.inputText = "",
      final Set<StylingOption> enabledStyling = const {},
      this.rewriteIntensity = RewriteIntensity.polish})
      : _enabledStyling = enabledStyling;

  @override
  @JsonKey()
  final String inputText;
  final Set<StylingOption> _enabledStyling;
  @override
  @JsonKey()
  Set<StylingOption> get enabledStyling {
    if (_enabledStyling is EqualUnmodifiableSetView) return _enabledStyling;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_enabledStyling);
  }

  @override
  @JsonKey()
  final RewriteIntensity rewriteIntensity;

  /// Create a copy of GrammarStateData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GrammarStateDataCopyWith<_GrammarStateData> get copyWith =>
      __$GrammarStateDataCopyWithImpl<_GrammarStateData>(this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'GrammarStateData'))
      ..add(DiagnosticsProperty('inputText', inputText))
      ..add(DiagnosticsProperty('enabledStyling', enabledStyling))
      ..add(DiagnosticsProperty('rewriteIntensity', rewriteIntensity));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GrammarStateData &&
            (identical(other.inputText, inputText) ||
                other.inputText == inputText) &&
            const DeepCollectionEquality()
                .equals(other._enabledStyling, _enabledStyling) &&
            (identical(other.rewriteIntensity, rewriteIntensity) ||
                other.rewriteIntensity == rewriteIntensity));
  }

  @override
  int get hashCode => Object.hash(runtimeType, inputText,
      const DeepCollectionEquality().hash(_enabledStyling), rewriteIntensity);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'GrammarStateData(inputText: $inputText, enabledStyling: $enabledStyling, rewriteIntensity: $rewriteIntensity)';
  }
}

/// @nodoc
abstract mixin class _$GrammarStateDataCopyWith<$Res>
    implements $GrammarStateDataCopyWith<$Res> {
  factory _$GrammarStateDataCopyWith(
          _GrammarStateData value, $Res Function(_GrammarStateData) _then) =
      __$GrammarStateDataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String inputText,
      Set<StylingOption> enabledStyling,
      RewriteIntensity rewriteIntensity});
}

/// @nodoc
class __$GrammarStateDataCopyWithImpl<$Res>
    implements _$GrammarStateDataCopyWith<$Res> {
  __$GrammarStateDataCopyWithImpl(this._self, this._then);

  final _GrammarStateData _self;
  final $Res Function(_GrammarStateData) _then;

  /// Create a copy of GrammarStateData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? inputText = null,
    Object? enabledStyling = null,
    Object? rewriteIntensity = null,
  }) {
    return _then(_GrammarStateData(
      inputText: null == inputText
          ? _self.inputText
          : inputText // ignore: cast_nullable_to_non_nullable
              as String,
      enabledStyling: null == enabledStyling
          ? _self._enabledStyling
          : enabledStyling // ignore: cast_nullable_to_non_nullable
              as Set<StylingOption>,
      rewriteIntensity: null == rewriteIntensity
          ? _self.rewriteIntensity
          : rewriteIntensity // ignore: cast_nullable_to_non_nullable
              as RewriteIntensity,
    ));
  }
}

// dart format on
