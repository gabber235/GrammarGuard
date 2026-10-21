// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bar_items.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BarItem {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is BarItem);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'BarItem()';
}


}

/// @nodoc
class $BarItemCopyWith<$Res>  {
$BarItemCopyWith(BarItem _, $Res Function(BarItem) __);
}


/// Adds pattern-matching-related methods to [BarItem].
extension BarItemPatterns on BarItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( InstructionItem value)?  instruction,TResult Function( ProfileItem value)?  profile,TResult Function( ModelItem value)?  model,TResult Function( ActionItem value)?  action,TResult Function( SuggestionItem value)?  suggestion,TResult Function( WordsItem value)?  words,TResult Function( AskItem value)?  ask,required TResult orElse(),}){
final _that = this;
switch (_that) {
case InstructionItem() when instruction != null:
return instruction(_that);case ProfileItem() when profile != null:
return profile(_that);case ModelItem() when model != null:
return model(_that);case ActionItem() when action != null:
return action(_that);case SuggestionItem() when suggestion != null:
return suggestion(_that);case WordsItem() when words != null:
return words(_that);case AskItem() when ask != null:
return ask(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( InstructionItem value)  instruction,required TResult Function( ProfileItem value)  profile,required TResult Function( ModelItem value)  model,required TResult Function( ActionItem value)  action,required TResult Function( SuggestionItem value)  suggestion,required TResult Function( WordsItem value)  words,required TResult Function( AskItem value)  ask,}){
final _that = this;
switch (_that) {
case InstructionItem():
return instruction(_that);case ProfileItem():
return profile(_that);case ModelItem():
return model(_that);case ActionItem():
return action(_that);case SuggestionItem():
return suggestion(_that);case WordsItem():
return words(_that);case AskItem():
return ask(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( InstructionItem value)?  instruction,TResult? Function( ProfileItem value)?  profile,TResult? Function( ModelItem value)?  model,TResult? Function( ActionItem value)?  action,TResult? Function( SuggestionItem value)?  suggestion,TResult? Function( WordsItem value)?  words,TResult? Function( AskItem value)?  ask,}){
final _that = this;
switch (_that) {
case InstructionItem() when instruction != null:
return instruction(_that);case ProfileItem() when profile != null:
return profile(_that);case ModelItem() when model != null:
return model(_that);case ActionItem() when action != null:
return action(_that);case SuggestionItem() when suggestion != null:
return suggestion(_that);case WordsItem() when words != null:
return words(_that);case AskItem() when ask != null:
return ask(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( Instruction instruction,  bool active)?  instruction,TResult Function( Profile profile)?  profile,TResult Function( ModelInfo model)?  model,TResult Function( BarAction action,  String title)?  action,TResult Function( PutProfile change)?  suggestion,TResult Function( String words,  bool active)?  words,TResult Function( String words)?  ask,required TResult orElse(),}) {final _that = this;
switch (_that) {
case InstructionItem() when instruction != null:
return instruction(_that.instruction,_that.active);case ProfileItem() when profile != null:
return profile(_that.profile);case ModelItem() when model != null:
return model(_that.model);case ActionItem() when action != null:
return action(_that.action,_that.title);case SuggestionItem() when suggestion != null:
return suggestion(_that.change);case WordsItem() when words != null:
return words(_that.words,_that.active);case AskItem() when ask != null:
return ask(_that.words);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( Instruction instruction,  bool active)  instruction,required TResult Function( Profile profile)  profile,required TResult Function( ModelInfo model)  model,required TResult Function( BarAction action,  String title)  action,required TResult Function( PutProfile change)  suggestion,required TResult Function( String words,  bool active)  words,required TResult Function( String words)  ask,}) {final _that = this;
switch (_that) {
case InstructionItem():
return instruction(_that.instruction,_that.active);case ProfileItem():
return profile(_that.profile);case ModelItem():
return model(_that.model);case ActionItem():
return action(_that.action,_that.title);case SuggestionItem():
return suggestion(_that.change);case WordsItem():
return words(_that.words,_that.active);case AskItem():
return ask(_that.words);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( Instruction instruction,  bool active)?  instruction,TResult? Function( Profile profile)?  profile,TResult? Function( ModelInfo model)?  model,TResult? Function( BarAction action,  String title)?  action,TResult? Function( PutProfile change)?  suggestion,TResult? Function( String words,  bool active)?  words,TResult? Function( String words)?  ask,}) {final _that = this;
switch (_that) {
case InstructionItem() when instruction != null:
return instruction(_that.instruction,_that.active);case ProfileItem() when profile != null:
return profile(_that.profile);case ModelItem() when model != null:
return model(_that.model);case ActionItem() when action != null:
return action(_that.action,_that.title);case SuggestionItem() when suggestion != null:
return suggestion(_that.change);case WordsItem() when words != null:
return words(_that.words,_that.active);case AskItem() when ask != null:
return ask(_that.words);case _:
  return null;

}
}

}

/// @nodoc


class InstructionItem extends BarItem {
  const InstructionItem(this.instruction, {required this.active}): super._();
  

 final  Instruction instruction;
 final  bool active;

/// Create a copy of BarItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstructionItemCopyWith<InstructionItem> get copyWith => _$InstructionItemCopyWithImpl<InstructionItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is InstructionItem&&(identical(other.instruction, instruction) || other.instruction == instruction)&&(identical(other.active, active) || other.active == active));
}


@override
int get hashCode {
    return Object.hash(runtimeType,instruction,active);
}

@override
String toString() {
    return 'BarItem.instruction(instruction: $instruction, active: $active)';
}


}

/// @nodoc
abstract mixin class $InstructionItemCopyWith<$Res> implements $BarItemCopyWith<$Res> {
  factory $InstructionItemCopyWith(InstructionItem value, $Res Function(InstructionItem) _then) = _$InstructionItemCopyWithImpl;
@useResult
$Res call({
 Instruction instruction, bool active
});


$InstructionCopyWith<$Res> get instruction;

}
/// @nodoc
class _$InstructionItemCopyWithImpl<$Res>
    implements $InstructionItemCopyWith<$Res> {
  _$InstructionItemCopyWithImpl(this._self, this._then);

  final InstructionItem _self;
  final $Res Function(InstructionItem) _then;

/// Create a copy of BarItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? instruction = null,Object? active = null,}) {
  return _then(InstructionItem(
null == instruction ? _self.instruction : instruction // ignore: cast_nullable_to_non_nullable
as Instruction,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of BarItem
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


class ProfileItem extends BarItem {
  const ProfileItem(this.profile): super._();
  

 final  Profile profile;

/// Create a copy of BarItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileItemCopyWith<ProfileItem> get copyWith => _$ProfileItemCopyWithImpl<ProfileItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileItem&&(identical(other.profile, profile) || other.profile == profile));
}


@override
int get hashCode {
    return Object.hash(runtimeType,profile);
}

@override
String toString() {
    return 'BarItem.profile(profile: $profile)';
}


}

/// @nodoc
abstract mixin class $ProfileItemCopyWith<$Res> implements $BarItemCopyWith<$Res> {
  factory $ProfileItemCopyWith(ProfileItem value, $Res Function(ProfileItem) _then) = _$ProfileItemCopyWithImpl;
@useResult
$Res call({
 Profile profile
});


$ProfileCopyWith<$Res> get profile;

}
/// @nodoc
class _$ProfileItemCopyWithImpl<$Res>
    implements $ProfileItemCopyWith<$Res> {
  _$ProfileItemCopyWithImpl(this._self, this._then);

  final ProfileItem _self;
  final $Res Function(ProfileItem) _then;

/// Create a copy of BarItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? profile = null,}) {
  return _then(ProfileItem(
null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as Profile,
  ));
}

/// Create a copy of BarItem
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


class ModelItem extends BarItem {
  const ModelItem(this.model): super._();
  

 final  ModelInfo model;

/// Create a copy of BarItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModelItemCopyWith<ModelItem> get copyWith => _$ModelItemCopyWithImpl<ModelItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ModelItem&&(identical(other.model, model) || other.model == model));
}


@override
int get hashCode {
    return Object.hash(runtimeType,model);
}

@override
String toString() {
    return 'BarItem.model(model: $model)';
}


}

/// @nodoc
abstract mixin class $ModelItemCopyWith<$Res> implements $BarItemCopyWith<$Res> {
  factory $ModelItemCopyWith(ModelItem value, $Res Function(ModelItem) _then) = _$ModelItemCopyWithImpl;
@useResult
$Res call({
 ModelInfo model
});


$ModelInfoCopyWith<$Res> get model;

}
/// @nodoc
class _$ModelItemCopyWithImpl<$Res>
    implements $ModelItemCopyWith<$Res> {
  _$ModelItemCopyWithImpl(this._self, this._then);

  final ModelItem _self;
  final $Res Function(ModelItem) _then;

/// Create a copy of BarItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? model = null,}) {
  return _then(ModelItem(
null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as ModelInfo,
  ));
}

/// Create a copy of BarItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModelInfoCopyWith<$Res> get model {
  
  return $ModelInfoCopyWith<$Res>(_self.model, (value) {
    return _then(_self.copyWith(model: value));
  });
}
}

