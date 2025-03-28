// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
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

 int get promptTokenCount; int get completionTokenCount; Model get model;
/// Create a copy of RequestUsage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestUsageCopyWith<RequestUsage> get copyWith => _$RequestUsageCopyWithImpl<RequestUsage>(this as RequestUsage, _$identity);

  /// Serializes this RequestUsage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestUsage&&(identical(other.promptTokenCount, promptTokenCount) || other.promptTokenCount == promptTokenCount)&&(identical(other.completionTokenCount, completionTokenCount) || other.completionTokenCount == completionTokenCount)&&(identical(other.model, model) || other.model == model));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,promptTokenCount,completionTokenCount,model);

@override
String toString() {
  return 'RequestUsage(promptTokenCount: $promptTokenCount, completionTokenCount: $completionTokenCount, model: $model)';
}


}

/// @nodoc
abstract mixin class $RequestUsageCopyWith<$Res>  {
  factory $RequestUsageCopyWith(RequestUsage value, $Res Function(RequestUsage) _then) = _$RequestUsageCopyWithImpl;
@useResult
$Res call({
 int promptTokenCount, int completionTokenCount, Model model
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
@pragma('vm:prefer-inline') @override $Res call({Object? promptTokenCount = null,Object? completionTokenCount = null,Object? model = null,}) {
  return _then(_self.copyWith(
promptTokenCount: null == promptTokenCount ? _self.promptTokenCount : promptTokenCount // ignore: cast_nullable_to_non_nullable
as int,completionTokenCount: null == completionTokenCount ? _self.completionTokenCount : completionTokenCount // ignore: cast_nullable_to_non_nullable
as int,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as Model,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _RequestUsage implements RequestUsage {
  const _RequestUsage({required this.promptTokenCount, required this.completionTokenCount, required this.model});
  factory _RequestUsage.fromJson(Map<String, dynamic> json) => _$RequestUsageFromJson(json);

@override final  int promptTokenCount;
@override final  int completionTokenCount;
@override final  Model model;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequestUsage&&(identical(other.promptTokenCount, promptTokenCount) || other.promptTokenCount == promptTokenCount)&&(identical(other.completionTokenCount, completionTokenCount) || other.completionTokenCount == completionTokenCount)&&(identical(other.model, model) || other.model == model));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,promptTokenCount,completionTokenCount,model);

@override
String toString() {
  return 'RequestUsage(promptTokenCount: $promptTokenCount, completionTokenCount: $completionTokenCount, model: $model)';
}


}

/// @nodoc
abstract mixin class _$RequestUsageCopyWith<$Res> implements $RequestUsageCopyWith<$Res> {
  factory _$RequestUsageCopyWith(_RequestUsage value, $Res Function(_RequestUsage) _then) = __$RequestUsageCopyWithImpl;
@override @useResult
$Res call({
 int promptTokenCount, int completionTokenCount, Model model
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
@override @pragma('vm:prefer-inline') $Res call({Object? promptTokenCount = null,Object? completionTokenCount = null,Object? model = null,}) {
  return _then(_RequestUsage(
promptTokenCount: null == promptTokenCount ? _self.promptTokenCount : promptTokenCount // ignore: cast_nullable_to_non_nullable
as int,completionTokenCount: null == completionTokenCount ? _self.completionTokenCount : completionTokenCount // ignore: cast_nullable_to_non_nullable
as int,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as Model,
  ));
}


}

// dart format on
