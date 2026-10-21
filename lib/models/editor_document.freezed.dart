// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'editor_document.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DocumentSegment {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentSegment);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DocumentSegment()';
}


}

/// @nodoc
class $DocumentSegmentCopyWith<$Res>  {
$DocumentSegmentCopyWith(DocumentSegment _, $Res Function(DocumentSegment) __);
}


/// Adds pattern-matching-related methods to [DocumentSegment].
extension DocumentSegmentPatterns on DocumentSegment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TextSegment value)?  text,TResult Function( ChangeSegment value)?  change,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TextSegment() when text != null:
return text(_that);case ChangeSegment() when change != null:
return change(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TextSegment value)  text,required TResult Function( ChangeSegment value)  change,}){
final _that = this;
switch (_that) {
case TextSegment():
return text(_that);case ChangeSegment():
return change(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TextSegment value)?  text,TResult? Function( ChangeSegment value)?  change,}){
final _that = this;
switch (_that) {
case TextSegment() when text != null:
return text(_that);case ChangeSegment() when change != null:
return change(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String text)?  text,TResult Function( int changeIndex)?  change,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TextSegment() when text != null:
return text(_that.text);case ChangeSegment() when change != null:
return change(_that.changeIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String text)  text,required TResult Function( int changeIndex)  change,}) {final _that = this;
switch (_that) {
case TextSegment():
return text(_that.text);case ChangeSegment():
return change(_that.changeIndex);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String text)?  text,TResult? Function( int changeIndex)?  change,}) {final _that = this;
switch (_that) {
case TextSegment() when text != null:
return text(_that.text);case ChangeSegment() when change != null:
return change(_that.changeIndex);case _:
  return null;

}
}

}

/// @nodoc


class TextSegment extends DocumentSegment {
  const TextSegment(this.text): super._();
  

 final  String text;

/// Create a copy of DocumentSegment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextSegmentCopyWith<TextSegment> get copyWith => _$TextSegmentCopyWithImpl<TextSegment>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TextSegment&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode {
    return Object.hash(runtimeType,text);
}

@override
String toString() {
    return 'DocumentSegment.text(text: $text)';
}


}

/// @nodoc
abstract mixin class $TextSegmentCopyWith<$Res> implements $DocumentSegmentCopyWith<$Res> {
  factory $TextSegmentCopyWith(TextSegment value, $Res Function(TextSegment) _then) = _$TextSegmentCopyWithImpl;
@useResult
$Res call({
 String text
});




}
/// @nodoc
class _$TextSegmentCopyWithImpl<$Res>
    implements $TextSegmentCopyWith<$Res> {
  _$TextSegmentCopyWithImpl(this._self, this._then);

  final TextSegment _self;
  final $Res Function(TextSegment) _then;

/// Create a copy of DocumentSegment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? text = null,}) {
  return _then(TextSegment(
null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ChangeSegment extends DocumentSegment {
  const ChangeSegment(this.changeIndex): super._();
  

 final  int changeIndex;

/// Create a copy of DocumentSegment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangeSegmentCopyWith<ChangeSegment> get copyWith => _$ChangeSegmentCopyWithImpl<ChangeSegment>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangeSegment&&(identical(other.changeIndex, changeIndex) || other.changeIndex == changeIndex));
}


@override
int get hashCode {
    return Object.hash(runtimeType,changeIndex);
}

@override
String toString() {
    return 'DocumentSegment.change(changeIndex: $changeIndex)';
}


}

/// @nodoc
abstract mixin class $ChangeSegmentCopyWith<$Res> implements $DocumentSegmentCopyWith<$Res> {
  factory $ChangeSegmentCopyWith(ChangeSegment value, $Res Function(ChangeSegment) _then) = _$ChangeSegmentCopyWithImpl;
@useResult
$Res call({
 int changeIndex
});




}
/// @nodoc
class _$ChangeSegmentCopyWithImpl<$Res>
    implements $ChangeSegmentCopyWith<$Res> {
  _$ChangeSegmentCopyWithImpl(this._self, this._then);

  final ChangeSegment _self;
  final $Res Function(ChangeSegment) _then;

/// Create a copy of DocumentSegment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? changeIndex = null,}) {
  return _then(ChangeSegment(
null == changeIndex ? _self.changeIndex : changeIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$EditorDocument {

 List<DocumentSegment> get segments; List<PendingChange> get pendingChanges;
/// Create a copy of EditorDocument
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditorDocumentCopyWith<EditorDocument> get copyWith => _$EditorDocumentCopyWithImpl<EditorDocument>(this as EditorDocument, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as EditorDocument;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditorDocument&&const DeepCollectionEquality().equals(other.segments, _this.segments)&&const DeepCollectionEquality().equals(other.pendingChanges, _this.pendingChanges));
}


@override
int get hashCode {
  final _this = this as EditorDocument;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.segments),const DeepCollectionEquality().hash(_this.pendingChanges));
}

@override
String toString() {
  final _this = this as EditorDocument;
  return 'EditorDocument(segments: ${_this.segments}, pendingChanges: ${_this.pendingChanges})';
}


}

/// @nodoc
abstract mixin class $EditorDocumentCopyWith<$Res>  {
  factory $EditorDocumentCopyWith(EditorDocument value, $Res Function(EditorDocument) _then) = _$EditorDocumentCopyWithImpl;
@useResult
$Res call({
 List<DocumentSegment> segments, List<PendingChange> pendingChanges
});




}
/// @nodoc
class _$EditorDocumentCopyWithImpl<$Res>
    implements $EditorDocumentCopyWith<$Res> {
  _$EditorDocumentCopyWithImpl(this._self, this._then);

  final EditorDocument _self;
  final $Res Function(EditorDocument) _then;

/// Create a copy of EditorDocument
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? segments = null,Object? pendingChanges = null,}) {
  return _then(EditorDocument(
segments: null == segments ? _self.segments : segments // ignore: cast_nullable_to_non_nullable
as List<DocumentSegment>,pendingChanges: null == pendingChanges ? _self.pendingChanges : pendingChanges // ignore: cast_nullable_to_non_nullable
as List<PendingChange>,
  ));
}

}


