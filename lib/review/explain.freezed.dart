// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'explain.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChangeKey {

 String get before; String get after;
/// Create a copy of ChangeKey
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangeKeyCopyWith<ChangeKey> get copyWith => _$ChangeKeyCopyWithImpl<ChangeKey>(this as ChangeKey, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ChangeKey;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangeKey&&(identical(other.before, _this.before) || other.before == _this.before)&&(identical(other.after, _this.after) || other.after == _this.after));
}


@override
int get hashCode {
  final _this = this as ChangeKey;
  return Object.hash(runtimeType,_this.before,_this.after);
}

@override
String toString() {
  final _this = this as ChangeKey;
  return 'ChangeKey(before: ${_this.before}, after: ${_this.after})';
}


}

/// @nodoc
abstract mixin class $ChangeKeyCopyWith<$Res>  {
  factory $ChangeKeyCopyWith(ChangeKey value, $Res Function(ChangeKey) _then) = _$ChangeKeyCopyWithImpl;
@useResult
$Res call({
 String before, String after
});




}
/// @nodoc
class _$ChangeKeyCopyWithImpl<$Res>
    implements $ChangeKeyCopyWith<$Res> {
  _$ChangeKeyCopyWithImpl(this._self, this._then);

  final ChangeKey _self;
  final $Res Function(ChangeKey) _then;

/// Create a copy of ChangeKey
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? before = null,Object? after = null,}) {
  return _then(ChangeKey(
before: null == before ? _self.before : before // ignore: cast_nullable_to_non_nullable
as String,after: null == after ? _self.after : after // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChangeKey].
extension ChangeKeyPatterns on ChangeKey {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChangeKey value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChangeKey() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChangeKey value)  $default,){
final _that = this;
switch (_that) {
case _ChangeKey():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChangeKey value)?  $default,){
final _that = this;
switch (_that) {
case _ChangeKey() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String before,  String after)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChangeKey() when $default != null:
return $default(_that.before,_that.after);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String before,  String after)  $default,) {final _that = this;
switch (_that) {
case _ChangeKey():
return $default(_that.before,_that.after);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String before,  String after)?  $default,) {final _that = this;
switch (_that) {
case _ChangeKey() when $default != null:
return $default(_that.before,_that.after);case _:
  return null;

}
}

}

/// @nodoc


class _ChangeKey implements ChangeKey {
  const _ChangeKey({required this.before, required this.after});
  

@override final  String before;
@override final  String after;

/// Create a copy of ChangeKey
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangeKeyCopyWith<_ChangeKey> get copyWith => __$ChangeKeyCopyWithImpl<_ChangeKey>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangeKey&&(identical(other.before, before) || other.before == before)&&(identical(other.after, after) || other.after == after));
}


@override
int get hashCode {
    return Object.hash(runtimeType,before,after);
}

@override
String toString() {
    return 'ChangeKey(before: $before, after: $after)';
}


}

/// @nodoc
abstract mixin class _$ChangeKeyCopyWith<$Res> implements $ChangeKeyCopyWith<$Res> {
  factory _$ChangeKeyCopyWith(_ChangeKey value, $Res Function(_ChangeKey) _then) = __$ChangeKeyCopyWithImpl;
@override @useResult
$Res call({
 String before, String after
});




}
/// @nodoc
class __$ChangeKeyCopyWithImpl<$Res>
    implements _$ChangeKeyCopyWith<$Res> {
  __$ChangeKeyCopyWithImpl(this._self, this._then);

  final _ChangeKey _self;
  final $Res Function(_ChangeKey) _then;

/// Create a copy of ChangeKey
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? before = null,Object? after = null,}) {
  return _then(_ChangeKey(
before: null == before ? _self.before : before // ignore: cast_nullable_to_non_nullable
as String,after: null == after ? _self.after : after // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
