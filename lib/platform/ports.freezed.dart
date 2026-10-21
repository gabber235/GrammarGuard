// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ports.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SourceApp implements DiagnosticableTreeMixin {

/// macOS bundle id, Windows exe name or X11 WM_CLASS, lowercased.
 String get id;/// Display name. The only part of the source sent to the model.
 String get name;/// Brings the app back to the front before pasting.
 int get processId;/// For profile matching only, never sent to the model.
 String? get windowTitle;/// The active browser tab, where the OS exposes it (macOS browsers
/// through Accessibility). For profile matching only.
 Uri? get url;
/// Create a copy of SourceApp
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SourceAppCopyWith<SourceApp> get copyWith => _$SourceAppCopyWithImpl<SourceApp>(this as SourceApp, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as SourceApp;
  properties
    ..add(DiagnosticsProperty('type', 'SourceApp'))
    ..add(DiagnosticsProperty('id', _this.id))..add(DiagnosticsProperty('name', _this.name))..add(DiagnosticsProperty('processId', _this.processId))..add(DiagnosticsProperty('windowTitle', _this.windowTitle))..add(DiagnosticsProperty('url', _this.url));
}

@override
bool operator ==(Object other) {
  final _this = this as SourceApp;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SourceApp&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.processId, _this.processId) || other.processId == _this.processId)&&(identical(other.windowTitle, _this.windowTitle) || other.windowTitle == _this.windowTitle)&&(identical(other.url, _this.url) || other.url == _this.url));
}


@override
int get hashCode {
  final _this = this as SourceApp;
  return Object.hash(runtimeType,_this.id,_this.name,_this.processId,_this.windowTitle,_this.url);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as SourceApp;
  return 'SourceApp(id: ${_this.id}, name: ${_this.name}, processId: ${_this.processId}, windowTitle: ${_this.windowTitle}, url: ${_this.url})';
}


}

/// @nodoc
abstract mixin class $SourceAppCopyWith<$Res>  {
  factory $SourceAppCopyWith(SourceApp value, $Res Function(SourceApp) _then) = _$SourceAppCopyWithImpl;
@useResult
$Res call({
 String id, String name, int processId, String? windowTitle, Uri? url
});




}
/// @nodoc
class _$SourceAppCopyWithImpl<$Res>
    implements $SourceAppCopyWith<$Res> {
  _$SourceAppCopyWithImpl(this._self, this._then);

  final SourceApp _self;
  final $Res Function(SourceApp) _then;

/// Create a copy of SourceApp
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? processId = null,Object? windowTitle = freezed,Object? url = freezed,}) {
  return _then(SourceApp(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,processId: null == processId ? _self.processId : processId // ignore: cast_nullable_to_non_nullable
as int,windowTitle: freezed == windowTitle ? _self.windowTitle : windowTitle // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as Uri?,
  ));
}

}


/// Adds pattern-matching-related methods to [SourceApp].
extension SourceAppPatterns on SourceApp {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SourceApp value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SourceApp() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SourceApp value)  $default,){
final _that = this;
switch (_that) {
case _SourceApp():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SourceApp value)?  $default,){
final _that = this;
switch (_that) {
case _SourceApp() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int processId,  String? windowTitle,  Uri? url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SourceApp() when $default != null:
return $default(_that.id,_that.name,_that.processId,_that.windowTitle,_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int processId,  String? windowTitle,  Uri? url)  $default,) {final _that = this;
switch (_that) {
case _SourceApp():
return $default(_that.id,_that.name,_that.processId,_that.windowTitle,_that.url);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int processId,  String? windowTitle,  Uri? url)?  $default,) {final _that = this;
switch (_that) {
case _SourceApp() when $default != null:
return $default(_that.id,_that.name,_that.processId,_that.windowTitle,_that.url);case _:
  return null;

}
}

}

/// @nodoc


class _SourceApp with DiagnosticableTreeMixin implements SourceApp {
  const _SourceApp({required this.id, required this.name, required this.processId, this.windowTitle, this.url});
  

/// macOS bundle id, Windows exe name or X11 WM_CLASS, lowercased.
@override final  String id;
/// Display name. The only part of the source sent to the model.
@override final  String name;
/// Brings the app back to the front before pasting.
@override final  int processId;
/// For profile matching only, never sent to the model.
@override final  String? windowTitle;
/// The active browser tab, where the OS exposes it (macOS browsers
/// through Accessibility). For profile matching only.
@override final  Uri? url;

/// Create a copy of SourceApp
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SourceAppCopyWith<_SourceApp> get copyWith => __$SourceAppCopyWithImpl<_SourceApp>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'SourceApp'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('processId', processId))..add(DiagnosticsProperty('windowTitle', windowTitle))..add(DiagnosticsProperty('url', url));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SourceApp&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.processId, processId) || other.processId == processId)&&(identical(other.windowTitle, windowTitle) || other.windowTitle == windowTitle)&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,processId,windowTitle,url);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'SourceApp(id: $id, name: $name, processId: $processId, windowTitle: $windowTitle, url: $url)';
}


}

