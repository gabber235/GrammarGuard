// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vim_handler.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VimHandlerResult {

 VimMode get mode; int get cursorPosition; int? get visualStart; String? get pendingOperator; String get countBuffer; String? get textToInsert; bool get deleteAtCursor; bool get deleteBeforeCursor; int? get deleteToPosition; bool get deleteLine; bool get deleteSelection; int? get changeToPosition; bool get changeLine; bool get yankLine; bool get yankSelection; bool get pasteAfter; bool get pasteBefore; bool get undo; bool get redo; bool get insertNewLineBelow; bool get insertNewLineAbove;
/// Create a copy of VimHandlerResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VimHandlerResultCopyWith<VimHandlerResult> get copyWith => _$VimHandlerResultCopyWithImpl<VimHandlerResult>(this as VimHandlerResult, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as VimHandlerResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VimHandlerResult&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.cursorPosition, _this.cursorPosition) || other.cursorPosition == _this.cursorPosition)&&(identical(other.visualStart, _this.visualStart) || other.visualStart == _this.visualStart)&&(identical(other.pendingOperator, _this.pendingOperator) || other.pendingOperator == _this.pendingOperator)&&(identical(other.countBuffer, _this.countBuffer) || other.countBuffer == _this.countBuffer)&&(identical(other.textToInsert, _this.textToInsert) || other.textToInsert == _this.textToInsert)&&(identical(other.deleteAtCursor, _this.deleteAtCursor) || other.deleteAtCursor == _this.deleteAtCursor)&&(identical(other.deleteBeforeCursor, _this.deleteBeforeCursor) || other.deleteBeforeCursor == _this.deleteBeforeCursor)&&(identical(other.deleteToPosition, _this.deleteToPosition) || other.deleteToPosition == _this.deleteToPosition)&&(identical(other.deleteLine, _this.deleteLine) || other.deleteLine == _this.deleteLine)&&(identical(other.deleteSelection, _this.deleteSelection) || other.deleteSelection == _this.deleteSelection)&&(identical(other.changeToPosition, _this.changeToPosition) || other.changeToPosition == _this.changeToPosition)&&(identical(other.changeLine, _this.changeLine) || other.changeLine == _this.changeLine)&&(identical(other.yankLine, _this.yankLine) || other.yankLine == _this.yankLine)&&(identical(other.yankSelection, _this.yankSelection) || other.yankSelection == _this.yankSelection)&&(identical(other.pasteAfter, _this.pasteAfter) || other.pasteAfter == _this.pasteAfter)&&(identical(other.pasteBefore, _this.pasteBefore) || other.pasteBefore == _this.pasteBefore)&&(identical(other.undo, _this.undo) || other.undo == _this.undo)&&(identical(other.redo, _this.redo) || other.redo == _this.redo)&&(identical(other.insertNewLineBelow, _this.insertNewLineBelow) || other.insertNewLineBelow == _this.insertNewLineBelow)&&(identical(other.insertNewLineAbove, _this.insertNewLineAbove) || other.insertNewLineAbove == _this.insertNewLineAbove));
}


@override
int get hashCode {
  final _this = this as VimHandlerResult;
  return Object.hashAll([runtimeType,_this.mode,_this.cursorPosition,_this.visualStart,_this.pendingOperator,_this.countBuffer,_this.textToInsert,_this.deleteAtCursor,_this.deleteBeforeCursor,_this.deleteToPosition,_this.deleteLine,_this.deleteSelection,_this.changeToPosition,_this.changeLine,_this.yankLine,_this.yankSelection,_this.pasteAfter,_this.pasteBefore,_this.undo,_this.redo,_this.insertNewLineBelow,_this.insertNewLineAbove]);
}

@override
String toString() {
  final _this = this as VimHandlerResult;
  return 'VimHandlerResult(mode: ${_this.mode}, cursorPosition: ${_this.cursorPosition}, visualStart: ${_this.visualStart}, pendingOperator: ${_this.pendingOperator}, countBuffer: ${_this.countBuffer}, textToInsert: ${_this.textToInsert}, deleteAtCursor: ${_this.deleteAtCursor}, deleteBeforeCursor: ${_this.deleteBeforeCursor}, deleteToPosition: ${_this.deleteToPosition}, deleteLine: ${_this.deleteLine}, deleteSelection: ${_this.deleteSelection}, changeToPosition: ${_this.changeToPosition}, changeLine: ${_this.changeLine}, yankLine: ${_this.yankLine}, yankSelection: ${_this.yankSelection}, pasteAfter: ${_this.pasteAfter}, pasteBefore: ${_this.pasteBefore}, undo: ${_this.undo}, redo: ${_this.redo}, insertNewLineBelow: ${_this.insertNewLineBelow}, insertNewLineAbove: ${_this.insertNewLineAbove})';
}


}

