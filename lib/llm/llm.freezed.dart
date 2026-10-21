// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'llm.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Connection {

 Backend get backend;/// Off by default for local servers, so startup never waits on one.
 bool get enabled; String? get apiKey; Uri? get baseUrl;
/// Create a copy of Connection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConnectionCopyWith<Connection> get copyWith => _$ConnectionCopyWithImpl<Connection>(this as Connection, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Connection;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Connection&&(identical(other.backend, _this.backend) || other.backend == _this.backend)&&(identical(other.enabled, _this.enabled) || other.enabled == _this.enabled)&&(identical(other.apiKey, _this.apiKey) || other.apiKey == _this.apiKey)&&(identical(other.baseUrl, _this.baseUrl) || other.baseUrl == _this.baseUrl));
}


@override
int get hashCode {
  final _this = this as Connection;
  return Object.hash(runtimeType,_this.backend,_this.enabled,_this.apiKey,_this.baseUrl);
}

@override
String toString() {
  final _this = this as Connection;
  return 'Connection(backend: ${_this.backend}, enabled: ${_this.enabled}, apiKey: ${_this.apiKey}, baseUrl: ${_this.baseUrl})';
}


}

/// @nodoc
abstract mixin class $ConnectionCopyWith<$Res>  {
  factory $ConnectionCopyWith(Connection value, $Res Function(Connection) _then) = _$ConnectionCopyWithImpl;
@useResult
$Res call({
 Backend backend, bool enabled, String? apiKey, Uri? baseUrl
});




}
/// @nodoc
class _$ConnectionCopyWithImpl<$Res>
    implements $ConnectionCopyWith<$Res> {
  _$ConnectionCopyWithImpl(this._self, this._then);

  final Connection _self;
  final $Res Function(Connection) _then;

/// Create a copy of Connection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? backend = null,Object? enabled = null,Object? apiKey = freezed,Object? baseUrl = freezed,}) {
  return _then(Connection(
backend: null == backend ? _self.backend : backend // ignore: cast_nullable_to_non_nullable
as Backend,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,apiKey: freezed == apiKey ? _self.apiKey : apiKey // ignore: cast_nullable_to_non_nullable
as String?,baseUrl: freezed == baseUrl ? _self.baseUrl : baseUrl // ignore: cast_nullable_to_non_nullable
as Uri?,
  ));
}

}


/// Adds pattern-matching-related methods to [Connection].
extension ConnectionPatterns on Connection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Connection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Connection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Connection value)  $default,){
final _that = this;
switch (_that) {
case _Connection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Connection value)?  $default,){
final _that = this;
switch (_that) {
case _Connection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Backend backend,  bool enabled,  String? apiKey,  Uri? baseUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Connection() when $default != null:
return $default(_that.backend,_that.enabled,_that.apiKey,_that.baseUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Backend backend,  bool enabled,  String? apiKey,  Uri? baseUrl)  $default,) {final _that = this;
switch (_that) {
case _Connection():
return $default(_that.backend,_that.enabled,_that.apiKey,_that.baseUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Backend backend,  bool enabled,  String? apiKey,  Uri? baseUrl)?  $default,) {final _that = this;
switch (_that) {
case _Connection() when $default != null:
return $default(_that.backend,_that.enabled,_that.apiKey,_that.baseUrl);case _:
  return null;

}
}

}

/// @nodoc


class _Connection extends Connection {
  const _Connection({required this.backend, required this.enabled, this.apiKey, this.baseUrl}): super._();
  

@override final  Backend backend;
/// Off by default for local servers, so startup never waits on one.
@override final  bool enabled;
@override final  String? apiKey;
@override final  Uri? baseUrl;

/// Create a copy of Connection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConnectionCopyWith<_Connection> get copyWith => __$ConnectionCopyWithImpl<_Connection>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Connection&&(identical(other.backend, backend) || other.backend == backend)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.apiKey, apiKey) || other.apiKey == apiKey)&&(identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl));
}


@override
int get hashCode {
    return Object.hash(runtimeType,backend,enabled,apiKey,baseUrl);
}

@override
String toString() {
    return 'Connection(backend: $backend, enabled: $enabled, apiKey: $apiKey, baseUrl: $baseUrl)';
}


}

