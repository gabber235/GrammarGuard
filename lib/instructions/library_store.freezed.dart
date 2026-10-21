// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_store.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoadedLibrary implements DiagnosticableTreeMixin {

 Library get library; LibraryProblem? get problem;
/// Create a copy of LoadedLibrary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadedLibraryCopyWith<LoadedLibrary> get copyWith => _$LoadedLibraryCopyWithImpl<LoadedLibrary>(this as LoadedLibrary, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as LoadedLibrary;
  properties
    ..add(DiagnosticsProperty('type', 'LoadedLibrary'))
    ..add(DiagnosticsProperty('library', _this.library))..add(DiagnosticsProperty('problem', _this.problem));
}

@override
bool operator ==(Object other) {
  final _this = this as LoadedLibrary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadedLibrary&&(identical(other.library, _this.library) || other.library == _this.library)&&(identical(other.problem, _this.problem) || other.problem == _this.problem));
}


@override
int get hashCode {
  final _this = this as LoadedLibrary;
  return Object.hash(runtimeType,_this.library,_this.problem);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as LoadedLibrary;
  return 'LoadedLibrary(library: ${_this.library}, problem: ${_this.problem})';
}


}

/// @nodoc
abstract mixin class $LoadedLibraryCopyWith<$Res>  {
  factory $LoadedLibraryCopyWith(LoadedLibrary value, $Res Function(LoadedLibrary) _then) = _$LoadedLibraryCopyWithImpl;
@useResult
$Res call({
 Library library, LibraryProblem? problem
});


$LibraryCopyWith<$Res> get library;$LibraryProblemCopyWith<$Res>? get problem;

}
/// @nodoc
class _$LoadedLibraryCopyWithImpl<$Res>
    implements $LoadedLibraryCopyWith<$Res> {
  _$LoadedLibraryCopyWithImpl(this._self, this._then);

  final LoadedLibrary _self;
  final $Res Function(LoadedLibrary) _then;

/// Create a copy of LoadedLibrary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? library = null,Object? problem = freezed,}) {
  return _then(LoadedLibrary(
null == library ? _self.library : library // ignore: cast_nullable_to_non_nullable
as Library,problem: freezed == problem ? _self.problem : problem // ignore: cast_nullable_to_non_nullable
as LibraryProblem?,
  ));
}
/// Create a copy of LoadedLibrary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LibraryCopyWith<$Res> get library {
  
  return $LibraryCopyWith<$Res>(_self.library, (value) {
    return _then(_self.copyWith(library: value));
  });
}/// Create a copy of LoadedLibrary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LibraryProblemCopyWith<$Res>? get problem {
    if (_self.problem == null) {
    return null;
  }

  return $LibraryProblemCopyWith<$Res>(_self.problem!, (value) {
    return _then(_self.copyWith(problem: value));
  });
}
}


/// Adds pattern-matching-related methods to [LoadedLibrary].
extension LoadedLibraryPatterns on LoadedLibrary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoadedLibrary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoadedLibrary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoadedLibrary value)  $default,){
final _that = this;
switch (_that) {
case _LoadedLibrary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoadedLibrary value)?  $default,){
final _that = this;
switch (_that) {
case _LoadedLibrary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Library library,  LibraryProblem? problem)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoadedLibrary() when $default != null:
return $default(_that.library,_that.problem);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Library library,  LibraryProblem? problem)  $default,) {final _that = this;
switch (_that) {
case _LoadedLibrary():
return $default(_that.library,_that.problem);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Library library,  LibraryProblem? problem)?  $default,) {final _that = this;
switch (_that) {
case _LoadedLibrary() when $default != null:
return $default(_that.library,_that.problem);case _:
  return null;

}
}

}

/// @nodoc


class _LoadedLibrary with DiagnosticableTreeMixin implements LoadedLibrary {
  const _LoadedLibrary(this.library, {this.problem});
  

@override final  Library library;
@override final  LibraryProblem? problem;

/// Create a copy of LoadedLibrary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedLibraryCopyWith<_LoadedLibrary> get copyWith => __$LoadedLibraryCopyWithImpl<_LoadedLibrary>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'LoadedLibrary'))
    ..add(DiagnosticsProperty('library', library))..add(DiagnosticsProperty('problem', problem));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadedLibrary&&(identical(other.library, library) || other.library == library)&&(identical(other.problem, problem) || other.problem == problem));
}


