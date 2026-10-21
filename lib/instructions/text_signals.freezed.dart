// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'text_signals.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TextSignals {

 int get words; Set<Content> get contains;/// ISO 639-1 code, or null when too short or unclear to tell.
 String? get language;
/// Create a copy of TextSignals
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextSignalsCopyWith<TextSignals> get copyWith => _$TextSignalsCopyWithImpl<TextSignals>(this as TextSignals, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TextSignals;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TextSignals&&(identical(other.words, _this.words) || other.words == _this.words)&&const DeepCollectionEquality().equals(other.contains, _this.contains)&&(identical(other.language, _this.language) || other.language == _this.language));
}


@override
int get hashCode {
  final _this = this as TextSignals;
  return Object.hash(runtimeType,_this.words,const DeepCollectionEquality().hash(_this.contains),_this.language);
}

@override
String toString() {
  final _this = this as TextSignals;
  return 'TextSignals(words: ${_this.words}, contains: ${_this.contains}, language: ${_this.language})';
}


}

/// @nodoc
abstract mixin class $TextSignalsCopyWith<$Res>  {
  factory $TextSignalsCopyWith(TextSignals value, $Res Function(TextSignals) _then) = _$TextSignalsCopyWithImpl;
@useResult
$Res call({
 int words, Set<Content> contains, String? language
});




}
/// @nodoc
class _$TextSignalsCopyWithImpl<$Res>
    implements $TextSignalsCopyWith<$Res> {
  _$TextSignalsCopyWithImpl(this._self, this._then);

  final TextSignals _self;
  final $Res Function(TextSignals) _then;

/// Create a copy of TextSignals
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? words = null,Object? contains = null,Object? language = freezed,}) {
  return _then(TextSignals(
words: null == words ? _self.words : words // ignore: cast_nullable_to_non_nullable
as int,contains: null == contains ? _self.contains : contains // ignore: cast_nullable_to_non_nullable
as Set<Content>,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TextSignals].
extension TextSignalsPatterns on TextSignals {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TextSignals value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TextSignals() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TextSignals value)  $default,){
final _that = this;
switch (_that) {
case _TextSignals():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TextSignals value)?  $default,){
final _that = this;
switch (_that) {
case _TextSignals() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int words,  Set<Content> contains,  String? language)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TextSignals() when $default != null:
return $default(_that.words,_that.contains,_that.language);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int words,  Set<Content> contains,  String? language)  $default,) {final _that = this;
switch (_that) {
case _TextSignals():
return $default(_that.words,_that.contains,_that.language);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int words,  Set<Content> contains,  String? language)?  $default,) {final _that = this;
switch (_that) {
case _TextSignals() when $default != null:
return $default(_that.words,_that.contains,_that.language);case _:
  return null;

}
}

}

/// @nodoc


class _TextSignals implements TextSignals {
  const _TextSignals({required this.words, required  Set<Content> contains, this.language}): _contains = contains;
  

@override final  int words;
 final  Set<Content> _contains;
@override Set<Content> get contains {
  if (_contains is EqualUnmodifiableSetView) return _contains;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_contains);
}

/// ISO 639-1 code, or null when too short or unclear to tell.
@override final  String? language;

/// Create a copy of TextSignals
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TextSignalsCopyWith<_TextSignals> get copyWith => __$TextSignalsCopyWithImpl<_TextSignals>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TextSignals&&(identical(other.words, words) || other.words == words)&&const DeepCollectionEquality().equals(other.contains, _contains)&&(identical(other.language, language) || other.language == language));
}


@override
int get hashCode {
    return Object.hash(runtimeType,words,const DeepCollectionEquality().hash(_contains),language);
}

@override
String toString() {
    return 'TextSignals(words: $words, contains: $contains, language: $language)';
}


}

/// @nodoc
abstract mixin class _$TextSignalsCopyWith<$Res> implements $TextSignalsCopyWith<$Res> {
  factory _$TextSignalsCopyWith(_TextSignals value, $Res Function(_TextSignals) _then) = __$TextSignalsCopyWithImpl;
@override @useResult
$Res call({
 int words, Set<Content> contains, String? language
});




}
/// @nodoc
class __$TextSignalsCopyWithImpl<$Res>
    implements _$TextSignalsCopyWith<$Res> {
  __$TextSignalsCopyWithImpl(this._self, this._then);

  final _TextSignals _self;
  final $Res Function(_TextSignals) _then;

/// Create a copy of TextSignals
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? words = null,Object? contains = null,Object? language = freezed,}) {
  return _then(_TextSignals(
words: null == words ? _self.words : words // ignore: cast_nullable_to_non_nullable
as int,contains: null == contains ? _self._contains : contains // ignore: cast_nullable_to_non_nullable
as Set<Content>,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