/// @nodoc
abstract mixin class _$ConnectionCopyWith<$Res> implements $ConnectionCopyWith<$Res> {
  factory _$ConnectionCopyWith(_Connection value, $Res Function(_Connection) _then) = __$ConnectionCopyWithImpl;
@override @useResult
$Res call({
 Backend backend, bool enabled, String? apiKey, Uri? baseUrl
});




}
/// @nodoc
class __$ConnectionCopyWithImpl<$Res>
    implements _$ConnectionCopyWith<$Res> {
  __$ConnectionCopyWithImpl(this._self, this._then);

  final _Connection _self;
  final $Res Function(_Connection) _then;

/// Create a copy of Connection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? backend = null,Object? enabled = null,Object? apiKey = freezed,Object? baseUrl = freezed,}) {
  return _then(_Connection(
backend: null == backend ? _self.backend : backend // ignore: cast_nullable_to_non_nullable
as Backend,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,apiKey: freezed == apiKey ? _self.apiKey : apiKey // ignore: cast_nullable_to_non_nullable
as String?,baseUrl: freezed == baseUrl ? _self.baseUrl : baseUrl // ignore: cast_nullable_to_non_nullable
as Uri?,
  ));
}


}

/// @nodoc
mixin _$ModelRef {

 Backend get backend; String get id;
/// Create a copy of ModelRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModelRefCopyWith<ModelRef> get copyWith => _$ModelRefCopyWithImpl<ModelRef>(this as ModelRef, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ModelRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModelRef&&(identical(other.backend, _this.backend) || other.backend == _this.backend)&&(identical(other.id, _this.id) || other.id == _this.id));
}


@override
int get hashCode {
  final _this = this as ModelRef;
  return Object.hash(runtimeType,_this.backend,_this.id);
}



}

/// @nodoc
abstract mixin class $ModelRefCopyWith<$Res>  {
  factory $ModelRefCopyWith(ModelRef value, $Res Function(ModelRef) _then) = _$ModelRefCopyWithImpl;
@useResult
$Res call({
 Backend backend, String id
});




}
/// @nodoc
class _$ModelRefCopyWithImpl<$Res>
    implements $ModelRefCopyWith<$Res> {
  _$ModelRefCopyWithImpl(this._self, this._then);

  final ModelRef _self;
  final $Res Function(ModelRef) _then;

/// Create a copy of ModelRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? backend = null,Object? id = null,}) {
  return _then(ModelRef(
null == backend ? _self.backend : backend // ignore: cast_nullable_to_non_nullable
as Backend,null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ModelRef].
extension ModelRefPatterns on ModelRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModelRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModelRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModelRef value)  $default,){
final _that = this;
switch (_that) {
case _ModelRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModelRef value)?  $default,){
final _that = this;
switch (_that) {
case _ModelRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Backend backend,  String id)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModelRef() when $default != null:
return $default(_that.backend,_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Backend backend,  String id)  $default,) {final _that = this;
switch (_that) {
case _ModelRef():
return $default(_that.backend,_that.id);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Backend backend,  String id)?  $default,) {final _that = this;
switch (_that) {
case _ModelRef() when $default != null:
return $default(_that.backend,_that.id);case _:
  return null;

}
}

}

/// @nodoc


class _ModelRef extends ModelRef {
  const _ModelRef(this.backend, this.id): super._();
  

@override final  Backend backend;
@override final  String id;

/// Create a copy of ModelRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModelRefCopyWith<_ModelRef> get copyWith => __$ModelRefCopyWithImpl<_ModelRef>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModelRef&&(identical(other.backend, backend) || other.backend == backend)&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode {
    return Object.hash(runtimeType,backend,id);
}



}

