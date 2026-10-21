// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'usage.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UsageSummary {

 int get tokens; double get cost;
/// Create a copy of UsageSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsageSummaryCopyWith<UsageSummary> get copyWith => _$UsageSummaryCopyWithImpl<UsageSummary>(this as UsageSummary, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as UsageSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsageSummary&&(identical(other.tokens, _this.tokens) || other.tokens == _this.tokens)&&(identical(other.cost, _this.cost) || other.cost == _this.cost));
}


@override
int get hashCode {
  final _this = this as UsageSummary;
  return Object.hash(runtimeType,_this.tokens,_this.cost);
}

@override
String toString() {
  final _this = this as UsageSummary;
  return 'UsageSummary(tokens: ${_this.tokens}, cost: ${_this.cost})';
}


}

/// @nodoc
abstract mixin class $UsageSummaryCopyWith<$Res>  {
  factory $UsageSummaryCopyWith(UsageSummary value, $Res Function(UsageSummary) _then) = _$UsageSummaryCopyWithImpl;
@useResult
$Res call({
 int tokens, double cost
});




}
/// @nodoc
class _$UsageSummaryCopyWithImpl<$Res>
    implements $UsageSummaryCopyWith<$Res> {
  _$UsageSummaryCopyWithImpl(this._self, this._then);

  final UsageSummary _self;
  final $Res Function(UsageSummary) _then;

/// Create a copy of UsageSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tokens = null,Object? cost = null,}) {
  return _then(UsageSummary(
tokens: null == tokens ? _self.tokens : tokens // ignore: cast_nullable_to_non_nullable
as int,cost: null == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [UsageSummary].
extension UsageSummaryPatterns on UsageSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UsageSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UsageSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UsageSummary value)  $default,){
final _that = this;
switch (_that) {
case _UsageSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UsageSummary value)?  $default,){
final _that = this;
switch (_that) {
case _UsageSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int tokens,  double cost)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UsageSummary() when $default != null:
return $default(_that.tokens,_that.cost);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int tokens,  double cost)  $default,) {final _that = this;
switch (_that) {
case _UsageSummary():
return $default(_that.tokens,_that.cost);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int tokens,  double cost)?  $default,) {final _that = this;
switch (_that) {
case _UsageSummary() when $default != null:
return $default(_that.tokens,_that.cost);case _:
  return null;

}
}

}

/// @nodoc


class _UsageSummary implements UsageSummary {
  const _UsageSummary({required this.tokens, required this.cost});
  

@override final  int tokens;
@override final  double cost;

/// Create a copy of UsageSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UsageSummaryCopyWith<_UsageSummary> get copyWith => __$UsageSummaryCopyWithImpl<_UsageSummary>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UsageSummary&&(identical(other.tokens, tokens) || other.tokens == tokens)&&(identical(other.cost, cost) || other.cost == cost));
}


@override
int get hashCode {
    return Object.hash(runtimeType,tokens,cost);
}

@override
String toString() {
    return 'UsageSummary(tokens: $tokens, cost: $cost)';
}


}

/// @nodoc
abstract mixin class _$UsageSummaryCopyWith<$Res> implements $UsageSummaryCopyWith<$Res> {
  factory _$UsageSummaryCopyWith(_UsageSummary value, $Res Function(_UsageSummary) _then) = __$UsageSummaryCopyWithImpl;
@override @useResult
$Res call({
 int tokens, double cost
});




}
/// @nodoc
class __$UsageSummaryCopyWithImpl<$Res>
    implements _$UsageSummaryCopyWith<$Res> {
  __$UsageSummaryCopyWithImpl(this._self, this._then);

  final _UsageSummary _self;
  final $Res Function(_UsageSummary) _then;

/// Create a copy of UsageSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tokens = null,Object? cost = null,}) {
  return _then(_UsageSummary(
tokens: null == tokens ? _self.tokens : tokens // ignore: cast_nullable_to_non_nullable
as int,cost: null == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
