// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'window_lifecycle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WindowLifecycleState {

 bool get isVisible; bool get isGenerating; bool get hideAfterCompletionOnBlur; RefreshTrigger get refreshTrigger; String get lastClipboardHash; bool get hideRequested; bool get refreshRequested; bool get closeAllowed;
/// Create a copy of WindowLifecycleState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WindowLifecycleStateCopyWith<WindowLifecycleState> get copyWith => _$WindowLifecycleStateCopyWithImpl<WindowLifecycleState>(this as WindowLifecycleState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WindowLifecycleState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WindowLifecycleState&&(identical(other.isVisible, _this.isVisible) || other.isVisible == _this.isVisible)&&(identical(other.isGenerating, _this.isGenerating) || other.isGenerating == _this.isGenerating)&&(identical(other.hideAfterCompletionOnBlur, _this.hideAfterCompletionOnBlur) || other.hideAfterCompletionOnBlur == _this.hideAfterCompletionOnBlur)&&(identical(other.refreshTrigger, _this.refreshTrigger) || other.refreshTrigger == _this.refreshTrigger)&&(identical(other.lastClipboardHash, _this.lastClipboardHash) || other.lastClipboardHash == _this.lastClipboardHash)&&(identical(other.hideRequested, _this.hideRequested) || other.hideRequested == _this.hideRequested)&&(identical(other.refreshRequested, _this.refreshRequested) || other.refreshRequested == _this.refreshRequested)&&(identical(other.closeAllowed, _this.closeAllowed) || other.closeAllowed == _this.closeAllowed));
}


@override
int get hashCode {
  final _this = this as WindowLifecycleState;
  return Object.hash(runtimeType,_this.isVisible,_this.isGenerating,_this.hideAfterCompletionOnBlur,_this.refreshTrigger,_this.lastClipboardHash,_this.hideRequested,_this.refreshRequested,_this.closeAllowed);
}

@override
String toString() {
  final _this = this as WindowLifecycleState;
  return 'WindowLifecycleState(isVisible: ${_this.isVisible}, isGenerating: ${_this.isGenerating}, hideAfterCompletionOnBlur: ${_this.hideAfterCompletionOnBlur}, refreshTrigger: ${_this.refreshTrigger}, lastClipboardHash: ${_this.lastClipboardHash}, hideRequested: ${_this.hideRequested}, refreshRequested: ${_this.refreshRequested}, closeAllowed: ${_this.closeAllowed})';
}


}