/// @nodoc
abstract mixin class _$ModelRefCopyWith<$Res> implements $ModelRefCopyWith<$Res> {
  factory _$ModelRefCopyWith(_ModelRef value, $Res Function(_ModelRef) _then) = __$ModelRefCopyWithImpl;
@override @useResult
$Res call({
 Backend backend, String id
});




}
/// @nodoc
class __$ModelRefCopyWithImpl<$Res>
    implements _$ModelRefCopyWith<$Res> {
  __$ModelRefCopyWithImpl(this._self, this._then);

  final _ModelRef _self;
  final $Res Function(_ModelRef) _then;

/// Create a copy of ModelRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? backend = null,Object? id = null,}) {
  return _then(_ModelRef(
null == backend ? _self.backend : backend // ignore: cast_nullable_to_non_nullable
as Backend,null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$Price {

 double get inputPerMillion; double get outputPerMillion;
/// Create a copy of Price
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PriceCopyWith<Price> get copyWith => _$PriceCopyWithImpl<Price>(this as Price, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Price;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Price&&(identical(other.inputPerMillion, _this.inputPerMillion) || other.inputPerMillion == _this.inputPerMillion)&&(identical(other.outputPerMillion, _this.outputPerMillion) || other.outputPerMillion == _this.outputPerMillion));
}


@override
int get hashCode {
  final _this = this as Price;
  return Object.hash(runtimeType,_this.inputPerMillion,_this.outputPerMillion);
}

@override
String toString() {
  final _this = this as Price;
  return 'Price(inputPerMillion: ${_this.inputPerMillion}, outputPerMillion: ${_this.outputPerMillion})';
}


}

/// @nodoc
abstract mixin class $PriceCopyWith<$Res>  {
  factory $PriceCopyWith(Price value, $Res Function(Price) _then) = _$PriceCopyWithImpl;
@useResult
$Res call({
 double inputPerMillion, double outputPerMillion
});




}
/// @nodoc
class _$PriceCopyWithImpl<$Res>
    implements $PriceCopyWith<$Res> {
  _$PriceCopyWithImpl(this._self, this._then);

  final Price _self;
  final $Res Function(Price) _then;

/// Create a copy of Price
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inputPerMillion = null,Object? outputPerMillion = null,}) {
  return _then(Price(
inputPerMillion: null == inputPerMillion ? _self.inputPerMillion : inputPerMillion // ignore: cast_nullable_to_non_nullable
as double,outputPerMillion: null == outputPerMillion ? _self.outputPerMillion : outputPerMillion // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [Price].
extension PricePatterns on Price {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Price value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Price() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Price value)  $default,){
final _that = this;
switch (_that) {
case _Price():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Price value)?  $default,){
final _that = this;
switch (_that) {
case _Price() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double inputPerMillion,  double outputPerMillion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Price() when $default != null:
return $default(_that.inputPerMillion,_that.outputPerMillion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double inputPerMillion,  double outputPerMillion)  $default,) {final _that = this;
switch (_that) {
case _Price():
return $default(_that.inputPerMillion,_that.outputPerMillion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double inputPerMillion,  double outputPerMillion)?  $default,) {final _that = this;
switch (_that) {
case _Price() when $default != null:
return $default(_that.inputPerMillion,_that.outputPerMillion);case _:
  return null;

}
}

}

/// @nodoc


class _Price extends Price {
  const _Price({required this.inputPerMillion, required this.outputPerMillion}): super._();
  

@override final  double inputPerMillion;
@override final  double outputPerMillion;

/// Create a copy of Price
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PriceCopyWith<_Price> get copyWith => __$PriceCopyWithImpl<_Price>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Price&&(identical(other.inputPerMillion, inputPerMillion) || other.inputPerMillion == inputPerMillion)&&(identical(other.outputPerMillion, outputPerMillion) || other.outputPerMillion == outputPerMillion));
}


@override
int get hashCode {
    return Object.hash(runtimeType,inputPerMillion,outputPerMillion);
}

@override
String toString() {
    return 'Price(inputPerMillion: $inputPerMillion, outputPerMillion: $outputPerMillion)';
}


}

/// @nodoc
abstract mixin class _$PriceCopyWith<$Res> implements $PriceCopyWith<$Res> {
  factory _$PriceCopyWith(_Price value, $Res Function(_Price) _then) = __$PriceCopyWithImpl;
@override @useResult
$Res call({
 double inputPerMillion, double outputPerMillion
});




}
/// @nodoc
class __$PriceCopyWithImpl<$Res>
    implements _$PriceCopyWith<$Res> {
  __$PriceCopyWithImpl(this._self, this._then);

  final _Price _self;
  final $Res Function(_Price) _then;

/// Create a copy of Price
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inputPerMillion = null,Object? outputPerMillion = null,}) {
  return _then(_Price(
inputPerMillion: null == inputPerMillion ? _self.inputPerMillion : inputPerMillion // ignore: cast_nullable_to_non_nullable
as double,outputPerMillion: null == outputPerMillion ? _self.outputPerMillion : outputPerMillion // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$ModelInfo {

 ModelRef get ref; String get label;/// Null when unknown; local backends are [Price.free].
 Price? get price;/// Whether the model can call tools, which the assistant needs. Null
/// when unknown (models a server lists that models.dev does not know).
 bool? get tools;
/// Create a copy of ModelInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModelInfoCopyWith<ModelInfo> get copyWith => _$ModelInfoCopyWithImpl<ModelInfo>(this as ModelInfo, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ModelInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModelInfo&&(identical(other.ref, _this.ref) || other.ref == _this.ref)&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.tools, _this.tools) || other.tools == _this.tools));
}


@override
int get hashCode {
  final _this = this as ModelInfo;
  return Object.hash(runtimeType,_this.ref,_this.label,_this.price,_this.tools);
}

@override
String toString() {
  final _this = this as ModelInfo;
  return 'ModelInfo(ref: ${_this.ref}, label: ${_this.label}, price: ${_this.price}, tools: ${_this.tools})';
}


}

/// @nodoc
abstract mixin class $ModelInfoCopyWith<$Res>  {
  factory $ModelInfoCopyWith(ModelInfo value, $Res Function(ModelInfo) _then) = _$ModelInfoCopyWithImpl;
@useResult
$Res call({
 ModelRef ref, String label, Price? price, bool? tools
});


$ModelRefCopyWith<$Res> get ref;$PriceCopyWith<$Res>? get price;

}
/// @nodoc
class _$ModelInfoCopyWithImpl<$Res>
    implements $ModelInfoCopyWith<$Res> {
  _$ModelInfoCopyWithImpl(this._self, this._then);

  final ModelInfo _self;
  final $Res Function(ModelInfo) _then;

/// Create a copy of ModelInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ref = null,Object? label = null,Object? price = freezed,Object? tools = freezed,}) {
  return _then(ModelInfo(
ref: null == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as ModelRef,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as Price?,tools: freezed == tools ? _self.tools : tools // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}
/// Create a copy of ModelInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModelRefCopyWith<$Res> get ref {
  
  return $ModelRefCopyWith<$Res>(_self.ref, (value) {
    return _then(_self.copyWith(ref: value));
  });
}/// Create a copy of ModelInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PriceCopyWith<$Res>? get price {
    if (_self.price == null) {
    return null;
  }

  return $PriceCopyWith<$Res>(_self.price!, (value) {
    return _then(_self.copyWith(price: value));
  });
}
}


/// Adds pattern-matching-related methods to [ModelInfo].
extension ModelInfoPatterns on ModelInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModelInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModelInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModelInfo value)  $default,){
final _that = this;
switch (_that) {
case _ModelInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModelInfo value)?  $default,){
final _that = this;
switch (_that) {
case _ModelInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ModelRef ref,  String label,  Price? price,  bool? tools)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModelInfo() when $default != null:
return $default(_that.ref,_that.label,_that.price,_that.tools);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ModelRef ref,  String label,  Price? price,  bool? tools)  $default,) {final _that = this;
switch (_that) {
case _ModelInfo():
return $default(_that.ref,_that.label,_that.price,_that.tools);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ModelRef ref,  String label,  Price? price,  bool? tools)?  $default,) {final _that = this;
switch (_that) {
case _ModelInfo() when $default != null:
return $default(_that.ref,_that.label,_that.price,_that.tools);case _:
  return null;

}
}

}

