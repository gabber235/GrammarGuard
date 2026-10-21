// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'instruction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Group {

 GroupId get id; String get name; Pick get pick;/// Members are ordered levels; [ and ] step through them (Fix only,
/// Polish, Enhance, Rewrite).
 bool get steps;
/// Create a copy of Group
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupCopyWith<Group> get copyWith => _$GroupCopyWithImpl<Group>(this as Group, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Group;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Group&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.pick, _this.pick) || other.pick == _this.pick)&&(identical(other.steps, _this.steps) || other.steps == _this.steps));
}


@override
int get hashCode {
  final _this = this as Group;
  return Object.hash(runtimeType,_this.id,_this.name,_this.pick,_this.steps);
}

@override
String toString() {
  final _this = this as Group;
  return 'Group(id: ${_this.id}, name: ${_this.name}, pick: ${_this.pick}, steps: ${_this.steps})';
}


}

/// @nodoc
abstract mixin class $GroupCopyWith<$Res>  {
  factory $GroupCopyWith(Group value, $Res Function(Group) _then) = _$GroupCopyWithImpl;
@useResult
$Res call({
 GroupId id, String name, Pick pick, bool steps
});




}
/// @nodoc
class _$GroupCopyWithImpl<$Res>
    implements $GroupCopyWith<$Res> {
  _$GroupCopyWithImpl(this._self, this._then);

  final Group _self;
  final $Res Function(Group) _then;

/// Create a copy of Group
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? pick = null,Object? steps = null,}) {
  return _then(Group(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as GroupId,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,pick: null == pick ? _self.pick : pick // ignore: cast_nullable_to_non_nullable
as Pick,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Group].
extension GroupPatterns on Group {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Group value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Group() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Group value)  $default,){
final _that = this;
switch (_that) {
case _Group():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Group value)?  $default,){
final _that = this;
switch (_that) {
case _Group() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GroupId id,  String name,  Pick pick,  bool steps)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Group() when $default != null:
return $default(_that.id,_that.name,_that.pick,_that.steps);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GroupId id,  String name,  Pick pick,  bool steps)  $default,) {final _that = this;
switch (_that) {
case _Group():
return $default(_that.id,_that.name,_that.pick,_that.steps);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GroupId id,  String name,  Pick pick,  bool steps)?  $default,) {final _that = this;
switch (_that) {
case _Group() when $default != null:
return $default(_that.id,_that.name,_that.pick,_that.steps);case _:
  return null;

}
}

}

/// @nodoc


class _Group implements Group {
  const _Group({required this.id, required this.name, this.pick = Pick.one, this.steps = false});
  

@override final  GroupId id;
@override final  String name;
@override@JsonKey() final  Pick pick;
/// Members are ordered levels; [ and ] step through them (Fix only,
/// Polish, Enhance, Rewrite).
@override@JsonKey() final  bool steps;

/// Create a copy of Group
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupCopyWith<_Group> get copyWith => __$GroupCopyWithImpl<_Group>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Group&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.pick, pick) || other.pick == pick)&&(identical(other.steps, steps) || other.steps == steps));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,pick,steps);
}

@override
String toString() {
    return 'Group(id: $id, name: $name, pick: $pick, steps: $steps)';
}


}

/// @nodoc
abstract mixin class _$GroupCopyWith<$Res> implements $GroupCopyWith<$Res> {
  factory _$GroupCopyWith(_Group value, $Res Function(_Group) _then) = __$GroupCopyWithImpl;
@override @useResult
$Res call({
 GroupId id, String name, Pick pick, bool steps
});




}
/// @nodoc
class __$GroupCopyWithImpl<$Res>
    implements _$GroupCopyWith<$Res> {
  __$GroupCopyWithImpl(this._self, this._then);

  final _Group _self;
  final $Res Function(_Group) _then;

/// Create a copy of Group
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? pick = null,Object? steps = null,}) {
  return _then(_Group(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as GroupId,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,pick: null == pick ? _self.pick : pick // ignore: cast_nullable_to_non_nullable
as Pick,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$Instruction {

 InstructionId get id;/// Shown in the bar and Settings, and what the bar searches.
 String get name;/// Sent to the model as written.
 String get text;/// Number key 1 to 9 that toggles it. Unique in a library.
 int? get pin; GroupId? get group;/// Instructions that cannot be on together with this one, across
/// groups: turning this on turns those off (Fix only excludes Rewrite
/// style requests such as Shorter).
 Set<InstructionId> get excludes;
/// Create a copy of Instruction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstructionCopyWith<Instruction> get copyWith => _$InstructionCopyWithImpl<Instruction>(this as Instruction, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Instruction;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Instruction&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.pin, _this.pin) || other.pin == _this.pin)&&(identical(other.group, _this.group) || other.group == _this.group)&&const DeepCollectionEquality().equals(other.excludes, _this.excludes));
}


@override
int get hashCode {
  final _this = this as Instruction;
  return Object.hash(runtimeType,_this.id,_this.name,_this.text,_this.pin,_this.group,const DeepCollectionEquality().hash(_this.excludes));
}

@override
String toString() {
  final _this = this as Instruction;
  return 'Instruction(id: ${_this.id}, name: ${_this.name}, text: ${_this.text}, pin: ${_this.pin}, group: ${_this.group}, excludes: ${_this.excludes})';
}


}

/// @nodoc
abstract mixin class $InstructionCopyWith<$Res>  {
  factory $InstructionCopyWith(Instruction value, $Res Function(Instruction) _then) = _$InstructionCopyWithImpl;
@useResult
$Res call({
 InstructionId id, String name, String text, int? pin, GroupId? group, Set<InstructionId> excludes
});




}
/// @nodoc
class _$InstructionCopyWithImpl<$Res>
    implements $InstructionCopyWith<$Res> {
  _$InstructionCopyWithImpl(this._self, this._then);

  final Instruction _self;
  final $Res Function(Instruction) _then;

/// Create a copy of Instruction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? text = null,Object? pin = freezed,Object? group = freezed,Object? excludes = null,}) {
  return _then(Instruction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as InstructionId,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,pin: freezed == pin ? _self.pin : pin // ignore: cast_nullable_to_non_nullable
as int?,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as GroupId?,excludes: null == excludes ? _self.excludes : excludes // ignore: cast_nullable_to_non_nullable
as Set<InstructionId>,
  ));
}

}


/// Adds pattern-matching-related methods to [Instruction].
extension InstructionPatterns on Instruction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Instruction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Instruction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Instruction value)  $default,){
final _that = this;
switch (_that) {
case _Instruction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Instruction value)?  $default,){
final _that = this;
switch (_that) {
case _Instruction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( InstructionId id,  String name,  String text,  int? pin,  GroupId? group,  Set<InstructionId> excludes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Instruction() when $default != null:
return $default(_that.id,_that.name,_that.text,_that.pin,_that.group,_that.excludes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( InstructionId id,  String name,  String text,  int? pin,  GroupId? group,  Set<InstructionId> excludes)  $default,) {final _that = this;
switch (_that) {
case _Instruction():
return $default(_that.id,_that.name,_that.text,_that.pin,_that.group,_that.excludes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( InstructionId id,  String name,  String text,  int? pin,  GroupId? group,  Set<InstructionId> excludes)?  $default,) {final _that = this;
switch (_that) {
case _Instruction() when $default != null:
return $default(_that.id,_that.name,_that.text,_that.pin,_that.group,_that.excludes);case _:
  return null;

}
}

}

/// @nodoc


class _Instruction implements Instruction {
  const _Instruction({required this.id, required this.name, required this.text, this.pin, this.group,  Set<InstructionId> excludes = const <InstructionId>{}}): _excludes = excludes;
  

@override final  InstructionId id;
/// Shown in the bar and Settings, and what the bar searches.
@override final  String name;
/// Sent to the model as written.
@override final  String text;
/// Number key 1 to 9 that toggles it. Unique in a library.
@override final  int? pin;
@override final  GroupId? group;
/// Instructions that cannot be on together with this one, across
/// groups: turning this on turns those off (Fix only excludes Rewrite
/// style requests such as Shorter).
 final  Set<InstructionId> _excludes;
/// Instructions that cannot be on together with this one, across
/// groups: turning this on turns those off (Fix only excludes Rewrite
/// style requests such as Shorter).
@override@JsonKey() Set<InstructionId> get excludes {
  if (_excludes is EqualUnmodifiableSetView) return _excludes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_excludes);
}


/// Create a copy of Instruction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstructionCopyWith<_Instruction> get copyWith => __$InstructionCopyWithImpl<_Instruction>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Instruction&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.text, text) || other.text == text)&&(identical(other.pin, pin) || other.pin == pin)&&(identical(other.group, group) || other.group == group)&&const DeepCollectionEquality().equals(other.excludes, _excludes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,text,pin,group,const DeepCollectionEquality().hash(_excludes));
}

@override
String toString() {
    return 'Instruction(id: $id, name: $name, text: $text, pin: $pin, group: $group, excludes: $excludes)';
}


}

/// @nodoc
abstract mixin class _$InstructionCopyWith<$Res> implements $InstructionCopyWith<$Res> {
  factory _$InstructionCopyWith(_Instruction value, $Res Function(_Instruction) _then) = __$InstructionCopyWithImpl;
@override @useResult
$Res call({
 InstructionId id, String name, String text, int? pin, GroupId? group, Set<InstructionId> excludes
});




}
/// @nodoc
class __$InstructionCopyWithImpl<$Res>
    implements _$InstructionCopyWith<$Res> {
  __$InstructionCopyWithImpl(this._self, this._then);

  final _Instruction _self;
  final $Res Function(_Instruction) _then;

/// Create a copy of Instruction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? text = null,Object? pin = freezed,Object? group = freezed,Object? excludes = null,}) {
  return _then(_Instruction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as InstructionId,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,pin: freezed == pin ? _self.pin : pin // ignore: cast_nullable_to_non_nullable
as int?,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as GroupId?,excludes: null == excludes ? _self._excludes : excludes // ignore: cast_nullable_to_non_nullable
as Set<InstructionId>,
  ));
}


}

