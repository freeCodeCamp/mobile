// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scene_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CharacterState {

 String get name; ScenePosition get position; bool get mouthOpen; bool get eyesClosed; double get opacity;
/// Create a copy of CharacterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CharacterStateCopyWith<CharacterState> get copyWith => _$CharacterStateCopyWithImpl<CharacterState>(this as CharacterState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CharacterState&&(identical(other.name, name) || other.name == name)&&(identical(other.position, position) || other.position == position)&&(identical(other.mouthOpen, mouthOpen) || other.mouthOpen == mouthOpen)&&(identical(other.eyesClosed, eyesClosed) || other.eyesClosed == eyesClosed)&&(identical(other.opacity, opacity) || other.opacity == opacity));
}


@override
int get hashCode => Object.hash(runtimeType,name,position,mouthOpen,eyesClosed,opacity);

@override
String toString() {
  return 'CharacterState(name: $name, position: $position, mouthOpen: $mouthOpen, eyesClosed: $eyesClosed, opacity: $opacity)';
}


}

/// @nodoc
abstract mixin class $CharacterStateCopyWith<$Res>  {
  factory $CharacterStateCopyWith(CharacterState value, $Res Function(CharacterState) _then) = _$CharacterStateCopyWithImpl;
@useResult
$Res call({
 String name, ScenePosition position, bool mouthOpen, bool eyesClosed, double opacity
});


$ScenePositionCopyWith<$Res> get position;

}
/// @nodoc
class _$CharacterStateCopyWithImpl<$Res>
    implements $CharacterStateCopyWith<$Res> {
  _$CharacterStateCopyWithImpl(this._self, this._then);

  final CharacterState _self;
  final $Res Function(CharacterState) _then;

/// Create a copy of CharacterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? position = null,Object? mouthOpen = null,Object? eyesClosed = null,Object? opacity = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as ScenePosition,mouthOpen: null == mouthOpen ? _self.mouthOpen : mouthOpen // ignore: cast_nullable_to_non_nullable
as bool,eyesClosed: null == eyesClosed ? _self.eyesClosed : eyesClosed // ignore: cast_nullable_to_non_nullable
as bool,opacity: null == opacity ? _self.opacity : opacity // ignore: cast_nullable_to_non_nullable
as double,
  ));
}
/// Create a copy of CharacterState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScenePositionCopyWith<$Res> get position {
  
  return $ScenePositionCopyWith<$Res>(_self.position, (value) {
    return _then(_self.copyWith(position: value));
  });
}
}


/// Adds pattern-matching-related methods to [CharacterState].
extension CharacterStatePatterns on CharacterState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CharacterState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CharacterState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CharacterState value)  $default,){
final _that = this;
switch (_that) {
case _CharacterState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CharacterState value)?  $default,){
final _that = this;
switch (_that) {
case _CharacterState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  ScenePosition position,  bool mouthOpen,  bool eyesClosed,  double opacity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CharacterState() when $default != null:
return $default(_that.name,_that.position,_that.mouthOpen,_that.eyesClosed,_that.opacity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  ScenePosition position,  bool mouthOpen,  bool eyesClosed,  double opacity)  $default,) {final _that = this;
switch (_that) {
case _CharacterState():
return $default(_that.name,_that.position,_that.mouthOpen,_that.eyesClosed,_that.opacity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  ScenePosition position,  bool mouthOpen,  bool eyesClosed,  double opacity)?  $default,) {final _that = this;
switch (_that) {
case _CharacterState() when $default != null:
return $default(_that.name,_that.position,_that.mouthOpen,_that.eyesClosed,_that.opacity);case _:
  return null;

}
}

}

/// @nodoc


class _CharacterState implements CharacterState {
  const _CharacterState({required this.name, required this.position, this.mouthOpen = false, this.eyesClosed = false, this.opacity = 1});
  

@override final  String name;
@override final  ScenePosition position;
@override@JsonKey() final  bool mouthOpen;
@override@JsonKey() final  bool eyesClosed;
@override@JsonKey() final  double opacity;

/// Create a copy of CharacterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CharacterStateCopyWith<_CharacterState> get copyWith => __$CharacterStateCopyWithImpl<_CharacterState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CharacterState&&(identical(other.name, name) || other.name == name)&&(identical(other.position, position) || other.position == position)&&(identical(other.mouthOpen, mouthOpen) || other.mouthOpen == mouthOpen)&&(identical(other.eyesClosed, eyesClosed) || other.eyesClosed == eyesClosed)&&(identical(other.opacity, opacity) || other.opacity == opacity));
}


@override
int get hashCode => Object.hash(runtimeType,name,position,mouthOpen,eyesClosed,opacity);

@override
String toString() {
  return 'CharacterState(name: $name, position: $position, mouthOpen: $mouthOpen, eyesClosed: $eyesClosed, opacity: $opacity)';
}


}

