// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionState {

/// Null until text is captured. No text means no model call.
 Captured? get input; RunChoices get choices;/// Second model while comparing (C). Both results run side by side.
 ModelRef? get compare;/// The bar, shown in place of the result while set (Space, M, C).
 BarRequest? get bar;/// Esc during a run. Stops watching the run, which cancels it.
 bool get cancelled;/// One line toast: "Copied", "Select some text first", a paste problem.
 String? get notice;
/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionStateCopyWith<SessionState> get copyWith => _$SessionStateCopyWithImpl<SessionState>(this as SessionState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SessionState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionState&&(identical(other.input, _this.input) || other.input == _this.input)&&(identical(other.choices, _this.choices) || other.choices == _this.choices)&&(identical(other.compare, _this.compare) || other.compare == _this.compare)&&(identical(other.bar, _this.bar) || other.bar == _this.bar)&&(identical(other.cancelled, _this.cancelled) || other.cancelled == _this.cancelled)&&(identical(other.notice, _this.notice) || other.notice == _this.notice));
}


@override
int get hashCode {
  final _this = this as SessionState;
  return Object.hash(runtimeType,_this.input,_this.choices,_this.compare,_this.bar,_this.cancelled,_this.notice);
}

@override
String toString() {
  final _this = this as SessionState;
  return 'SessionState(input: ${_this.input}, choices: ${_this.choices}, compare: ${_this.compare}, bar: ${_this.bar}, cancelled: ${_this.cancelled}, notice: ${_this.notice})';
}


}

/// @nodoc
abstract mixin class $SessionStateCopyWith<$Res>  {
  factory $SessionStateCopyWith(SessionState value, $Res Function(SessionState) _then) = _$SessionStateCopyWithImpl;
@useResult
$Res call({
 Captured? input, RunChoices choices, ModelRef? compare, BarRequest? bar, bool cancelled, String? notice
});


$CapturedCopyWith<$Res>? get input;$RunChoicesCopyWith<$Res> get choices;$ModelRefCopyWith<$Res>? get compare;$BarRequestCopyWith<$Res>? get bar;

}
/// @nodoc
class _$SessionStateCopyWithImpl<$Res>
    implements $SessionStateCopyWith<$Res> {
  _$SessionStateCopyWithImpl(this._self, this._then);

  final SessionState _self;
  final $Res Function(SessionState) _then;

/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? input = freezed,Object? choices = null,Object? compare = freezed,Object? bar = freezed,Object? cancelled = null,Object? notice = freezed,}) {
  return _then(SessionState(
input: freezed == input ? _self.input : input // ignore: cast_nullable_to_non_nullable
as Captured?,choices: null == choices ? _self.choices : choices // ignore: cast_nullable_to_non_nullable
as RunChoices,compare: freezed == compare ? _self.compare : compare // ignore: cast_nullable_to_non_nullable
as ModelRef?,bar: freezed == bar ? _self.bar : bar // ignore: cast_nullable_to_non_nullable
as BarRequest?,cancelled: null == cancelled ? _self.cancelled : cancelled // ignore: cast_nullable_to_non_nullable
as bool,notice: freezed == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CapturedCopyWith<$Res>? get input {
    if (_self.input == null) {
    return null;
  }

  return $CapturedCopyWith<$Res>(_self.input!, (value) {
    return _then(_self.copyWith(input: value));
  });
}/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RunChoicesCopyWith<$Res> get choices {
  
  return $RunChoicesCopyWith<$Res>(_self.choices, (value) {
    return _then(_self.copyWith(choices: value));
  });
}/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModelRefCopyWith<$Res>? get compare {
    if (_self.compare == null) {
    return null;
  }

  return $ModelRefCopyWith<$Res>(_self.compare!, (value) {
    return _then(_self.copyWith(compare: value));
  });
}/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BarRequestCopyWith<$Res>? get bar {
    if (_self.bar == null) {
    return null;
  }

  return $BarRequestCopyWith<$Res>(_self.bar!, (value) {
    return _then(_self.copyWith(bar: value));
  });
}
}


/// Adds pattern-matching-related methods to [SessionState].
extension SessionStatePatterns on SessionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionState value)  $default,){
final _that = this;
switch (_that) {
case _SessionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionState value)?  $default,){
final _that = this;
switch (_that) {
case _SessionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Captured? input,  RunChoices choices,  ModelRef? compare,  BarRequest? bar,  bool cancelled,  String? notice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionState() when $default != null:
return $default(_that.input,_that.choices,_that.compare,_that.bar,_that.cancelled,_that.notice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Captured? input,  RunChoices choices,  ModelRef? compare,  BarRequest? bar,  bool cancelled,  String? notice)  $default,) {final _that = this;
switch (_that) {
case _SessionState():
return $default(_that.input,_that.choices,_that.compare,_that.bar,_that.cancelled,_that.notice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Captured? input,  RunChoices choices,  ModelRef? compare,  BarRequest? bar,  bool cancelled,  String? notice)?  $default,) {final _that = this;
switch (_that) {
case _SessionState() when $default != null:
return $default(_that.input,_that.choices,_that.compare,_that.bar,_that.cancelled,_that.notice);case _:
  return null;

}
}

}

/// @nodoc


class _SessionState implements SessionState {
  const _SessionState({this.input, this.choices = const RunChoices(), this.compare, this.bar, this.cancelled = false, this.notice});
  

/// Null until text is captured. No text means no model call.
@override final  Captured? input;
@override@JsonKey() final  RunChoices choices;
/// Second model while comparing (C). Both results run side by side.
@override final  ModelRef? compare;
/// The bar, shown in place of the result while set (Space, M, C).
@override final  BarRequest? bar;
/// Esc during a run. Stops watching the run, which cancels it.
@override@JsonKey() final  bool cancelled;
/// One line toast: "Copied", "Select some text first", a paste problem.
@override final  String? notice;

/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionStateCopyWith<_SessionState> get copyWith => __$SessionStateCopyWithImpl<_SessionState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionState&&(identical(other.input, input) || other.input == input)&&(identical(other.choices, choices) || other.choices == choices)&&(identical(other.compare, compare) || other.compare == compare)&&(identical(other.bar, bar) || other.bar == bar)&&(identical(other.cancelled, cancelled) || other.cancelled == cancelled)&&(identical(other.notice, notice) || other.notice == notice));
}


