// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HistoryEntry {

 DateTime get at; String get input; String get output; List<String> get profiles; List<String> get instructions; List<String> get picked; String get words; List<Decision> get decisions; String? get appId; String? get app; String? get model; double? get cost;
/// Create a copy of HistoryEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryEntryCopyWith<HistoryEntry> get copyWith => _$HistoryEntryCopyWithImpl<HistoryEntry>(this as HistoryEntry, _$identity);

  /// Serializes this HistoryEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HistoryEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryEntry&&(identical(other.at, _this.at) || other.at == _this.at)&&(identical(other.input, _this.input) || other.input == _this.input)&&(identical(other.output, _this.output) || other.output == _this.output)&&const DeepCollectionEquality().equals(other.profiles, _this.profiles)&&const DeepCollectionEquality().equals(other.instructions, _this.instructions)&&const DeepCollectionEquality().equals(other.picked, _this.picked)&&(identical(other.words, _this.words) || other.words == _this.words)&&const DeepCollectionEquality().equals(other.decisions, _this.decisions)&&(identical(other.appId, _this.appId) || other.appId == _this.appId)&&(identical(other.app, _this.app) || other.app == _this.app)&&(identical(other.model, _this.model) || other.model == _this.model)&&(identical(other.cost, _this.cost) || other.cost == _this.cost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HistoryEntry;
  return Object.hash(runtimeType,_this.at,_this.input,_this.output,const DeepCollectionEquality().hash(_this.profiles),const DeepCollectionEquality().hash(_this.instructions),const DeepCollectionEquality().hash(_this.picked),_this.words,const DeepCollectionEquality().hash(_this.decisions),_this.appId,_this.app,_this.model,_this.cost);
}

@override
String toString() {
  final _this = this as HistoryEntry;
  return 'HistoryEntry(at: ${_this.at}, input: ${_this.input}, output: ${_this.output}, profiles: ${_this.profiles}, instructions: ${_this.instructions}, picked: ${_this.picked}, words: ${_this.words}, decisions: ${_this.decisions}, appId: ${_this.appId}, app: ${_this.app}, model: ${_this.model}, cost: ${_this.cost})';
}


}

/// @nodoc
abstract mixin class $HistoryEntryCopyWith<$Res>  {
  factory $HistoryEntryCopyWith(HistoryEntry value, $Res Function(HistoryEntry) _then) = _$HistoryEntryCopyWithImpl;
@useResult
$Res call({
 DateTime at, String input, String output, List<String> profiles, List<String> instructions, List<String> picked, String words, List<Decision> decisions, String? appId, String? app, String? model, double? cost
});




}
/// @nodoc
class _$HistoryEntryCopyWithImpl<$Res>
    implements $HistoryEntryCopyWith<$Res> {
  _$HistoryEntryCopyWithImpl(this._self, this._then);

  final HistoryEntry _self;
  final $Res Function(HistoryEntry) _then;

/// Create a copy of HistoryEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? at = null,Object? input = null,Object? output = null,Object? profiles = null,Object? instructions = null,Object? picked = null,Object? words = null,Object? decisions = null,Object? appId = freezed,Object? app = freezed,Object? model = freezed,Object? cost = freezed,}) {
  return _then(HistoryEntry(
at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,input: null == input ? _self.input : input // ignore: cast_nullable_to_non_nullable
as String,output: null == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String,profiles: null == profiles ? _self.profiles : profiles // ignore: cast_nullable_to_non_nullable
as List<String>,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as List<String>,picked: null == picked ? _self.picked : picked // ignore: cast_nullable_to_non_nullable
as List<String>,words: null == words ? _self.words : words // ignore: cast_nullable_to_non_nullable
as String,decisions: null == decisions ? _self.decisions : decisions // ignore: cast_nullable_to_non_nullable
as List<Decision>,appId: freezed == appId ? _self.appId : appId // ignore: cast_nullable_to_non_nullable
as String?,app: freezed == app ? _self.app : app // ignore: cast_nullable_to_non_nullable
as String?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,cost: freezed == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [HistoryEntry].
extension HistoryEntryPatterns on HistoryEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistoryEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistoryEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistoryEntry value)  $default,){
final _that = this;
switch (_that) {
case _HistoryEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistoryEntry value)?  $default,){
final _that = this;
switch (_that) {
case _HistoryEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime at,  String input,  String output,  List<String> profiles,  List<String> instructions,  List<String> picked,  String words,  List<Decision> decisions,  String? appId,  String? app,  String? model,  double? cost)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistoryEntry() when $default != null:
return $default(_that.at,_that.input,_that.output,_that.profiles,_that.instructions,_that.picked,_that.words,_that.decisions,_that.appId,_that.app,_that.model,_that.cost);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime at,  String input,  String output,  List<String> profiles,  List<String> instructions,  List<String> picked,  String words,  List<Decision> decisions,  String? appId,  String? app,  String? model,  double? cost)  $default,) {final _that = this;
switch (_that) {
case _HistoryEntry():
return $default(_that.at,_that.input,_that.output,_that.profiles,_that.instructions,_that.picked,_that.words,_that.decisions,_that.appId,_that.app,_that.model,_that.cost);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime at,  String input,  String output,  List<String> profiles,  List<String> instructions,  List<String> picked,  String words,  List<Decision> decisions,  String? appId,  String? app,  String? model,  double? cost)?  $default,) {final _that = this;
switch (_that) {
case _HistoryEntry() when $default != null:
return $default(_that.at,_that.input,_that.output,_that.profiles,_that.instructions,_that.picked,_that.words,_that.decisions,_that.appId,_that.app,_that.model,_that.cost);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HistoryEntry implements HistoryEntry {
  const _HistoryEntry({required this.at, required this.input, required this.output, required  List<String> profiles, required  List<String> instructions, required  List<String> picked, required this.words, required  List<Decision> decisions, this.appId, this.app, this.model, this.cost}): _profiles = profiles,_instructions = instructions,_picked = picked,_decisions = decisions;
  factory _HistoryEntry.fromJson(Map<String, dynamic> json) => _$HistoryEntryFromJson(json);

@override final  DateTime at;
@override final  String input;
@override final  String output;
 final  List<String> _profiles;
@override List<String> get profiles {
  if (_profiles is EqualUnmodifiableListView) return _profiles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_profiles);
}

 final  List<String> _instructions;
@override List<String> get instructions {
  if (_instructions is EqualUnmodifiableListView) return _instructions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_instructions);
}

 final  List<String> _picked;
@override List<String> get picked {
  if (_picked is EqualUnmodifiableListView) return _picked;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_picked);
}