/// @nodoc
abstract mixin class _$SourceAppCopyWith<$Res> implements $SourceAppCopyWith<$Res> {
  factory _$SourceAppCopyWith(_SourceApp value, $Res Function(_SourceApp) _then) = __$SourceAppCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int processId, String? windowTitle, Uri? url
});




}
/// @nodoc
class __$SourceAppCopyWithImpl<$Res>
    implements _$SourceAppCopyWith<$Res> {
  __$SourceAppCopyWithImpl(this._self, this._then);

  final _SourceApp _self;
  final $Res Function(_SourceApp) _then;

/// Create a copy of SourceApp
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? processId = null,Object? windowTitle = freezed,Object? url = freezed,}) {
  return _then(_SourceApp(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,processId: null == processId ? _self.processId : processId // ignore: cast_nullable_to_non_nullable
as int,windowTitle: freezed == windowTitle ? _self.windowTitle : windowTitle // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as Uri?,
  ));
}


}

/// @nodoc
mixin _$Captured implements DiagnosticableTreeMixin {

 String get text; CaptureMethod get via;/// Null when GrammarGuard itself was in front, or on Wayland.
 SourceApp? get source;/// Why the selection could not be read and the clipboard was used
/// instead (no Accessibility permission). Shown when the clipboard is
/// empty and again on delivery.
 String? get fallbackReason;
/// Create a copy of Captured
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CapturedCopyWith<Captured> get copyWith => _$CapturedCopyWithImpl<Captured>(this as Captured, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as Captured;
  properties
    ..add(DiagnosticsProperty('type', 'Captured'))
    ..add(DiagnosticsProperty('text', _this.text))..add(DiagnosticsProperty('via', _this.via))..add(DiagnosticsProperty('source', _this.source))..add(DiagnosticsProperty('fallbackReason', _this.fallbackReason));
}

@override
bool operator ==(Object other) {
  final _this = this as Captured;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Captured&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.via, _this.via) || other.via == _this.via)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.fallbackReason, _this.fallbackReason) || other.fallbackReason == _this.fallbackReason));
}


@override
int get hashCode {
  final _this = this as Captured;
  return Object.hash(runtimeType,_this.text,_this.via,_this.source,_this.fallbackReason);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as Captured;
  return 'Captured(text: ${_this.text}, via: ${_this.via}, source: ${_this.source}, fallbackReason: ${_this.fallbackReason})';
}


}

/// @nodoc
abstract mixin class $CapturedCopyWith<$Res>  {
  factory $CapturedCopyWith(Captured value, $Res Function(Captured) _then) = _$CapturedCopyWithImpl;
@useResult
$Res call({
 String text, CaptureMethod via, SourceApp? source, String? fallbackReason
});


$SourceAppCopyWith<$Res>? get source;

}
/// @nodoc
class _$CapturedCopyWithImpl<$Res>
    implements $CapturedCopyWith<$Res> {
  _$CapturedCopyWithImpl(this._self, this._then);

  final Captured _self;
  final $Res Function(Captured) _then;

/// Create a copy of Captured
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? via = null,Object? source = freezed,Object? fallbackReason = freezed,}) {
  return _then(Captured(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,via: null == via ? _self.via : via // ignore: cast_nullable_to_non_nullable
as CaptureMethod,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as SourceApp?,fallbackReason: freezed == fallbackReason ? _self.fallbackReason : fallbackReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of Captured
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SourceAppCopyWith<$Res>? get source {
    if (_self.source == null) {
    return null;
  }

  return $SourceAppCopyWith<$Res>(_self.source!, (value) {
    return _then(_self.copyWith(source: value));
  });
}
}


/// Adds pattern-matching-related methods to [Captured].
extension CapturedPatterns on Captured {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Captured value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Captured() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Captured value)  $default,){
final _that = this;
switch (_that) {
case _Captured():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Captured value)?  $default,){
final _that = this;
switch (_that) {
case _Captured() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  CaptureMethod via,  SourceApp? source,  String? fallbackReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Captured() when $default != null:
return $default(_that.text,_that.via,_that.source,_that.fallbackReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  CaptureMethod via,  SourceApp? source,  String? fallbackReason)  $default,) {final _that = this;
switch (_that) {
case _Captured():
return $default(_that.text,_that.via,_that.source,_that.fallbackReason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  CaptureMethod via,  SourceApp? source,  String? fallbackReason)?  $default,) {final _that = this;
switch (_that) {
case _Captured() when $default != null:
return $default(_that.text,_that.via,_that.source,_that.fallbackReason);case _:
  return null;

}
}

}

/// @nodoc


class _Captured with DiagnosticableTreeMixin implements Captured {
  const _Captured({required this.text, required this.via, this.source, this.fallbackReason});
  

@override final  String text;
@override final  CaptureMethod via;
/// Null when GrammarGuard itself was in front, or on Wayland.
@override final  SourceApp? source;
/// Why the selection could not be read and the clipboard was used
/// instead (no Accessibility permission). Shown when the clipboard is
/// empty and again on delivery.
@override final  String? fallbackReason;

/// Create a copy of Captured
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CapturedCopyWith<_Captured> get copyWith => __$CapturedCopyWithImpl<_Captured>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'Captured'))
    ..add(DiagnosticsProperty('text', text))..add(DiagnosticsProperty('via', via))..add(DiagnosticsProperty('source', source))..add(DiagnosticsProperty('fallbackReason', fallbackReason));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Captured&&(identical(other.text, text) || other.text == text)&&(identical(other.via, via) || other.via == via)&&(identical(other.source, source) || other.source == source)&&(identical(other.fallbackReason, fallbackReason) || other.fallbackReason == fallbackReason));
}