/// @nodoc
abstract mixin class $WindowLifecycleStateCopyWith<$Res>  {
  factory $WindowLifecycleStateCopyWith(WindowLifecycleState value, $Res Function(WindowLifecycleState) _then) = _$WindowLifecycleStateCopyWithImpl;
@useResult
$Res call({
 bool isVisible, bool isGenerating, bool hideAfterCompletionOnBlur, RefreshTrigger refreshTrigger, String lastClipboardHash, bool hideRequested, bool refreshRequested, bool closeAllowed
});




}
/// @nodoc
class _$WindowLifecycleStateCopyWithImpl<$Res>
    implements $WindowLifecycleStateCopyWith<$Res> {
  _$WindowLifecycleStateCopyWithImpl(this._self, this._then);

  final WindowLifecycleState _self;
  final $Res Function(WindowLifecycleState) _then;

/// Create a copy of WindowLifecycleState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isVisible = null,Object? isGenerating = null,Object? hideAfterCompletionOnBlur = null,Object? refreshTrigger = null,Object? lastClipboardHash = null,Object? hideRequested = null,Object? refreshRequested = null,Object? closeAllowed = null,}) {
  return _then(WindowLifecycleState(
isVisible: null == isVisible ? _self.isVisible : isVisible // ignore: cast_nullable_to_non_nullable
as bool,isGenerating: null == isGenerating ? _self.isGenerating : isGenerating // ignore: cast_nullable_to_non_nullable
as bool,hideAfterCompletionOnBlur: null == hideAfterCompletionOnBlur ? _self.hideAfterCompletionOnBlur : hideAfterCompletionOnBlur // ignore: cast_nullable_to_non_nullable
as bool,refreshTrigger: null == refreshTrigger ? _self.refreshTrigger : refreshTrigger // ignore: cast_nullable_to_non_nullable
as RefreshTrigger,lastClipboardHash: null == lastClipboardHash ? _self.lastClipboardHash : lastClipboardHash // ignore: cast_nullable_to_non_nullable
as String,hideRequested: null == hideRequested ? _self.hideRequested : hideRequested // ignore: cast_nullable_to_non_nullable
as bool,refreshRequested: null == refreshRequested ? _self.refreshRequested : refreshRequested // ignore: cast_nullable_to_non_nullable
as bool,closeAllowed: null == closeAllowed ? _self.closeAllowed : closeAllowed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WindowLifecycleState].
extension WindowLifecycleStatePatterns on WindowLifecycleState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WindowLifecycleState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WindowLifecycleState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WindowLifecycleState value)  $default,){
final _that = this;
switch (_that) {
case _WindowLifecycleState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WindowLifecycleState value)?  $default,){
final _that = this;
switch (_that) {
case _WindowLifecycleState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isVisible,  bool isGenerating,  bool hideAfterCompletionOnBlur,  RefreshTrigger refreshTrigger,  String lastClipboardHash,  bool hideRequested,  bool refreshRequested,  bool closeAllowed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WindowLifecycleState() when $default != null:
return $default(_that.isVisible,_that.isGenerating,_that.hideAfterCompletionOnBlur,_that.refreshTrigger,_that.lastClipboardHash,_that.hideRequested,_that.refreshRequested,_that.closeAllowed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isVisible,  bool isGenerating,  bool hideAfterCompletionOnBlur,  RefreshTrigger refreshTrigger,  String lastClipboardHash,  bool hideRequested,  bool refreshRequested,  bool closeAllowed)  $default,) {final _that = this;
switch (_that) {
case _WindowLifecycleState():
return $default(_that.isVisible,_that.isGenerating,_that.hideAfterCompletionOnBlur,_that.refreshTrigger,_that.lastClipboardHash,_that.hideRequested,_that.refreshRequested,_that.closeAllowed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isVisible,  bool isGenerating,  bool hideAfterCompletionOnBlur,  RefreshTrigger refreshTrigger,  String lastClipboardHash,  bool hideRequested,  bool refreshRequested,  bool closeAllowed)?  $default,) {final _that = this;
switch (_that) {
case _WindowLifecycleState() when $default != null:
return $default(_that.isVisible,_that.isGenerating,_that.hideAfterCompletionOnBlur,_that.refreshTrigger,_that.lastClipboardHash,_that.hideRequested,_that.refreshRequested,_that.closeAllowed);case _:
  return null;

}
}

}

/// @nodoc


class _WindowLifecycleState implements WindowLifecycleState {
  const _WindowLifecycleState({this.isVisible = true, this.isGenerating = false, this.hideAfterCompletionOnBlur = false, this.refreshTrigger = RefreshTrigger.none, this.lastClipboardHash = "", this.hideRequested = false, this.refreshRequested = false, this.closeAllowed = true});
  

@override@JsonKey() final  bool isVisible;
@override@JsonKey() final  bool isGenerating;
@override@JsonKey() final  bool hideAfterCompletionOnBlur;
@override@JsonKey() final  RefreshTrigger refreshTrigger;
@override@JsonKey() final  String lastClipboardHash;
@override@JsonKey() final  bool hideRequested;
@override@JsonKey() final  bool refreshRequested;
@override@JsonKey() final  bool closeAllowed;

/// Create a copy of WindowLifecycleState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WindowLifecycleStateCopyWith<_WindowLifecycleState> get copyWith => __$WindowLifecycleStateCopyWithImpl<_WindowLifecycleState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WindowLifecycleState&&(identical(other.isVisible, isVisible) || other.isVisible == isVisible)&&(identical(other.isGenerating, isGenerating) || other.isGenerating == isGenerating)&&(identical(other.hideAfterCompletionOnBlur, hideAfterCompletionOnBlur) || other.hideAfterCompletionOnBlur == hideAfterCompletionOnBlur)&&(identical(other.refreshTrigger, refreshTrigger) || other.refreshTrigger == refreshTrigger)&&(identical(other.lastClipboardHash, lastClipboardHash) || other.lastClipboardHash == lastClipboardHash)&&(identical(other.hideRequested, hideRequested) || other.hideRequested == hideRequested)&&(identical(other.refreshRequested, refreshRequested) || other.refreshRequested == refreshRequested)&&(identical(other.closeAllowed, closeAllowed) || other.closeAllowed == closeAllowed));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isVisible,isGenerating,hideAfterCompletionOnBlur,refreshTrigger,lastClipboardHash,hideRequested,refreshRequested,closeAllowed);
}

@override
String toString() {
    return 'WindowLifecycleState(isVisible: $isVisible, isGenerating: $isGenerating, hideAfterCompletionOnBlur: $hideAfterCompletionOnBlur, refreshTrigger: $refreshTrigger, lastClipboardHash: $lastClipboardHash, hideRequested: $hideRequested, refreshRequested: $refreshRequested, closeAllowed: $closeAllowed)';
}


}