@override final  String words;
 final  List<Decision> _decisions;
@override List<Decision> get decisions {
  if (_decisions is EqualUnmodifiableListView) return _decisions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_decisions);
}

@override final  String? appId;
@override final  String? app;
@override final  String? model;
@override final  double? cost;

/// Create a copy of HistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistoryEntryCopyWith<_HistoryEntry> get copyWith => __$HistoryEntryCopyWithImpl<_HistoryEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HistoryEntryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoryEntry&&(identical(other.at, at) || other.at == at)&&(identical(other.input, input) || other.input == input)&&(identical(other.output, output) || other.output == output)&&const DeepCollectionEquality().equals(other.profiles, _profiles)&&const DeepCollectionEquality().equals(other.instructions, _instructions)&&const DeepCollectionEquality().equals(other.picked, _picked)&&(identical(other.words, words) || other.words == words)&&const DeepCollectionEquality().equals(other.decisions, _decisions)&&(identical(other.appId, appId) || other.appId == appId)&&(identical(other.app, app) || other.app == app)&&(identical(other.model, model) || other.model == model)&&(identical(other.cost, cost) || other.cost == cost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,at,input,output,const DeepCollectionEquality().hash(_profiles),const DeepCollectionEquality().hash(_instructions),const DeepCollectionEquality().hash(_picked),words,const DeepCollectionEquality().hash(_decisions),appId,app,model,cost);
}

@override
String toString() {
    return 'HistoryEntry(at: $at, input: $input, output: $output, profiles: $profiles, instructions: $instructions, picked: $picked, words: $words, decisions: $decisions, appId: $appId, app: $app, model: $model, cost: $cost)';
}


}

/// @nodoc
abstract mixin class _$HistoryEntryCopyWith<$Res> implements $HistoryEntryCopyWith<$Res> {
  factory _$HistoryEntryCopyWith(_HistoryEntry value, $Res Function(_HistoryEntry) _then) = __$HistoryEntryCopyWithImpl;
@override @useResult
$Res call({
 DateTime at, String input, String output, List<String> profiles, List<String> instructions, List<String> picked, String words, List<Decision> decisions, String? appId, String? app, String? model, double? cost
});




}
/// @nodoc
class __$HistoryEntryCopyWithImpl<$Res>
    implements _$HistoryEntryCopyWith<$Res> {
  __$HistoryEntryCopyWithImpl(this._self, this._then);

  final _HistoryEntry _self;
  final $Res Function(_HistoryEntry) _then;

/// Create a copy of HistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? at = null,Object? input = null,Object? output = null,Object? profiles = null,Object? instructions = null,Object? picked = null,Object? words = null,Object? decisions = null,Object? appId = freezed,Object? app = freezed,Object? model = freezed,Object? cost = freezed,}) {
  return _then(_HistoryEntry(
at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,input: null == input ? _self.input : input // ignore: cast_nullable_to_non_nullable
as String,output: null == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String,profiles: null == profiles ? _self._profiles : profiles // ignore: cast_nullable_to_non_nullable
as List<String>,instructions: null == instructions ? _self._instructions : instructions // ignore: cast_nullable_to_non_nullable
as List<String>,picked: null == picked ? _self._picked : picked // ignore: cast_nullable_to_non_nullable
as List<String>,words: null == words ? _self.words : words // ignore: cast_nullable_to_non_nullable
as String,decisions: null == decisions ? _self._decisions : decisions // ignore: cast_nullable_to_non_nullable
as List<Decision>,appId: freezed == appId ? _self.appId : appId // ignore: cast_nullable_to_non_nullable
as String?,app: freezed == app ? _self.app : app // ignore: cast_nullable_to_non_nullable
as String?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,cost: freezed == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
