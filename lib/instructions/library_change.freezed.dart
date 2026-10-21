// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_change.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LibraryChange {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is LibraryChange);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'LibraryChange()';
}


}

/// @nodoc
class $LibraryChangeCopyWith<$Res>  {
$LibraryChangeCopyWith(LibraryChange _, $Res Function(LibraryChange) __);
}


/// Adds pattern-matching-related methods to [LibraryChange].
extension LibraryChangePatterns on LibraryChange {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PutInstruction value)?  putInstruction,TResult Function( RemoveInstruction value)?  removeInstruction,TResult Function( PutProfile value)?  putProfile,TResult Function( RemoveProfile value)?  removeProfile,TResult Function( PutGroup value)?  putGroup,TResult Function( RemoveGroup value)?  removeGroup,TResult Function( SetDefaults value)?  setDefaults,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PutInstruction() when putInstruction != null:
return putInstruction(_that);case RemoveInstruction() when removeInstruction != null:
return removeInstruction(_that);case PutProfile() when putProfile != null:
return putProfile(_that);case RemoveProfile() when removeProfile != null:
return removeProfile(_that);case PutGroup() when putGroup != null:
return putGroup(_that);case RemoveGroup() when removeGroup != null:
return removeGroup(_that);case SetDefaults() when setDefaults != null:
return setDefaults(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PutInstruction value)  putInstruction,required TResult Function( RemoveInstruction value)  removeInstruction,required TResult Function( PutProfile value)  putProfile,required TResult Function( RemoveProfile value)  removeProfile,required TResult Function( PutGroup value)  putGroup,required TResult Function( RemoveGroup value)  removeGroup,required TResult Function( SetDefaults value)  setDefaults,}){
final _that = this;
switch (_that) {
case PutInstruction():
return putInstruction(_that);case RemoveInstruction():
return removeInstruction(_that);case PutProfile():
return putProfile(_that);case RemoveProfile():
return removeProfile(_that);case PutGroup():
return putGroup(_that);case RemoveGroup():
return removeGroup(_that);case SetDefaults():
return setDefaults(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PutInstruction value)?  putInstruction,TResult? Function( RemoveInstruction value)?  removeInstruction,TResult? Function( PutProfile value)?  putProfile,TResult? Function( RemoveProfile value)?  removeProfile,TResult? Function( PutGroup value)?  putGroup,TResult? Function( RemoveGroup value)?  removeGroup,TResult? Function( SetDefaults value)?  setDefaults,}){
final _that = this;
switch (_that) {
case PutInstruction() when putInstruction != null:
return putInstruction(_that);case RemoveInstruction() when removeInstruction != null:
return removeInstruction(_that);case PutProfile() when putProfile != null:
return putProfile(_that);case RemoveProfile() when removeProfile != null:
return removeProfile(_that);case PutGroup() when putGroup != null:
return putGroup(_that);case RemoveGroup() when removeGroup != null:
return removeGroup(_that);case SetDefaults() when setDefaults != null:
return setDefaults(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( Instruction instruction)?  putInstruction,TResult Function( InstructionId id)?  removeInstruction,TResult Function( Profile profile)?  putProfile,TResult Function( String name)?  removeProfile,TResult Function( Group group)?  putGroup,TResult Function( GroupId id)?  removeGroup,TResult Function( List<InstructionId>? use,  ModelRef? model,  ModelRef? assistantModel,  List<String>? keepWords)?  setDefaults,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PutInstruction() when putInstruction != null:
return putInstruction(_that.instruction);case RemoveInstruction() when removeInstruction != null:
return removeInstruction(_that.id);case PutProfile() when putProfile != null:
return putProfile(_that.profile);case RemoveProfile() when removeProfile != null:
return removeProfile(_that.name);case PutGroup() when putGroup != null:
return putGroup(_that.group);case RemoveGroup() when removeGroup != null:
return removeGroup(_that.id);case SetDefaults() when setDefaults != null:
return setDefaults(_that.use,_that.model,_that.assistantModel,_that.keepWords);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( Instruction instruction)  putInstruction,required TResult Function( InstructionId id)  removeInstruction,required TResult Function( Profile profile)  putProfile,required TResult Function( String name)  removeProfile,required TResult Function( Group group)  putGroup,required TResult Function( GroupId id)  removeGroup,required TResult Function( List<InstructionId>? use,  ModelRef? model,  ModelRef? assistantModel,  List<String>? keepWords)  setDefaults,}) {final _that = this;
switch (_that) {
case PutInstruction():
return putInstruction(_that.instruction);case RemoveInstruction():
return removeInstruction(_that.id);case PutProfile():
return putProfile(_that.profile);case RemoveProfile():
return removeProfile(_that.name);case PutGroup():
return putGroup(_that.group);case RemoveGroup():
return removeGroup(_that.id);case SetDefaults():
return setDefaults(_that.use,_that.model,_that.assistantModel,_that.keepWords);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( Instruction instruction)?  putInstruction,TResult? Function( InstructionId id)?  removeInstruction,TResult? Function( Profile profile)?  putProfile,TResult? Function( String name)?  removeProfile,TResult? Function( Group group)?  putGroup,TResult? Function( GroupId id)?  removeGroup,TResult? Function( List<InstructionId>? use,  ModelRef? model,  ModelRef? assistantModel,  List<String>? keepWords)?  setDefaults,}) {final _that = this;
switch (_that) {
case PutInstruction() when putInstruction != null:
return putInstruction(_that.instruction);case RemoveInstruction() when removeInstruction != null:
return removeInstruction(_that.id);case PutProfile() when putProfile != null:
return putProfile(_that.profile);case RemoveProfile() when removeProfile != null:
return removeProfile(_that.name);case PutGroup() when putGroup != null:
return putGroup(_that.group);case RemoveGroup() when removeGroup != null:
return removeGroup(_that.id);case SetDefaults() when setDefaults != null:
return setDefaults(_that.use,_that.model,_that.assistantModel,_that.keepWords);case _:
  return null;

}
}

}