/// @nodoc


class _ModelInfo implements ModelInfo {
  const _ModelInfo({required this.ref, required this.label, this.price, this.tools});
  

@override final  ModelRef ref;
@override final  String label;
/// Null when unknown; local backends are [Price.free].
@override final  Price? price;
/// Whether the model can call tools, which the assistant needs. Null
/// when unknown (models a server lists that models.dev does not know).
@override final  bool? tools;

/// Create a copy of ModelInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModelInfoCopyWith<_ModelInfo> get copyWith => __$ModelInfoCopyWithImpl<_ModelInfo>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModelInfo&&(identical(other.ref, ref) || other.ref == ref)&&(identical(other.label, label) || other.label == label)&&(identical(other.price, price) || other.price == price)&&(identical(other.tools, tools) || other.tools == tools));
}


@override
int get hashCode {
    return Object.hash(runtimeType,ref,label,price,tools);
}

@override
String toString() {
    return 'ModelInfo(ref: $ref, label: $label, price: $price, tools: $tools)';
}


}

/// @nodoc
abstract mixin class _$ModelInfoCopyWith<$Res> implements $ModelInfoCopyWith<$Res> {
  factory _$ModelInfoCopyWith(_ModelInfo value, $Res Function(_ModelInfo) _then) = __$ModelInfoCopyWithImpl;
@override @useResult
$Res call({
 ModelRef ref, String label, Price? price, bool? tools
});


@override $ModelRefCopyWith<$Res> get ref;@override $PriceCopyWith<$Res>? get price;

}
/// @nodoc
class __$ModelInfoCopyWithImpl<$Res>
    implements _$ModelInfoCopyWith<$Res> {
  __$ModelInfoCopyWithImpl(this._self, this._then);

  final _ModelInfo _self;
  final $Res Function(_ModelInfo) _then;

/// Create a copy of ModelInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ref = null,Object? label = null,Object? price = freezed,Object? tools = freezed,}) {
  return _then(_ModelInfo(
ref: null == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as ModelRef,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as Price?,tools: freezed == tools ? _self.tools : tools // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

/// Create a copy of ModelInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModelRefCopyWith<$Res> get ref {
  
  return $ModelRefCopyWith<$Res>(_self.ref, (value) {
    return _then(_self.copyWith(ref: value));
  });
}/// Create a copy of ModelInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PriceCopyWith<$Res>? get price {
    if (_self.price == null) {
    return null;
  }

  return $PriceCopyWith<$Res>(_self.price!, (value) {
    return _then(_self.copyWith(price: value));
  });
}
}

