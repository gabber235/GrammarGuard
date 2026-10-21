// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prompt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Prompt {

 String get system; String get user;
/// Create a copy of Prompt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromptCopyWith<Prompt> get copyWith => _$PromptCopyWithImpl<Prompt>(this as Prompt, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Prompt;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Prompt&&(identical(other.system, _this.system) || other.system == _this.system)&&(identical(other.user, _this.user) || other.user == _this.user));
}


@override
int get hashCode {
  final _this = this as Prompt;
  return Object.hash(runtimeType,_this.system,_this.user);
}

@override
String toString() {
  final _this = this as Prompt;
  return 'Prompt(system: ${_this.system}, user: ${_this.user})';
}


}

/// @nodoc
abstract mixin class $PromptCopyWith<$Res>  {
  factory $PromptCopyWith(Prompt value, $Res Function(Prompt) _then) = _$PromptCopyWithImpl;
@useResult
$Res call({
 String system, String user
});




}
/// @nodoc
class _$PromptCopyWithImpl<$Res>
    implements $PromptCopyWith<$Res> {
  _$PromptCopyWithImpl(this._self, this._then);

  final Prompt _self;
  final $Res Function(Prompt) _then;

/// Create a copy of Prompt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? system = null,Object? user = null,}) {
  return _then(Prompt(
system: null == system ? _self.system : system // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Prompt].
extension PromptPatterns on Prompt {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Prompt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Prompt() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Prompt value)  $default,){
final _that = this;
switch (_that) {
case _Prompt():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Prompt value)?  $default,){
final _that = this;
switch (_that) {
case _Prompt() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String system,  String user)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Prompt() when $default != null:
return $default(_that.system,_that.user);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String system,  String user)  $default,) {final _that = this;
switch (_that) {
case _Prompt():
return $default(_that.system,_that.user);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String system,  String user)?  $default,) {final _that = this;
switch (_that) {
case _Prompt() when $default != null:
return $default(_that.system,_that.user);case _:
  return null;

}
}

}

/// @nodoc


class _Prompt implements Prompt {
  const _Prompt({required this.system, required this.user});
  

@override final  String system;
@override final  String user;

/// Create a copy of Prompt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PromptCopyWith<_Prompt> get copyWith => __$PromptCopyWithImpl<_Prompt>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Prompt&&(identical(other.system, system) || other.system == system)&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode {
    return Object.hash(runtimeType,system,user);
}

@override
String toString() {
    return 'Prompt(system: $system, user: $user)';
}


}

/// @nodoc
abstract mixin class _$PromptCopyWith<$Res> implements $PromptCopyWith<$Res> {
  factory _$PromptCopyWith(_Prompt value, $Res Function(_Prompt) _then) = __$PromptCopyWithImpl;
@override @useResult
$Res call({
 String system, String user
});




}
/// @nodoc
class __$PromptCopyWithImpl<$Res>
    implements _$PromptCopyWith<$Res> {
  __$PromptCopyWithImpl(this._self, this._then);

  final _Prompt _self;
  final $Res Function(_Prompt) _then;

/// Create a copy of Prompt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? system = null,Object? user = null,}) {
  return _then(_Prompt(
system: null == system ? _self.system : system // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