/// @nodoc


class PutInstruction extends LibraryChange {
  const PutInstruction(this.instruction): super._();
  

 final  Instruction instruction;

/// Create a copy of LibraryChange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PutInstructionCopyWith<PutInstruction> get copyWith => _$PutInstructionCopyWithImpl<PutInstruction>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PutInstruction&&(identical(other.instruction, instruction) || other.instruction == instruction));
}


@override
int get hashCode {
    return Object.hash(runtimeType,instruction);
}

@override
String toString() {
    return 'LibraryChange.putInstruction(instruction: $instruction)';
}


}

/// @nodoc
abstract mixin class $PutInstructionCopyWith<$Res> implements $LibraryChangeCopyWith<$Res> {
  factory $PutInstructionCopyWith(PutInstruction value, $Res Function(PutInstruction) _then) = _$PutInstructionCopyWithImpl;
@useResult
$Res call({
 Instruction instruction
});


$InstructionCopyWith<$Res> get instruction;

}
/// @nodoc
class _$PutInstructionCopyWithImpl<$Res>
    implements $PutInstructionCopyWith<$Res> {
  _$PutInstructionCopyWithImpl(this._self, this._then);

  final PutInstruction _self;
  final $Res Function(PutInstruction) _then;

/// Create a copy of LibraryChange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? instruction = null,}) {
  return _then(PutInstruction(
null == instruction ? _self.instruction : instruction // ignore: cast_nullable_to_non_nullable
as Instruction,
  ));
}

/// Create a copy of LibraryChange
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InstructionCopyWith<$Res> get instruction {
  
  return $InstructionCopyWith<$Res>(_self.instruction, (value) {
    return _then(_self.copyWith(instruction: value));
  });
}
}

/// @nodoc


class RemoveInstruction extends LibraryChange {
  const RemoveInstruction(this.id): super._();
  

 final  InstructionId id;

/// Create a copy of LibraryChange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoveInstructionCopyWith<RemoveInstruction> get copyWith => _$RemoveInstructionCopyWithImpl<RemoveInstruction>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoveInstruction&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id);
}

@override
String toString() {
    return 'LibraryChange.removeInstruction(id: $id)';
}


}

/// @nodoc
abstract mixin class $RemoveInstructionCopyWith<$Res> implements $LibraryChangeCopyWith<$Res> {
  factory $RemoveInstructionCopyWith(RemoveInstruction value, $Res Function(RemoveInstruction) _then) = _$RemoveInstructionCopyWithImpl;
@useResult
$Res call({
 InstructionId id
});




}
/// @nodoc
class _$RemoveInstructionCopyWithImpl<$Res>
    implements $RemoveInstructionCopyWith<$Res> {
  _$RemoveInstructionCopyWithImpl(this._self, this._then);

  final RemoveInstruction _self;
  final $Res Function(RemoveInstruction) _then;

/// Create a copy of LibraryChange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(RemoveInstruction(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as InstructionId,
  ));
}


}

