// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pending_change.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PendingChange {

 String get originalText; String get newText; ChangeStatus get status;
/// Create a copy of PendingChange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PendingChangeCopyWith<PendingChange> get copyWith => _$PendingChangeCopyWithImpl<PendingChange>(this as PendingChange, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PendingChange;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PendingChange&&(identical(other.originalText, _this.originalText) || other.originalText == _this.originalText)&&(identical(other.newText, _this.newText) || other.newText == _this.newText)&&(identical(other.status, _this.status) || other.status == _this.status));
}


@override
int get hashCode {
  final _this = this as PendingChange;
  return Object.hash(runtimeType,_this.originalText,_this.newText,_this.status);
}

@override
String toString() {
  final _this = this as PendingChange;
  return 'PendingChange(originalText: ${_this.originalText}, newText: ${_this.newText}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $PendingChangeCopyWith<$Res>  {
  factory $PendingChangeCopyWith(PendingChange value, $Res Function(PendingChange) _then) = _$PendingChangeCopyWithImpl;
@useResult
$Res call({
 String originalText, String newText, ChangeStatus status
});




}
/// @nodoc
class _$PendingChangeCopyWithImpl<$Res>
    implements $PendingChangeCopyWith<$Res> {
  _$PendingChangeCopyWithImpl(this._self, this._then);

  final PendingChange _self;
  final $Res Function(PendingChange) _then;

/// Create a copy of PendingChange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? originalText = null,Object? newText = null,Object? status = null,}) {
  return _then(PendingChange(
originalText: null == originalText ? _self.originalText : originalText // ignore: cast_nullable_to_non_nullable
as String,newText: null == newText ? _self.newText : newText // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ChangeStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [PendingChange].
extension PendingChangePatterns on PendingChange {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PendingChange value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PendingChange() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PendingChange value)  $default,){
final _that = this;
switch (_that) {
case _PendingChange():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PendingChange value)?  $default,){
final _that = this;
switch (_that) {
case _PendingChange() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String originalText,  String newText,  ChangeStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PendingChange() when $default != null:
return $default(_that.originalText,_that.newText,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String originalText,  String newText,  ChangeStatus status)  $default,) {final _that = this;
switch (_that) {
case _PendingChange():
return $default(_that.originalText,_that.newText,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String originalText,  String newText,  ChangeStatus status)?  $default,) {final _that = this;
switch (_that) {
case _PendingChange() when $default != null:
return $default(_that.originalText,_that.newText,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _PendingChange extends PendingChange {
  const _PendingChange({required this.originalText, required this.newText, this.status = ChangeStatus.pending}): super._();
  

@override final  String originalText;
@override final  String newText;
@override@JsonKey() final  ChangeStatus status;

/// Create a copy of PendingChange
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PendingChangeCopyWith<_PendingChange> get copyWith => __$PendingChangeCopyWithImpl<_PendingChange>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PendingChange&&(identical(other.originalText, originalText) || other.originalText == originalText)&&(identical(other.newText, newText) || other.newText == newText)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode {
    return Object.hash(runtimeType,originalText,newText,status);
}

@override
String toString() {
    return 'PendingChange(originalText: $originalText, newText: $newText, status: $status)';
}


}

/// @nodoc
abstract mixin class _$PendingChangeCopyWith<$Res> implements $PendingChangeCopyWith<$Res> {
  factory _$PendingChangeCopyWith(_PendingChange value, $Res Function(_PendingChange) _then) = __$PendingChangeCopyWithImpl;
@override @useResult
$Res call({
 String originalText, String newText, ChangeStatus status
});




}
/// @nodoc
class __$PendingChangeCopyWithImpl<$Res>
    implements _$PendingChangeCopyWith<$Res> {
  __$PendingChangeCopyWithImpl(this._self, this._then);

  final _PendingChange _self;
  final $Res Function(_PendingChange) _then;

/// Create a copy of PendingChange
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? originalText = null,Object? newText = null,Object? status = null,}) {
  return _then(_PendingChange(
originalText: null == originalText ? _self.originalText : originalText // ignore: cast_nullable_to_non_nullable
as String,newText: null == newText ? _self.newText : newText // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ChangeStatus,
  ));
}


}

// dart format on