@override
int get hashCode {
    return Object.hash(runtimeType,input,choices,compare,bar,cancelled,notice);
}

@override
String toString() {
    return 'SessionState(input: $input, choices: $choices, compare: $compare, bar: $bar, cancelled: $cancelled, notice: $notice)';
}


}

/// @nodoc
abstract mixin class _$SessionStateCopyWith<$Res> implements $SessionStateCopyWith<$Res> {
  factory _$SessionStateCopyWith(_SessionState value, $Res Function(_SessionState) _then) = __$SessionStateCopyWithImpl;
@override @useResult
$Res call({
 Captured? input, RunChoices choices, ModelRef? compare, BarRequest? bar, bool cancelled, String? notice
});


@override $CapturedCopyWith<$Res>? get input;@override $RunChoicesCopyWith<$Res> get choices;@override $ModelRefCopyWith<$Res>? get compare;@override $BarRequestCopyWith<$Res>? get bar;

}
/// @nodoc
class __$SessionStateCopyWithImpl<$Res>
    implements _$SessionStateCopyWith<$Res> {
  __$SessionStateCopyWithImpl(this._self, this._then);

  final _SessionState _self;
  final $Res Function(_SessionState) _then;

/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? input = freezed,Object? choices = null,Object? compare = freezed,Object? bar = freezed,Object? cancelled = null,Object? notice = freezed,}) {
  return _then(_SessionState(
input: freezed == input ? _self.input : input // ignore: cast_nullable_to_non_nullable
as Captured?,choices: null == choices ? _self.choices : choices // ignore: cast_nullable_to_non_nullable
as RunChoices,compare: freezed == compare ? _self.compare : compare // ignore: cast_nullable_to_non_nullable
as ModelRef?,bar: freezed == bar ? _self.bar : bar // ignore: cast_nullable_to_non_nullable
as BarRequest?,cancelled: null == cancelled ? _self.cancelled : cancelled // ignore: cast_nullable_to_non_nullable
as bool,notice: freezed == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CapturedCopyWith<$Res>? get input {
    if (_self.input == null) {
    return null;
  }

  return $CapturedCopyWith<$Res>(_self.input!, (value) {
    return _then(_self.copyWith(input: value));
  });
}/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RunChoicesCopyWith<$Res> get choices {
  
  return $RunChoicesCopyWith<$Res>(_self.choices, (value) {
    return _then(_self.copyWith(choices: value));
  });
}/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModelRefCopyWith<$Res>? get compare {
    if (_self.compare == null) {
    return null;
  }

  return $ModelRefCopyWith<$Res>(_self.compare!, (value) {
    return _then(_self.copyWith(compare: value));
  });
}/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BarRequestCopyWith<$Res>? get bar {
    if (_self.bar == null) {
    return null;
  }

  return $BarRequestCopyWith<$Res>(_self.bar!, (value) {
    return _then(_self.copyWith(bar: value));
  });
}
}

/// @nodoc
mixin _$BarRequest {

 String get query; BarMode get mode;
/// Create a copy of BarRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BarRequestCopyWith<BarRequest> get copyWith => _$BarRequestCopyWithImpl<BarRequest>(this as BarRequest, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BarRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BarRequest&&(identical(other.query, _this.query) || other.query == _this.query)&&(identical(other.mode, _this.mode) || other.mode == _this.mode));
}


@override
int get hashCode {
  final _this = this as BarRequest;
  return Object.hash(runtimeType,_this.query,_this.mode);
}

@override
String toString() {
  final _this = this as BarRequest;
  return 'BarRequest(query: ${_this.query}, mode: ${_this.mode})';
}


}

/// @nodoc
abstract mixin class $BarRequestCopyWith<$Res>  {
  factory $BarRequestCopyWith(BarRequest value, $Res Function(BarRequest) _then) = _$BarRequestCopyWithImpl;
@useResult
$Res call({
 String query, BarMode mode
});




}
/// @nodoc
class _$BarRequestCopyWithImpl<$Res>
    implements $BarRequestCopyWith<$Res> {
  _$BarRequestCopyWithImpl(this._self, this._then);

  final BarRequest _self;
  final $Res Function(BarRequest) _then;

/// Create a copy of BarRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = null,Object? mode = null,}) {
  return _then(BarRequest(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as BarMode,
  ));
}

}