@override
int get hashCode {
    return Object.hash(runtimeType,text,via,source,fallbackReason);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'Captured(text: $text, via: $via, source: $source, fallbackReason: $fallbackReason)';
}


}

/// @nodoc
abstract mixin class _$CapturedCopyWith<$Res> implements $CapturedCopyWith<$Res> {
  factory _$CapturedCopyWith(_Captured value, $Res Function(_Captured) _then) = __$CapturedCopyWithImpl;
@override @useResult
$Res call({
 String text, CaptureMethod via, SourceApp? source, String? fallbackReason
});


@override $SourceAppCopyWith<$Res>? get source;

}
/// @nodoc
class __$CapturedCopyWithImpl<$Res>
    implements _$CapturedCopyWith<$Res> {
  __$CapturedCopyWithImpl(this._self, this._then);

  final _Captured _self;
  final $Res Function(_Captured) _then;

/// Create a copy of Captured
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? via = null,Object? source = freezed,Object? fallbackReason = freezed,}) {
  return _then(_Captured(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,via: null == via ? _self.via : via // ignore: cast_nullable_to_non_nullable
as CaptureMethod,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as SourceApp?,fallbackReason: freezed == fallbackReason ? _self.fallbackReason : fallbackReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Captured
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SourceAppCopyWith<$Res>? get source {
    if (_self.source == null) {
    return null;
  }

  return $SourceAppCopyWith<$Res>(_self.source!, (value) {
    return _then(_self.copyWith(source: value));
  });
}
}

/// @nodoc
mixin _$Delivery implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'Delivery'))
    ;
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is Delivery);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'Delivery()';
}


}

/// @nodoc
class $DeliveryCopyWith<$Res>  {
$DeliveryCopyWith(Delivery _, $Res Function(Delivery) __);
}


/// Adds pattern-matching-related methods to [Delivery].
extension DeliveryPatterns on Delivery {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( Pasted value)?  pasted,TResult Function( Copied value)?  copied,required TResult orElse(),}){
final _that = this;
switch (_that) {
case Pasted() when pasted != null:
return pasted(_that);case Copied() when copied != null:
return copied(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( Pasted value)  pasted,required TResult Function( Copied value)  copied,}){
final _that = this;
switch (_that) {
case Pasted():
return pasted(_that);case Copied():
return copied(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( Pasted value)?  pasted,TResult? Function( Copied value)?  copied,}){
final _that = this;
switch (_that) {
case Pasted() when pasted != null:
return pasted(_that);case Copied() when copied != null:
return copied(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  pasted,TResult Function( String? reason)?  copied,required TResult orElse(),}) {final _that = this;
switch (_that) {
case Pasted() when pasted != null:
return pasted();case Copied() when copied != null:
return copied(_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  pasted,required TResult Function( String? reason)  copied,}) {final _that = this;
switch (_that) {
case Pasted():
return pasted();case Copied():
return copied(_that.reason);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  pasted,TResult? Function( String? reason)?  copied,}) {final _that = this;
switch (_that) {
case Pasted() when pasted != null:
return pasted();case Copied() when copied != null:
return copied(_that.reason);case _:
  return null;

}
}

}

/// @nodoc


class Pasted with DiagnosticableTreeMixin implements Delivery {
  const Pasted();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'Delivery.pasted'))
    ;
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is Pasted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'Delivery.pasted()';
}


}




/// @nodoc


