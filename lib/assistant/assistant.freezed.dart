// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assistant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Proposed {

 ProposalItem get item; bool? get keep;
/// Create a copy of Proposed
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProposedCopyWith<Proposed> get copyWith => _$ProposedCopyWithImpl<Proposed>(this as Proposed, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Proposed;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Proposed&&(identical(other.item, _this.item) || other.item == _this.item)&&(identical(other.keep, _this.keep) || other.keep == _this.keep));
}


@override
int get hashCode {
  final _this = this as Proposed;
  return Object.hash(runtimeType,_this.item,_this.keep);
}

@override
String toString() {
  final _this = this as Proposed;
  return 'Proposed(item: ${_this.item}, keep: ${_this.keep})';
}


}

/// @nodoc
abstract mixin class $ProposedCopyWith<$Res>  {
  factory $ProposedCopyWith(Proposed value, $Res Function(Proposed) _then) = _$ProposedCopyWithImpl;
@useResult
$Res call({
 ProposalItem item, bool? keep
});


$ProposalItemCopyWith<$Res> get item;

}
/// @nodoc
class _$ProposedCopyWithImpl<$Res>
    implements $ProposedCopyWith<$Res> {
  _$ProposedCopyWithImpl(this._self, this._then);

  final Proposed _self;
  final $Res Function(Proposed) _then;

/// Create a copy of Proposed
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? item = null,Object? keep = freezed,}) {
  return _then(Proposed(
null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as ProposalItem,keep: freezed == keep ? _self.keep : keep // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}
/// Create a copy of Proposed
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProposalItemCopyWith<$Res> get item {
  
  return $ProposalItemCopyWith<$Res>(_self.item, (value) {
    return _then(_self.copyWith(item: value));
  });
}
}


/// Adds pattern-matching-related methods to [Proposed].
extension ProposedPatterns on Proposed {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Proposed value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Proposed() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Proposed value)  $default,){
final _that = this;
switch (_that) {
case _Proposed():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Proposed value)?  $default,){
final _that = this;
switch (_that) {
case _Proposed() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProposalItem item,  bool? keep)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Proposed() when $default != null:
return $default(_that.item,_that.keep);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProposalItem item,  bool? keep)  $default,) {final _that = this;
switch (_that) {
case _Proposed():
return $default(_that.item,_that.keep);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProposalItem item,  bool? keep)?  $default,) {final _that = this;
switch (_that) {
case _Proposed() when $default != null:
return $default(_that.item,_that.keep);case _:
  return null;

}
}

}

/// @nodoc


class _Proposed implements Proposed {
  const _Proposed(this.item, {this.keep});
  

@override final  ProposalItem item;
@override final  bool? keep;

/// Create a copy of Proposed
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProposedCopyWith<_Proposed> get copyWith => __$ProposedCopyWithImpl<_Proposed>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Proposed&&(identical(other.item, item) || other.item == item)&&(identical(other.keep, keep) || other.keep == keep));
}


@override
int get hashCode {
    return Object.hash(runtimeType,item,keep);
}

@override
String toString() {
    return 'Proposed(item: $item, keep: $keep)';
}


}