/// @nodoc
mixin _$When {

/// Lowercased bundle ids, exe names or WM_CLASS values.
 Set<String> get apps; RegExp? get title;/// Browser tab address, where the OS exposes it.
 RegExp? get url;/// ISO 639-1 codes, such as nl or en, from [TextSignals.language].
 Set<String> get languages; int? get minWords; int? get maxWords; Set<Content> get contains;
/// Create a copy of When
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WhenCopyWith<When> get copyWith => _$WhenCopyWithImpl<When>(this as When, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as When;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is When&&const DeepCollectionEquality().equals(other.apps, _this.apps)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.url, _this.url) || other.url == _this.url)&&const DeepCollectionEquality().equals(other.languages, _this.languages)&&(identical(other.minWords, _this.minWords) || other.minWords == _this.minWords)&&(identical(other.maxWords, _this.maxWords) || other.maxWords == _this.maxWords)&&const DeepCollectionEquality().equals(other.contains, _this.contains));
}


@override
int get hashCode {
  final _this = this as When;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.apps),_this.title,_this.url,const DeepCollectionEquality().hash(_this.languages),_this.minWords,_this.maxWords,const DeepCollectionEquality().hash(_this.contains));
}

@override
String toString() {
  final _this = this as When;
  return 'When(apps: ${_this.apps}, title: ${_this.title}, url: ${_this.url}, languages: ${_this.languages}, minWords: ${_this.minWords}, maxWords: ${_this.maxWords}, contains: ${_this.contains})';
}


}

/// @nodoc
abstract mixin class $WhenCopyWith<$Res>  {
  factory $WhenCopyWith(When value, $Res Function(When) _then) = _$WhenCopyWithImpl;
@useResult
$Res call({
 Set<String> apps, RegExp? title, RegExp? url, Set<String> languages, int? minWords, int? maxWords, Set<Content> contains
});




}
/// @nodoc
class _$WhenCopyWithImpl<$Res>
    implements $WhenCopyWith<$Res> {
  _$WhenCopyWithImpl(this._self, this._then);

  final When _self;
  final $Res Function(When) _then;

/// Create a copy of When
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? apps = null,Object? title = freezed,Object? url = freezed,Object? languages = null,Object? minWords = freezed,Object? maxWords = freezed,Object? contains = null,}) {
  return _then(When(
apps: null == apps ? _self.apps : apps // ignore: cast_nullable_to_non_nullable
as Set<String>,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as RegExp?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as RegExp?,languages: null == languages ? _self.languages : languages // ignore: cast_nullable_to_non_nullable
as Set<String>,minWords: freezed == minWords ? _self.minWords : minWords // ignore: cast_nullable_to_non_nullable
as int?,maxWords: freezed == maxWords ? _self.maxWords : maxWords // ignore: cast_nullable_to_non_nullable
as int?,contains: null == contains ? _self.contains : contains // ignore: cast_nullable_to_non_nullable
as Set<Content>,
  ));
}

}


/// Adds pattern-matching-related methods to [When].
extension WhenPatterns on When {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _When value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _When() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _When value)  $default,){
final _that = this;
switch (_that) {
case _When():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _When value)?  $default,){
final _that = this;
switch (_that) {
case _When() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Set<String> apps,  RegExp? title,  RegExp? url,  Set<String> languages,  int? minWords,  int? maxWords,  Set<Content> contains)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _When() when $default != null:
return $default(_that.apps,_that.title,_that.url,_that.languages,_that.minWords,_that.maxWords,_that.contains);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Set<String> apps,  RegExp? title,  RegExp? url,  Set<String> languages,  int? minWords,  int? maxWords,  Set<Content> contains)  $default,) {final _that = this;
switch (_that) {
case _When():
return $default(_that.apps,_that.title,_that.url,_that.languages,_that.minWords,_that.maxWords,_that.contains);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Set<String> apps,  RegExp? title,  RegExp? url,  Set<String> languages,  int? minWords,  int? maxWords,  Set<Content> contains)?  $default,) {final _that = this;
switch (_that) {
case _When() when $default != null:
return $default(_that.apps,_that.title,_that.url,_that.languages,_that.minWords,_that.maxWords,_that.contains);case _:
  return null;

}
}

}

/// @nodoc


class _When extends When {
  const _When({ Set<String> apps = const <String>{}, this.title, this.url,  Set<String> languages = const <String>{}, this.minWords, this.maxWords,  Set<Content> contains = const <Content>{}}): _apps = apps,_languages = languages,_contains = contains,super._();
  

/// Lowercased bundle ids, exe names or WM_CLASS values.
 final  Set<String> _apps;
/// Lowercased bundle ids, exe names or WM_CLASS values.
@override@JsonKey() Set<String> get apps {
  if (_apps is EqualUnmodifiableSetView) return _apps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_apps);
}

@override final  RegExp? title;
/// Browser tab address, where the OS exposes it.
@override final  RegExp? url;
/// ISO 639-1 codes, such as nl or en, from [TextSignals.language].
 final  Set<String> _languages;
/// ISO 639-1 codes, such as nl or en, from [TextSignals.language].
@override@JsonKey() Set<String> get languages {
  if (_languages is EqualUnmodifiableSetView) return _languages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_languages);
}

@override final  int? minWords;
@override final  int? maxWords;
 final  Set<Content> _contains;
@override@JsonKey() Set<Content> get contains {
  if (_contains is EqualUnmodifiableSetView) return _contains;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_contains);
}


/// Create a copy of When
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WhenCopyWith<_When> get copyWith => __$WhenCopyWithImpl<_When>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _When&&const DeepCollectionEquality().equals(other.apps, _apps)&&(identical(other.title, title) || other.title == title)&&(identical(other.url, url) || other.url == url)&&const DeepCollectionEquality().equals(other.languages, _languages)&&(identical(other.minWords, minWords) || other.minWords == minWords)&&(identical(other.maxWords, maxWords) || other.maxWords == maxWords)&&const DeepCollectionEquality().equals(other.contains, _contains));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_apps),title,url,const DeepCollectionEquality().hash(_languages),minWords,maxWords,const DeepCollectionEquality().hash(_contains));
}

@override
String toString() {
    return 'When(apps: $apps, title: $title, url: $url, languages: $languages, minWords: $minWords, maxWords: $maxWords, contains: $contains)';
}


}