/// @nodoc
mixin _$ModelOptions {

 double? get temperature; llm.ReasoningEffort? get reasoningEffort;
/// Create a copy of ModelOptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModelOptionsCopyWith<ModelOptions> get copyWith => _$ModelOptionsCopyWithImpl<ModelOptions>(this as ModelOptions, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ModelOptions;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModelOptions&&(identical(other.temperature, _this.temperature) || other.temperature == _this.temperature)&&(identical(other.reasoningEffort, _this.reasoningEffort) || other.reasoningEffort == _this.reasoningEffort));
}


@override
int get hashCode {
  final _this = this as ModelOptions;
  return Object.hash(runtimeType,_this.temperature,_this.reasoningEffort);
}

@override
String toString() {
  final _this = this as ModelOptions;
  return 'ModelOptions(temperature: ${_this.temperature}, reasoningEffort: ${_this.reasoningEffort})';
}


}

/// @nodoc
abstract mixin class $ModelOptionsCopyWith<$Res>  {
  factory $ModelOptionsCopyWith(ModelOptions value, $Res Function(ModelOptions) _then) = _$ModelOptionsCopyWithImpl;
@useResult
$Res call({
 double? temperature, llm.ReasoningEffort? reasoningEffort
});




}
/// @nodoc
class _$ModelOptionsCopyWithImpl<$Res>
    implements $ModelOptionsCopyWith<$Res> {
  _$ModelOptionsCopyWithImpl(this._self, this._then);

  final ModelOptions _self;
  final $Res Function(ModelOptions) _then;

/// Create a copy of ModelOptions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? temperature = freezed,Object? reasoningEffort = freezed,}) {
  return _then(ModelOptions(
temperature: freezed == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double?,reasoningEffort: freezed == reasoningEffort ? _self.reasoningEffort : reasoningEffort // ignore: cast_nullable_to_non_nullable
as llm.ReasoningEffort?,
  ));
}

}


