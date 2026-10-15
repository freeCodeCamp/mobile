// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scene_assets_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SceneAssets {

 String get backgrounds; Map<String, CharacterAssets> get characterAssets;
/// Create a copy of SceneAssets
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SceneAssetsCopyWith<SceneAssets> get copyWith => _$SceneAssetsCopyWithImpl<SceneAssets>(this as SceneAssets, _$identity);

  /// Serializes this SceneAssets to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SceneAssets&&(identical(other.backgrounds, backgrounds) || other.backgrounds == backgrounds)&&const DeepCollectionEquality().equals(other.characterAssets, characterAssets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,backgrounds,const DeepCollectionEquality().hash(characterAssets));

@override
String toString() {
  return 'SceneAssets(backgrounds: $backgrounds, characterAssets: $characterAssets)';
}


}

/// @nodoc
abstract mixin class $SceneAssetsCopyWith<$Res>  {
  factory $SceneAssetsCopyWith(SceneAssets value, $Res Function(SceneAssets) _then) = _$SceneAssetsCopyWithImpl;
@useResult
$Res call({
 String backgrounds, Map<String, CharacterAssets> characterAssets
});




}
/// @nodoc
class _$SceneAssetsCopyWithImpl<$Res>
    implements $SceneAssetsCopyWith<$Res> {
  _$SceneAssetsCopyWithImpl(this._self, this._then);

  final SceneAssets _self;
  final $Res Function(SceneAssets) _then;

/// Create a copy of SceneAssets
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? backgrounds = null,Object? characterAssets = null,}) {
  return _then(_self.copyWith(
backgrounds: null == backgrounds ? _self.backgrounds : backgrounds // ignore: cast_nullable_to_non_nullable
as String,characterAssets: null == characterAssets ? _self.characterAssets : characterAssets // ignore: cast_nullable_to_non_nullable
as Map<String, CharacterAssets>,
  ));
}

}


/// Adds pattern-matching-related methods to [SceneAssets].
extension SceneAssetsPatterns on SceneAssets {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SceneAssets value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SceneAssets() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SceneAssets value)  $default,){
final _that = this;
switch (_that) {
case _SceneAssets():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SceneAssets value)?  $default,){
final _that = this;
switch (_that) {
case _SceneAssets() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String backgrounds,  Map<String, CharacterAssets> characterAssets)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SceneAssets() when $default != null:
return $default(_that.backgrounds,_that.characterAssets);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String backgrounds,  Map<String, CharacterAssets> characterAssets)  $default,) {final _that = this;
switch (_that) {
case _SceneAssets():
return $default(_that.backgrounds,_that.characterAssets);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String backgrounds,  Map<String, CharacterAssets> characterAssets)?  $default,) {final _that = this;
switch (_that) {
case _SceneAssets() when $default != null:
return $default(_that.backgrounds,_that.characterAssets);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SceneAssets implements SceneAssets {
  const _SceneAssets({required this.backgrounds, required final  Map<String, CharacterAssets> characterAssets}): _characterAssets = characterAssets;
  factory _SceneAssets.fromJson(Map<String, dynamic> json) => _$SceneAssetsFromJson(json);

@override final  String backgrounds;
 final  Map<String, CharacterAssets> _characterAssets;
@override Map<String, CharacterAssets> get characterAssets {
  if (_characterAssets is EqualUnmodifiableMapView) return _characterAssets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_characterAssets);
}


/// Create a copy of SceneAssets
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SceneAssetsCopyWith<_SceneAssets> get copyWith => __$SceneAssetsCopyWithImpl<_SceneAssets>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SceneAssetsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SceneAssets&&(identical(other.backgrounds, backgrounds) || other.backgrounds == backgrounds)&&const DeepCollectionEquality().equals(other._characterAssets, _characterAssets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,backgrounds,const DeepCollectionEquality().hash(_characterAssets));

@override
String toString() {
  return 'SceneAssets(backgrounds: $backgrounds, characterAssets: $characterAssets)';
}


}

/// @nodoc
abstract mixin class _$SceneAssetsCopyWith<$Res> implements $SceneAssetsCopyWith<$Res> {
  factory _$SceneAssetsCopyWith(_SceneAssets value, $Res Function(_SceneAssets) _then) = __$SceneAssetsCopyWithImpl;
@override @useResult
$Res call({
 String backgrounds, Map<String, CharacterAssets> characterAssets
});




}
/// @nodoc
class __$SceneAssetsCopyWithImpl<$Res>
    implements _$SceneAssetsCopyWith<$Res> {
  __$SceneAssetsCopyWithImpl(this._self, this._then);

  final _SceneAssets _self;
  final $Res Function(_SceneAssets) _then;

/// Create a copy of SceneAssets
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? backgrounds = null,Object? characterAssets = null,}) {
  return _then(_SceneAssets(
backgrounds: null == backgrounds ? _self.backgrounds : backgrounds // ignore: cast_nullable_to_non_nullable
as String,characterAssets: null == characterAssets ? _self._characterAssets : characterAssets // ignore: cast_nullable_to_non_nullable
as Map<String, CharacterAssets>,
  ));
}


}