/// @nodoc
abstract mixin class _$WhenCopyWith<$Res> implements $WhenCopyWith<$Res> {
  factory _$WhenCopyWith(_When value, $Res Function(_When) _then) = __$WhenCopyWithImpl;
@override @useResult
$Res call({
 Set<String> apps, RegExp? title, RegExp? url, Set<String> languages, int? minWords, int? maxWords, Set<Content> contains
});




}
/// @nodoc
class __$WhenCopyWithImpl<$Res>
    implements _$WhenCopyWith<$Res> {
  __$WhenCopyWithImpl(this._self, this._then);

  final _When _self;
  final $Res Function(_When) _then;

/// Create a copy of When
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? apps = null,Object? title = freezed,Object? url = freezed,Object? languages = null,Object? minWords = freezed,Object? maxWords = freezed,Object? contains = null,}) {
  return _then(_When(
apps: null == apps ? _self._apps : apps // ignore: cast_nullable_to_non_nullable
as Set<String>,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as RegExp?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as RegExp?,languages: null == languages ? _self._languages : languages // ignore: cast_nullable_to_non_nullable
as Set<String>,minWords: freezed == minWords ? _self.minWords : minWords // ignore: cast_nullable_to_non_nullable
as int?,maxWords: freezed == maxWords ? _self.maxWords : maxWords // ignore: cast_nullable_to_non_nullable
as int?,contains: null == contains ? _self._contains : contains // ignore: cast_nullable_to_non_nullable
as Set<Content>,
  ));
}


}

/// @nodoc
mixin _$Profile {

 String get name; When get when; List<InstructionId> get use;/// Model for matching text. The last matching profile with one wins.
 ModelRef? get model; ModelOptions get options;/// Added to the library's keep words while this profile applies.
 List<String> get keepWords;/// Paste, rich paste or copy. Default paste.
 DeliveryMode? get deliver;
/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileCopyWith<Profile> get copyWith => _$ProfileCopyWithImpl<Profile>(this as Profile, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Profile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Profile&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.when, _this.when) || other.when == _this.when)&&const DeepCollectionEquality().equals(other.use, _this.use)&&(identical(other.model, _this.model) || other.model == _this.model)&&(identical(other.options, _this.options) || other.options == _this.options)&&const DeepCollectionEquality().equals(other.keepWords, _this.keepWords)&&(identical(other.deliver, _this.deliver) || other.deliver == _this.deliver));
}


@override
int get hashCode {
  final _this = this as Profile;
  return Object.hash(runtimeType,_this.name,_this.when,const DeepCollectionEquality().hash(_this.use),_this.model,_this.options,const DeepCollectionEquality().hash(_this.keepWords),_this.deliver);
}

@override
String toString() {
  final _this = this as Profile;
  return 'Profile(name: ${_this.name}, when: ${_this.when}, use: ${_this.use}, model: ${_this.model}, options: ${_this.options}, keepWords: ${_this.keepWords}, deliver: ${_this.deliver})';
}


}

/// @nodoc
abstract mixin class $ProfileCopyWith<$Res>  {
  factory $ProfileCopyWith(Profile value, $Res Function(Profile) _then) = _$ProfileCopyWithImpl;
@useResult
$Res call({
 String name, When when, List<InstructionId> use, ModelRef? model, ModelOptions options, List<String> keepWords, DeliveryMode? deliver
});


$WhenCopyWith<$Res> get when;$ModelRefCopyWith<$Res>? get model;$ModelOptionsCopyWith<$Res> get options;

}
/// @nodoc
class _$ProfileCopyWithImpl<$Res>
    implements $ProfileCopyWith<$Res> {
  _$ProfileCopyWithImpl(this._self, this._then);

  final Profile _self;
  final $Res Function(Profile) _then;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? when = null,Object? use = null,Object? model = freezed,Object? options = null,Object? keepWords = null,Object? deliver = freezed,}) {
  return _then(Profile(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,when: null == when ? _self.when : when // ignore: cast_nullable_to_non_nullable
as When,use: null == use ? _self.use : use // ignore: cast_nullable_to_non_nullable
as List<InstructionId>,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as ModelRef?,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as ModelOptions,keepWords: null == keepWords ? _self.keepWords : keepWords // ignore: cast_nullable_to_non_nullable
as List<String>,deliver: freezed == deliver ? _self.deliver : deliver // ignore: cast_nullable_to_non_nullable
as DeliveryMode?,
  ));
}
/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WhenCopyWith<$Res> get when {
  
  return $WhenCopyWith<$Res>(_self.when, (value) {
    return _then(_self.copyWith(when: value));
  });
}/// Create a copy of Profile
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
}/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModelOptionsCopyWith<$Res> get options {
  
  return $ModelOptionsCopyWith<$Res>(_self.options, (value) {
    return _then(_self.copyWith(options: value));
  });
}
}


/// Adds pattern-matching-related methods to [Profile].
extension ProfilePatterns on Profile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Profile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Profile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Profile value)  $default,){
final _that = this;
switch (_that) {
case _Profile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Profile value)?  $default,){
final _that = this;
switch (_that) {
case _Profile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  When when,  List<InstructionId> use,  ModelRef? model,  ModelOptions options,  List<String> keepWords,  DeliveryMode? deliver)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that.name,_that.when,_that.use,_that.model,_that.options,_that.keepWords,_that.deliver);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  When when,  List<InstructionId> use,  ModelRef? model,  ModelOptions options,  List<String> keepWords,  DeliveryMode? deliver)  $default,) {final _that = this;
switch (_that) {
case _Profile():
return $default(_that.name,_that.when,_that.use,_that.model,_that.options,_that.keepWords,_that.deliver);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  When when,  List<InstructionId> use,  ModelRef? model,  ModelOptions options,  List<String> keepWords,  DeliveryMode? deliver)?  $default,) {final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that.name,_that.when,_that.use,_that.model,_that.options,_that.keepWords,_that.deliver);case _:
  return null;

}
}

}

/// @nodoc


class _Profile implements Profile {
  const _Profile({required this.name, required this.when,  List<InstructionId> use = const <InstructionId>[], this.model, this.options = const ModelOptions(),  List<String> keepWords = const <String>[], this.deliver}): _use = use,_keepWords = keepWords;
  

@override final  String name;
@override final  When when;
 final  List<InstructionId> _use;
@override@JsonKey() List<InstructionId> get use {
  if (_use is EqualUnmodifiableListView) return _use;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_use);
}

/// Model for matching text. The last matching profile with one wins.
@override final  ModelRef? model;
@override@JsonKey() final  ModelOptions options;
/// Added to the library's keep words while this profile applies.
 final  List<String> _keepWords;
/// Added to the library's keep words while this profile applies.
@override@JsonKey() List<String> get keepWords {
  if (_keepWords is EqualUnmodifiableListView) return _keepWords;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_keepWords);
}

/// Paste, rich paste or copy. Default paste.
@override final  DeliveryMode? deliver;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileCopyWith<_Profile> get copyWith => __$ProfileCopyWithImpl<_Profile>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Profile&&(identical(other.name, name) || other.name == name)&&(identical(other.when, when) || other.when == when)&&const DeepCollectionEquality().equals(other.use, _use)&&(identical(other.model, model) || other.model == model)&&(identical(other.options, options) || other.options == options)&&const DeepCollectionEquality().equals(other.keepWords, _keepWords)&&(identical(other.deliver, deliver) || other.deliver == deliver));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,when,const DeepCollectionEquality().hash(_use),model,options,const DeepCollectionEquality().hash(_keepWords),deliver);
}

@override
String toString() {
    return 'Profile(name: $name, when: $when, use: $use, model: $model, options: $options, keepWords: $keepWords, deliver: $deliver)';
}


}

/// @nodoc
abstract mixin class _$ProfileCopyWith<$Res> implements $ProfileCopyWith<$Res> {
  factory _$ProfileCopyWith(_Profile value, $Res Function(_Profile) _then) = __$ProfileCopyWithImpl;
@override @useResult
$Res call({
 String name, When when, List<InstructionId> use, ModelRef? model, ModelOptions options, List<String> keepWords, DeliveryMode? deliver
});


@override $WhenCopyWith<$Res> get when;@override $ModelRefCopyWith<$Res>? get model;@override $ModelOptionsCopyWith<$Res> get options;

}
/// @nodoc
class __$ProfileCopyWithImpl<$Res>
    implements _$ProfileCopyWith<$Res> {
  __$ProfileCopyWithImpl(this._self, this._then);

  final _Profile _self;
  final $Res Function(_Profile) _then;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? when = null,Object? use = null,Object? model = freezed,Object? options = null,Object? keepWords = null,Object? deliver = freezed,}) {
  return _then(_Profile(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,when: null == when ? _self.when : when // ignore: cast_nullable_to_non_nullable
as When,use: null == use ? _self._use : use // ignore: cast_nullable_to_non_nullable
as List<InstructionId>,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as ModelRef?,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as ModelOptions,keepWords: null == keepWords ? _self._keepWords : keepWords // ignore: cast_nullable_to_non_nullable
as List<String>,deliver: freezed == deliver ? _self.deliver : deliver // ignore: cast_nullable_to_non_nullable
as DeliveryMode?,
  ));
}

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WhenCopyWith<$Res> get when {
  
  return $WhenCopyWith<$Res>(_self.when, (value) {
    return _then(_self.copyWith(when: value));
  });
}/// Create a copy of Profile
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
}/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModelOptionsCopyWith<$Res> get options {
  
  return $ModelOptionsCopyWith<$Res>(_self.options, (value) {
    return _then(_self.copyWith(options: value));
  });
}
}