/// @nodoc


class ActionItem extends BarItem {
  const ActionItem(this.action, this.title): super._();
  

 final  BarAction action;
 final  String title;

/// Create a copy of BarItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActionItemCopyWith<ActionItem> get copyWith => _$ActionItemCopyWithImpl<ActionItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ActionItem&&(identical(other.action, action) || other.action == action)&&(identical(other.title, title) || other.title == title));
}


@override
int get hashCode {
    return Object.hash(runtimeType,action,title);
}

@override
String toString() {
    return 'BarItem.action(action: $action, title: $title)';
}


}

/// @nodoc
abstract mixin class $ActionItemCopyWith<$Res> implements $BarItemCopyWith<$Res> {
  factory $ActionItemCopyWith(ActionItem value, $Res Function(ActionItem) _then) = _$ActionItemCopyWithImpl;
@useResult
$Res call({
 BarAction action, String title
});




}
/// @nodoc
class _$ActionItemCopyWithImpl<$Res>
    implements $ActionItemCopyWith<$Res> {
  _$ActionItemCopyWithImpl(this._self, this._then);

  final ActionItem _self;
  final $Res Function(ActionItem) _then;

/// Create a copy of BarItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? action = null,Object? title = null,}) {
  return _then(ActionItem(
null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as BarAction,null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SuggestionItem extends BarItem {
  const SuggestionItem(this.change): super._();
  

 final  PutProfile change;

/// Create a copy of BarItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuggestionItemCopyWith<SuggestionItem> get copyWith => _$SuggestionItemCopyWithImpl<SuggestionItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SuggestionItem&&const DeepCollectionEquality().equals(other.change, change));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(change));
}

@override
String toString() {
    return 'BarItem.suggestion(change: $change)';
}


}

/// @nodoc
abstract mixin class $SuggestionItemCopyWith<$Res> implements $BarItemCopyWith<$Res> {
  factory $SuggestionItemCopyWith(SuggestionItem value, $Res Function(SuggestionItem) _then) = _$SuggestionItemCopyWithImpl;
@useResult
$Res call({
 PutProfile change
});




}
/// @nodoc
class _$SuggestionItemCopyWithImpl<$Res>
    implements $SuggestionItemCopyWith<$Res> {
  _$SuggestionItemCopyWithImpl(this._self, this._then);

  final SuggestionItem _self;
  final $Res Function(SuggestionItem) _then;

/// Create a copy of BarItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? change = freezed,}) {
  return _then(SuggestionItem(
freezed == change ? _self.change : change // ignore: cast_nullable_to_non_nullable
as PutProfile,
  ));
}


}

/// @nodoc


class WordsItem extends BarItem {
  const WordsItem(this.words, {this.active = false}): super._();
  

 final  String words;
@JsonKey() final  bool active;

/// Create a copy of BarItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WordsItemCopyWith<WordsItem> get copyWith => _$WordsItemCopyWithImpl<WordsItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is WordsItem&&(identical(other.words, words) || other.words == words)&&(identical(other.active, active) || other.active == active));
}


@override
int get hashCode {
    return Object.hash(runtimeType,words,active);
}

@override
String toString() {
    return 'BarItem.words(words: $words, active: $active)';
}


}

