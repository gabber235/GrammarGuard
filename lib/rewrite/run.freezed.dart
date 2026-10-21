// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'run.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RunRequest {

 ModelInfo get model; Prompt get prompt; ModelOptions get options;/// The captured text, used to restore its outer whitespace.
 String get input;
/// Create a copy of RunRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RunRequestCopyWith<RunRequest> get copyWith => _$RunRequestCopyWithImpl<RunRequest>(this as RunRequest, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RunRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RunRequest&&(identical(other.model, _this.model) || other.model == _this.model)&&(identical(other.prompt, _this.prompt) || other.prompt == _this.prompt)&&(identical(other.options, _this.options) || other.options == _this.options)&&(identical(other.input, _this.input) || other.input == _this.input));
}


@override
int get hashCode {
  final _this = this as RunRequest;
  return Object.hash(runtimeType,_this.model,_this.prompt,_this.options,_this.input);
}

@override
String toString() {
  final _this = this as RunRequest;
  return 'RunRequest(model: ${_this.model}, prompt: ${_this.prompt}, options: ${_this.options}, input: ${_this.input})';
}


}

/// @nodoc
abstract mixin class $RunRequestCopyWith<$Res>  {
  factory $RunRequestCopyWith(RunRequest value, $Res Function(RunRequest) _then) = _$RunRequestCopyWithImpl;
@useResult
$Res call({
 ModelInfo model, Prompt prompt, ModelOptions options, String input
});


$ModelInfoCopyWith<$Res> get model;$PromptCopyWith<$Res> get prompt;$ModelOptionsCopyWith<$Res> get options;

}
/// @nodoc
class _$RunRequestCopyWithImpl<$Res>
    implements $RunRequestCopyWith<$Res> {
  _$RunRequestCopyWithImpl(this._self, this._then);

  final RunRequest _self;
  final $Res Function(RunRequest) _then;

/// Create a copy of RunRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? model = null,Object? prompt = null,Object? options = null,Object? input = null,}) {
  return _then(RunRequest(
model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as ModelInfo,prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as Prompt,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as ModelOptions,input: null == input ? _self.input : input // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of RunRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModelInfoCopyWith<$Res> get model {
  
  return $ModelInfoCopyWith<$Res>(_self.model, (value) {
    return _then(_self.copyWith(model: value));
  });
}/// Create a copy of RunRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PromptCopyWith<$Res> get prompt {
  
  return $PromptCopyWith<$Res>(_self.prompt, (value) {
    return _then(_self.copyWith(prompt: value));
  });
}/// Create a copy of RunRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModelOptionsCopyWith<$Res> get options {
  
  return $ModelOptionsCopyWith<$Res>(_self.options, (value) {
    return _then(_self.copyWith(options: value));
  });
}
}


/// Adds pattern-matching-related methods to [RunRequest].
extension RunRequestPatterns on RunRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RunRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RunRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RunRequest value)  $default,){
final _that = this;
switch (_that) {
case _RunRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RunRequest value)?  $default,){
final _that = this;
switch (_that) {
case _RunRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ModelInfo model,  Prompt prompt,  ModelOptions options,  String input)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RunRequest() when $default != null:
return $default(_that.model,_that.prompt,_that.options,_that.input);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ModelInfo model,  Prompt prompt,  ModelOptions options,  String input)  $default,) {final _that = this;
switch (_that) {
case _RunRequest():
return $default(_that.model,_that.prompt,_that.options,_that.input);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ModelInfo model,  Prompt prompt,  ModelOptions options,  String input)?  $default,) {final _that = this;
switch (_that) {
case _RunRequest() when $default != null:
return $default(_that.model,_that.prompt,_that.options,_that.input);case _:
  return null;

}
}

}

/// @nodoc


class _RunRequest implements RunRequest {
  const _RunRequest({required this.model, required this.prompt, required this.options, required this.input});
  

@override final  ModelInfo model;
@override final  Prompt prompt;
@override final  ModelOptions options;
/// The captured text, used to restore its outer whitespace.
@override final  String input;

/// Create a copy of RunRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RunRequestCopyWith<_RunRequest> get copyWith => __$RunRequestCopyWithImpl<_RunRequest>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RunRequest&&(identical(other.model, model) || other.model == model)&&(identical(other.prompt, prompt) || other.prompt == prompt)&&(identical(other.options, options) || other.options == options)&&(identical(other.input, input) || other.input == input));
}