/// Adds pattern-matching-related methods to [BarRequest].
extension BarRequestPatterns on BarRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BarRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BarRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BarRequest value)  $default,){
final _that = this;
switch (_that) {
case _BarRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BarRequest value)?  $default,){
final _that = this;
switch (_that) {
case _BarRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String query,  BarMode mode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BarRequest() when $default != null:
return $default(_that.query,_that.mode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String query,  BarMode mode)  $default,) {final _that = this;
switch (_that) {
case _BarRequest():
return $default(_that.query,_that.mode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String query,  BarMode mode)?  $default,) {final _that = this;
switch (_that) {
case _BarRequest() when $default != null:
return $default(_that.query,_that.mode);case _:
  return null;

}
}

}

/// @nodoc


class _BarRequest implements BarRequest {
  const _BarRequest({this.query = "", this.mode = BarMode.act});
  

@override@JsonKey() final  String query;
@override@JsonKey() final  BarMode mode;

/// Create a copy of BarRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BarRequestCopyWith<_BarRequest> get copyWith => __$BarRequestCopyWithImpl<_BarRequest>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BarRequest&&(identical(other.query, query) || other.query == query)&&(identical(other.mode, mode) || other.mode == mode));
}


@override
int get hashCode {
    return Object.hash(runtimeType,query,mode);
}

@override
String toString() {
    return 'BarRequest(query: $query, mode: $mode)';
}


}

/// @nodoc
abstract mixin class _$BarRequestCopyWith<$Res> implements $BarRequestCopyWith<$Res> {
  factory _$BarRequestCopyWith(_BarRequest value, $Res Function(_BarRequest) _then) = __$BarRequestCopyWithImpl;
@override @useResult
$Res call({
 String query, BarMode mode
});




}
/// @nodoc
class __$BarRequestCopyWithImpl<$Res>
    implements _$BarRequestCopyWith<$Res> {
  __$BarRequestCopyWithImpl(this._self, this._then);

  final _BarRequest _self;
  final $Res Function(_BarRequest) _then;

/// Create a copy of BarRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = null,Object? mode = null,}) {
  return _then(_BarRequest(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as BarMode,
  ));
}


}

// dart format on