class Copied with DiagnosticableTreeMixin implements Delivery {
  const Copied([this.reason]);
  

 final  String? reason;

/// Create a copy of Delivery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CopiedCopyWith<Copied> get copyWith => _$CopiedCopyWithImpl<Copied>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'Delivery.copied'))
    ..add(DiagnosticsProperty('reason', reason));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is Copied&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode {
    return Object.hash(runtimeType,reason);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'Delivery.copied(reason: $reason)';
}


}

/// @nodoc
abstract mixin class $CopiedCopyWith<$Res> implements $DeliveryCopyWith<$Res> {
  factory $CopiedCopyWith(Copied value, $Res Function(Copied) _then) = _$CopiedCopyWithImpl;
@useResult
$Res call({
 String? reason
});




}
/// @nodoc
class _$CopiedCopyWithImpl<$Res>
    implements $CopiedCopyWith<$Res> {
  _$CopiedCopyWithImpl(this._self, this._then);

  final Copied _self;
  final $Res Function(Copied) _then;

/// Create a copy of Delivery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reason = freezed,}) {
  return _then(Copied(
freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$HotkeyStatus implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'HotkeyStatus'))
    ;
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is HotkeyStatus);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'HotkeyStatus()';
}


}

/// @nodoc
class $HotkeyStatusCopyWith<$Res>  {
$HotkeyStatusCopyWith(HotkeyStatus _, $Res Function(HotkeyStatus) __);
}


/// Adds pattern-matching-related methods to [HotkeyStatus].
extension HotkeyStatusPatterns on HotkeyStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( HotkeyActive value)?  active,TResult Function( HotkeyUnavailable value)?  unavailable,required TResult orElse(),}){
final _that = this;
switch (_that) {
case HotkeyActive() when active != null:
return active(_that);case HotkeyUnavailable() when unavailable != null:
return unavailable(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( HotkeyActive value)  active,required TResult Function( HotkeyUnavailable value)  unavailable,}){
final _that = this;
switch (_that) {
case HotkeyActive():
return active(_that);case HotkeyUnavailable():
return unavailable(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( HotkeyActive value)?  active,TResult? Function( HotkeyUnavailable value)?  unavailable,}){
final _that = this;
switch (_that) {
case HotkeyActive() when active != null:
return active(_that);case HotkeyUnavailable() when unavailable != null:
return unavailable(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  active,TResult Function( String reason)?  unavailable,required TResult orElse(),}) {final _that = this;
switch (_that) {
case HotkeyActive() when active != null:
return active();case HotkeyUnavailable() when unavailable != null:
return unavailable(_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  active,required TResult Function( String reason)  unavailable,}) {final _that = this;
switch (_that) {
case HotkeyActive():
return active();case HotkeyUnavailable():
return unavailable(_that.reason);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  active,TResult? Function( String reason)?  unavailable,}) {final _that = this;
switch (_that) {
case HotkeyActive() when active != null:
return active();case HotkeyUnavailable() when unavailable != null:
return unavailable(_that.reason);case _:
  return null;

}
}

}

/// @nodoc


class HotkeyActive with DiagnosticableTreeMixin implements HotkeyStatus {
  const HotkeyActive();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'HotkeyStatus.active'))
    ;
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is HotkeyActive);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'HotkeyStatus.active()';
}


}




/// @nodoc


class HotkeyUnavailable with DiagnosticableTreeMixin implements HotkeyStatus {
  const HotkeyUnavailable(this.reason);
  

 final  String reason;

/// Create a copy of HotkeyStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HotkeyUnavailableCopyWith<HotkeyUnavailable> get copyWith => _$HotkeyUnavailableCopyWithImpl<HotkeyUnavailable>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'HotkeyStatus.unavailable'))
    ..add(DiagnosticsProperty('reason', reason));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is HotkeyUnavailable&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode {
    return Object.hash(runtimeType,reason);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'HotkeyStatus.unavailable(reason: $reason)';
}


}

/// @nodoc
abstract mixin class $HotkeyUnavailableCopyWith<$Res> implements $HotkeyStatusCopyWith<$Res> {
  factory $HotkeyUnavailableCopyWith(HotkeyUnavailable value, $Res Function(HotkeyUnavailable) _then) = _$HotkeyUnavailableCopyWithImpl;
@useResult
$Res call({
 String reason
});




}
/// @nodoc
class _$HotkeyUnavailableCopyWithImpl<$Res>
    implements $HotkeyUnavailableCopyWith<$Res> {
  _$HotkeyUnavailableCopyWithImpl(this._self, this._then);

  final HotkeyUnavailable _self;
  final $Res Function(HotkeyUnavailable) _then;

/// Create a copy of HotkeyStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reason = null,}) {
  return _then(HotkeyUnavailable(
null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