@override
int get hashCode {
    return Object.hash(runtimeType,library,problem);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'LoadedLibrary(library: $library, problem: $problem)';
}


}

/// @nodoc
abstract mixin class _$LoadedLibraryCopyWith<$Res> implements $LoadedLibraryCopyWith<$Res> {
  factory _$LoadedLibraryCopyWith(_LoadedLibrary value, $Res Function(_LoadedLibrary) _then) = __$LoadedLibraryCopyWithImpl;
@override @useResult
$Res call({
 Library library, LibraryProblem? problem
});


@override $LibraryCopyWith<$Res> get library;@override $LibraryProblemCopyWith<$Res>? get problem;

}
/// @nodoc
class __$LoadedLibraryCopyWithImpl<$Res>
    implements _$LoadedLibraryCopyWith<$Res> {
  __$LoadedLibraryCopyWithImpl(this._self, this._then);

  final _LoadedLibrary _self;
  final $Res Function(_LoadedLibrary) _then;

/// Create a copy of LoadedLibrary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? library = null,Object? problem = freezed,}) {
  return _then(_LoadedLibrary(
null == library ? _self.library : library // ignore: cast_nullable_to_non_nullable
as Library,problem: freezed == problem ? _self.problem : problem // ignore: cast_nullable_to_non_nullable
as LibraryProblem?,
  ));
}

/// Create a copy of LoadedLibrary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LibraryCopyWith<$Res> get library {
  
  return $LibraryCopyWith<$Res>(_self.library, (value) {
    return _then(_self.copyWith(library: value));
  });
}/// Create a copy of LoadedLibrary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LibraryProblemCopyWith<$Res>? get problem {
    if (_self.problem == null) {
    return null;
  }

  return $LibraryProblemCopyWith<$Res>(_self.problem!, (value) {
    return _then(_self.copyWith(problem: value));
  });
}
}


/// @nodoc
mixin _$ChangeLogEntry implements DiagnosticableTreeMixin {

 DateTime get at; ChangeAuthor get author; List<String> get summary; String get snapshot;
/// Create a copy of ChangeLogEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangeLogEntryCopyWith<ChangeLogEntry> get copyWith => _$ChangeLogEntryCopyWithImpl<ChangeLogEntry>(this as ChangeLogEntry, _$identity);

  /// Serializes this ChangeLogEntry to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as ChangeLogEntry;
  properties
    ..add(DiagnosticsProperty('type', 'ChangeLogEntry'))
    ..add(DiagnosticsProperty('at', _this.at))..add(DiagnosticsProperty('author', _this.author))..add(DiagnosticsProperty('summary', _this.summary))..add(DiagnosticsProperty('snapshot', _this.snapshot));
}

@override
bool operator ==(Object other) {
  final _this = this as ChangeLogEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangeLogEntry&&(identical(other.at, _this.at) || other.at == _this.at)&&(identical(other.author, _this.author) || other.author == _this.author)&&const DeepCollectionEquality().equals(other.summary, _this.summary)&&(identical(other.snapshot, _this.snapshot) || other.snapshot == _this.snapshot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChangeLogEntry;
  return Object.hash(runtimeType,_this.at,_this.author,const DeepCollectionEquality().hash(_this.summary),_this.snapshot);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as ChangeLogEntry;
  return 'ChangeLogEntry(at: ${_this.at}, author: ${_this.author}, summary: ${_this.summary}, snapshot: ${_this.snapshot})';
}


}