/// @nodoc
mixin _$Library {

 List<Group> get groups; List<Instruction> get instructions;/// Every matching profile applies, in this order.
 List<Profile> get profiles;/// Active in every run, before profiles.
 List<InstructionId> get defaults;/// Names and terms the model must leave exactly as written.
 List<String> get keepWords;/// The "always" model.
 ModelRef? get defaultModel;/// Runs the assistant. Needs tool calls.
 ModelRef? get assistantModel;
/// Create a copy of Library
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibraryCopyWith<Library> get copyWith => _$LibraryCopyWithImpl<Library>(this as Library, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Library;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Library&&const DeepCollectionEquality().equals(other.groups, _this.groups)&&const DeepCollectionEquality().equals(other.instructions, _this.instructions)&&const DeepCollectionEquality().equals(other.profiles, _this.profiles)&&const DeepCollectionEquality().equals(other.defaults, _this.defaults)&&const DeepCollectionEquality().equals(other.keepWords, _this.keepWords)&&(identical(other.defaultModel, _this.defaultModel) || other.defaultModel == _this.defaultModel)&&(identical(other.assistantModel, _this.assistantModel) || other.assistantModel == _this.assistantModel));
}


@override
int get hashCode {
  final _this = this as Library;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.groups),const DeepCollectionEquality().hash(_this.instructions),const DeepCollectionEquality().hash(_this.profiles),const DeepCollectionEquality().hash(_this.defaults),const DeepCollectionEquality().hash(_this.keepWords),_this.defaultModel,_this.assistantModel);
}

@override
String toString() {
  final _this = this as Library;
  return 'Library(groups: ${_this.groups}, instructions: ${_this.instructions}, profiles: ${_this.profiles}, defaults: ${_this.defaults}, keepWords: ${_this.keepWords}, defaultModel: ${_this.defaultModel}, assistantModel: ${_this.assistantModel})';
}


}

/// @nodoc
abstract mixin class $LibraryCopyWith<$Res>  {
  factory $LibraryCopyWith(Library value, $Res Function(Library) _then) = _$LibraryCopyWithImpl;
@useResult
$Res call({
 List<Group> groups, List<Instruction> instructions, List<Profile> profiles, List<InstructionId> defaults, List<String> keepWords, ModelRef? defaultModel, ModelRef? assistantModel
});


$ModelRefCopyWith<$Res>? get defaultModel;$ModelRefCopyWith<$Res>? get assistantModel;

}
/// @nodoc
class _$LibraryCopyWithImpl<$Res>
    implements $LibraryCopyWith<$Res> {
  _$LibraryCopyWithImpl(this._self, this._then);

  final Library _self;
  final $Res Function(Library) _then;

/// Create a copy of Library
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groups = null,Object? instructions = null,Object? profiles = null,Object? defaults = null,Object? keepWords = null,Object? defaultModel = freezed,Object? assistantModel = freezed,}) {
  return _then(Library(
groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<Group>,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as List<Instruction>,profiles: null == profiles ? _self.profiles : profiles // ignore: cast_nullable_to_non_nullable
as List<Profile>,defaults: null == defaults ? _self.defaults : defaults // ignore: cast_nullable_to_non_nullable
as List<InstructionId>,keepWords: null == keepWords ? _self.keepWords : keepWords // ignore: cast_nullable_to_non_nullable
as List<String>,defaultModel: freezed == defaultModel ? _self.defaultModel : defaultModel // ignore: cast_nullable_to_non_nullable
as ModelRef?,assistantModel: freezed == assistantModel ? _self.assistantModel : assistantModel // ignore: cast_nullable_to_non_nullable
as ModelRef?,
  ));
}
/// Create a copy of Library
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModelRefCopyWith<$Res>? get defaultModel {
    if (_self.defaultModel == null) {
    return null;
  }

  return $ModelRefCopyWith<$Res>(_self.defaultModel!, (value) {
    return _then(_self.copyWith(defaultModel: value));
  });
}/// Create a copy of Library
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


/// Adds pattern-matching-related methods to [Library].
extension LibraryPatterns on Library {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Library value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Library() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Library value)  $default,){
final _that = this;
switch (_that) {
case _Library():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Library value)?  $default,){
final _that = this;
switch (_that) {
case _Library() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Group> groups,  List<Instruction> instructions,  List<Profile> profiles,  List<InstructionId> defaults,  List<String> keepWords,  ModelRef? defaultModel,  ModelRef? assistantModel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Library() when $default != null:
return $default(_that.groups,_that.instructions,_that.profiles,_that.defaults,_that.keepWords,_that.defaultModel,_that.assistantModel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Group> groups,  List<Instruction> instructions,  List<Profile> profiles,  List<InstructionId> defaults,  List<String> keepWords,  ModelRef? defaultModel,  ModelRef? assistantModel)  $default,) {final _that = this;
switch (_that) {
case _Library():
return $default(_that.groups,_that.instructions,_that.profiles,_that.defaults,_that.keepWords,_that.defaultModel,_that.assistantModel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Group> groups,  List<Instruction> instructions,  List<Profile> profiles,  List<InstructionId> defaults,  List<String> keepWords,  ModelRef? defaultModel,  ModelRef? assistantModel)?  $default,) {final _that = this;
switch (_that) {
case _Library() when $default != null:
return $default(_that.groups,_that.instructions,_that.profiles,_that.defaults,_that.keepWords,_that.defaultModel,_that.assistantModel);case _:
  return null;

}
}

}

/// @nodoc


class _Library extends Library {
  const _Library({required  List<Group> groups, required  List<Instruction> instructions, required  List<Profile> profiles, required  List<InstructionId> defaults, required  List<String> keepWords, this.defaultModel, this.assistantModel}): _groups = groups,_instructions = instructions,_profiles = profiles,_defaults = defaults,_keepWords = keepWords,super._();
  

 final  List<Group> _groups;
@override List<Group> get groups {
  if (_groups is EqualUnmodifiableListView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groups);
}

 final  List<Instruction> _instructions;
@override List<Instruction> get instructions {
  if (_instructions is EqualUnmodifiableListView) return _instructions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_instructions);
}

/// Every matching profile applies, in this order.
 final  List<Profile> _profiles;
/// Every matching profile applies, in this order.
@override List<Profile> get profiles {
  if (_profiles is EqualUnmodifiableListView) return _profiles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_profiles);
}

/// Active in every run, before profiles.
 final  List<InstructionId> _defaults;
/// Active in every run, before profiles.
@override List<InstructionId> get defaults {
  if (_defaults is EqualUnmodifiableListView) return _defaults;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_defaults);
}

/// Names and terms the model must leave exactly as written.
 final  List<String> _keepWords;
/// Names and terms the model must leave exactly as written.
@override List<String> get keepWords {
  if (_keepWords is EqualUnmodifiableListView) return _keepWords;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_keepWords);
}

/// The "always" model.
@override final  ModelRef? defaultModel;
/// Runs the assistant. Needs tool calls.
@override final  ModelRef? assistantModel;

/// Create a copy of Library
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibraryCopyWith<_Library> get copyWith => __$LibraryCopyWithImpl<_Library>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Library&&const DeepCollectionEquality().equals(other.groups, _groups)&&const DeepCollectionEquality().equals(other.instructions, _instructions)&&const DeepCollectionEquality().equals(other.profiles, _profiles)&&const DeepCollectionEquality().equals(other.defaults, _defaults)&&const DeepCollectionEquality().equals(other.keepWords, _keepWords)&&(identical(other.defaultModel, defaultModel) || other.defaultModel == defaultModel)&&(identical(other.assistantModel, assistantModel) || other.assistantModel == assistantModel));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_groups),const DeepCollectionEquality().hash(_instructions),const DeepCollectionEquality().hash(_profiles),const DeepCollectionEquality().hash(_defaults),const DeepCollectionEquality().hash(_keepWords),defaultModel,assistantModel);
}

@override
String toString() {
    return 'Library(groups: $groups, instructions: $instructions, profiles: $profiles, defaults: $defaults, keepWords: $keepWords, defaultModel: $defaultModel, assistantModel: $assistantModel)';
}


}