/// @nodoc
abstract mixin class $VimHandlerResultCopyWith<$Res>  {
  factory $VimHandlerResultCopyWith(VimHandlerResult value, $Res Function(VimHandlerResult) _then) = _$VimHandlerResultCopyWithImpl;
@useResult
$Res call({
 VimMode mode, int cursorPosition, int? visualStart, String? pendingOperator, String countBuffer, String? textToInsert, bool deleteAtCursor, bool deleteBeforeCursor, int? deleteToPosition, bool deleteLine, bool deleteSelection, int? changeToPosition, bool changeLine, bool yankLine, bool yankSelection, bool pasteAfter, bool pasteBefore, bool undo, bool redo, bool insertNewLineBelow, bool insertNewLineAbove
});




}
/// @nodoc
class _$VimHandlerResultCopyWithImpl<$Res>
    implements $VimHandlerResultCopyWith<$Res> {
  _$VimHandlerResultCopyWithImpl(this._self, this._then);

  final VimHandlerResult _self;
  final $Res Function(VimHandlerResult) _then;

/// Create a copy of VimHandlerResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? cursorPosition = null,Object? visualStart = freezed,Object? pendingOperator = freezed,Object? countBuffer = null,Object? textToInsert = freezed,Object? deleteAtCursor = null,Object? deleteBeforeCursor = null,Object? deleteToPosition = freezed,Object? deleteLine = null,Object? deleteSelection = null,Object? changeToPosition = freezed,Object? changeLine = null,Object? yankLine = null,Object? yankSelection = null,Object? pasteAfter = null,Object? pasteBefore = null,Object? undo = null,Object? redo = null,Object? insertNewLineBelow = null,Object? insertNewLineAbove = null,}) {
  return _then(VimHandlerResult(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as VimMode,cursorPosition: null == cursorPosition ? _self.cursorPosition : cursorPosition // ignore: cast_nullable_to_non_nullable
as int,visualStart: freezed == visualStart ? _self.visualStart : visualStart // ignore: cast_nullable_to_non_nullable
as int?,pendingOperator: freezed == pendingOperator ? _self.pendingOperator : pendingOperator // ignore: cast_nullable_to_non_nullable
as String?,countBuffer: null == countBuffer ? _self.countBuffer : countBuffer // ignore: cast_nullable_to_non_nullable
as String,textToInsert: freezed == textToInsert ? _self.textToInsert : textToInsert // ignore: cast_nullable_to_non_nullable
as String?,deleteAtCursor: null == deleteAtCursor ? _self.deleteAtCursor : deleteAtCursor // ignore: cast_nullable_to_non_nullable
as bool,deleteBeforeCursor: null == deleteBeforeCursor ? _self.deleteBeforeCursor : deleteBeforeCursor // ignore: cast_nullable_to_non_nullable
as bool,deleteToPosition: freezed == deleteToPosition ? _self.deleteToPosition : deleteToPosition // ignore: cast_nullable_to_non_nullable
as int?,deleteLine: null == deleteLine ? _self.deleteLine : deleteLine // ignore: cast_nullable_to_non_nullable
as bool,deleteSelection: null == deleteSelection ? _self.deleteSelection : deleteSelection // ignore: cast_nullable_to_non_nullable
as bool,changeToPosition: freezed == changeToPosition ? _self.changeToPosition : changeToPosition // ignore: cast_nullable_to_non_nullable
as int?,changeLine: null == changeLine ? _self.changeLine : changeLine // ignore: cast_nullable_to_non_nullable
as bool,yankLine: null == yankLine ? _self.yankLine : yankLine // ignore: cast_nullable_to_non_nullable
as bool,yankSelection: null == yankSelection ? _self.yankSelection : yankSelection // ignore: cast_nullable_to_non_nullable
as bool,pasteAfter: null == pasteAfter ? _self.pasteAfter : pasteAfter // ignore: cast_nullable_to_non_nullable
as bool,pasteBefore: null == pasteBefore ? _self.pasteBefore : pasteBefore // ignore: cast_nullable_to_non_nullable
as bool,undo: null == undo ? _self.undo : undo // ignore: cast_nullable_to_non_nullable
as bool,redo: null == redo ? _self.redo : redo // ignore: cast_nullable_to_non_nullable
as bool,insertNewLineBelow: null == insertNewLineBelow ? _self.insertNewLineBelow : insertNewLineBelow // ignore: cast_nullable_to_non_nullable
as bool,insertNewLineAbove: null == insertNewLineAbove ? _self.insertNewLineAbove : insertNewLineAbove // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [VimHandlerResult].
extension VimHandlerResultPatterns on VimHandlerResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VimHandlerResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VimHandlerResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VimHandlerResult value)  $default,){
final _that = this;
switch (_that) {
case _VimHandlerResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VimHandlerResult value)?  $default,){
final _that = this;
switch (_that) {
case _VimHandlerResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( VimMode mode,  int cursorPosition,  int? visualStart,  String? pendingOperator,  String countBuffer,  String? textToInsert,  bool deleteAtCursor,  bool deleteBeforeCursor,  int? deleteToPosition,  bool deleteLine,  bool deleteSelection,  int? changeToPosition,  bool changeLine,  bool yankLine,  bool yankSelection,  bool pasteAfter,  bool pasteBefore,  bool undo,  bool redo,  bool insertNewLineBelow,  bool insertNewLineAbove)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VimHandlerResult() when $default != null:
return $default(_that.mode,_that.cursorPosition,_that.visualStart,_that.pendingOperator,_that.countBuffer,_that.textToInsert,_that.deleteAtCursor,_that.deleteBeforeCursor,_that.deleteToPosition,_that.deleteLine,_that.deleteSelection,_that.changeToPosition,_that.changeLine,_that.yankLine,_that.yankSelection,_that.pasteAfter,_that.pasteBefore,_that.undo,_that.redo,_that.insertNewLineBelow,_that.insertNewLineAbove);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( VimMode mode,  int cursorPosition,  int? visualStart,  String? pendingOperator,  String countBuffer,  String? textToInsert,  bool deleteAtCursor,  bool deleteBeforeCursor,  int? deleteToPosition,  bool deleteLine,  bool deleteSelection,  int? changeToPosition,  bool changeLine,  bool yankLine,  bool yankSelection,  bool pasteAfter,  bool pasteBefore,  bool undo,  bool redo,  bool insertNewLineBelow,  bool insertNewLineAbove)  $default,) {final _that = this;
switch (_that) {
case _VimHandlerResult():
return $default(_that.mode,_that.cursorPosition,_that.visualStart,_that.pendingOperator,_that.countBuffer,_that.textToInsert,_that.deleteAtCursor,_that.deleteBeforeCursor,_that.deleteToPosition,_that.deleteLine,_that.deleteSelection,_that.changeToPosition,_that.changeLine,_that.yankLine,_that.yankSelection,_that.pasteAfter,_that.pasteBefore,_that.undo,_that.redo,_that.insertNewLineBelow,_that.insertNewLineAbove);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( VimMode mode,  int cursorPosition,  int? visualStart,  String? pendingOperator,  String countBuffer,  String? textToInsert,  bool deleteAtCursor,  bool deleteBeforeCursor,  int? deleteToPosition,  bool deleteLine,  bool deleteSelection,  int? changeToPosition,  bool changeLine,  bool yankLine,  bool yankSelection,  bool pasteAfter,  bool pasteBefore,  bool undo,  bool redo,  bool insertNewLineBelow,  bool insertNewLineAbove)?  $default,) {final _that = this;
switch (_that) {
case _VimHandlerResult() when $default != null:
return $default(_that.mode,_that.cursorPosition,_that.visualStart,_that.pendingOperator,_that.countBuffer,_that.textToInsert,_that.deleteAtCursor,_that.deleteBeforeCursor,_that.deleteToPosition,_that.deleteLine,_that.deleteSelection,_that.changeToPosition,_that.changeLine,_that.yankLine,_that.yankSelection,_that.pasteAfter,_that.pasteBefore,_that.undo,_that.redo,_that.insertNewLineBelow,_that.insertNewLineAbove);case _:
  return null;

}
}

}

/// @nodoc


class _VimHandlerResult extends VimHandlerResult {
  const _VimHandlerResult({required this.mode, required this.cursorPosition, this.visualStart, this.pendingOperator, this.countBuffer = "", this.textToInsert, this.deleteAtCursor = false, this.deleteBeforeCursor = false, this.deleteToPosition, this.deleteLine = false, this.deleteSelection = false, this.changeToPosition, this.changeLine = false, this.yankLine = false, this.yankSelection = false, this.pasteAfter = false, this.pasteBefore = false, this.undo = false, this.redo = false, this.insertNewLineBelow = false, this.insertNewLineAbove = false}): super._();
  

@override final  VimMode mode;
@override final  int cursorPosition;
@override final  int? visualStart;
@override final  String? pendingOperator;
@override@JsonKey() final  String countBuffer;
@override final  String? textToInsert;
@override@JsonKey() final  bool deleteAtCursor;
@override@JsonKey() final  bool deleteBeforeCursor;
@override final  int? deleteToPosition;
@override@JsonKey() final  bool deleteLine;
@override@JsonKey() final  bool deleteSelection;
@override final  int? changeToPosition;
@override@JsonKey() final  bool changeLine;
@override@JsonKey() final  bool yankLine;
@override@JsonKey() final  bool yankSelection;
@override@JsonKey() final  bool pasteAfter;
@override@JsonKey() final  bool pasteBefore;
@override@JsonKey() final  bool undo;
@override@JsonKey() final  bool redo;
@override@JsonKey() final  bool insertNewLineBelow;
@override@JsonKey() final  bool insertNewLineAbove;

/// Create a copy of VimHandlerResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VimHandlerResultCopyWith<_VimHandlerResult> get copyWith => __$VimHandlerResultCopyWithImpl<_VimHandlerResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VimHandlerResult&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.cursorPosition, cursorPosition) || other.cursorPosition == cursorPosition)&&(identical(other.visualStart, visualStart) || other.visualStart == visualStart)&&(identical(other.pendingOperator, pendingOperator) || other.pendingOperator == pendingOperator)&&(identical(other.countBuffer, countBuffer) || other.countBuffer == countBuffer)&&(identical(other.textToInsert, textToInsert) || other.textToInsert == textToInsert)&&(identical(other.deleteAtCursor, deleteAtCursor) || other.deleteAtCursor == deleteAtCursor)&&(identical(other.deleteBeforeCursor, deleteBeforeCursor) || other.deleteBeforeCursor == deleteBeforeCursor)&&(identical(other.deleteToPosition, deleteToPosition) || other.deleteToPosition == deleteToPosition)&&(identical(other.deleteLine, deleteLine) || other.deleteLine == deleteLine)&&(identical(other.deleteSelection, deleteSelection) || other.deleteSelection == deleteSelection)&&(identical(other.changeToPosition, changeToPosition) || other.changeToPosition == changeToPosition)&&(identical(other.changeLine, changeLine) || other.changeLine == changeLine)&&(identical(other.yankLine, yankLine) || other.yankLine == yankLine)&&(identical(other.yankSelection, yankSelection) || other.yankSelection == yankSelection)&&(identical(other.pasteAfter, pasteAfter) || other.pasteAfter == pasteAfter)&&(identical(other.pasteBefore, pasteBefore) || other.pasteBefore == pasteBefore)&&(identical(other.undo, undo) || other.undo == undo)&&(identical(other.redo, redo) || other.redo == redo)&&(identical(other.insertNewLineBelow, insertNewLineBelow) || other.insertNewLineBelow == insertNewLineBelow)&&(identical(other.insertNewLineAbove, insertNewLineAbove) || other.insertNewLineAbove == insertNewLineAbove));
}


@override
int get hashCode {
    return Object.hashAll([runtimeType,mode,cursorPosition,visualStart,pendingOperator,countBuffer,textToInsert,deleteAtCursor,deleteBeforeCursor,deleteToPosition,deleteLine,deleteSelection,changeToPosition,changeLine,yankLine,yankSelection,pasteAfter,pasteBefore,undo,redo,insertNewLineBelow,insertNewLineAbove]);
}

@override
String toString() {
    return 'VimHandlerResult(mode: $mode, cursorPosition: $cursorPosition, visualStart: $visualStart, pendingOperator: $pendingOperator, countBuffer: $countBuffer, textToInsert: $textToInsert, deleteAtCursor: $deleteAtCursor, deleteBeforeCursor: $deleteBeforeCursor, deleteToPosition: $deleteToPosition, deleteLine: $deleteLine, deleteSelection: $deleteSelection, changeToPosition: $changeToPosition, changeLine: $changeLine, yankLine: $yankLine, yankSelection: $yankSelection, pasteAfter: $pasteAfter, pasteBefore: $pasteBefore, undo: $undo, redo: $redo, insertNewLineBelow: $insertNewLineBelow, insertNewLineAbove: $insertNewLineAbove)';
}


}

/// @nodoc
abstract mixin class _$VimHandlerResultCopyWith<$Res> implements $VimHandlerResultCopyWith<$Res> {
  factory _$VimHandlerResultCopyWith(_VimHandlerResult value, $Res Function(_VimHandlerResult) _then) = __$VimHandlerResultCopyWithImpl;
@override @useResult
$Res call({
 VimMode mode, int cursorPosition, int? visualStart, String? pendingOperator, String countBuffer, String? textToInsert, bool deleteAtCursor, bool deleteBeforeCursor, int? deleteToPosition, bool deleteLine, bool deleteSelection, int? changeToPosition, bool changeLine, bool yankLine, bool yankSelection, bool pasteAfter, bool pasteBefore, bool undo, bool redo, bool insertNewLineBelow, bool insertNewLineAbove
});




}
/// @nodoc
class __$VimHandlerResultCopyWithImpl<$Res>
    implements _$VimHandlerResultCopyWith<$Res> {
  __$VimHandlerResultCopyWithImpl(this._self, this._then);

  final _VimHandlerResult _self;
  final $Res Function(_VimHandlerResult) _then;

/// Create a copy of VimHandlerResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? cursorPosition = null,Object? visualStart = freezed,Object? pendingOperator = freezed,Object? countBuffer = null,Object? textToInsert = freezed,Object? deleteAtCursor = null,Object? deleteBeforeCursor = null,Object? deleteToPosition = freezed,Object? deleteLine = null,Object? deleteSelection = null,Object? changeToPosition = freezed,Object? changeLine = null,Object? yankLine = null,Object? yankSelection = null,Object? pasteAfter = null,Object? pasteBefore = null,Object? undo = null,Object? redo = null,Object? insertNewLineBelow = null,Object? insertNewLineAbove = null,}) {
  return _then(_VimHandlerResult(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as VimMode,cursorPosition: null == cursorPosition ? _self.cursorPosition : cursorPosition // ignore: cast_nullable_to_non_nullable
as int,visualStart: freezed == visualStart ? _self.visualStart : visualStart // ignore: cast_nullable_to_non_nullable
as int?,pendingOperator: freezed == pendingOperator ? _self.pendingOperator : pendingOperator // ignore: cast_nullable_to_non_nullable
as String?,countBuffer: null == countBuffer ? _self.countBuffer : countBuffer // ignore: cast_nullable_to_non_nullable
as String,textToInsert: freezed == textToInsert ? _self.textToInsert : textToInsert // ignore: cast_nullable_to_non_nullable
as String?,deleteAtCursor: null == deleteAtCursor ? _self.deleteAtCursor : deleteAtCursor // ignore: cast_nullable_to_non_nullable
as bool,deleteBeforeCursor: null == deleteBeforeCursor ? _self.deleteBeforeCursor : deleteBeforeCursor // ignore: cast_nullable_to_non_nullable
as bool,deleteToPosition: freezed == deleteToPosition ? _self.deleteToPosition : deleteToPosition // ignore: cast_nullable_to_non_nullable
as int?,deleteLine: null == deleteLine ? _self.deleteLine : deleteLine // ignore: cast_nullable_to_non_nullable
as bool,deleteSelection: null == deleteSelection ? _self.deleteSelection : deleteSelection // ignore: cast_nullable_to_non_nullable
as bool,changeToPosition: freezed == changeToPosition ? _self.changeToPosition : changeToPosition // ignore: cast_nullable_to_non_nullable
as int?,changeLine: null == changeLine ? _self.changeLine : changeLine // ignore: cast_nullable_to_non_nullable
as bool,yankLine: null == yankLine ? _self.yankLine : yankLine // ignore: cast_nullable_to_non_nullable
as bool,yankSelection: null == yankSelection ? _self.yankSelection : yankSelection // ignore: cast_nullable_to_non_nullable
as bool,pasteAfter: null == pasteAfter ? _self.pasteAfter : pasteAfter // ignore: cast_nullable_to_non_nullable
as bool,pasteBefore: null == pasteBefore ? _self.pasteBefore : pasteBefore // ignore: cast_nullable_to_non_nullable
as bool,undo: null == undo ? _self.undo : undo // ignore: cast_nullable_to_non_nullable
as bool,redo: null == redo ? _self.redo : redo // ignore: cast_nullable_to_non_nullable
as bool,insertNewLineBelow: null == insertNewLineBelow ? _self.insertNewLineBelow : insertNewLineBelow // ignore: cast_nullable_to_non_nullable
as bool,insertNewLineAbove: null == insertNewLineAbove ? _self.insertNewLineAbove : insertNewLineAbove // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