/// Adds pattern-matching-related methods to [ModelOptions].
extension ModelOptionsPatterns on ModelOptions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModelOptions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModelOptions() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModelOptions value)  $default,){
final _that = this;
switch (_that) {
case _ModelOptions():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModelOptions value)?  $default,){
final _that = this;
switch (_that) {
case _ModelOptions() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? temperature,  llm.ReasoningEffort? reasoningEffort)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModelOptions() when $default != null:
return $default(_that.temperature,_that.reasoningEffort);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? temperature,  llm.ReasoningEffort? reasoningEffort)  $default,) {final _that = this;
switch (_that) {
case _ModelOptions():
return $default(_that.temperature,_that.reasoningEffort);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? temperature,  llm.ReasoningEffort? reasoningEffort)?  $default,) {final _that = this;
switch (_that) {
case _ModelOptions() when $default != null:
return $default(_that.temperature,_that.reasoningEffort);case _:
  return null;

}
}

}

/// @nodoc


class _ModelOptions implements ModelOptions {
  const _ModelOptions({this.temperature, this.reasoningEffort});
  

@override final  double? temperature;
@override final  llm.ReasoningEffort? reasoningEffort;

/// Create a copy of ModelOptions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModelOptionsCopyWith<_ModelOptions> get copyWith => __$ModelOptionsCopyWithImpl<_ModelOptions>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModelOptions&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.reasoningEffort, reasoningEffort) || other.reasoningEffort == reasoningEffort));
}


@override
int get hashCode {
    return Object.hash(runtimeType,temperature,reasoningEffort);
}

@override
String toString() {
    return 'ModelOptions(temperature: $temperature, reasoningEffort: $reasoningEffort)';
}


}

/// @nodoc
abstract mixin class _$ModelOptionsCopyWith<$Res> implements $ModelOptionsCopyWith<$Res> {
  factory _$ModelOptionsCopyWith(_ModelOptions value, $Res Function(_ModelOptions) _then) = __$ModelOptionsCopyWithImpl;
@override @useResult
$Res call({
 double? temperature, llm.ReasoningEffort? reasoningEffort
});




}
/// @nodoc
class __$ModelOptionsCopyWithImpl<$Res>
    implements _$ModelOptionsCopyWith<$Res> {
  __$ModelOptionsCopyWithImpl(this._self, this._then);

  final _ModelOptions _self;
  final $Res Function(_ModelOptions) _then;

/// Create a copy of ModelOptions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? temperature = freezed,Object? reasoningEffort = freezed,}) {
  return _then(_ModelOptions(
temperature: freezed == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double?,reasoningEffort: freezed == reasoningEffort ? _self.reasoningEffort : reasoningEffort // ignore: cast_nullable_to_non_nullable
as llm.ReasoningEffort?,
  ));
}


}

// dart format on