/// @nodoc
mixin _$CharacterAssets {

 String get base; String get brows; String get eyesClosed; String get eyesOpen; String? get glasses; String get mouthClosed; String get mouthOpen;
/// Create a copy of CharacterAssets
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CharacterAssetsCopyWith<CharacterAssets> get copyWith => _$CharacterAssetsCopyWithImpl<CharacterAssets>(this as CharacterAssets, _$identity);

  /// Serializes this CharacterAssets to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CharacterAssets&&(identical(other.base, base) || other.base == base)&&(identical(other.brows, brows) || other.brows == brows)&&(identical(other.eyesClosed, eyesClosed) || other.eyesClosed == eyesClosed)&&(identical(other.eyesOpen, eyesOpen) || other.eyesOpen == eyesOpen)&&(identical(other.glasses, glasses) || other.glasses == glasses)&&(identical(other.mouthClosed, mouthClosed) || other.mouthClosed == mouthClosed)&&(identical(other.mouthOpen, mouthOpen) || other.mouthOpen == mouthOpen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,base,brows,eyesClosed,eyesOpen,glasses,mouthClosed,mouthOpen);

@override
String toString() {
  return 'CharacterAssets(base: $base, brows: $brows, eyesClosed: $eyesClosed, eyesOpen: $eyesOpen, glasses: $glasses, mouthClosed: $mouthClosed, mouthOpen: $mouthOpen)';
}


}