/// @nodoc


class PutProfile extends LibraryChange {
  const PutProfile(this.profile): super._();
  

 final  Profile profile;

/// Create a copy of LibraryChange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PutProfileCopyWith<PutProfile> get copyWith => _$PutProfileCopyWithImpl<PutProfile>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PutProfile&&(identical(other.profile, profile) || other.profile == profile));
}


@override
int get hashCode {
    return Object.hash(runtimeType,profile);
}

@override
String toString() {
    return 'LibraryChange.putProfile(profile: $profile)';
}


}

/// @nodoc
abstract mixin class $PutProfileCopyWith<$Res> implements $LibraryChangeCopyWith<$Res> {
  factory $PutProfileCopyWith(PutProfile value, $Res Function(PutProfile) _then) = _$PutProfileCopyWithImpl;
@useResult
$Res call({
 Profile profile
});


$ProfileCopyWith<$Res> get profile;

}
/// @nodoc
class _$PutProfileCopyWithImpl<$Res>
    implements $PutProfileCopyWith<$Res> {
  _$PutProfileCopyWithImpl(this._self, this._then);

  final PutProfile _self;
  final $Res Function(PutProfile) _then;

/// Create a copy of LibraryChange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? profile = null,}) {
  return _then(PutProfile(
null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as Profile,
  ));
}

/// Create a copy of LibraryChange
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileCopyWith<$Res> get profile {
  
  return $ProfileCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}

/// @nodoc


class RemoveProfile extends LibraryChange {
  const RemoveProfile(this.name): super._();
  

 final  String name;

/// Create a copy of LibraryChange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoveProfileCopyWith<RemoveProfile> get copyWith => _$RemoveProfileCopyWithImpl<RemoveProfile>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoveProfile&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name);
}

@override
String toString() {
    return 'LibraryChange.removeProfile(name: $name)';
}


}

/// @nodoc
abstract mixin class $RemoveProfileCopyWith<$Res> implements $LibraryChangeCopyWith<$Res> {
  factory $RemoveProfileCopyWith(RemoveProfile value, $Res Function(RemoveProfile) _then) = _$RemoveProfileCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class _$RemoveProfileCopyWithImpl<$Res>
    implements $RemoveProfileCopyWith<$Res> {
  _$RemoveProfileCopyWithImpl(this._self, this._then);

  final RemoveProfile _self;
  final $Res Function(RemoveProfile) _then;

/// Create a copy of LibraryChange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(RemoveProfile(
null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class PutGroup extends LibraryChange {
  const PutGroup(this.group): super._();
  

 final  Group group;

/// Create a copy of LibraryChange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PutGroupCopyWith<PutGroup> get copyWith => _$PutGroupCopyWithImpl<PutGroup>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PutGroup&&(identical(other.group, group) || other.group == group));
}


@override
int get hashCode {
    return Object.hash(runtimeType,group);
}

@override
String toString() {
    return 'LibraryChange.putGroup(group: $group)';
}


}

/// @nodoc
abstract mixin class $PutGroupCopyWith<$Res> implements $LibraryChangeCopyWith<$Res> {
  factory $PutGroupCopyWith(PutGroup value, $Res Function(PutGroup) _then) = _$PutGroupCopyWithImpl;
@useResult
$Res call({
 Group group
});


$GroupCopyWith<$Res> get group;

}
/// @nodoc
class _$PutGroupCopyWithImpl<$Res>
    implements $PutGroupCopyWith<$Res> {
  _$PutGroupCopyWithImpl(this._self, this._then);

  final PutGroup _self;
  final $Res Function(PutGroup) _then;

/// Create a copy of LibraryChange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? group = null,}) {
  return _then(PutGroup(
null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as Group,
  ));
}

/// Create a copy of LibraryChange
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GroupCopyWith<$Res> get group {
  
  return $GroupCopyWith<$Res>(_self.group, (value) {
    return _then(_self.copyWith(group: value));
  });
}
}

/// @nodoc


class RemoveGroup extends LibraryChange {
  const RemoveGroup(this.id): super._();
  