/// @nodoc
abstract mixin class _$LibraryCopyWith<$Res> implements $LibraryCopyWith<$Res> {
  factory _$LibraryCopyWith(_Library value, $Res Function(_Library) _then) = __$LibraryCopyWithImpl;
@override @useResult
$Res call({
 List<Group> groups, List<Instruction> instructions, List<Profile> profiles, List<InstructionId> defaults, List<String> keepWords, ModelRef? defaultModel, ModelRef? assistantModel
});


@override $ModelRefCopyWith<$Res>? get defaultModel;@override $ModelRefCopyWith<$Res>? get assistantModel;

}
/// @nodoc
class __$LibraryCopyWithImpl<$Res>
    implements _$LibraryCopyWith<$Res> {
  __$LibraryCopyWithImpl(this._self, this._then);

  final _Library _self;
  final $Res Function(_Library) _then;

/// Create a copy of Library
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groups = null,Object? instructions = null,Object? profiles = null,Object? defaults = null,Object? keepWords = null,Object? defaultModel = freezed,Object? assistantModel = freezed,}) {
  return _then(_Library(
groups: null == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as List<Group>,instructions: null == instructions ? _self._instructions : instructions // ignore: cast_nullable_to_non_nullable
as List<Instruction>,profiles: null == profiles ? _self._profiles : profiles // ignore: cast_nullable_to_non_nullable
as List<Profile>,defaults: null == defaults ? _self._defaults : defaults // ignore: cast_nullable_to_non_nullable
as List<InstructionId>,keepWords: null == keepWords ? _self._keepWords : keepWords // ignore: cast_nullable_to_non_nullable
as List<String>,defaultModel: freezed == defaultModel ? _self.defaultModel : defaultModel // ignore: cast_nullable_to_non_nullable
as ModelRef?,assistantModel: freezed == assistantModel ? _self.assistantModel : assistantModel // ignore: cast_nullable_to_non_nullable
as ModelRef?,
  ));
}

/// Create a copy of Library
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModelRefCopyWith<$Res>? get defaultModel {
    if (_self.defaultModel == null) {
    return null;
  }

  return $ModelRefCopyWith<$Res>(_self.defaultModel!, (value) {
    return _then(_self.copyWith(defaultModel: value));
  });
}/// Create a copy of Library
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

/// @nodoc
mixin _$RunChoices {

/// In pick order, so a later pick wins a group or excludes conflict.
 List<InstructionId> get added;/// Default or profile instructions the user switched off.
 Set<InstructionId> get removed;/// Free text from the bar.
 String get words;/// Model picked for now.
 ModelRef? get model;/// Profile picked for now from the bar, instead of the matching ones.
 String? get profile;
/// Create a copy of RunChoices
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RunChoicesCopyWith<RunChoices> get copyWith => _$RunChoicesCopyWithImpl<RunChoices>(this as RunChoices, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RunChoices;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RunChoices&&const DeepCollectionEquality().equals(other.added, _this.added)&&const DeepCollectionEquality().equals(other.removed, _this.removed)&&(identical(other.words, _this.words) || other.words == _this.words)&&(identical(other.model, _this.model) || other.model == _this.model)&&(identical(other.profile, _this.profile) || other.profile == _this.profile));
}


@override
int get hashCode {
  final _this = this as RunChoices;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.added),const DeepCollectionEquality().hash(_this.removed),_this.words,_this.model,_this.profile);
}

@override
String toString() {
  final _this = this as RunChoices;
  return 'RunChoices(added: ${_this.added}, removed: ${_this.removed}, words: ${_this.words}, model: ${_this.model}, profile: ${_this.profile})';
}


}

/// @nodoc
abstract mixin class $RunChoicesCopyWith<$Res>  {
  factory $RunChoicesCopyWith(RunChoices value, $Res Function(RunChoices) _then) = _$RunChoicesCopyWithImpl;
@useResult
$Res call({
 List<InstructionId> added, Set<InstructionId> removed, String words, ModelRef? model, String? profile
});


$ModelRefCopyWith<$Res>? get model;

}
/// @nodoc
class _$RunChoicesCopyWithImpl<$Res>
    implements $RunChoicesCopyWith<$Res> {
  _$RunChoicesCopyWithImpl(this._self, this._then);

  final RunChoices _self;
  final $Res Function(RunChoices) _then;

/// Create a copy of RunChoices
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? added = null,Object? removed = null,Object? words = null,Object? model = freezed,Object? profile = freezed,}) {
  return _then(RunChoices(
added: null == added ? _self.added : added // ignore: cast_nullable_to_non_nullable
as List<InstructionId>,removed: null == removed ? _self.removed : removed // ignore: cast_nullable_to_non_nullable
as Set<InstructionId>,words: null == words ? _self.words : words // ignore: cast_nullable_to_non_nullable
as String,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as ModelRef?,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of RunChoices
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
}
}


/// Adds pattern-matching-related methods to [RunChoices].
extension RunChoicesPatterns on RunChoices {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RunChoices value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RunChoices() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RunChoices value)  $default,){
final _that = this;
switch (_that) {
case _RunChoices():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RunChoices value)?  $default,){
final _that = this;
switch (_that) {
case _RunChoices() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<InstructionId> added,  Set<InstructionId> removed,  String words,  ModelRef? model,  String? profile)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RunChoices() when $default != null:
return $default(_that.added,_that.removed,_that.words,_that.model,_that.profile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<InstructionId> added,  Set<InstructionId> removed,  String words,  ModelRef? model,  String? profile)  $default,) {final _that = this;
switch (_that) {
case _RunChoices():
return $default(_that.added,_that.removed,_that.words,_that.model,_that.profile);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<InstructionId> added,  Set<InstructionId> removed,  String words,  ModelRef? model,  String? profile)?  $default,) {final _that = this;
switch (_that) {
case _RunChoices() when $default != null:
return $default(_that.added,_that.removed,_that.words,_that.model,_that.profile);case _:
  return null;

}
}

}

/// @nodoc


class _RunChoices extends RunChoices {
  const _RunChoices({ List<InstructionId> added = const <InstructionId>[],  Set<InstructionId> removed = const <InstructionId>{}, this.words = "", this.model, this.profile}): _added = added,_removed = removed,super._();
  

/// In pick order, so a later pick wins a group or excludes conflict.
 final  List<InstructionId> _added;
/// In pick order, so a later pick wins a group or excludes conflict.
@override@JsonKey() List<InstructionId> get added {
  if (_added is EqualUnmodifiableListView) return _added;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_added);
}

/// Default or profile instructions the user switched off.
 final  Set<InstructionId> _removed;
/// Default or profile instructions the user switched off.
@override@JsonKey() Set<InstructionId> get removed {
  if (_removed is EqualUnmodifiableSetView) return _removed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_removed);
}

/// Free text from the bar.
@override@JsonKey() final  String words;
/// Model picked for now.
@override final  ModelRef? model;
/// Profile picked for now from the bar, instead of the matching ones.
@override final  String? profile;

/// Create a copy of RunChoices
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RunChoicesCopyWith<_RunChoices> get copyWith => __$RunChoicesCopyWithImpl<_RunChoices>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RunChoices&&const DeepCollectionEquality().equals(other.added, _added)&&const DeepCollectionEquality().equals(other.removed, _removed)&&(identical(other.words, words) || other.words == words)&&(identical(other.model, model) || other.model == model)&&(identical(other.profile, profile) || other.profile == profile));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_added),const DeepCollectionEquality().hash(_removed),words,model,profile);
}

@override
String toString() {
    return 'RunChoices(added: $added, removed: $removed, words: $words, model: $model, profile: $profile)';
}


}

/// @nodoc
abstract mixin class _$RunChoicesCopyWith<$Res> implements $RunChoicesCopyWith<$Res> {
  factory _$RunChoicesCopyWith(_RunChoices value, $Res Function(_RunChoices) _then) = __$RunChoicesCopyWithImpl;
@override @useResult
$Res call({
 List<InstructionId> added, Set<InstructionId> removed, String words, ModelRef? model, String? profile
});


@override $ModelRefCopyWith<$Res>? get model;

}
/// @nodoc
class __$RunChoicesCopyWithImpl<$Res>
    implements _$RunChoicesCopyWith<$Res> {
  __$RunChoicesCopyWithImpl(this._self, this._then);

  final _RunChoices _self;
  final $Res Function(_RunChoices) _then;

/// Create a copy of RunChoices
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? added = null,Object? removed = null,Object? words = null,Object? model = freezed,Object? profile = freezed,}) {
  return _then(_RunChoices(
added: null == added ? _self._added : added // ignore: cast_nullable_to_non_nullable
as List<InstructionId>,removed: null == removed ? _self._removed : removed // ignore: cast_nullable_to_non_nullable
as Set<InstructionId>,words: null == words ? _self.words : words // ignore: cast_nullable_to_non_nullable
as String,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as ModelRef?,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of RunChoices
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
}
}

/// @nodoc
mixin _$Origin {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is Origin);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'Origin()';
}


}