/// @nodoc
abstract mixin class $WordsItemCopyWith<$Res> implements $BarItemCopyWith<$Res> {
  factory $WordsItemCopyWith(WordsItem value, $Res Function(WordsItem) _then) = _$WordsItemCopyWithImpl;
@useResult
$Res call({
 String words, bool active
});




}
/// @nodoc
class _$WordsItemCopyWithImpl<$Res>
    implements $WordsItemCopyWith<$Res> {
  _$WordsItemCopyWithImpl(this._self, this._then);

  final WordsItem _self;
  final $Res Function(WordsItem) _then;

/// Create a copy of BarItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? words = null,Object? active = null,}) {
  return _then(WordsItem(
null == words ? _self.words : words // ignore: cast_nullable_to_non_nullable
as String,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class AskItem extends BarItem {
  const AskItem(this.words): super._();
  

 final  String words;

/// Create a copy of BarItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AskItemCopyWith<AskItem> get copyWith => _$AskItemCopyWithImpl<AskItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AskItem&&(identical(other.words, words) || other.words == words));
}


@override
int get hashCode {
    return Object.hash(runtimeType,words);
}

@override
String toString() {
    return 'BarItem.ask(words: $words)';
}


}

/// @nodoc
abstract mixin class $AskItemCopyWith<$Res> implements $BarItemCopyWith<$Res> {
  factory $AskItemCopyWith(AskItem value, $Res Function(AskItem) _then) = _$AskItemCopyWithImpl;
@useResult
$Res call({
 String words
});




}
/// @nodoc
class _$AskItemCopyWithImpl<$Res>
    implements $AskItemCopyWith<$Res> {
  _$AskItemCopyWithImpl(this._self, this._then);

  final AskItem _self;
  final $Res Function(AskItem) _then;

/// Create a copy of BarItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? words = null,}) {
  return _then(AskItem(
null == words ? _self.words : words // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
