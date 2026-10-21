// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'selection_editor_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SelectionEditorState {

 EditorDocument get document; VimState get vimState; List<SelectionEditorState> get undoStack; List<SelectionEditorState> get redoStack;
/// Create a copy of SelectionEditorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SelectionEditorStateCopyWith<SelectionEditorState> get copyWith => _$SelectionEditorStateCopyWithImpl<SelectionEditorState>(this as SelectionEditorState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SelectionEditorState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelectionEditorState&&(identical(other.document, _this.document) || other.document == _this.document)&&(identical(other.vimState, _this.vimState) || other.vimState == _this.vimState)&&const DeepCollectionEquality().equals(other.undoStack, _this.undoStack)&&const DeepCollectionEquality().equals(other.redoStack, _this.redoStack));
}


@override
int get hashCode {
  final _this = this as SelectionEditorState;
  return Object.hash(runtimeType,_this.document,_this.vimState,const DeepCollectionEquality().hash(_this.undoStack),const DeepCollectionEquality().hash(_this.redoStack));
}

@override
String toString() {
  final _this = this as SelectionEditorState;
  return 'SelectionEditorState(document: ${_this.document}, vimState: ${_this.vimState}, undoStack: ${_this.undoStack}, redoStack: ${_this.redoStack})';
}


}

/// @nodoc
abstract mixin class $SelectionEditorStateCopyWith<$Res>  {
  factory $SelectionEditorStateCopyWith(SelectionEditorState value, $Res Function(SelectionEditorState) _then) = _$SelectionEditorStateCopyWithImpl;
@useResult
$Res call({
 EditorDocument document, VimState vimState, List<SelectionEditorState> undoStack, List<SelectionEditorState> redoStack
});


$EditorDocumentCopyWith<$Res> get document;$VimStateCopyWith<$Res> get vimState;

}
/// @nodoc
class _$SelectionEditorStateCopyWithImpl<$Res>
    implements $SelectionEditorStateCopyWith<$Res> {
  _$SelectionEditorStateCopyWithImpl(this._self, this._then);

  final SelectionEditorState _self;
  final $Res Function(SelectionEditorState) _then;

/// Create a copy of SelectionEditorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? document = null,Object? vimState = null,Object? undoStack = null,Object? redoStack = null,}) {
  return _then(SelectionEditorState(
document: null == document ? _self.document : document // ignore: cast_nullable_to_non_nullable
as EditorDocument,vimState: null == vimState ? _self.vimState : vimState // ignore: cast_nullable_to_non_nullable
as VimState,undoStack: null == undoStack ? _self.undoStack : undoStack // ignore: cast_nullable_to_non_nullable
as List<SelectionEditorState>,redoStack: null == redoStack ? _self.redoStack : redoStack // ignore: cast_nullable_to_non_nullable
as List<SelectionEditorState>,
  ));
}
/// Create a copy of SelectionEditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EditorDocumentCopyWith<$Res> get document {
  
  return $EditorDocumentCopyWith<$Res>(_self.document, (value) {
    return _then(_self.copyWith(document: value));
  });
}/// Create a copy of SelectionEditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VimStateCopyWith<$Res> get vimState {
  
  return $VimStateCopyWith<$Res>(_self.vimState, (value) {
    return _then(_self.copyWith(vimState: value));
  });
}
}


/// Adds pattern-matching-related methods to [SelectionEditorState].
extension SelectionEditorStatePatterns on SelectionEditorState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SelectionEditorState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SelectionEditorState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SelectionEditorState value)  $default,){
final _that = this;
switch (_that) {
case _SelectionEditorState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SelectionEditorState value)?  $default,){
final _that = this;
switch (_that) {
case _SelectionEditorState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EditorDocument document,  VimState vimState,  List<SelectionEditorState> undoStack,  List<SelectionEditorState> redoStack)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SelectionEditorState() when $default != null:
return $default(_that.document,_that.vimState,_that.undoStack,_that.redoStack);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EditorDocument document,  VimState vimState,  List<SelectionEditorState> undoStack,  List<SelectionEditorState> redoStack)  $default,) {final _that = this;
switch (_that) {
case _SelectionEditorState():
return $default(_that.document,_that.vimState,_that.undoStack,_that.redoStack);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EditorDocument document,  VimState vimState,  List<SelectionEditorState> undoStack,  List<SelectionEditorState> redoStack)?  $default,) {final _that = this;
switch (_that) {
case _SelectionEditorState() when $default != null:
return $default(_that.document,_that.vimState,_that.undoStack,_that.redoStack);case _:
  return null;

}
}

}