/// @nodoc
class $OriginCopyWith<$Res>  {
$OriginCopyWith(Origin _, $Res Function(Origin) __);
}


/// Adds pattern-matching-related methods to [Origin].
extension OriginPatterns on Origin {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( FromDefaults value)?  defaults,TResult Function( FromProfile value)?  profile,TResult Function( FromYou value)?  you,required TResult orElse(),}){
final _that = this;
switch (_that) {
case FromDefaults() when defaults != null:
return defaults(_that);case FromProfile() when profile != null:
return profile(_that);case FromYou() when you != null:
return you(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( FromDefaults value)  defaults,required TResult Function( FromProfile value)  profile,required TResult Function( FromYou value)  you,}){
final _that = this;
switch (_that) {
case FromDefaults():
return defaults(_that);case FromProfile():
return profile(_that);case FromYou():
return you(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( FromDefaults value)?  defaults,TResult? Function( FromProfile value)?  profile,TResult? Function( FromYou value)?  you,}){
final _that = this;
switch (_that) {
case FromDefaults() when defaults != null:
return defaults(_that);case FromProfile() when profile != null:
return profile(_that);case FromYou() when you != null:
return you(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  defaults,TResult Function( String name)?  profile,TResult Function()?  you,required TResult orElse(),}) {final _that = this;
switch (_that) {
case FromDefaults() when defaults != null:
return defaults();case FromProfile() when profile != null:
return profile(_that.name);case FromYou() when you != null:
return you();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  defaults,required TResult Function( String name)  profile,required TResult Function()  you,}) {final _that = this;
switch (_that) {
case FromDefaults():
return defaults();case FromProfile():
return profile(_that.name);case FromYou():
return you();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  defaults,TResult? Function( String name)?  profile,TResult? Function()?  you,}) {final _that = this;
switch (_that) {
case FromDefaults() when defaults != null:
return defaults();case FromProfile() when profile != null:
return profile(_that.name);case FromYou() when you != null:
return you();case _:
  return null;

}
}

}

/// @nodoc


class FromDefaults implements Origin {
  const FromDefaults();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is FromDefaults);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'Origin.defaults()';
}


}




/// @nodoc


class FromProfile implements Origin {
  const FromProfile(this.name);
  

 final  String name;

/// Create a copy of Origin
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FromProfileCopyWith<FromProfile> get copyWith => _$FromProfileCopyWithImpl<FromProfile>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is FromProfile&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name);
}

@override
String toString() {
    return 'Origin.profile(name: $name)';
}


}

/// @nodoc
abstract mixin class $FromProfileCopyWith<$Res> implements $OriginCopyWith<$Res> {
  factory $FromProfileCopyWith(FromProfile value, $Res Function(FromProfile) _then) = _$FromProfileCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class _$FromProfileCopyWithImpl<$Res>
    implements $FromProfileCopyWith<$Res> {
  _$FromProfileCopyWithImpl(this._self, this._then);

  final FromProfile _self;
  final $Res Function(FromProfile) _then;

/// Create a copy of Origin
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(FromProfile(
null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class FromYou implements Origin {
  const FromYou();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is FromYou);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'Origin.you()';
}


}




/// @nodoc
mixin _$ActiveInstruction {

 Instruction get instruction; Origin get origin;
/// Create a copy of ActiveInstruction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActiveInstructionCopyWith<ActiveInstruction> get copyWith => _$ActiveInstructionCopyWithImpl<ActiveInstruction>(this as ActiveInstruction, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ActiveInstruction;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActiveInstruction&&(identical(other.instruction, _this.instruction) || other.instruction == _this.instruction)&&(identical(other.origin, _this.origin) || other.origin == _this.origin));
}


@override
int get hashCode {
  final _this = this as ActiveInstruction;
  return Object.hash(runtimeType,_this.instruction,_this.origin);
}

@override
String toString() {
  final _this = this as ActiveInstruction;
  return 'ActiveInstruction(instruction: ${_this.instruction}, origin: ${_this.origin})';
}


}

/// @nodoc
abstract mixin class $ActiveInstructionCopyWith<$Res>  {
  factory $ActiveInstructionCopyWith(ActiveInstruction value, $Res Function(ActiveInstruction) _then) = _$ActiveInstructionCopyWithImpl;
@useResult
$Res call({
 Instruction instruction, Origin origin
});


$InstructionCopyWith<$Res> get instruction;$OriginCopyWith<$Res> get origin;

}
/// @nodoc
class _$ActiveInstructionCopyWithImpl<$Res>
    implements $ActiveInstructionCopyWith<$Res> {
  _$ActiveInstructionCopyWithImpl(this._self, this._then);

  final ActiveInstruction _self;
  final $Res Function(ActiveInstruction) _then;

/// Create a copy of ActiveInstruction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? instruction = null,Object? origin = null,}) {
  return _then(ActiveInstruction(
null == instruction ? _self.instruction : instruction // ignore: cast_nullable_to_non_nullable
as Instruction,null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as Origin,
  ));
}
/// Create a copy of ActiveInstruction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InstructionCopyWith<$Res> get instruction {
  
  return $InstructionCopyWith<$Res>(_self.instruction, (value) {
    return _then(_self.copyWith(instruction: value));
  });
}/// Create a copy of ActiveInstruction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OriginCopyWith<$Res> get origin {
  
  return $OriginCopyWith<$Res>(_self.origin, (value) {
    return _then(_self.copyWith(origin: value));
  });
}
}


/// Adds pattern-matching-related methods to [ActiveInstruction].
extension ActiveInstructionPatterns on ActiveInstruction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActiveInstruction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActiveInstruction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActiveInstruction value)  $default,){
final _that = this;
switch (_that) {
case _ActiveInstruction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActiveInstruction value)?  $default,){
final _that = this;
switch (_that) {
case _ActiveInstruction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Instruction instruction,  Origin origin)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActiveInstruction() when $default != null:
return $default(_that.instruction,_that.origin);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Instruction instruction,  Origin origin)  $default,) {final _that = this;
switch (_that) {
case _ActiveInstruction():
return $default(_that.instruction,_that.origin);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Instruction instruction,  Origin origin)?  $default,) {final _that = this;
switch (_that) {
case _ActiveInstruction() when $default != null:
return $default(_that.instruction,_that.origin);case _:
  return null;

}
}

}

/// @nodoc


class _ActiveInstruction implements ActiveInstruction {
  const _ActiveInstruction(this.instruction, this.origin);
  

@override final  Instruction instruction;
@override final  Origin origin;

/// Create a copy of ActiveInstruction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActiveInstructionCopyWith<_ActiveInstruction> get copyWith => __$ActiveInstructionCopyWithImpl<_ActiveInstruction>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActiveInstruction&&(identical(other.instruction, instruction) || other.instruction == instruction)&&(identical(other.origin, origin) || other.origin == origin));
}


@override
int get hashCode {
    return Object.hash(runtimeType,instruction,origin);
}

@override
String toString() {
    return 'ActiveInstruction(instruction: $instruction, origin: $origin)';
}


}

/// @nodoc
abstract mixin class _$ActiveInstructionCopyWith<$Res> implements $ActiveInstructionCopyWith<$Res> {
  factory _$ActiveInstructionCopyWith(_ActiveInstruction value, $Res Function(_ActiveInstruction) _then) = __$ActiveInstructionCopyWithImpl;
@override @useResult
$Res call({
 Instruction instruction, Origin origin
});


@override $InstructionCopyWith<$Res> get instruction;@override $OriginCopyWith<$Res> get origin;

}
/// @nodoc
class __$ActiveInstructionCopyWithImpl<$Res>
    implements _$ActiveInstructionCopyWith<$Res> {
  __$ActiveInstructionCopyWithImpl(this._self, this._then);

  final _ActiveInstruction _self;
  final $Res Function(_ActiveInstruction) _then;

/// Create a copy of ActiveInstruction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? instruction = null,Object? origin = null,}) {
  return _then(_ActiveInstruction(
null == instruction ? _self.instruction : instruction // ignore: cast_nullable_to_non_nullable
as Instruction,null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as Origin,
  ));
}

