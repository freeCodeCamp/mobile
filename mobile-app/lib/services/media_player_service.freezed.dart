// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_player_service.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MediaPlayerState {

 MediaItem? get item; PlaybackState get playback; bool get isRadio; (Podcast, Episode,)? get episode; Duration? get duration;
/// Create a copy of MediaPlayerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaPlayerStateCopyWith<MediaPlayerState> get copyWith => _$MediaPlayerStateCopyWithImpl<MediaPlayerState>(this as MediaPlayerState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MediaPlayerState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaPlayerState&&(identical(other.item, _this.item) || other.item == _this.item)&&(identical(other.playback, _this.playback) || other.playback == _this.playback)&&(identical(other.isRadio, _this.isRadio) || other.isRadio == _this.isRadio)&&(identical(other.episode, _this.episode) || other.episode == _this.episode)&&(identical(other.duration, _this.duration) || other.duration == _this.duration));
}


@override
int get hashCode {
  final _this = this as MediaPlayerState;
  return Object.hash(runtimeType,_this.item,_this.playback,_this.isRadio,_this.episode,_this.duration);
}

@override
String toString() {
  final _this = this as MediaPlayerState;
  return 'MediaPlayerState(item: ${_this.item}, playback: ${_this.playback}, isRadio: ${_this.isRadio}, episode: ${_this.episode}, duration: ${_this.duration})';
}


}

/// @nodoc
abstract mixin class $MediaPlayerStateCopyWith<$Res>  {
  factory $MediaPlayerStateCopyWith(MediaPlayerState value, $Res Function(MediaPlayerState) _then) = _$MediaPlayerStateCopyWithImpl;
@useResult
$Res call({
 MediaItem? item, PlaybackState playback, bool isRadio, (Podcast, Episode,)? episode, Duration? duration
});




}
/// @nodoc
class _$MediaPlayerStateCopyWithImpl<$Res>
    implements $MediaPlayerStateCopyWith<$Res> {
  _$MediaPlayerStateCopyWithImpl(this._self, this._then);

  final MediaPlayerState _self;
  final $Res Function(MediaPlayerState) _then;

/// Create a copy of MediaPlayerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? item = freezed,Object? playback = null,Object? isRadio = null,Object? episode = freezed,Object? duration = freezed,}) {
  return _then(MediaPlayerState(
item: freezed == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as MediaItem?,playback: null == playback ? _self.playback : playback // ignore: cast_nullable_to_non_nullable
as PlaybackState,isRadio: null == isRadio ? _self.isRadio : isRadio // ignore: cast_nullable_to_non_nullable
as bool,episode: freezed == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as (Podcast, Episode,)?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration?,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaPlayerState].
extension MediaPlayerStatePatterns on MediaPlayerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaPlayerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaPlayerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaPlayerState value)  $default,){
final _that = this;
switch (_that) {
case _MediaPlayerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaPlayerState value)?  $default,){
final _that = this;
switch (_that) {
case _MediaPlayerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MediaItem? item,  PlaybackState playback,  bool isRadio,  (Podcast, Episode,)? episode,  Duration? duration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaPlayerState() when $default != null:
return $default(_that.item,_that.playback,_that.isRadio,_that.episode,_that.duration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MediaItem? item,  PlaybackState playback,  bool isRadio,  (Podcast, Episode,)? episode,  Duration? duration)  $default,) {final _that = this;
switch (_that) {
case _MediaPlayerState():
return $default(_that.item,_that.playback,_that.isRadio,_that.episode,_that.duration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MediaItem? item,  PlaybackState playback,  bool isRadio,  (Podcast, Episode,)? episode,  Duration? duration)?  $default,) {final _that = this;
switch (_that) {
case _MediaPlayerState() when $default != null:
return $default(_that.item,_that.playback,_that.isRadio,_that.episode,_that.duration);case _:
  return null;

}
}

}

/// @nodoc


class _MediaPlayerState extends MediaPlayerState {
  const _MediaPlayerState({this.item, required this.playback, this.isRadio = false, this.episode, this.duration}): super._();
  

@override final  MediaItem? item;
@override final  PlaybackState playback;
@override@JsonKey() final  bool isRadio;
@override final  (Podcast, Episode,)? episode;
@override final  Duration? duration;

/// Create a copy of MediaPlayerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaPlayerStateCopyWith<_MediaPlayerState> get copyWith => __$MediaPlayerStateCopyWithImpl<_MediaPlayerState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaPlayerState&&(identical(other.item, item) || other.item == item)&&(identical(other.playback, playback) || other.playback == playback)&&(identical(other.isRadio, isRadio) || other.isRadio == isRadio)&&(identical(other.episode, episode) || other.episode == episode)&&(identical(other.duration, duration) || other.duration == duration));
}


@override
int get hashCode {
    return Object.hash(runtimeType,item,playback,isRadio,episode,duration);
}

@override
String toString() {
    return 'MediaPlayerState(item: $item, playback: $playback, isRadio: $isRadio, episode: $episode, duration: $duration)';
}


}

/// @nodoc
abstract mixin class _$MediaPlayerStateCopyWith<$Res> implements $MediaPlayerStateCopyWith<$Res> {
  factory _$MediaPlayerStateCopyWith(_MediaPlayerState value, $Res Function(_MediaPlayerState) _then) = __$MediaPlayerStateCopyWithImpl;
@override @useResult
$Res call({
 MediaItem? item, PlaybackState playback, bool isRadio, (Podcast, Episode,)? episode, Duration? duration
});




}
/// @nodoc
class __$MediaPlayerStateCopyWithImpl<$Res>
    implements _$MediaPlayerStateCopyWith<$Res> {
  __$MediaPlayerStateCopyWithImpl(this._self, this._then);

  final _MediaPlayerState _self;
  final $Res Function(_MediaPlayerState) _then;

/// Create a copy of MediaPlayerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? item = freezed,Object? playback = null,Object? isRadio = null,Object? episode = freezed,Object? duration = freezed,}) {
  return _then(_MediaPlayerState(
item: freezed == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as MediaItem?,playback: null == playback ? _self.playback : playback // ignore: cast_nullable_to_non_nullable
as PlaybackState,isRadio: null == isRadio ? _self.isRadio : isRadio // ignore: cast_nullable_to_non_nullable
as bool,episode: freezed == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as (Podcast, Episode,)?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration?,
  ));
}


}

// dart format on
