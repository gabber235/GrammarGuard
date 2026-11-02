// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'key_tips.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$KeyTipState {

/// Commands this computer has run, so they need no tip.
 Set<AppCommand> get used;/// This rewrite's tip. Changes only between rewrites, so nothing moves
/// while reading; gone once its command runs.
 AppCommand? get tip; bool get enabled;
/// Create a copy of KeyTipState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KeyTipStateCopyWith<KeyTipState> get copyWith => _$KeyTipStateCopyWithImpl<KeyTipState>(this as KeyTipState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as KeyTipState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KeyTipState&&const DeepCollectionEquality().equals(other.used, _this.used)&&(identical(other.tip, _this.tip) || other.tip == _this.tip)&&(identical(other.enabled, _this.enabled) || other.enabled == _this.enabled));
}


@override
int get hashCode {
  final _this = this as KeyTipState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.used),_this.tip,_this.enabled);
}

@override
String toString() {
  final _this = this as KeyTipState;
  return 'KeyTipState(used: ${_this.used}, tip: ${_this.tip}, enabled: ${_this.enabled})';
}


}

/// @nodoc
abstract mixin class $KeyTipStateCopyWith<$Res>  {
  factory $KeyTipStateCopyWith(KeyTipState value, $Res Function(KeyTipState) _then) = _$KeyTipStateCopyWithImpl;
@useResult
$Res call({
 Set<AppCommand> used, AppCommand? tip, bool enabled
});




}
/// @nodoc
class _$KeyTipStateCopyWithImpl<$Res>
    implements $KeyTipStateCopyWith<$Res> {
  _$KeyTipStateCopyWithImpl(this._self, this._then);

  final KeyTipState _self;
  final $Res Function(KeyTipState) _then;

/// Create a copy of KeyTipState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? used = null,Object? tip = freezed,Object? enabled = null,}) {
  return _then(KeyTipState(
used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as Set<AppCommand>,tip: freezed == tip ? _self.tip : tip // ignore: cast_nullable_to_non_nullable
as AppCommand?,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [KeyTipState].
extension KeyTipStatePatterns on KeyTipState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KeyTipState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KeyTipState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KeyTipState value)  $default,){
final _that = this;
switch (_that) {
case _KeyTipState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KeyTipState value)?  $default,){
final _that = this;
switch (_that) {
case _KeyTipState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Set<AppCommand> used,  AppCommand? tip,  bool enabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KeyTipState() when $default != null:
return $default(_that.used,_that.tip,_that.enabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Set<AppCommand> used,  AppCommand? tip,  bool enabled)  $default,) {final _that = this;
switch (_that) {
case _KeyTipState():
return $default(_that.used,_that.tip,_that.enabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Set<AppCommand> used,  AppCommand? tip,  bool enabled)?  $default,) {final _that = this;
switch (_that) {
case _KeyTipState() when $default != null:
return $default(_that.used,_that.tip,_that.enabled);case _:
  return null;

}
}

}

/// @nodoc


class _KeyTipState extends KeyTipState {
  const _KeyTipState({ Set<AppCommand> used = const <AppCommand>{}, this.tip, this.enabled = true}): _used = used,super._();
  

/// Commands this computer has run, so they need no tip.
 final  Set<AppCommand> _used;
/// Commands this computer has run, so they need no tip.
@override@JsonKey() Set<AppCommand> get used {
  if (_used is EqualUnmodifiableSetView) return _used;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_used);
}

/// This rewrite's tip. Changes only between rewrites, so nothing moves
/// while reading; gone once its command runs.
@override final  AppCommand? tip;
@override@JsonKey() final  bool enabled;

/// Create a copy of KeyTipState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KeyTipStateCopyWith<_KeyTipState> get copyWith => __$KeyTipStateCopyWithImpl<_KeyTipState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _KeyTipState&&const DeepCollectionEquality().equals(other.used, _used)&&(identical(other.tip, tip) || other.tip == tip)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_used),tip,enabled);
}

@override
String toString() {
    return 'KeyTipState(used: $used, tip: $tip, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class _$KeyTipStateCopyWith<$Res> implements $KeyTipStateCopyWith<$Res> {
  factory _$KeyTipStateCopyWith(_KeyTipState value, $Res Function(_KeyTipState) _then) = __$KeyTipStateCopyWithImpl;
@override @useResult
$Res call({
 Set<AppCommand> used, AppCommand? tip, bool enabled
});




}
/// @nodoc
class __$KeyTipStateCopyWithImpl<$Res>
    implements _$KeyTipStateCopyWith<$Res> {
  __$KeyTipStateCopyWithImpl(this._self, this._then);

  final _KeyTipState _self;
  final $Res Function(_KeyTipState) _then;

/// Create a copy of KeyTipState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? used = null,Object? tip = freezed,Object? enabled = null,}) {
  return _then(_KeyTipState(
used: null == used ? _self._used : used // ignore: cast_nullable_to_non_nullable
as Set<AppCommand>,tip: freezed == tip ? _self.tip : tip // ignore: cast_nullable_to_non_nullable
as AppCommand?,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
