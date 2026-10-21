// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vim_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VimState {

 VimMode get mode; int get cursorPosition; int? get visualStart; String? get pendingOperator; String get countBuffer;
/// Create a copy of VimState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VimStateCopyWith<VimState> get copyWith => _$VimStateCopyWithImpl<VimState>(this as VimState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as VimState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VimState&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.cursorPosition, _this.cursorPosition) || other.cursorPosition == _this.cursorPosition)&&(identical(other.visualStart, _this.visualStart) || other.visualStart == _this.visualStart)&&(identical(other.pendingOperator, _this.pendingOperator) || other.pendingOperator == _this.pendingOperator)&&(identical(other.countBuffer, _this.countBuffer) || other.countBuffer == _this.countBuffer));
}


@override
int get hashCode {
  final _this = this as VimState;
  return Object.hash(runtimeType,_this.mode,_this.cursorPosition,_this.visualStart,_this.pendingOperator,_this.countBuffer);
}

@override
String toString() {
  final _this = this as VimState;
  return 'VimState(mode: ${_this.mode}, cursorPosition: ${_this.cursorPosition}, visualStart: ${_this.visualStart}, pendingOperator: ${_this.pendingOperator}, countBuffer: ${_this.countBuffer})';
}


}

/// @nodoc
abstract mixin class $VimStateCopyWith<$Res>  {
  factory $VimStateCopyWith(VimState value, $Res Function(VimState) _then) = _$VimStateCopyWithImpl;
@useResult
$Res call({
 VimMode mode, int cursorPosition, int? visualStart, String? pendingOperator, String countBuffer
});




}
/// @nodoc
class _$VimStateCopyWithImpl<$Res>
    implements $VimStateCopyWith<$Res> {
  _$VimStateCopyWithImpl(this._self, this._then);

  final VimState _self;
  final $Res Function(VimState) _then;

/// Create a copy of VimState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? cursorPosition = null,Object? visualStart = freezed,Object? pendingOperator = freezed,Object? countBuffer = null,}) {
  return _then(VimState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as VimMode,cursorPosition: null == cursorPosition ? _self.cursorPosition : cursorPosition // ignore: cast_nullable_to_non_nullable
as int,visualStart: freezed == visualStart ? _self.visualStart : visualStart // ignore: cast_nullable_to_non_nullable
as int?,pendingOperator: freezed == pendingOperator ? _self.pendingOperator : pendingOperator // ignore: cast_nullable_to_non_nullable
as String?,countBuffer: null == countBuffer ? _self.countBuffer : countBuffer // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [VimState].
extension VimStatePatterns on VimState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VimState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VimState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VimState value)  $default,){
final _that = this;
switch (_that) {
case _VimState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VimState value)?  $default,){
final _that = this;
switch (_that) {
case _VimState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( VimMode mode,  int cursorPosition,  int? visualStart,  String? pendingOperator,  String countBuffer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VimState() when $default != null:
return $default(_that.mode,_that.cursorPosition,_that.visualStart,_that.pendingOperator,_that.countBuffer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( VimMode mode,  int cursorPosition,  int? visualStart,  String? pendingOperator,  String countBuffer)  $default,) {final _that = this;
switch (_that) {
case _VimState():
return $default(_that.mode,_that.cursorPosition,_that.visualStart,_that.pendingOperator,_that.countBuffer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( VimMode mode,  int cursorPosition,  int? visualStart,  String? pendingOperator,  String countBuffer)?  $default,) {final _that = this;
switch (_that) {
case _VimState() when $default != null:
return $default(_that.mode,_that.cursorPosition,_that.visualStart,_that.pendingOperator,_that.countBuffer);case _:
  return null;

}
}

}

/// @nodoc


class _VimState extends VimState {
  const _VimState({this.mode = VimMode.normal, this.cursorPosition = 0, this.visualStart, this.pendingOperator, this.countBuffer = ""}): super._();
  

@override@JsonKey() final  VimMode mode;
@override@JsonKey() final  int cursorPosition;
@override final  int? visualStart;
@override final  String? pendingOperator;
@override@JsonKey() final  String countBuffer;

/// Create a copy of VimState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VimStateCopyWith<_VimState> get copyWith => __$VimStateCopyWithImpl<_VimState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VimState&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.cursorPosition, cursorPosition) || other.cursorPosition == cursorPosition)&&(identical(other.visualStart, visualStart) || other.visualStart == visualStart)&&(identical(other.pendingOperator, pendingOperator) || other.pendingOperator == pendingOperator)&&(identical(other.countBuffer, countBuffer) || other.countBuffer == countBuffer));
}


@override
int get hashCode {
    return Object.hash(runtimeType,mode,cursorPosition,visualStart,pendingOperator,countBuffer);
}

@override
String toString() {
    return 'VimState(mode: $mode, cursorPosition: $cursorPosition, visualStart: $visualStart, pendingOperator: $pendingOperator, countBuffer: $countBuffer)';
}


}

/// @nodoc
abstract mixin class _$VimStateCopyWith<$Res> implements $VimStateCopyWith<$Res> {
  factory _$VimStateCopyWith(_VimState value, $Res Function(_VimState) _then) = __$VimStateCopyWithImpl;
@override @useResult
$Res call({
 VimMode mode, int cursorPosition, int? visualStart, String? pendingOperator, String countBuffer
});




}
/// @nodoc
class __$VimStateCopyWithImpl<$Res>
    implements _$VimStateCopyWith<$Res> {
  __$VimStateCopyWithImpl(this._self, this._then);

  final _VimState _self;
  final $Res Function(_VimState) _then;

/// Create a copy of VimState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? cursorPosition = null,Object? visualStart = freezed,Object? pendingOperator = freezed,Object? countBuffer = null,}) {
  return _then(_VimState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as VimMode,cursorPosition: null == cursorPosition ? _self.cursorPosition : cursorPosition // ignore: cast_nullable_to_non_nullable
as int,visualStart: freezed == visualStart ? _self.visualStart : visualStart // ignore: cast_nullable_to_non_nullable
as int?,pendingOperator: freezed == pendingOperator ? _self.pendingOperator : pendingOperator // ignore: cast_nullable_to_non_nullable
as String?,countBuffer: null == countBuffer ? _self.countBuffer : countBuffer // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