/// @nodoc
abstract mixin class _$ProposedCopyWith<$Res> implements $ProposedCopyWith<$Res> {
  factory _$ProposedCopyWith(_Proposed value, $Res Function(_Proposed) _then) = __$ProposedCopyWithImpl;
@override @useResult
$Res call({
 ProposalItem item, bool? keep
});


@override $ProposalItemCopyWith<$Res> get item;

}
/// @nodoc
class __$ProposedCopyWithImpl<$Res>
    implements _$ProposedCopyWith<$Res> {
  __$ProposedCopyWithImpl(this._self, this._then);

  final _Proposed _self;
  final $Res Function(_Proposed) _then;

/// Create a copy of Proposed
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? item = null,Object? keep = freezed,}) {
  return _then(_Proposed(
null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as ProposalItem,keep: freezed == keep ? _self.keep : keep // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

/// Create a copy of Proposed
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProposalItemCopyWith<$Res> get item {
  
  return $ProposalItemCopyWith<$Res>(_self.item, (value) {
    return _then(_self.copyWith(item: value));
  });
}
}

/// @nodoc
mixin _$AssistantState {

/// Shown in place of the result while true.
 bool get open;/// The conversation in llm_dart's own message types, tool calls included.
 List<llm.ChatMessage> get messages;/// Pending items, reviewed with n, p, y, x and applied with Enter.
 List<Proposed> get proposal; int get current; bool get busy;/// The globe toggle. Off by default.
 bool get webSearch; String? get error;
/// Create a copy of AssistantState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssistantStateCopyWith<AssistantState> get copyWith => _$AssistantStateCopyWithImpl<AssistantState>(this as AssistantState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AssistantState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssistantState&&(identical(other.open, _this.open) || other.open == _this.open)&&const DeepCollectionEquality().equals(other.messages, _this.messages)&&const DeepCollectionEquality().equals(other.proposal, _this.proposal)&&(identical(other.current, _this.current) || other.current == _this.current)&&(identical(other.busy, _this.busy) || other.busy == _this.busy)&&(identical(other.webSearch, _this.webSearch) || other.webSearch == _this.webSearch)&&(identical(other.error, _this.error) || other.error == _this.error));
}


@override
int get hashCode {
  final _this = this as AssistantState;
  return Object.hash(runtimeType,_this.open,const DeepCollectionEquality().hash(_this.messages),const DeepCollectionEquality().hash(_this.proposal),_this.current,_this.busy,_this.webSearch,_this.error);
}

@override
String toString() {
  final _this = this as AssistantState;
  return 'AssistantState(open: ${_this.open}, messages: ${_this.messages}, proposal: ${_this.proposal}, current: ${_this.current}, busy: ${_this.busy}, webSearch: ${_this.webSearch}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $AssistantStateCopyWith<$Res>  {
  factory $AssistantStateCopyWith(AssistantState value, $Res Function(AssistantState) _then) = _$AssistantStateCopyWithImpl;
@useResult
$Res call({
 bool open, List<llm.ChatMessage> messages, List<Proposed> proposal, int current, bool busy, bool webSearch, String? error
});




}
/// @nodoc
class _$AssistantStateCopyWithImpl<$Res>
    implements $AssistantStateCopyWith<$Res> {
  _$AssistantStateCopyWithImpl(this._self, this._then);

  final AssistantState _self;
  final $Res Function(AssistantState) _then;

/// Create a copy of AssistantState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? open = null,Object? messages = null,Object? proposal = null,Object? current = null,Object? busy = null,Object? webSearch = null,Object? error = freezed,}) {
  return _then(AssistantState(
open: null == open ? _self.open : open // ignore: cast_nullable_to_non_nullable
as bool,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<llm.ChatMessage>,proposal: null == proposal ? _self.proposal : proposal // ignore: cast_nullable_to_non_nullable
as List<Proposed>,current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as int,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,webSearch: null == webSearch ? _self.webSearch : webSearch // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AssistantState].
extension AssistantStatePatterns on AssistantState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssistantState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssistantState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssistantState value)  $default,){
final _that = this;
switch (_that) {
case _AssistantState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssistantState value)?  $default,){
final _that = this;
switch (_that) {
case _AssistantState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool open,  List<llm.ChatMessage> messages,  List<Proposed> proposal,  int current,  bool busy,  bool webSearch,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssistantState() when $default != null:
return $default(_that.open,_that.messages,_that.proposal,_that.current,_that.busy,_that.webSearch,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool open,  List<llm.ChatMessage> messages,  List<Proposed> proposal,  int current,  bool busy,  bool webSearch,  String? error)  $default,) {final _that = this;
switch (_that) {
case _AssistantState():
return $default(_that.open,_that.messages,_that.proposal,_that.current,_that.busy,_that.webSearch,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool open,  List<llm.ChatMessage> messages,  List<Proposed> proposal,  int current,  bool busy,  bool webSearch,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _AssistantState() when $default != null:
return $default(_that.open,_that.messages,_that.proposal,_that.current,_that.busy,_that.webSearch,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _AssistantState implements AssistantState {
  const _AssistantState({this.open = false,  List<llm.ChatMessage> messages = const <llm.ChatMessage>[],  List<Proposed> proposal = const <Proposed>[], this.current = 0, this.busy = false, this.webSearch = false, this.error}): _messages = messages,_proposal = proposal;
  

/// Shown in place of the result while true.
@override@JsonKey() final  bool open;
/// The conversation in llm_dart's own message types, tool calls included.
 final  List<llm.ChatMessage> _messages;
/// The conversation in llm_dart's own message types, tool calls included.
@override@JsonKey() List<llm.ChatMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

/// Pending items, reviewed with n, p, y, x and applied with Enter.
 final  List<Proposed> _proposal;
/// Pending items, reviewed with n, p, y, x and applied with Enter.
@override@JsonKey() List<Proposed> get proposal {
  if (_proposal is EqualUnmodifiableListView) return _proposal;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_proposal);
}

@override@JsonKey() final  int current;
@override@JsonKey() final  bool busy;
/// The globe toggle. Off by default.
@override@JsonKey() final  bool webSearch;
@override final  String? error;

/// Create a copy of AssistantState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssistantStateCopyWith<_AssistantState> get copyWith => __$AssistantStateCopyWithImpl<_AssistantState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssistantState&&(identical(other.open, open) || other.open == open)&&const DeepCollectionEquality().equals(other.messages, _messages)&&const DeepCollectionEquality().equals(other.proposal, _proposal)&&(identical(other.current, current) || other.current == current)&&(identical(other.busy, busy) || other.busy == busy)&&(identical(other.webSearch, webSearch) || other.webSearch == webSearch)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,open,const DeepCollectionEquality().hash(_messages),const DeepCollectionEquality().hash(_proposal),current,busy,webSearch,error);
}

@override
String toString() {
    return 'AssistantState(open: $open, messages: $messages, proposal: $proposal, current: $current, busy: $busy, webSearch: $webSearch, error: $error)';
}


}

/// @nodoc
abstract mixin class _$AssistantStateCopyWith<$Res> implements $AssistantStateCopyWith<$Res> {
  factory _$AssistantStateCopyWith(_AssistantState value, $Res Function(_AssistantState) _then) = __$AssistantStateCopyWithImpl;
@override @useResult
$Res call({
 bool open, List<llm.ChatMessage> messages, List<Proposed> proposal, int current, bool busy, bool webSearch, String? error
});




}
/// @nodoc
class __$AssistantStateCopyWithImpl<$Res>
    implements _$AssistantStateCopyWith<$Res> {
  __$AssistantStateCopyWithImpl(this._self, this._then);

  final _AssistantState _self;
  final $Res Function(_AssistantState) _then;

/// Create a copy of AssistantState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? open = null,Object? messages = null,Object? proposal = null,Object? current = null,Object? busy = null,Object? webSearch = null,Object? error = freezed,}) {
  return _then(_AssistantState(
open: null == open ? _self.open : open // ignore: cast_nullable_to_non_nullable
as bool,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<llm.ChatMessage>,proposal: null == proposal ? _self._proposal : proposal // ignore: cast_nullable_to_non_nullable
as List<Proposed>,current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as int,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,webSearch: null == webSearch ? _self.webSearch : webSearch // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
