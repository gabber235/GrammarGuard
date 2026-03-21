// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_usage.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RequestUsage {

 int get promptTokenCount; int get completionTokenCount; String get modelName; String get providerName; double get cost;
/// Create a copy of RequestUsage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestUsageCopyWith<RequestUsage> get copyWith => _$RequestUsageCopyWithImpl<RequestUsage>(this as RequestUsage, _$identity);

  /// Serializes this RequestUsage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestUsage&&(identical(other.promptTokenCount, promptTokenCount) || other.promptTokenCount == promptTokenCount)&&(identical(other.completionTokenCount, completionTokenCount) || other.completionTokenCount == completionTokenCount)&&(identical(other.modelName, modelName) || other.modelName == modelName)&&(identical(other.providerName, providerName) || other.providerName == providerName)&&(identical(other.cost, cost) || other.cost == cost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,promptTokenCount,completionTokenCount,modelName,providerName,cost);

@override
String toString() {
  return 'RequestUsage(promptTokenCount: $promptTokenCount, completionTokenCount: $completionTokenCount, modelName: $modelName, providerName: $providerName, cost: $cost)';
}


}

/// @nodoc
abstract mixin class $RequestUsageCopyWith<$Res>  {
  factory $RequestUsageCopyWith(RequestUsage value, $Res Function(RequestUsage) _then) = _$RequestUsageCopyWithImpl;
@useResult
$Res call({
 int promptTokenCount, int completionTokenCount, String modelName, String providerName, double cost
});




}
/// @nodoc
class _$RequestUsageCopyWithImpl<$Res>
    implements $RequestUsageCopyWith<$Res> {
  _$RequestUsageCopyWithImpl(this._self, this._then);

  final RequestUsage _self;
  final $Res Function(RequestUsage) _then;

/// Create a copy of RequestUsage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? promptTokenCount = null,Object? completionTokenCount = null,Object? modelName = null,Object? providerName = null,Object? cost = null,}) {
  return _then(_self.copyWith(
promptTokenCount: null == promptTokenCount ? _self.promptTokenCount : promptTokenCount // ignore: cast_nullable_to_non_nullable
as int,completionTokenCount: null == completionTokenCount ? _self.completionTokenCount : completionTokenCount // ignore: cast_nullable_to_non_nullable
as int,modelName: null == modelName ? _self.modelName : modelName // ignore: cast_nullable_to_non_nullable
as String,providerName: null == providerName ? _self.providerName : providerName // ignore: cast_nullable_to_non_nullable
as String,cost: null == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [RequestUsage].
extension RequestUsagePatterns on RequestUsage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RequestUsage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RequestUsage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RequestUsage value)  $default,){
final _that = this;
switch (_that) {
case _RequestUsage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RequestUsage value)?  $default,){
final _that = this;
switch (_that) {
case _RequestUsage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int promptTokenCount,  int completionTokenCount,  String modelName,  String providerName,  double cost)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RequestUsage() when $default != null:
return $default(_that.promptTokenCount,_that.completionTokenCount,_that.modelName,_that.providerName,_that.cost);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int promptTokenCount,  int completionTokenCount,  String modelName,  String providerName,  double cost)  $default,) {final _that = this;
switch (_that) {
case _RequestUsage():
return $default(_that.promptTokenCount,_that.completionTokenCount,_that.modelName,_that.providerName,_that.cost);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int promptTokenCount,  int completionTokenCount,  String modelName,  String providerName,  double cost)?  $default,) {final _that = this;
switch (_that) {
case _RequestUsage() when $default != null:
return $default(_that.promptTokenCount,_that.completionTokenCount,_that.modelName,_that.providerName,_that.cost);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RequestUsage implements RequestUsage {
  const _RequestUsage({required this.promptTokenCount, required this.completionTokenCount, required this.modelName, required this.providerName, required this.cost});
  factory _RequestUsage.fromJson(Map<String, dynamic> json) => _$RequestUsageFromJson(json);

@override final  int promptTokenCount;
@override final  int completionTokenCount;
@override final  String modelName;
@override final  String providerName;
@override final  double cost;

/// Create a copy of RequestUsage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequestUsageCopyWith<_RequestUsage> get copyWith => __$RequestUsageCopyWithImpl<_RequestUsage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RequestUsageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequestUsage&&(identical(other.promptTokenCount, promptTokenCount) || other.promptTokenCount == promptTokenCount)&&(identical(other.completionTokenCount, completionTokenCount) || other.completionTokenCount == completionTokenCount)&&(identical(other.modelName, modelName) || other.modelName == modelName)&&(identical(other.providerName, providerName) || other.providerName == providerName)&&(identical(other.cost, cost) || other.cost == cost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,promptTokenCount,completionTokenCount,modelName,providerName,cost);

@override
String toString() {
  return 'RequestUsage(promptTokenCount: $promptTokenCount, completionTokenCount: $completionTokenCount, modelName: $modelName, providerName: $providerName, cost: $cost)';
}


}

/// @nodoc
abstract mixin class _$RequestUsageCopyWith<$Res> implements $RequestUsageCopyWith<$Res> {
  factory _$RequestUsageCopyWith(_RequestUsage value, $Res Function(_RequestUsage) _then) = __$RequestUsageCopyWithImpl;
@override @useResult
$Res call({
 int promptTokenCount, int completionTokenCount, String modelName, String providerName, double cost
});




}
/// @nodoc
class __$RequestUsageCopyWithImpl<$Res>
    implements _$RequestUsageCopyWith<$Res> {
  __$RequestUsageCopyWithImpl(this._self, this._then);

  final _RequestUsage _self;
  final $Res Function(_RequestUsage) _then;

/// Create a copy of RequestUsage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? promptTokenCount = null,Object? completionTokenCount = null,Object? modelName = null,Object? providerName = null,Object? cost = null,}) {
  return _then(_RequestUsage(
promptTokenCount: null == promptTokenCount ? _self.promptTokenCount : promptTokenCount // ignore: cast_nullable_to_non_nullable
as int,completionTokenCount: null == completionTokenCount ? _self.completionTokenCount : completionTokenCount // ignore: cast_nullable_to_non_nullable
as int,modelName: null == modelName ? _self.modelName : modelName // ignore: cast_nullable_to_non_nullable
as String,providerName: null == providerName ? _self.providerName : providerName // ignore: cast_nullable_to_non_nullable
as String,cost: null == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