@override
int get hashCode {
    return Object.hash(runtimeType,model,prompt,options,input);
}

@override
String toString() {
    return 'RunRequest(model: $model, prompt: $prompt, options: $options, input: $input)';
}


}

/// @nodoc
abstract mixin class _$RunRequestCopyWith<$Res> implements $RunRequestCopyWith<$Res> {
  factory _$RunRequestCopyWith(_RunRequest value, $Res Function(_RunRequest) _then) = __$RunRequestCopyWithImpl;
@override @useResult
$Res call({
 ModelInfo model, Prompt prompt, ModelOptions options, String input
});


@override $ModelInfoCopyWith<$Res> get model;@override $PromptCopyWith<$Res> get prompt;@override $ModelOptionsCopyWith<$Res> get options;

}
/// @nodoc
class __$RunRequestCopyWithImpl<$Res>
    implements _$RunRequestCopyWith<$Res> {
  __$RunRequestCopyWithImpl(this._self, this._then);

  final _RunRequest _self;
  final $Res Function(_RunRequest) _then;

/// Create a copy of RunRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? model = null,Object? prompt = null,Object? options = null,Object? input = null,}) {
  return _then(_RunRequest(
model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as ModelInfo,prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as Prompt,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as ModelOptions,input: null == input ? _self.input : input // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of RunRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModelInfoCopyWith<$Res> get model {
  
  return $ModelInfoCopyWith<$Res>(_self.model, (value) {
    return _then(_self.copyWith(model: value));
  });
}/// Create a copy of RunRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PromptCopyWith<$Res> get prompt {
  
  return $PromptCopyWith<$Res>(_self.prompt, (value) {
    return _then(_self.copyWith(prompt: value));
  });
}/// Create a copy of RunRequest
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
mixin _$RunState {

 DateTime get startedAt;
/// Create a copy of RunState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RunStateCopyWith<RunState> get copyWith => _$RunStateCopyWithImpl<RunState>(this as RunState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RunState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RunState&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt));
}


@override
int get hashCode {
  final _this = this as RunState;
  return Object.hash(runtimeType,_this.startedAt);
}

@override
String toString() {
  final _this = this as RunState;
  return 'RunState(startedAt: ${_this.startedAt})';
}


}