/// @nodoc
abstract mixin class $CharacterAssetsCopyWith<$Res>  {
  factory $CharacterAssetsCopyWith(CharacterAssets value, $Res Function(CharacterAssets) _then) = _$CharacterAssetsCopyWithImpl;
@useResult
$Res call({
 String base, String brows, String eyesClosed, String eyesOpen, String? glasses, String mouthClosed, String mouthOpen
});




}
/// @nodoc
class _$CharacterAssetsCopyWithImpl<$Res>
    implements $CharacterAssetsCopyWith<$Res> {
  _$CharacterAssetsCopyWithImpl(this._self, this._then);

  final CharacterAssets _self;
  final $Res Function(CharacterAssets) _then;

/// Create a copy of CharacterAssets
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? base = null,Object? brows = null,Object? eyesClosed = null,Object? eyesOpen = null,Object? glasses = freezed,Object? mouthClosed = null,Object? mouthOpen = null,}) {
  return _then(_self.copyWith(
base: null == base ? _self.base : base // ignore: cast_nullable_to_non_nullable
as String,brows: null == brows ? _self.brows : brows // ignore: cast_nullable_to_non_nullable
as String,eyesClosed: null == eyesClosed ? _self.eyesClosed : eyesClosed // ignore: cast_nullable_to_non_nullable
as String,eyesOpen: null == eyesOpen ? _self.eyesOpen : eyesOpen // ignore: cast_nullable_to_non_nullable
as String,glasses: freezed == glasses ? _self.glasses : glasses // ignore: cast_nullable_to_non_nullable
as String?,mouthClosed: null == mouthClosed ? _self.mouthClosed : mouthClosed // ignore: cast_nullable_to_non_nullable
as String,mouthOpen: null == mouthOpen ? _self.mouthOpen : mouthOpen // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CharacterAssets].
extension CharacterAssetsPatterns on CharacterAssets {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CharacterAssets value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CharacterAssets() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CharacterAssets value)  $default,){
final _that = this;
switch (_that) {
case _CharacterAssets():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CharacterAssets value)?  $default,){
final _that = this;
switch (_that) {
case _CharacterAssets() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String base,  String brows,  String eyesClosed,  String eyesOpen,  String? glasses,  String mouthClosed,  String mouthOpen)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CharacterAssets() when $default != null:
return $default(_that.base,_that.brows,_that.eyesClosed,_that.eyesOpen,_that.glasses,_that.mouthClosed,_that.mouthOpen);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String base,  String brows,  String eyesClosed,  String eyesOpen,  String? glasses,  String mouthClosed,  String mouthOpen)  $default,) {final _that = this;
switch (_that) {
case _CharacterAssets():
return $default(_that.base,_that.brows,_that.eyesClosed,_that.eyesOpen,_that.glasses,_that.mouthClosed,_that.mouthOpen);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String base,  String brows,  String eyesClosed,  String eyesOpen,  String? glasses,  String mouthClosed,  String mouthOpen)?  $default,) {final _that = this;
switch (_that) {
case _CharacterAssets() when $default != null:
return $default(_that.base,_that.brows,_that.eyesClosed,_that.eyesOpen,_that.glasses,_that.mouthClosed,_that.mouthOpen);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CharacterAssets implements CharacterAssets {
  const _CharacterAssets({required this.base, required this.brows, required this.eyesClosed, required this.eyesOpen, this.glasses, required this.mouthClosed, required this.mouthOpen});
  factory _CharacterAssets.fromJson(Map<String, dynamic> json) => _$CharacterAssetsFromJson(json);

@override final  String base;
@override final  String brows;
@override final  String eyesClosed;
@override final  String eyesOpen;
@override final  String? glasses;
@override final  String mouthClosed;
@override final  String mouthOpen;

/// Create a copy of CharacterAssets
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CharacterAssetsCopyWith<_CharacterAssets> get copyWith => __$CharacterAssetsCopyWithImpl<_CharacterAssets>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CharacterAssetsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CharacterAssets&&(identical(other.base, base) || other.base == base)&&(identical(other.brows, brows) || other.brows == brows)&&(identical(other.eyesClosed, eyesClosed) || other.eyesClosed == eyesClosed)&&(identical(other.eyesOpen, eyesOpen) || other.eyesOpen == eyesOpen)&&(identical(other.glasses, glasses) || other.glasses == glasses)&&(identical(other.mouthClosed, mouthClosed) || other.mouthClosed == mouthClosed)&&(identical(other.mouthOpen, mouthOpen) || other.mouthOpen == mouthOpen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,base,brows,eyesClosed,eyesOpen,glasses,mouthClosed,mouthOpen);

@override
String toString() {
  return 'CharacterAssets(base: $base, brows: $brows, eyesClosed: $eyesClosed, eyesOpen: $eyesOpen, glasses: $glasses, mouthClosed: $mouthClosed, mouthOpen: $mouthOpen)';
}


}

/// @nodoc
abstract mixin class _$CharacterAssetsCopyWith<$Res> implements $CharacterAssetsCopyWith<$Res> {
  factory _$CharacterAssetsCopyWith(_CharacterAssets value, $Res Function(_CharacterAssets) _then) = __$CharacterAssetsCopyWithImpl;
@override @useResult
$Res call({
 String base, String brows, String eyesClosed, String eyesOpen, String? glasses, String mouthClosed, String mouthOpen
});




}
/// @nodoc
class __$CharacterAssetsCopyWithImpl<$Res>
    implements _$CharacterAssetsCopyWith<$Res> {
  __$CharacterAssetsCopyWithImpl(this._self, this._then);

  final _CharacterAssets _self;
  final $Res Function(_CharacterAssets) _then;

/// Create a copy of CharacterAssets
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? base = null,Object? brows = null,Object? eyesClosed = null,Object? eyesOpen = null,Object? glasses = freezed,Object? mouthClosed = null,Object? mouthOpen = null,}) {
  return _then(_CharacterAssets(
base: null == base ? _self.base : base // ignore: cast_nullable_to_non_nullable
as String,brows: null == brows ? _self.brows : brows // ignore: cast_nullable_to_non_nullable
as String,eyesClosed: null == eyesClosed ? _self.eyesClosed : eyesClosed // ignore: cast_nullable_to_non_nullable
as String,eyesOpen: null == eyesOpen ? _self.eyesOpen : eyesOpen // ignore: cast_nullable_to_non_nullable
as String,glasses: freezed == glasses ? _self.glasses : glasses // ignore: cast_nullable_to_non_nullable
as String?,mouthClosed: null == mouthClosed ? _self.mouthClosed : mouthClosed // ignore: cast_nullable_to_non_nullable
as String,mouthOpen: null == mouthOpen ? _self.mouthOpen : mouthOpen // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
