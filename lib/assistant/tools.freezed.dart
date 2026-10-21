// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tools.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProposalItem {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ProposalItem);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ProposalItem()';
}


}

/// @nodoc
class $ProposalItemCopyWith<$Res>  {
$ProposalItemCopyWith(ProposalItem _, $Res Function(ProposalItem) __);
}


/// Adds pattern-matching-related methods to [ProposalItem].
extension ProposalItemPatterns on ProposalItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ProposedChange value)?  change,TResult Function( ProposedRestore value)?  restore,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ProposedChange() when change != null:
return change(_that);case ProposedRestore() when restore != null:
return restore(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ProposedChange value)  change,required TResult Function( ProposedRestore value)  restore,}){
final _that = this;
switch (_that) {
case ProposedChange():
return change(_that);case ProposedRestore():
return restore(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ProposedChange value)?  change,TResult? Function( ProposedRestore value)?  restore,}){
final _that = this;
switch (_that) {
case ProposedChange() when change != null:
return change(_that);case ProposedRestore() when restore != null:
return restore(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( LibraryChange change)?  change,TResult Function( ChangeLogEntry entry)?  restore,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ProposedChange() when change != null:
return change(_that.change);case ProposedRestore() when restore != null:
return restore(_that.entry);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( LibraryChange change)  change,required TResult Function( ChangeLogEntry entry)  restore,}) {final _that = this;
switch (_that) {
case ProposedChange():
return change(_that.change);case ProposedRestore():
return restore(_that.entry);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( LibraryChange change)?  change,TResult? Function( ChangeLogEntry entry)?  restore,}) {final _that = this;
switch (_that) {
case ProposedChange() when change != null:
return change(_that.change);case ProposedRestore() when restore != null:
return restore(_that.entry);case _:
  return null;

}
}

}

/// @nodoc


class ProposedChange implements ProposalItem {
  const ProposedChange(this.change);
  

 final  LibraryChange change;

/// Create a copy of ProposalItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProposedChangeCopyWith<ProposedChange> get copyWith => _$ProposedChangeCopyWithImpl<ProposedChange>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ProposedChange&&(identical(other.change, change) || other.change == change));
}


@override
int get hashCode {
    return Object.hash(runtimeType,change);
}

@override
String toString() {
    return 'ProposalItem.change(change: $change)';
}


}

/// @nodoc
abstract mixin class $ProposedChangeCopyWith<$Res> implements $ProposalItemCopyWith<$Res> {
  factory $ProposedChangeCopyWith(ProposedChange value, $Res Function(ProposedChange) _then) = _$ProposedChangeCopyWithImpl;
@useResult
$Res call({
 LibraryChange change
});


$LibraryChangeCopyWith<$Res> get change;

}
/// @nodoc
class _$ProposedChangeCopyWithImpl<$Res>
    implements $ProposedChangeCopyWith<$Res> {
  _$ProposedChangeCopyWithImpl(this._self, this._then);

  final ProposedChange _self;
  final $Res Function(ProposedChange) _then;

/// Create a copy of ProposalItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? change = null,}) {
  return _then(ProposedChange(
null == change ? _self.change : change // ignore: cast_nullable_to_non_nullable
as LibraryChange,
  ));
}

/// Create a copy of ProposalItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LibraryChangeCopyWith<$Res> get change {
  
  return $LibraryChangeCopyWith<$Res>(_self.change, (value) {
    return _then(_self.copyWith(change: value));
  });
}
}

/// @nodoc


class ProposedRestore implements ProposalItem {
  const ProposedRestore(this.entry);
  

 final  ChangeLogEntry entry;

/// Create a copy of ProposalItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProposedRestoreCopyWith<ProposedRestore> get copyWith => _$ProposedRestoreCopyWithImpl<ProposedRestore>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ProposedRestore&&(identical(other.entry, entry) || other.entry == entry));
}


@override
int get hashCode {
    return Object.hash(runtimeType,entry);
}

@override
String toString() {
    return 'ProposalItem.restore(entry: $entry)';
}


}

/// @nodoc
abstract mixin class $ProposedRestoreCopyWith<$Res> implements $ProposalItemCopyWith<$Res> {
  factory $ProposedRestoreCopyWith(ProposedRestore value, $Res Function(ProposedRestore) _then) = _$ProposedRestoreCopyWithImpl;
@useResult
$Res call({
 ChangeLogEntry entry
});


$ChangeLogEntryCopyWith<$Res> get entry;

}
/// @nodoc
class _$ProposedRestoreCopyWithImpl<$Res>
    implements $ProposedRestoreCopyWith<$Res> {
  _$ProposedRestoreCopyWithImpl(this._self, this._then);

  final ProposedRestore _self;
  final $Res Function(ProposedRestore) _then;

/// Create a copy of ProposalItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? entry = null,}) {
  return _then(ProposedRestore(
null == entry ? _self.entry : entry // ignore: cast_nullable_to_non_nullable
as ChangeLogEntry,
  ));
}