/// @nodoc
abstract mixin class _$WindowLifecycleStateCopyWith<$Res> implements $WindowLifecycleStateCopyWith<$Res> {
  factory _$WindowLifecycleStateCopyWith(_WindowLifecycleState value, $Res Function(_WindowLifecycleState) _then) = __$WindowLifecycleStateCopyWithImpl;
@override @useResult
$Res call({
 bool isVisible, bool isGenerating, bool hideAfterCompletionOnBlur, RefreshTrigger refreshTrigger, String lastClipboardHash, bool hideRequested, bool refreshRequested, bool closeAllowed
});




}
/// @nodoc
class __$WindowLifecycleStateCopyWithImpl<$Res>
    implements _$WindowLifecycleStateCopyWith<$Res> {
  __$WindowLifecycleStateCopyWithImpl(this._self, this._then);

  final _WindowLifecycleState _self;
  final $Res Function(_WindowLifecycleState) _then;

/// Create a copy of WindowLifecycleState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isVisible = null,Object? isGenerating = null,Object? hideAfterCompletionOnBlur = null,Object? refreshTrigger = null,Object? lastClipboardHash = null,Object? hideRequested = null,Object? refreshRequested = null,Object? closeAllowed = null,}) {
  return _then(_WindowLifecycleState(
isVisible: null == isVisible ? _self.isVisible : isVisible // ignore: cast_nullable_to_non_nullable
as bool,isGenerating: null == isGenerating ? _self.isGenerating : isGenerating // ignore: cast_nullable_to_non_nullable
as bool,hideAfterCompletionOnBlur: null == hideAfterCompletionOnBlur ? _self.hideAfterCompletionOnBlur : hideAfterCompletionOnBlur // ignore: cast_nullable_to_non_nullable
as bool,refreshTrigger: null == refreshTrigger ? _self.refreshTrigger : refreshTrigger // ignore: cast_nullable_to_non_nullable
as RefreshTrigger,lastClipboardHash: null == lastClipboardHash ? _self.lastClipboardHash : lastClipboardHash // ignore: cast_nullable_to_non_nullable
as String,hideRequested: null == hideRequested ? _self.hideRequested : hideRequested // ignore: cast_nullable_to_non_nullable
as bool,refreshRequested: null == refreshRequested ? _self.refreshRequested : refreshRequested // ignore: cast_nullable_to_non_nullable
as bool,closeAllowed: null == closeAllowed ? _self.closeAllowed : closeAllowed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$WindowLifecyclePolicy {

 bool get shouldHide; bool get shouldRefresh; bool get canClose;
/// Create a copy of WindowLifecyclePolicy
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WindowLifecyclePolicyCopyWith<WindowLifecyclePolicy> get copyWith => _$WindowLifecyclePolicyCopyWithImpl<WindowLifecyclePolicy>(this as WindowLifecyclePolicy, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WindowLifecyclePolicy;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WindowLifecyclePolicy&&(identical(other.shouldHide, _this.shouldHide) || other.shouldHide == _this.shouldHide)&&(identical(other.shouldRefresh, _this.shouldRefresh) || other.shouldRefresh == _this.shouldRefresh)&&(identical(other.canClose, _this.canClose) || other.canClose == _this.canClose));
}


@override
int get hashCode {
  final _this = this as WindowLifecyclePolicy;
  return Object.hash(runtimeType,_this.shouldHide,_this.shouldRefresh,_this.canClose);
}

@override
String toString() {
  final _this = this as WindowLifecyclePolicy;
  return 'WindowLifecyclePolicy(shouldHide: ${_this.shouldHide}, shouldRefresh: ${_this.shouldRefresh}, canClose: ${_this.canClose})';
}


}

/// @nodoc
abstract mixin class $WindowLifecyclePolicyCopyWith<$Res>  {
  factory $WindowLifecyclePolicyCopyWith(WindowLifecyclePolicy value, $Res Function(WindowLifecyclePolicy) _then) = _$WindowLifecyclePolicyCopyWithImpl;
@useResult
$Res call({
 bool shouldHide, bool shouldRefresh, bool canClose
});




}
/// @nodoc
class _$WindowLifecyclePolicyCopyWithImpl<$Res>
    implements $WindowLifecyclePolicyCopyWith<$Res> {
  _$WindowLifecyclePolicyCopyWithImpl(this._self, this._then);

  final WindowLifecyclePolicy _self;
  final $Res Function(WindowLifecyclePolicy) _then;

/// Create a copy of WindowLifecyclePolicy
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? shouldHide = null,Object? shouldRefresh = null,Object? canClose = null,}) {
  return _then(WindowLifecyclePolicy(
shouldHide: null == shouldHide ? _self.shouldHide : shouldHide // ignore: cast_nullable_to_non_nullable
as bool,shouldRefresh: null == shouldRefresh ? _self.shouldRefresh : shouldRefresh // ignore: cast_nullable_to_non_nullable
as bool,canClose: null == canClose ? _self.canClose : canClose // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WindowLifecyclePolicy].
extension WindowLifecyclePolicyPatterns on WindowLifecyclePolicy {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WindowLifecyclePolicy value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WindowLifecyclePolicy() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WindowLifecyclePolicy value)  $default,){
final _that = this;
switch (_that) {
case _WindowLifecyclePolicy():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WindowLifecyclePolicy value)?  $default,){
final _that = this;
switch (_that) {
case _WindowLifecyclePolicy() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool shouldHide,  bool shouldRefresh,  bool canClose)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WindowLifecyclePolicy() when $default != null:
return $default(_that.shouldHide,_that.shouldRefresh,_that.canClose);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool shouldHide,  bool shouldRefresh,  bool canClose)  $default,) {final _that = this;
switch (_that) {
case _WindowLifecyclePolicy():
return $default(_that.shouldHide,_that.shouldRefresh,_that.canClose);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool shouldHide,  bool shouldRefresh,  bool canClose)?  $default,) {final _that = this;
switch (_that) {
case _WindowLifecyclePolicy() when $default != null:
return $default(_that.shouldHide,_that.shouldRefresh,_that.canClose);case _:
  return null;

}
}

}

/// @nodoc


class _WindowLifecyclePolicy implements WindowLifecyclePolicy {
  const _WindowLifecyclePolicy({required this.shouldHide, required this.shouldRefresh, required this.canClose});
  

@override final  bool shouldHide;
@override final  bool shouldRefresh;
@override final  bool canClose;

/// Create a copy of WindowLifecyclePolicy
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WindowLifecyclePolicyCopyWith<_WindowLifecyclePolicy> get copyWith => __$WindowLifecyclePolicyCopyWithImpl<_WindowLifecyclePolicy>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WindowLifecyclePolicy&&(identical(other.shouldHide, shouldHide) || other.shouldHide == shouldHide)&&(identical(other.shouldRefresh, shouldRefresh) || other.shouldRefresh == shouldRefresh)&&(identical(other.canClose, canClose) || other.canClose == canClose));
}