/// Create a copy of ActiveInstruction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InstructionCopyWith<$Res> get instruction {
  
  return $InstructionCopyWith<$Res>(_self.instruction, (value) {
    return _then(_self.copyWith(instruction: value));
  });
}/// Create a copy of ActiveInstruction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OriginCopyWith<$Res> get origin {
  
  return $OriginCopyWith<$Res>(_self.origin, (value) {
    return _then(_self.copyWith(origin: value));
  });
}
}

/// @nodoc
mixin _$ActiveModel {

 ModelRef get ref; Origin get origin;
/// Create a copy of ActiveModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActiveModelCopyWith<ActiveModel> get copyWith => _$ActiveModelCopyWithImpl<ActiveModel>(this as ActiveModel, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ActiveModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActiveModel&&(identical(other.ref, _this.ref) || other.ref == _this.ref)&&(identical(other.origin, _this.origin) || other.origin == _this.origin));
}


@override
int get hashCode {
  final _this = this as ActiveModel;
  return Object.hash(runtimeType,_this.ref,_this.origin);
}

@override
String toString() {
  final _this = this as ActiveModel;
  return 'ActiveModel(ref: ${_this.ref}, origin: ${_this.origin})';
}


}

/// @nodoc
abstract mixin class $ActiveModelCopyWith<$Res>  {
  factory $ActiveModelCopyWith(ActiveModel value, $Res Function(ActiveModel) _then) = _$ActiveModelCopyWithImpl;
@useResult
$Res call({
 ModelRef ref, Origin origin
});


$ModelRefCopyWith<$Res> get ref;$OriginCopyWith<$Res> get origin;

}
/// @nodoc
class _$ActiveModelCopyWithImpl<$Res>
    implements $ActiveModelCopyWith<$Res> {
  _$ActiveModelCopyWithImpl(this._self, this._then);

  final ActiveModel _self;
  final $Res Function(ActiveModel) _then;

/// Create a copy of ActiveModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ref = null,Object? origin = null,}) {
  return _then(ActiveModel(
null == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as ModelRef,null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as Origin,
  ));
}
/// Create a copy of ActiveModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModelRefCopyWith<$Res> get ref {
  
  return $ModelRefCopyWith<$Res>(_self.ref, (value) {
    return _then(_self.copyWith(ref: value));
  });
}/// Create a copy of ActiveModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OriginCopyWith<$Res> get origin {
  
  return $OriginCopyWith<$Res>(_self.origin, (value) {
    return _then(_self.copyWith(origin: value));
  });
}
}


/// Adds pattern-matching-related methods to [ActiveModel].
extension ActiveModelPatterns on ActiveModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActiveModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActiveModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActiveModel value)  $default,){
final _that = this;
switch (_that) {
case _ActiveModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActiveModel value)?  $default,){
final _that = this;
switch (_that) {
case _ActiveModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ModelRef ref,  Origin origin)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActiveModel() when $default != null:
return $default(_that.ref,_that.origin);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ModelRef ref,  Origin origin)  $default,) {final _that = this;
switch (_that) {
case _ActiveModel():
return $default(_that.ref,_that.origin);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ModelRef ref,  Origin origin)?  $default,) {final _that = this;
switch (_that) {
case _ActiveModel() when $default != null:
return $default(_that.ref,_that.origin);case _:
  return null;

}
}

}

/// @nodoc


class _ActiveModel implements ActiveModel {
  const _ActiveModel(this.ref, this.origin);
  

@override final  ModelRef ref;
@override final  Origin origin;

/// Create a copy of ActiveModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActiveModelCopyWith<_ActiveModel> get copyWith => __$ActiveModelCopyWithImpl<_ActiveModel>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActiveModel&&(identical(other.ref, ref) || other.ref == ref)&&(identical(other.origin, origin) || other.origin == origin));
}


@override
int get hashCode {
    return Object.hash(runtimeType,ref,origin);
}

@override
String toString() {
    return 'ActiveModel(ref: $ref, origin: $origin)';
}


}

/// @nodoc
abstract mixin class _$ActiveModelCopyWith<$Res> implements $ActiveModelCopyWith<$Res> {
  factory _$ActiveModelCopyWith(_ActiveModel value, $Res Function(_ActiveModel) _then) = __$ActiveModelCopyWithImpl;
@override @useResult
$Res call({
 ModelRef ref, Origin origin
});


@override $ModelRefCopyWith<$Res> get ref;@override $OriginCopyWith<$Res> get origin;

}
/// @nodoc
class __$ActiveModelCopyWithImpl<$Res>
    implements _$ActiveModelCopyWith<$Res> {
  __$ActiveModelCopyWithImpl(this._self, this._then);

  final _ActiveModel _self;
  final $Res Function(_ActiveModel) _then;

/// Create a copy of ActiveModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ref = null,Object? origin = null,}) {
  return _then(_ActiveModel(
null == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as ModelRef,null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as Origin,
  ));
}

/// Create a copy of ActiveModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModelRefCopyWith<$Res> get ref {
  
  return $ModelRefCopyWith<$Res>(_self.ref, (value) {
    return _then(_self.copyWith(ref: value));
  });
}/// Create a copy of ActiveModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OriginCopyWith<$Res> get origin {
  
  return $OriginCopyWith<$Res>(_self.origin, (value) {
    return _then(_self.copyWith(origin: value));
  });
}
}

/// @nodoc
mixin _$Resolved {

 TextSignals get signals;/// Every matching profile, in file order.
 List<Profile> get profiles;/// In library file order: the same set always composes the same prompt.
 List<ActiveInstruction> get active; String get words; List<String> get keepWords; ModelOptions get options; DeliveryMode get deliver; SourceApp? get source;/// Null means the first model in the catalog.
 ActiveModel? get model;
/// Create a copy of Resolved
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResolvedCopyWith<Resolved> get copyWith => _$ResolvedCopyWithImpl<Resolved>(this as Resolved, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Resolved;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Resolved&&(identical(other.signals, _this.signals) || other.signals == _this.signals)&&const DeepCollectionEquality().equals(other.profiles, _this.profiles)&&const DeepCollectionEquality().equals(other.active, _this.active)&&(identical(other.words, _this.words) || other.words == _this.words)&&const DeepCollectionEquality().equals(other.keepWords, _this.keepWords)&&(identical(other.options, _this.options) || other.options == _this.options)&&(identical(other.deliver, _this.deliver) || other.deliver == _this.deliver)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.model, _this.model) || other.model == _this.model));
}


@override
int get hashCode {
  final _this = this as Resolved;
  return Object.hash(runtimeType,_this.signals,const DeepCollectionEquality().hash(_this.profiles),const DeepCollectionEquality().hash(_this.active),_this.words,const DeepCollectionEquality().hash(_this.keepWords),_this.options,_this.deliver,_this.source,_this.model);
}

@override
String toString() {
  final _this = this as Resolved;
  return 'Resolved(signals: ${_this.signals}, profiles: ${_this.profiles}, active: ${_this.active}, words: ${_this.words}, keepWords: ${_this.keepWords}, options: ${_this.options}, deliver: ${_this.deliver}, source: ${_this.source}, model: ${_this.model})';
}


}