/// Create a copy of ProposalItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChangeLogEntryCopyWith<$Res> get entry {
  
  return $ChangeLogEntryCopyWith<$Res>(_self.entry, (value) {
    return _then(_self.copyWith(entry: value));
  });
}
}

/// @nodoc
mixin _$ToolOutcome {

 String get result; ProposalItem? get propose;
/// Create a copy of ToolOutcome
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ToolOutcomeCopyWith<ToolOutcome> get copyWith => _$ToolOutcomeCopyWithImpl<ToolOutcome>(this as ToolOutcome, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ToolOutcome;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ToolOutcome&&(identical(other.result, _this.result) || other.result == _this.result)&&(identical(other.propose, _this.propose) || other.propose == _this.propose));
}


@override
int get hashCode {
  final _this = this as ToolOutcome;
  return Object.hash(runtimeType,_this.result,_this.propose);
}

@override
String toString() {
  final _this = this as ToolOutcome;
  return 'ToolOutcome(result: ${_this.result}, propose: ${_this.propose})';
}


}

/// @nodoc
abstract mixin class $ToolOutcomeCopyWith<$Res>  {
  factory $ToolOutcomeCopyWith(ToolOutcome value, $Res Function(ToolOutcome) _then) = _$ToolOutcomeCopyWithImpl;
@useResult
$Res call({
 String result, ProposalItem? propose
});


$ProposalItemCopyWith<$Res>? get propose;

}
/// @nodoc
class _$ToolOutcomeCopyWithImpl<$Res>
    implements $ToolOutcomeCopyWith<$Res> {
  _$ToolOutcomeCopyWithImpl(this._self, this._then);

  final ToolOutcome _self;
  final $Res Function(ToolOutcome) _then;

/// Create a copy of ToolOutcome
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? result = null,Object? propose = freezed,}) {
  return _then(ToolOutcome(
null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as String,propose: freezed == propose ? _self.propose : propose // ignore: cast_nullable_to_non_nullable
as ProposalItem?,
  ));
}
/// Create a copy of ToolOutcome
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProposalItemCopyWith<$Res>? get propose {
    if (_self.propose == null) {
    return null;
  }

  return $ProposalItemCopyWith<$Res>(_self.propose!, (value) {
    return _then(_self.copyWith(propose: value));
  });
}
}


/// Adds pattern-matching-related methods to [ToolOutcome].
extension ToolOutcomePatterns on ToolOutcome {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ToolOutcome value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ToolOutcome() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ToolOutcome value)  $default,){
final _that = this;
switch (_that) {
case _ToolOutcome():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ToolOutcome value)?  $default,){
final _that = this;
switch (_that) {
case _ToolOutcome() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String result,  ProposalItem? propose)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ToolOutcome() when $default != null:
return $default(_that.result,_that.propose);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String result,  ProposalItem? propose)  $default,) {final _that = this;
switch (_that) {
case _ToolOutcome():
return $default(_that.result,_that.propose);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String result,  ProposalItem? propose)?  $default,) {final _that = this;
switch (_that) {
case _ToolOutcome() when $default != null:
return $default(_that.result,_that.propose);case _:
  return null;

}
}

}

/// @nodoc


class _ToolOutcome implements ToolOutcome {
  const _ToolOutcome(this.result, {this.propose});
  

@override final  String result;
@override final  ProposalItem? propose;

/// Create a copy of ToolOutcome
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ToolOutcomeCopyWith<_ToolOutcome> get copyWith => __$ToolOutcomeCopyWithImpl<_ToolOutcome>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ToolOutcome&&(identical(other.result, result) || other.result == result)&&(identical(other.propose, propose) || other.propose == propose));
}


@override
int get hashCode {
    return Object.hash(runtimeType,result,propose);
}

@override
String toString() {
    return 'ToolOutcome(result: $result, propose: $propose)';
}


}

/// @nodoc
abstract mixin class _$ToolOutcomeCopyWith<$Res> implements $ToolOutcomeCopyWith<$Res> {
  factory _$ToolOutcomeCopyWith(_ToolOutcome value, $Res Function(_ToolOutcome) _then) = __$ToolOutcomeCopyWithImpl;
@override @useResult
$Res call({
 String result, ProposalItem? propose
});


@override $ProposalItemCopyWith<$Res>? get propose;

}
/// @nodoc
class __$ToolOutcomeCopyWithImpl<$Res>
    implements _$ToolOutcomeCopyWith<$Res> {
  __$ToolOutcomeCopyWithImpl(this._self, this._then);

  final _ToolOutcome _self;
  final $Res Function(_ToolOutcome) _then;

/// Create a copy of ToolOutcome
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? result = null,Object? propose = freezed,}) {
  return _then(_ToolOutcome(
null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as String,propose: freezed == propose ? _self.propose : propose // ignore: cast_nullable_to_non_nullable
as ProposalItem?,
  ));
}

/// Create a copy of ToolOutcome
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProposalItemCopyWith<$Res>? get propose {
    if (_self.propose == null) {
    return null;
  }

  return $ProposalItemCopyWith<$Res>(_self.propose!, (value) {
    return _then(_self.copyWith(propose: value));
  });
}
}

// dart format on