@override
int get hashCode {
    return Object.hash(runtimeType,shouldHide,shouldRefresh,canClose);
}

@override
String toString() {
    return 'WindowLifecyclePolicy(shouldHide: $shouldHide, shouldRefresh: $shouldRefresh, canClose: $canClose)';
}


}

/// @nodoc
abstract mixin class _$WindowLifecyclePolicyCopyWith<$Res> implements $WindowLifecyclePolicyCopyWith<$Res> {
  factory _$WindowLifecyclePolicyCopyWith(_WindowLifecyclePolicy value, $Res Function(_WindowLifecyclePolicy) _then) = __$WindowLifecyclePolicyCopyWithImpl;
@override @useResult
$Res call({
 bool shouldHide, bool shouldRefresh, bool canClose
});




}
/// @nodoc
class __$WindowLifecyclePolicyCopyWithImpl<$Res>
    implements _$WindowLifecyclePolicyCopyWith<$Res> {
  __$WindowLifecyclePolicyCopyWithImpl(this._self, this._then);

  final _WindowLifecyclePolicy _self;
  final $Res Function(_WindowLifecyclePolicy) _then;

/// Create a copy of WindowLifecyclePolicy
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? shouldHide = null,Object? shouldRefresh = null,Object? canClose = null,}) {
  return _then(_WindowLifecyclePolicy(
shouldHide: null == shouldHide ? _self.shouldHide : shouldHide // ignore: cast_nullable_to_non_nullable
as bool,shouldRefresh: null == shouldRefresh ? _self.shouldRefresh : shouldRefresh // ignore: cast_nullable_to_non_nullable
as bool,canClose: null == canClose ? _self.canClose : canClose // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