/// @nodoc
abstract mixin class $RunStateCopyWith<$Res>  {
  factory $RunStateCopyWith(RunState value, $Res Function(RunState) _then) = _$RunStateCopyWithImpl;
@useResult
$Res call({
 DateTime startedAt
});




}
/// @nodoc
class _$RunStateCopyWithImpl<$Res>
    implements $RunStateCopyWith<$Res> {
  _$RunStateCopyWithImpl(this._self, this._then);

  final RunState _self;
  final $Res Function(RunState) _then;

/// Create a copy of RunState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startedAt = null,}) {
  return _then(_self.copyWith(
startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [RunState].
extension RunStatePatterns on RunState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( Waiting value)?  waiting,TResult Function( Streaming value)?  streaming,TResult Function( Done value)?  done,TResult Function( Failed value)?  failed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case Waiting() when waiting != null:
return waiting(_that);case Streaming() when streaming != null:
return streaming(_that);case Done() when done != null:
return done(_that);case Failed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( Waiting value)  waiting,required TResult Function( Streaming value)  streaming,required TResult Function( Done value)  done,required TResult Function( Failed value)  failed,}){
final _that = this;
switch (_that) {
case Waiting():
return waiting(_that);case Streaming():
return streaming(_that);case Done():
return done(_that);case Failed():
return failed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( Waiting value)?  waiting,TResult? Function( Streaming value)?  streaming,TResult? Function( Done value)?  done,TResult? Function( Failed value)?  failed,}){
final _that = this;
switch (_that) {
case Waiting() when waiting != null:
return waiting(_that);case Streaming() when streaming != null:
return streaming(_that);case Done() when done != null:
return done(_that);case Failed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( DateTime startedAt)?  waiting,TResult Function( DateTime startedAt,  String text,  String thinking,  Duration? firstTokenAfter)?  streaming,TResult Function( DateTime startedAt,  String text,  String thinking,  Duration took,  llm.UsageInfo usage,  double? cost,  Duration? firstTokenAfter)?  done,TResult Function( DateTime startedAt,  String message)?  failed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case Waiting() when waiting != null:
return waiting(_that.startedAt);case Streaming() when streaming != null:
return streaming(_that.startedAt,_that.text,_that.thinking,_that.firstTokenAfter);case Done() when done != null:
return done(_that.startedAt,_that.text,_that.thinking,_that.took,_that.usage,_that.cost,_that.firstTokenAfter);case Failed() when failed != null:
return failed(_that.startedAt,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( DateTime startedAt)  waiting,required TResult Function( DateTime startedAt,  String text,  String thinking,  Duration? firstTokenAfter)  streaming,required TResult Function( DateTime startedAt,  String text,  String thinking,  Duration took,  llm.UsageInfo usage,  double? cost,  Duration? firstTokenAfter)  done,required TResult Function( DateTime startedAt,  String message)  failed,}) {final _that = this;
switch (_that) {
case Waiting():
return waiting(_that.startedAt);case Streaming():
return streaming(_that.startedAt,_that.text,_that.thinking,_that.firstTokenAfter);case Done():
return done(_that.startedAt,_that.text,_that.thinking,_that.took,_that.usage,_that.cost,_that.firstTokenAfter);case Failed():
return failed(_that.startedAt,_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( DateTime startedAt)?  waiting,TResult? Function( DateTime startedAt,  String text,  String thinking,  Duration? firstTokenAfter)?  streaming,TResult? Function( DateTime startedAt,  String text,  String thinking,  Duration took,  llm.UsageInfo usage,  double? cost,  Duration? firstTokenAfter)?  done,TResult? Function( DateTime startedAt,  String message)?  failed,}) {final _that = this;
switch (_that) {
case Waiting() when waiting != null:
return waiting(_that.startedAt);case Streaming() when streaming != null:
return streaming(_that.startedAt,_that.text,_that.thinking,_that.firstTokenAfter);case Done() when done != null:
return done(_that.startedAt,_that.text,_that.thinking,_that.took,_that.usage,_that.cost,_that.firstTokenAfter);case Failed() when failed != null:
return failed(_that.startedAt,_that.message);case _:
  return null;

}
}

}

/// @nodoc


class Waiting extends RunState {
  const Waiting({required this.startedAt}): super._();
  

@override final  DateTime startedAt;

/// Create a copy of RunState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WaitingCopyWith<Waiting> get copyWith => _$WaitingCopyWithImpl<Waiting>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is Waiting&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,startedAt);
}

@override
String toString() {
    return 'RunState.waiting(startedAt: $startedAt)';
}


}

/// @nodoc
abstract mixin class $WaitingCopyWith<$Res> implements $RunStateCopyWith<$Res> {
  factory $WaitingCopyWith(Waiting value, $Res Function(Waiting) _then) = _$WaitingCopyWithImpl;
@override @useResult
$Res call({
 DateTime startedAt
});




}
/// @nodoc
class _$WaitingCopyWithImpl<$Res>
    implements $WaitingCopyWith<$Res> {
  _$WaitingCopyWithImpl(this._self, this._then);

  final Waiting _self;
  final $Res Function(Waiting) _then;

/// Create a copy of RunState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startedAt = null,}) {
  return _then(Waiting(
startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc


class Streaming extends RunState {
  const Streaming({required this.startedAt, required this.text, required this.thinking, this.firstTokenAfter}): super._();
  

@override final  DateTime startedAt;
 final  String text;
 final  String thinking;
/// Null while the model is still thinking.
 final  Duration? firstTokenAfter;

/// Create a copy of RunState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StreamingCopyWith<Streaming> get copyWith => _$StreamingCopyWithImpl<Streaming>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is Streaming&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.text, text) || other.text == text)&&(identical(other.thinking, thinking) || other.thinking == thinking)&&(identical(other.firstTokenAfter, firstTokenAfter) || other.firstTokenAfter == firstTokenAfter));
}


@override
int get hashCode {
    return Object.hash(runtimeType,startedAt,text,thinking,firstTokenAfter);
}

@override
String toString() {
    return 'RunState.streaming(startedAt: $startedAt, text: $text, thinking: $thinking, firstTokenAfter: $firstTokenAfter)';
}


}

/// @nodoc
abstract mixin class $StreamingCopyWith<$Res> implements $RunStateCopyWith<$Res> {
  factory $StreamingCopyWith(Streaming value, $Res Function(Streaming) _then) = _$StreamingCopyWithImpl;
@override @useResult
$Res call({
 DateTime startedAt, String text, String thinking, Duration? firstTokenAfter
});




}
/// @nodoc
class _$StreamingCopyWithImpl<$Res>
    implements $StreamingCopyWith<$Res> {
  _$StreamingCopyWithImpl(this._self, this._then);

  final Streaming _self;
  final $Res Function(Streaming) _then;

/// Create a copy of RunState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startedAt = null,Object? text = null,Object? thinking = null,Object? firstTokenAfter = freezed,}) {
  return _then(Streaming(
startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,thinking: null == thinking ? _self.thinking : thinking // ignore: cast_nullable_to_non_nullable
as String,firstTokenAfter: freezed == firstTokenAfter ? _self.firstTokenAfter : firstTokenAfter // ignore: cast_nullable_to_non_nullable
as Duration?,
  ));
}


}

/// @nodoc


class Done extends RunState {
  const Done({required this.startedAt, required this.text, required this.thinking, required this.took, required this.usage, required this.cost, this.firstTokenAfter}): super._();
  

@override final  DateTime startedAt;
 final  String text;
 final  String thinking;
 final  Duration took;
 final  llm.UsageInfo usage;
/// Null when the model's price is unknown.
 final  double? cost;
 final  Duration? firstTokenAfter;

/// Create a copy of RunState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoneCopyWith<Done> get copyWith => _$DoneCopyWithImpl<Done>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is Done&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.text, text) || other.text == text)&&(identical(other.thinking, thinking) || other.thinking == thinking)&&(identical(other.took, took) || other.took == took)&&(identical(other.usage, usage) || other.usage == usage)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.firstTokenAfter, firstTokenAfter) || other.firstTokenAfter == firstTokenAfter));
}


@override
int get hashCode {
    return Object.hash(runtimeType,startedAt,text,thinking,took,usage,cost,firstTokenAfter);
}

@override
String toString() {
    return 'RunState.done(startedAt: $startedAt, text: $text, thinking: $thinking, took: $took, usage: $usage, cost: $cost, firstTokenAfter: $firstTokenAfter)';
}


}

/// @nodoc
abstract mixin class $DoneCopyWith<$Res> implements $RunStateCopyWith<$Res> {
  factory $DoneCopyWith(Done value, $Res Function(Done) _then) = _$DoneCopyWithImpl;
@override @useResult
$Res call({
 DateTime startedAt, String text, String thinking, Duration took, llm.UsageInfo usage, double? cost, Duration? firstTokenAfter
});




}
/// @nodoc
class _$DoneCopyWithImpl<$Res>
    implements $DoneCopyWith<$Res> {
  _$DoneCopyWithImpl(this._self, this._then);

  final Done _self;
  final $Res Function(Done) _then;

/// Create a copy of RunState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startedAt = null,Object? text = null,Object? thinking = null,Object? took = null,Object? usage = null,Object? cost = freezed,Object? firstTokenAfter = freezed,}) {
  return _then(Done(
startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,thinking: null == thinking ? _self.thinking : thinking // ignore: cast_nullable_to_non_nullable
as String,took: null == took ? _self.took : took // ignore: cast_nullable_to_non_nullable
as Duration,usage: null == usage ? _self.usage : usage // ignore: cast_nullable_to_non_nullable
as llm.UsageInfo,cost: freezed == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double?,firstTokenAfter: freezed == firstTokenAfter ? _self.firstTokenAfter : firstTokenAfter // ignore: cast_nullable_to_non_nullable
as Duration?,
  ));
}


}

/// @nodoc


class Failed extends RunState {
  const Failed({required this.startedAt, required this.message}): super._();
  

@override final  DateTime startedAt;
 final  String message;

/// Create a copy of RunState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FailedCopyWith<Failed> get copyWith => _$FailedCopyWithImpl<Failed>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is Failed&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,startedAt,message);
}

@override
String toString() {
    return 'RunState.failed(startedAt: $startedAt, message: $message)';
}


}

/// @nodoc
abstract mixin class $FailedCopyWith<$Res> implements $RunStateCopyWith<$Res> {
  factory $FailedCopyWith(Failed value, $Res Function(Failed) _then) = _$FailedCopyWithImpl;
@override @useResult
$Res call({
 DateTime startedAt, String message
});




}
/// @nodoc
class _$FailedCopyWithImpl<$Res>
    implements $FailedCopyWith<$Res> {
  _$FailedCopyWithImpl(this._self, this._then);

  final Failed _self;
  final $Res Function(Failed) _then;

/// Create a copy of RunState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startedAt = null,Object? message = null,}) {
  return _then(Failed(
startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