/// @nodoc


class _SelectionEditorState extends SelectionEditorState {
  const _SelectionEditorState({required this.document, required this.vimState,  List<SelectionEditorState> undoStack = const <SelectionEditorState>[],  List<SelectionEditorState> redoStack = const <SelectionEditorState>[]}): _undoStack = undoStack,_redoStack = redoStack,super._();
  

@override final  EditorDocument document;
@override final  VimState vimState;
 final  List<SelectionEditorState> _undoStack;
@override@JsonKey() List<SelectionEditorState> get undoStack {
  if (_undoStack is EqualUnmodifiableListView) return _undoStack;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_undoStack);
}

 final  List<SelectionEditorState> _redoStack;
@override@JsonKey() List<SelectionEditorState> get redoStack {
  if (_redoStack is EqualUnmodifiableListView) return _redoStack;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_redoStack);
}


/// Create a copy of SelectionEditorState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SelectionEditorStateCopyWith<_SelectionEditorState> get copyWith => __$SelectionEditorStateCopyWithImpl<_SelectionEditorState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SelectionEditorState&&(identical(other.document, document) || other.document == document)&&(identical(other.vimState, vimState) || other.vimState == vimState)&&const DeepCollectionEquality().equals(other.undoStack, _undoStack)&&const DeepCollectionEquality().equals(other.redoStack, _redoStack));
}


@override
int get hashCode {
    return Object.hash(runtimeType,document,vimState,const DeepCollectionEquality().hash(_undoStack),const DeepCollectionEquality().hash(_redoStack));
}

@override
String toString() {
    return 'SelectionEditorState(document: $document, vimState: $vimState, undoStack: $undoStack, redoStack: $redoStack)';
}


}

/// @nodoc
abstract mixin class _$SelectionEditorStateCopyWith<$Res> implements $SelectionEditorStateCopyWith<$Res> {
  factory _$SelectionEditorStateCopyWith(_SelectionEditorState value, $Res Function(_SelectionEditorState) _then) = __$SelectionEditorStateCopyWithImpl;
@override @useResult
$Res call({
 EditorDocument document, VimState vimState, List<SelectionEditorState> undoStack, List<SelectionEditorState> redoStack
});


@override $EditorDocumentCopyWith<$Res> get document;@override $VimStateCopyWith<$Res> get vimState;

}
/// @nodoc
class __$SelectionEditorStateCopyWithImpl<$Res>
    implements _$SelectionEditorStateCopyWith<$Res> {
  __$SelectionEditorStateCopyWithImpl(this._self, this._then);

  final _SelectionEditorState _self;
  final $Res Function(_SelectionEditorState) _then;

/// Create a copy of SelectionEditorState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? document = null,Object? vimState = null,Object? undoStack = null,Object? redoStack = null,}) {
  return _then(_SelectionEditorState(
document: null == document ? _self.document : document // ignore: cast_nullable_to_non_nullable
as EditorDocument,vimState: null == vimState ? _self.vimState : vimState // ignore: cast_nullable_to_non_nullable
as VimState,undoStack: null == undoStack ? _self._undoStack : undoStack // ignore: cast_nullable_to_non_nullable
as List<SelectionEditorState>,redoStack: null == redoStack ? _self._redoStack : redoStack // ignore: cast_nullable_to_non_nullable
as List<SelectionEditorState>,
  ));
}

/// Create a copy of SelectionEditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EditorDocumentCopyWith<$Res> get document {
  
  return $EditorDocumentCopyWith<$Res>(_self.document, (value) {
    return _then(_self.copyWith(document: value));
  });
}/// Create a copy of SelectionEditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VimStateCopyWith<$Res> get vimState {
  
  return $VimStateCopyWith<$Res>(_self.vimState, (value) {
    return _then(_self.copyWith(vimState: value));
  });
}
}

// dart format on