/// Adds pattern-matching-related methods to [EditorDocument].
extension EditorDocumentPatterns on EditorDocument {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditorDocument value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditorDocument() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditorDocument value)  $default,){
final _that = this;
switch (_that) {
case _EditorDocument():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditorDocument value)?  $default,){
final _that = this;
switch (_that) {
case _EditorDocument() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DocumentSegment> segments,  List<PendingChange> pendingChanges)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditorDocument() when $default != null:
return $default(_that.segments,_that.pendingChanges);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DocumentSegment> segments,  List<PendingChange> pendingChanges)  $default,) {final _that = this;
switch (_that) {
case _EditorDocument():
return $default(_that.segments,_that.pendingChanges);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DocumentSegment> segments,  List<PendingChange> pendingChanges)?  $default,) {final _that = this;
switch (_that) {
case _EditorDocument() when $default != null:
return $default(_that.segments,_that.pendingChanges);case _:
  return null;

}
}

}

/// @nodoc


class _EditorDocument extends EditorDocument {
  const _EditorDocument({required  List<DocumentSegment> segments, required  List<PendingChange> pendingChanges}): _segments = segments,_pendingChanges = pendingChanges,super._();
  

 final  List<DocumentSegment> _segments;
@override List<DocumentSegment> get segments {
  if (_segments is EqualUnmodifiableListView) return _segments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_segments);
}

 final  List<PendingChange> _pendingChanges;
@override List<PendingChange> get pendingChanges {
  if (_pendingChanges is EqualUnmodifiableListView) return _pendingChanges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pendingChanges);
}


/// Create a copy of EditorDocument
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditorDocumentCopyWith<_EditorDocument> get copyWith => __$EditorDocumentCopyWithImpl<_EditorDocument>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditorDocument&&const DeepCollectionEquality().equals(other.segments, _segments)&&const DeepCollectionEquality().equals(other.pendingChanges, _pendingChanges));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_segments),const DeepCollectionEquality().hash(_pendingChanges));
}

@override
String toString() {
    return 'EditorDocument(segments: $segments, pendingChanges: $pendingChanges)';
}


}

/// @nodoc
abstract mixin class _$EditorDocumentCopyWith<$Res> implements $EditorDocumentCopyWith<$Res> {
  factory _$EditorDocumentCopyWith(_EditorDocument value, $Res Function(_EditorDocument) _then) = __$EditorDocumentCopyWithImpl;
@override @useResult
$Res call({
 List<DocumentSegment> segments, List<PendingChange> pendingChanges
});




}
/// @nodoc
class __$EditorDocumentCopyWithImpl<$Res>
    implements _$EditorDocumentCopyWith<$Res> {
  __$EditorDocumentCopyWithImpl(this._self, this._then);

  final _EditorDocument _self;
  final $Res Function(_EditorDocument) _then;

/// Create a copy of EditorDocument
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? segments = null,Object? pendingChanges = null,}) {
  return _then(_EditorDocument(
segments: null == segments ? _self._segments : segments // ignore: cast_nullable_to_non_nullable
as List<DocumentSegment>,pendingChanges: null == pendingChanges ? _self._pendingChanges : pendingChanges // ignore: cast_nullable_to_non_nullable
as List<PendingChange>,
  ));
}


}

// dart format on