 final  GroupId id;

/// Create a copy of LibraryChange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoveGroupCopyWith<RemoveGroup> get copyWith => _$RemoveGroupCopyWithImpl<RemoveGroup>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoveGroup&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id);
}

@override
String toString() {
    return 'LibraryChange.removeGroup(id: $id)';
}


}

/// @nodoc
abstract mixin class $RemoveGroupCopyWith<$Res> implements $LibraryChangeCopyWith<$Res> {
  factory $RemoveGroupCopyWith(RemoveGroup value, $Res Function(RemoveGroup) _then) = _$RemoveGroupCopyWithImpl;
@useResult
$Res call({
 GroupId id
});




}
/// @nodoc
class _$RemoveGroupCopyWithImpl<$Res>
    implements $RemoveGroupCopyWith<$Res> {
  _$RemoveGroupCopyWithImpl(this._self, this._then);

  final RemoveGroup _self;
  final $Res Function(RemoveGroup) _then;

/// Create a copy of LibraryChange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(RemoveGroup(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as GroupId,
  ));
}


}

/// @nodoc


class SetDefaults extends LibraryChange {
  const SetDefaults({ List<InstructionId>? use, this.model, this.assistantModel,  List<String>? keepWords}): _use = use,_keepWords = keepWords,super._();
  

 final  List<InstructionId>? _use;
 List<InstructionId>? get use {
  final value = _use;
  if (value == null) return null;
  if (_use is EqualUnmodifiableListView) return _use;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  ModelRef? model;
 final  ModelRef? assistantModel;
 final  List<String>? _keepWords;
 List<String>? get keepWords {
  final value = _keepWords;
  if (value == null) return null;
  if (_keepWords is EqualUnmodifiableListView) return _keepWords;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of LibraryChange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetDefaultsCopyWith<SetDefaults> get copyWith => _$SetDefaultsCopyWithImpl<SetDefaults>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SetDefaults&&const DeepCollectionEquality().equals(other.use, _use)&&(identical(other.model, model) || other.model == model)&&(identical(other.assistantModel, assistantModel) || other.assistantModel == assistantModel)&&const DeepCollectionEquality().equals(other.keepWords, _keepWords));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_use),model,assistantModel,const DeepCollectionEquality().hash(_keepWords));
}

@override
String toString() {
    return 'LibraryChange.setDefaults(use: $use, model: $model, assistantModel: $assistantModel, keepWords: $keepWords)';
}


}

/// @nodoc
abstract mixin class $SetDefaultsCopyWith<$Res> implements $LibraryChangeCopyWith<$Res> {
  factory $SetDefaultsCopyWith(SetDefaults value, $Res Function(SetDefaults) _then) = _$SetDefaultsCopyWithImpl;
@useResult
$Res call({
 List<InstructionId>? use, ModelRef? model, ModelRef? assistantModel, List<String>? keepWords
});


$ModelRefCopyWith<$Res>? get model;$ModelRefCopyWith<$Res>? get assistantModel;

}
/// @nodoc
class _$SetDefaultsCopyWithImpl<$Res>
    implements $SetDefaultsCopyWith<$Res> {
  _$SetDefaultsCopyWithImpl(this._self, this._then);

  final SetDefaults _self;
  final $Res Function(SetDefaults) _then;

/// Create a copy of LibraryChange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? use = freezed,Object? model = freezed,Object? assistantModel = freezed,Object? keepWords = freezed,}) {
  return _then(SetDefaults(
use: freezed == use ? _self._use : use // ignore: cast_nullable_to_non_nullable
as List<InstructionId>?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as ModelRef?,assistantModel: freezed == assistantModel ? _self.assistantModel : assistantModel // ignore: cast_nullable_to_non_nullable
as ModelRef?,keepWords: freezed == keepWords ? _self._keepWords : keepWords // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

/// Create a copy of LibraryChange
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModelRefCopyWith<$Res>? get model {
    if (_self.model == null) {
    return null;
  }

  return $ModelRefCopyWith<$Res>(_self.model!, (value) {
    return _then(_self.copyWith(model: value));
  });
}/// Create a copy of LibraryChange
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModelRefCopyWith<$Res>? get assistantModel {
    if (_self.assistantModel == null) {
    return null;
  }

  return $ModelRefCopyWith<$Res>(_self.assistantModel!, (value) {
    return _then(_self.copyWith(assistantModel: value));
  });
}
}

// dart format on