/// @nodoc
abstract mixin class $ResolvedCopyWith<$Res>  {
  factory $ResolvedCopyWith(Resolved value, $Res Function(Resolved) _then) = _$ResolvedCopyWithImpl;
@useResult
$Res call({
 TextSignals signals, List<Profile> profiles, List<ActiveInstruction> active, String words, List<String> keepWords, ModelOptions options, DeliveryMode deliver, SourceApp? source, ActiveModel? model
});


$TextSignalsCopyWith<$Res> get signals;$ModelOptionsCopyWith<$Res> get options;$SourceAppCopyWith<$Res>? get source;$ActiveModelCopyWith<$Res>? get model;

}
/// @nodoc
class _$ResolvedCopyWithImpl<$Res>
    implements $ResolvedCopyWith<$Res> {
  _$ResolvedCopyWithImpl(this._self, this._then);

  final Resolved _self;
  final $Res Function(Resolved) _then;

/// Create a copy of Resolved
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? signals = null,Object? profiles = null,Object? active = null,Object? words = null,Object? keepWords = null,Object? options = null,Object? deliver = null,Object? source = freezed,Object? model = freezed,}) {
  return _then(Resolved(
signals: null == signals ? _self.signals : signals // ignore: cast_nullable_to_non_nullable
as TextSignals,profiles: null == profiles ? _self.profiles : profiles // ignore: cast_nullable_to_non_nullable
as List<Profile>,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as List<ActiveInstruction>,words: null == words ? _self.words : words // ignore: cast_nullable_to_non_nullable
as String,keepWords: null == keepWords ? _self.keepWords : keepWords // ignore: cast_nullable_to_non_nullable
as List<String>,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as ModelOptions,deliver: null == deliver ? _self.deliver : deliver // ignore: cast_nullable_to_non_nullable
as DeliveryMode,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as SourceApp?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as ActiveModel?,
  ));
}
/// Create a copy of Resolved
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TextSignalsCopyWith<$Res> get signals {
  
  return $TextSignalsCopyWith<$Res>(_self.signals, (value) {
    return _then(_self.copyWith(signals: value));
  });
}/// Create a copy of Resolved
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModelOptionsCopyWith<$Res> get options {
  
  return $ModelOptionsCopyWith<$Res>(_self.options, (value) {
    return _then(_self.copyWith(options: value));
  });
}/// Create a copy of Resolved
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SourceAppCopyWith<$Res>? get source {
    if (_self.source == null) {
    return null;
  }

  return $SourceAppCopyWith<$Res>(_self.source!, (value) {
    return _then(_self.copyWith(source: value));
  });
}/// Create a copy of Resolved
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActiveModelCopyWith<$Res>? get model {
    if (_self.model == null) {
    return null;
  }

  return $ActiveModelCopyWith<$Res>(_self.model!, (value) {
    return _then(_self.copyWith(model: value));
  });
}
}


/// Adds pattern-matching-related methods to [Resolved].
extension ResolvedPatterns on Resolved {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Resolved value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Resolved() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Resolved value)  $default,){
final _that = this;
switch (_that) {
case _Resolved():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Resolved value)?  $default,){
final _that = this;
switch (_that) {
case _Resolved() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TextSignals signals,  List<Profile> profiles,  List<ActiveInstruction> active,  String words,  List<String> keepWords,  ModelOptions options,  DeliveryMode deliver,  SourceApp? source,  ActiveModel? model)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Resolved() when $default != null:
return $default(_that.signals,_that.profiles,_that.active,_that.words,_that.keepWords,_that.options,_that.deliver,_that.source,_that.model);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TextSignals signals,  List<Profile> profiles,  List<ActiveInstruction> active,  String words,  List<String> keepWords,  ModelOptions options,  DeliveryMode deliver,  SourceApp? source,  ActiveModel? model)  $default,) {final _that = this;
switch (_that) {
case _Resolved():
return $default(_that.signals,_that.profiles,_that.active,_that.words,_that.keepWords,_that.options,_that.deliver,_that.source,_that.model);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TextSignals signals,  List<Profile> profiles,  List<ActiveInstruction> active,  String words,  List<String> keepWords,  ModelOptions options,  DeliveryMode deliver,  SourceApp? source,  ActiveModel? model)?  $default,) {final _that = this;
switch (_that) {
case _Resolved() when $default != null:
return $default(_that.signals,_that.profiles,_that.active,_that.words,_that.keepWords,_that.options,_that.deliver,_that.source,_that.model);case _:
  return null;

}
}

}

/// @nodoc


class _Resolved implements Resolved {
  const _Resolved({required this.signals, required  List<Profile> profiles, required  List<ActiveInstruction> active, required this.words, required  List<String> keepWords, required this.options, required this.deliver, this.source, this.model}): _profiles = profiles,_active = active,_keepWords = keepWords;
  

@override final  TextSignals signals;
/// Every matching profile, in file order.
 final  List<Profile> _profiles;
/// Every matching profile, in file order.
@override List<Profile> get profiles {
  if (_profiles is EqualUnmodifiableListView) return _profiles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_profiles);
}

/// In library file order: the same set always composes the same prompt.
 final  List<ActiveInstruction> _active;
/// In library file order: the same set always composes the same prompt.
@override List<ActiveInstruction> get active {
  if (_active is EqualUnmodifiableListView) return _active;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_active);
}

@override final  String words;
 final  List<String> _keepWords;
@override List<String> get keepWords {
  if (_keepWords is EqualUnmodifiableListView) return _keepWords;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_keepWords);
}

@override final  ModelOptions options;
@override final  DeliveryMode deliver;
@override final  SourceApp? source;
/// Null means the first model in the catalog.
@override final  ActiveModel? model;

/// Create a copy of Resolved
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResolvedCopyWith<_Resolved> get copyWith => __$ResolvedCopyWithImpl<_Resolved>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Resolved&&(identical(other.signals, signals) || other.signals == signals)&&const DeepCollectionEquality().equals(other.profiles, _profiles)&&const DeepCollectionEquality().equals(other.active, _active)&&(identical(other.words, words) || other.words == words)&&const DeepCollectionEquality().equals(other.keepWords, _keepWords)&&(identical(other.options, options) || other.options == options)&&(identical(other.deliver, deliver) || other.deliver == deliver)&&(identical(other.source, source) || other.source == source)&&(identical(other.model, model) || other.model == model));
}


@override
int get hashCode {
    return Object.hash(runtimeType,signals,const DeepCollectionEquality().hash(_profiles),const DeepCollectionEquality().hash(_active),words,const DeepCollectionEquality().hash(_keepWords),options,deliver,source,model);
}

@override
String toString() {
    return 'Resolved(signals: $signals, profiles: $profiles, active: $active, words: $words, keepWords: $keepWords, options: $options, deliver: $deliver, source: $source, model: $model)';
}


}

/// @nodoc
abstract mixin class _$ResolvedCopyWith<$Res> implements $ResolvedCopyWith<$Res> {
  factory _$ResolvedCopyWith(_Resolved value, $Res Function(_Resolved) _then) = __$ResolvedCopyWithImpl;
@override @useResult
$Res call({
 TextSignals signals, List<Profile> profiles, List<ActiveInstruction> active, String words, List<String> keepWords, ModelOptions options, DeliveryMode deliver, SourceApp? source, ActiveModel? model
});


@override $TextSignalsCopyWith<$Res> get signals;@override $ModelOptionsCopyWith<$Res> get options;@override $SourceAppCopyWith<$Res>? get source;@override $ActiveModelCopyWith<$Res>? get model;

}
/// @nodoc
class __$ResolvedCopyWithImpl<$Res>
    implements _$ResolvedCopyWith<$Res> {
  __$ResolvedCopyWithImpl(this._self, this._then);

  final _Resolved _self;
  final $Res Function(_Resolved) _then;

/// Create a copy of Resolved
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? signals = null,Object? profiles = null,Object? active = null,Object? words = null,Object? keepWords = null,Object? options = null,Object? deliver = null,Object? source = freezed,Object? model = freezed,}) {
  return _then(_Resolved(
signals: null == signals ? _self.signals : signals // ignore: cast_nullable_to_non_nullable
as TextSignals,profiles: null == profiles ? _self._profiles : profiles // ignore: cast_nullable_to_non_nullable
as List<Profile>,active: null == active ? _self._active : active // ignore: cast_nullable_to_non_nullable
as List<ActiveInstruction>,words: null == words ? _self.words : words // ignore: cast_nullable_to_non_nullable
as String,keepWords: null == keepWords ? _self._keepWords : keepWords // ignore: cast_nullable_to_non_nullable
as List<String>,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as ModelOptions,deliver: null == deliver ? _self.deliver : deliver // ignore: cast_nullable_to_non_nullable
as DeliveryMode,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as SourceApp?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as ActiveModel?,
  ));
}

/// Create a copy of Resolved
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TextSignalsCopyWith<$Res> get signals {
  
  return $TextSignalsCopyWith<$Res>(_self.signals, (value) {
    return _then(_self.copyWith(signals: value));
  });
}/// Create a copy of Resolved
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModelOptionsCopyWith<$Res> get options {
  
  return $ModelOptionsCopyWith<$Res>(_self.options, (value) {
    return _then(_self.copyWith(options: value));
  });
}/// Create a copy of Resolved
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SourceAppCopyWith<$Res>? get source {
    if (_self.source == null) {
    return null;
  }

  return $SourceAppCopyWith<$Res>(_self.source!, (value) {
    return _then(_self.copyWith(source: value));
  });
}/// Create a copy of Resolved
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActiveModelCopyWith<$Res>? get model {
    if (_self.model == null) {
    return null;
  }

  return $ActiveModelCopyWith<$Res>(_self.model!, (value) {
    return _then(_self.copyWith(model: value));
  });
}
}

// dart format on
