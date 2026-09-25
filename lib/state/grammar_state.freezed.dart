// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grammar_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GrammarStateData implements DiagnosticableTreeMixin {

 String get inputText; Set<StylingOption> get enabledStyling; RewriteIntensity get rewriteIntensity;
/// Create a copy of GrammarStateData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GrammarStateDataCopyWith<GrammarStateData> get copyWith => _$GrammarStateDataCopyWithImpl<GrammarStateData>(this as GrammarStateData, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as GrammarStateData;
  properties
    ..add(DiagnosticsProperty('type', 'GrammarStateData'))
    ..add(DiagnosticsProperty('inputText', _this.inputText))..add(DiagnosticsProperty('enabledStyling', _this.enabledStyling))..add(DiagnosticsProperty('rewriteIntensity', _this.rewriteIntensity));
}

@override
bool operator ==(Object other) {
  final _this = this as GrammarStateData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GrammarStateData&&(identical(other.inputText, _this.inputText) || other.inputText == _this.inputText)&&const DeepCollectionEquality().equals(other.enabledStyling, _this.enabledStyling)&&(identical(other.rewriteIntensity, _this.rewriteIntensity) || other.rewriteIntensity == _this.rewriteIntensity));
}


@override
int get hashCode {
  final _this = this as GrammarStateData;
  return Object.hash(runtimeType,_this.inputText,const DeepCollectionEquality().hash(_this.enabledStyling),_this.rewriteIntensity);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as GrammarStateData;
  return 'GrammarStateData(inputText: ${_this.inputText}, enabledStyling: ${_this.enabledStyling}, rewriteIntensity: ${_this.rewriteIntensity})';
}


}

/// @nodoc
abstract mixin class $GrammarStateDataCopyWith<$Res>  {
  factory $GrammarStateDataCopyWith(GrammarStateData value, $Res Function(GrammarStateData) _then) = _$GrammarStateDataCopyWithImpl;
@useResult
$Res call({
 String inputText, Set<StylingOption> enabledStyling, RewriteIntensity rewriteIntensity
});




}
/// @nodoc
class _$GrammarStateDataCopyWithImpl<$Res>
    implements $GrammarStateDataCopyWith<$Res> {
  _$GrammarStateDataCopyWithImpl(this._self, this._then);

  final GrammarStateData _self;
  final $Res Function(GrammarStateData) _then;

/// Create a copy of GrammarStateData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inputText = null,Object? enabledStyling = null,Object? rewriteIntensity = null,}) {
  return _then(GrammarStateData(
inputText: null == inputText ? _self.inputText : inputText // ignore: cast_nullable_to_non_nullable
as String,enabledStyling: null == enabledStyling ? _self.enabledStyling : enabledStyling // ignore: cast_nullable_to_non_nullable
as Set<StylingOption>,rewriteIntensity: null == rewriteIntensity ? _self.rewriteIntensity : rewriteIntensity // ignore: cast_nullable_to_non_nullable
as RewriteIntensity,
  ));
}

}


/// Adds pattern-matching-related methods to [GrammarStateData].
extension GrammarStateDataPatterns on GrammarStateData {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GrammarStateData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GrammarStateData() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GrammarStateData value)  $default,){
final _that = this;
switch (_that) {
case _GrammarStateData():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GrammarStateData value)?  $default,){
final _that = this;
switch (_that) {
case _GrammarStateData() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String inputText,  Set<StylingOption> enabledStyling,  RewriteIntensity rewriteIntensity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GrammarStateData() when $default != null:
return $default(_that.inputText,_that.enabledStyling,_that.rewriteIntensity);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String inputText,  Set<StylingOption> enabledStyling,  RewriteIntensity rewriteIntensity)  $default,) {final _that = this;
switch (_that) {
case _GrammarStateData():
return $default(_that.inputText,_that.enabledStyling,_that.rewriteIntensity);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String inputText,  Set<StylingOption> enabledStyling,  RewriteIntensity rewriteIntensity)?  $default,) {final _that = this;
switch (_that) {
case _GrammarStateData() when $default != null:
return $default(_that.inputText,_that.enabledStyling,_that.rewriteIntensity);case _:
  return null;

}
}

}

/// @nodoc


class _GrammarStateData with DiagnosticableTreeMixin implements GrammarStateData {
  const _GrammarStateData({this.inputText = "",  Set<StylingOption> enabledStyling = const {}, this.rewriteIntensity = RewriteIntensity.polish}): _enabledStyling = enabledStyling;
  

@override@JsonKey() final  String inputText;
 final  Set<StylingOption> _enabledStyling;
@override@JsonKey() Set<StylingOption> get enabledStyling {
  if (_enabledStyling is EqualUnmodifiableSetView) return _enabledStyling;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_enabledStyling);
}

@override@JsonKey() final  RewriteIntensity rewriteIntensity;

/// Create a copy of GrammarStateData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GrammarStateDataCopyWith<_GrammarStateData> get copyWith => __$GrammarStateDataCopyWithImpl<_GrammarStateData>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'GrammarStateData'))
    ..add(DiagnosticsProperty('inputText', inputText))..add(DiagnosticsProperty('enabledStyling', enabledStyling))..add(DiagnosticsProperty('rewriteIntensity', rewriteIntensity));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GrammarStateData&&(identical(other.inputText, inputText) || other.inputText == inputText)&&const DeepCollectionEquality().equals(other.enabledStyling, _enabledStyling)&&(identical(other.rewriteIntensity, rewriteIntensity) || other.rewriteIntensity == rewriteIntensity));
}


@override
int get hashCode {
    return Object.hash(runtimeType,inputText,const DeepCollectionEquality().hash(_enabledStyling),rewriteIntensity);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'GrammarStateData(inputText: $inputText, enabledStyling: $enabledStyling, rewriteIntensity: $rewriteIntensity)';
}


}

/// @nodoc
abstract mixin class _$GrammarStateDataCopyWith<$Res> implements $GrammarStateDataCopyWith<$Res> {
  factory _$GrammarStateDataCopyWith(_GrammarStateData value, $Res Function(_GrammarStateData) _then) = __$GrammarStateDataCopyWithImpl;
@override @useResult
$Res call({
 String inputText, Set<StylingOption> enabledStyling, RewriteIntensity rewriteIntensity
});




}
/// @nodoc
class __$GrammarStateDataCopyWithImpl<$Res>
    implements _$GrammarStateDataCopyWith<$Res> {
  __$GrammarStateDataCopyWithImpl(this._self, this._then);

  final _GrammarStateData _self;
  final $Res Function(_GrammarStateData) _then;

/// Create a copy of GrammarStateData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inputText = null,Object? enabledStyling = null,Object? rewriteIntensity = null,}) {
  return _then(_GrammarStateData(
inputText: null == inputText ? _self.inputText : inputText // ignore: cast_nullable_to_non_nullable
as String,enabledStyling: null == enabledStyling ? _self._enabledStyling : enabledStyling // ignore: cast_nullable_to_non_nullable
as Set<StylingOption>,rewriteIntensity: null == rewriteIntensity ? _self.rewriteIntensity : rewriteIntensity // ignore: cast_nullable_to_non_nullable
as RewriteIntensity,
  ));
}


}

// dart format on
