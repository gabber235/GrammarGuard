// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConnectionCheck {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectionCheck);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ConnectionCheck()';
}


}

/// @nodoc
class $ConnectionCheckCopyWith<$Res>  {
$ConnectionCheckCopyWith(ConnectionCheck _, $Res Function(ConnectionCheck) __);
}


/// Adds pattern-matching-related methods to [ConnectionCheck].
extension ConnectionCheckPatterns on ConnectionCheck {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CheckRunning value)?  checking,TResult Function( CheckWorking value)?  working,TResult Function( CheckRejected value)?  rejected,TResult Function( CheckUnknown value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CheckRunning() when checking != null:
return checking(_that);case CheckWorking() when working != null:
return working(_that);case CheckRejected() when rejected != null:
return rejected(_that);case CheckUnknown() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CheckRunning value)  checking,required TResult Function( CheckWorking value)  working,required TResult Function( CheckRejected value)  rejected,required TResult Function( CheckUnknown value)  unknown,}){
final _that = this;
switch (_that) {
case CheckRunning():
return checking(_that);case CheckWorking():
return working(_that);case CheckRejected():
return rejected(_that);case CheckUnknown():
return unknown(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CheckRunning value)?  checking,TResult? Function( CheckWorking value)?  working,TResult? Function( CheckRejected value)?  rejected,TResult? Function( CheckUnknown value)?  unknown,}){
final _that = this;
switch (_that) {
case CheckRunning() when checking != null:
return checking(_that);case CheckWorking() when working != null:
return working(_that);case CheckRejected() when rejected != null:
return rejected(_that);case CheckUnknown() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  checking,TResult Function( int models)?  working,TResult Function()?  rejected,TResult Function()?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CheckRunning() when checking != null:
return checking();case CheckWorking() when working != null:
return working(_that.models);case CheckRejected() when rejected != null:
return rejected();case CheckUnknown() when unknown != null:
return unknown();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  checking,required TResult Function( int models)  working,required TResult Function()  rejected,required TResult Function()  unknown,}) {final _that = this;
switch (_that) {
case CheckRunning():
return checking();case CheckWorking():
return working(_that.models);case CheckRejected():
return rejected();case CheckUnknown():
return unknown();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  checking,TResult? Function( int models)?  working,TResult? Function()?  rejected,TResult? Function()?  unknown,}) {final _that = this;
switch (_that) {
case CheckRunning() when checking != null:
return checking();case CheckWorking() when working != null:
return working(_that.models);case CheckRejected() when rejected != null:
return rejected();case CheckUnknown() when unknown != null:
return unknown();case _:
  return null;

}
}

}

/// @nodoc


class CheckRunning implements ConnectionCheck {
  const CheckRunning();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckRunning);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ConnectionCheck.checking()';
}


}




/// @nodoc


class CheckWorking implements ConnectionCheck {
  const CheckWorking(this.models);
  

 final  int models;

/// Create a copy of ConnectionCheck
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckWorkingCopyWith<CheckWorking> get copyWith => _$CheckWorkingCopyWithImpl<CheckWorking>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckWorking&&(identical(other.models, models) || other.models == models));
}


@override
int get hashCode {
    return Object.hash(runtimeType,models);
}

@override
String toString() {
    return 'ConnectionCheck.working(models: $models)';
}


}

/// @nodoc
abstract mixin class $CheckWorkingCopyWith<$Res> implements $ConnectionCheckCopyWith<$Res> {
  factory $CheckWorkingCopyWith(CheckWorking value, $Res Function(CheckWorking) _then) = _$CheckWorkingCopyWithImpl;
@useResult
$Res call({
 int models
});




}
/// @nodoc
class _$CheckWorkingCopyWithImpl<$Res>
    implements $CheckWorkingCopyWith<$Res> {
  _$CheckWorkingCopyWithImpl(this._self, this._then);

  final CheckWorking _self;
  final $Res Function(CheckWorking) _then;

/// Create a copy of ConnectionCheck
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? models = null,}) {
  return _then(CheckWorking(
null == models ? _self.models : models // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class CheckRejected implements ConnectionCheck {
  const CheckRejected();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckRejected);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ConnectionCheck.rejected()';
}


}




/// @nodoc


class CheckUnknown implements ConnectionCheck {
  const CheckUnknown();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckUnknown);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ConnectionCheck.unknown()';
}


}




// dart format on