/// @nodoc
abstract mixin class $ChangeLogEntryCopyWith<$Res>  {
  factory $ChangeLogEntryCopyWith(ChangeLogEntry value, $Res Function(ChangeLogEntry) _then) = _$ChangeLogEntryCopyWithImpl;
@useResult
$Res call({
 DateTime at, ChangeAuthor author, List<String> summary, String snapshot
});




}
/// @nodoc
class _$ChangeLogEntryCopyWithImpl<$Res>
    implements $ChangeLogEntryCopyWith<$Res> {
  _$ChangeLogEntryCopyWithImpl(this._self, this._then);

  final ChangeLogEntry _self;
  final $Res Function(ChangeLogEntry) _then;

/// Create a copy of ChangeLogEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? at = null,Object? author = null,Object? summary = null,Object? snapshot = null,}) {
  return _then(ChangeLogEntry(
at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as ChangeAuthor,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as List<String>,snapshot: null == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChangeLogEntry].
extension ChangeLogEntryPatterns on ChangeLogEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChangeLogEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChangeLogEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChangeLogEntry value)  $default,){
final _that = this;
switch (_that) {
case _ChangeLogEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChangeLogEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ChangeLogEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime at,  ChangeAuthor author,  List<String> summary,  String snapshot)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChangeLogEntry() when $default != null:
return $default(_that.at,_that.author,_that.summary,_that.snapshot);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime at,  ChangeAuthor author,  List<String> summary,  String snapshot)  $default,) {final _that = this;
switch (_that) {
case _ChangeLogEntry():
return $default(_that.at,_that.author,_that.summary,_that.snapshot);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime at,  ChangeAuthor author,  List<String> summary,  String snapshot)?  $default,) {final _that = this;
switch (_that) {
case _ChangeLogEntry() when $default != null:
return $default(_that.at,_that.author,_that.summary,_that.snapshot);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChangeLogEntry with DiagnosticableTreeMixin implements ChangeLogEntry {
  const _ChangeLogEntry({required this.at, required this.author, required  List<String> summary, required this.snapshot}): _summary = summary;
  factory _ChangeLogEntry.fromJson(Map<String, dynamic> json) => _$ChangeLogEntryFromJson(json);

@override final  DateTime at;
@override final  ChangeAuthor author;
 final  List<String> _summary;
@override List<String> get summary {
  if (_summary is EqualUnmodifiableListView) return _summary;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_summary);
}

@override final  String snapshot;

/// Create a copy of ChangeLogEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangeLogEntryCopyWith<_ChangeLogEntry> get copyWith => __$ChangeLogEntryCopyWithImpl<_ChangeLogEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChangeLogEntryToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'ChangeLogEntry'))
    ..add(DiagnosticsProperty('at', at))..add(DiagnosticsProperty('author', author))..add(DiagnosticsProperty('summary', summary))..add(DiagnosticsProperty('snapshot', snapshot));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangeLogEntry&&(identical(other.at, at) || other.at == at)&&(identical(other.author, author) || other.author == author)&&const DeepCollectionEquality().equals(other.summary, _summary)&&(identical(other.snapshot, snapshot) || other.snapshot == snapshot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,at,author,const DeepCollectionEquality().hash(_summary),snapshot);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'ChangeLogEntry(at: $at, author: $author, summary: $summary, snapshot: $snapshot)';
}


}

/// @nodoc
abstract mixin class _$ChangeLogEntryCopyWith<$Res> implements $ChangeLogEntryCopyWith<$Res> {
  factory _$ChangeLogEntryCopyWith(_ChangeLogEntry value, $Res Function(_ChangeLogEntry) _then) = __$ChangeLogEntryCopyWithImpl;
@override @useResult
$Res call({
 DateTime at, ChangeAuthor author, List<String> summary, String snapshot
});




}
/// @nodoc
class __$ChangeLogEntryCopyWithImpl<$Res>
    implements _$ChangeLogEntryCopyWith<$Res> {
  __$ChangeLogEntryCopyWithImpl(this._self, this._then);

  final _ChangeLogEntry _self;
  final $Res Function(_ChangeLogEntry) _then;

/// Create a copy of ChangeLogEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? at = null,Object? author = null,Object? summary = null,Object? snapshot = null,}) {
  return _then(_ChangeLogEntry(
at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as ChangeAuthor,summary: null == summary ? _self._summary : summary // ignore: cast_nullable_to_non_nullable
as List<String>,snapshot: null == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