/// @nodoc
abstract mixin class _$CharacterStateCopyWith<$Res> implements $CharacterStateCopyWith<$Res> {
  factory _$CharacterStateCopyWith(_CharacterState value, $Res Function(_CharacterState) _then) = __$CharacterStateCopyWithImpl;
@override @useResult
$Res call({
 String name, ScenePosition position, bool mouthOpen, bool eyesClosed, double opacity
});


@override $ScenePositionCopyWith<$Res> get position;

}
/// @nodoc
class __$CharacterStateCopyWithImpl<$Res>
    implements _$CharacterStateCopyWith<$Res> {
  __$CharacterStateCopyWithImpl(this._self, this._then);

  final _CharacterState _self;
  final $Res Function(_CharacterState) _then;

/// Create a copy of CharacterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? position = null,Object? mouthOpen = null,Object? eyesClosed = null,Object? opacity = null,}) {
  return _then(_CharacterState(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as ScenePosition,mouthOpen: null == mouthOpen ? _self.mouthOpen : mouthOpen // ignore: cast_nullable_to_non_nullable
as bool,eyesClosed: null == eyesClosed ? _self.eyesClosed : eyesClosed // ignore: cast_nullable_to_non_nullable
as bool,opacity: null == opacity ? _self.opacity : opacity // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of CharacterState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScenePositionCopyWith<$Res> get position {
  
  return $ScenePositionCopyWith<$Res>(_self.position, (value) {
    return _then(_self.copyWith(position: value));
  });
}
}

/// @nodoc
mixin _$SceneState {

 String get background; List<CharacterState> get characters; SceneLine? get line; bool get showCaptions; bool get isActive;
/// Create a copy of SceneState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SceneStateCopyWith<SceneState> get copyWith => _$SceneStateCopyWithImpl<SceneState>(this as SceneState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SceneState&&(identical(other.background, background) || other.background == background)&&const DeepCollectionEquality().equals(other.characters, characters)&&(identical(other.line, line) || other.line == line)&&(identical(other.showCaptions, showCaptions) || other.showCaptions == showCaptions)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode => Object.hash(runtimeType,background,const DeepCollectionEquality().hash(characters),line,showCaptions,isActive);

@override
String toString() {
  return 'SceneState(background: $background, characters: $characters, line: $line, showCaptions: $showCaptions, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $SceneStateCopyWith<$Res>  {
  factory $SceneStateCopyWith(SceneState value, $Res Function(SceneState) _then) = _$SceneStateCopyWithImpl;
@useResult
$Res call({
 String background, List<CharacterState> characters, SceneLine? line, bool showCaptions, bool isActive
});




}
/// @nodoc
class _$SceneStateCopyWithImpl<$Res>
    implements $SceneStateCopyWith<$Res> {
  _$SceneStateCopyWithImpl(this._self, this._then);

  final SceneState _self;
  final $Res Function(SceneState) _then;

/// Create a copy of SceneState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? background = null,Object? characters = null,Object? line = freezed,Object? showCaptions = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
background: null == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as String,characters: null == characters ? _self.characters : characters // ignore: cast_nullable_to_non_nullable
as List<CharacterState>,line: freezed == line ? _self.line : line // ignore: cast_nullable_to_non_nullable
as SceneLine?,showCaptions: null == showCaptions ? _self.showCaptions : showCaptions // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SceneState].
extension SceneStatePatterns on SceneState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SceneState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SceneState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SceneState value)  $default,){
final _that = this;
switch (_that) {
case _SceneState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SceneState value)?  $default,){
final _that = this;
switch (_that) {
case _SceneState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String background,  List<CharacterState> characters,  SceneLine? line,  bool showCaptions,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SceneState() when $default != null:
return $default(_that.background,_that.characters,_that.line,_that.showCaptions,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String background,  List<CharacterState> characters,  SceneLine? line,  bool showCaptions,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _SceneState():
return $default(_that.background,_that.characters,_that.line,_that.showCaptions,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String background,  List<CharacterState> characters,  SceneLine? line,  bool showCaptions,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _SceneState() when $default != null:
return $default(_that.background,_that.characters,_that.line,_that.showCaptions,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc


class _SceneState implements SceneState {
  const _SceneState({required this.background, required final  List<CharacterState> characters, this.line, this.showCaptions = false, this.isActive = false}): _characters = characters;
  

@override final  String background;
 final  List<CharacterState> _characters;
@override List<CharacterState> get characters {
  if (_characters is EqualUnmodifiableListView) return _characters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_characters);
}

@override final  SceneLine? line;
@override@JsonKey() final  bool showCaptions;
@override@JsonKey() final  bool isActive;

/// Create a copy of SceneState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SceneStateCopyWith<_SceneState> get copyWith => __$SceneStateCopyWithImpl<_SceneState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SceneState&&(identical(other.background, background) || other.background == background)&&const DeepCollectionEquality().equals(other._characters, _characters)&&(identical(other.line, line) || other.line == line)&&(identical(other.showCaptions, showCaptions) || other.showCaptions == showCaptions)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode => Object.hash(runtimeType,background,const DeepCollectionEquality().hash(_characters),line,showCaptions,isActive);

@override
String toString() {
  return 'SceneState(background: $background, characters: $characters, line: $line, showCaptions: $showCaptions, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$SceneStateCopyWith<$Res> implements $SceneStateCopyWith<$Res> {
  factory _$SceneStateCopyWith(_SceneState value, $Res Function(_SceneState) _then) = __$SceneStateCopyWithImpl;
@override @useResult
$Res call({
 String background, List<CharacterState> characters, SceneLine? line, bool showCaptions, bool isActive
});




}
/// @nodoc
class __$SceneStateCopyWithImpl<$Res>
    implements _$SceneStateCopyWith<$Res> {
  __$SceneStateCopyWithImpl(this._self, this._then);

  final _SceneState _self;
  final $Res Function(_SceneState) _then;

/// Create a copy of SceneState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? background = null,Object? characters = null,Object? line = freezed,Object? showCaptions = null,Object? isActive = null,}) {
  return _then(_SceneState(
background: null == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as String,characters: null == characters ? _self._characters : characters // ignore: cast_nullable_to_non_nullable
as List<CharacterState>,line: freezed == line ? _self.line : line // ignore: cast_nullable_to_non_nullable
as SceneLine?,showCaptions: null == showCaptions ? _self.showCaptions : showCaptions // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
