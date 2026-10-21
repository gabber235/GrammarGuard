// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_spans.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReviewSpan {

 String get text; SpanKind get kind; int? get change;
/// Create a copy of ReviewSpan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewSpanCopyWith<ReviewSpan> get copyWith => _$ReviewSpanCopyWithImpl<ReviewSpan>(this as ReviewSpan, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ReviewSpan;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewSpan&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.change, _this.change) || other.change == _this.change));
}


@override
int get hashCode {
  final _this = this as ReviewSpan;
  return Object.hash(runtimeType,_this.text,_this.kind,_this.change);
}

@override
String toString() {
  final _this = this as ReviewSpan;
  return 'ReviewSpan(text: ${_this.text}, kind: ${_this.kind}, change: ${_this.change})';
}


}

/// @nodoc
abstract mixin class $ReviewSpanCopyWith<$Res>  {
  factory $ReviewSpanCopyWith(ReviewSpan value, $Res Function(ReviewSpan) _then) = _$ReviewSpanCopyWithImpl;
@useResult
$Res call({
 String text, SpanKind kind, int? change
});




}
/// @nodoc
class _$ReviewSpanCopyWithImpl<$Res>
    implements $ReviewSpanCopyWith<$Res> {
  _$ReviewSpanCopyWithImpl(this._self, this._then);

  final ReviewSpan _self;
  final $Res Function(ReviewSpan) _then;

/// Create a copy of ReviewSpan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? kind = null,Object? change = freezed,}) {
  return _then(ReviewSpan(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as SpanKind,change: freezed == change ? _self.change : change // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReviewSpan].
extension ReviewSpanPatterns on ReviewSpan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewSpan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewSpan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewSpan value)  $default,){
final _that = this;
switch (_that) {
case _ReviewSpan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewSpan value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewSpan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  SpanKind kind,  int? change)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewSpan() when $default != null:
return $default(_that.text,_that.kind,_that.change);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  SpanKind kind,  int? change)  $default,) {final _that = this;
switch (_that) {
case _ReviewSpan():
return $default(_that.text,_that.kind,_that.change);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  SpanKind kind,  int? change)?  $default,) {final _that = this;
switch (_that) {
case _ReviewSpan() when $default != null:
return $default(_that.text,_that.kind,_that.change);case _:
  return null;

}
}

}

/// @nodoc


class _ReviewSpan implements ReviewSpan {
  const _ReviewSpan({required this.text, required this.kind, this.change});
  

@override final  String text;
@override final  SpanKind kind;
@override final  int? change;

/// Create a copy of ReviewSpan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewSpanCopyWith<_ReviewSpan> get copyWith => __$ReviewSpanCopyWithImpl<_ReviewSpan>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewSpan&&(identical(other.text, text) || other.text == text)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.change, change) || other.change == change));
}


@override
int get hashCode {
    return Object.hash(runtimeType,text,kind,change);
}

@override
String toString() {
    return 'ReviewSpan(text: $text, kind: $kind, change: $change)';
}


}

/// @nodoc
abstract mixin class _$ReviewSpanCopyWith<$Res> implements $ReviewSpanCopyWith<$Res> {
  factory _$ReviewSpanCopyWith(_ReviewSpan value, $Res Function(_ReviewSpan) _then) = __$ReviewSpanCopyWithImpl;
@override @useResult
$Res call({
 String text, SpanKind kind, int? change
});




}
/// @nodoc
class __$ReviewSpanCopyWithImpl<$Res>
    implements _$ReviewSpanCopyWith<$Res> {
  __$ReviewSpanCopyWithImpl(this._self, this._then);

  final _ReviewSpan _self;
  final $Res Function(_ReviewSpan) _then;

/// Create a copy of ReviewSpan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? kind = null,Object? change = freezed,}) {
  return _then(_ReviewSpan(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as SpanKind,change: freezed == change ? _self.change : change // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
