// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PodcastPlayerState {

 String? get episodeId; String? get loadingEpisodeId; bool get isPlaying; bool get isBuffering; Duration? get duration; double get speed;
/// Create a copy of PodcastPlayerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PodcastPlayerStateCopyWith<PodcastPlayerState> get copyWith => _$PodcastPlayerStateCopyWithImpl<PodcastPlayerState>(this as PodcastPlayerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PodcastPlayerState&&(identical(other.episodeId, episodeId) || other.episodeId == episodeId)&&(identical(other.loadingEpisodeId, loadingEpisodeId) || other.loadingEpisodeId == loadingEpisodeId)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.isBuffering, isBuffering) || other.isBuffering == isBuffering)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.speed, speed) || other.speed == speed));
}


@override
int get hashCode => Object.hash(runtimeType,episodeId,loadingEpisodeId,isPlaying,isBuffering,duration,speed);

@override
String toString() {
  return 'PodcastPlayerState(episodeId: $episodeId, loadingEpisodeId: $loadingEpisodeId, isPlaying: $isPlaying, isBuffering: $isBuffering, duration: $duration, speed: $speed)';
}


}

/// @nodoc
abstract mixin class $PodcastPlayerStateCopyWith<$Res>  {
  factory $PodcastPlayerStateCopyWith(PodcastPlayerState value, $Res Function(PodcastPlayerState) _then) = _$PodcastPlayerStateCopyWithImpl;
@useResult
$Res call({
 String? episodeId, String? loadingEpisodeId, bool isPlaying, bool isBuffering, Duration? duration, double speed
});




}
/// @nodoc
class _$PodcastPlayerStateCopyWithImpl<$Res>
    implements $PodcastPlayerStateCopyWith<$Res> {
  _$PodcastPlayerStateCopyWithImpl(this._self, this._then);

  final PodcastPlayerState _self;
  final $Res Function(PodcastPlayerState) _then;

/// Create a copy of PodcastPlayerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? episodeId = freezed,Object? loadingEpisodeId = freezed,Object? isPlaying = null,Object? isBuffering = null,Object? duration = freezed,Object? speed = null,}) {
  return _then(_self.copyWith(
episodeId: freezed == episodeId ? _self.episodeId : episodeId // ignore: cast_nullable_to_non_nullable
as String?,loadingEpisodeId: freezed == loadingEpisodeId ? _self.loadingEpisodeId : loadingEpisodeId // ignore: cast_nullable_to_non_nullable
as String?,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,isBuffering: null == isBuffering ? _self.isBuffering : isBuffering // ignore: cast_nullable_to_non_nullable
as bool,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration?,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [PodcastPlayerState].
extension PodcastPlayerStatePatterns on PodcastPlayerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PodcastPlayerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PodcastPlayerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PodcastPlayerState value)  $default,){
final _that = this;
switch (_that) {
case _PodcastPlayerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PodcastPlayerState value)?  $default,){
final _that = this;
switch (_that) {
case _PodcastPlayerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? episodeId,  String? loadingEpisodeId,  bool isPlaying,  bool isBuffering,  Duration? duration,  double speed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PodcastPlayerState() when $default != null:
return $default(_that.episodeId,_that.loadingEpisodeId,_that.isPlaying,_that.isBuffering,_that.duration,_that.speed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? episodeId,  String? loadingEpisodeId,  bool isPlaying,  bool isBuffering,  Duration? duration,  double speed)  $default,) {final _that = this;
switch (_that) {
case _PodcastPlayerState():
return $default(_that.episodeId,_that.loadingEpisodeId,_that.isPlaying,_that.isBuffering,_that.duration,_that.speed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? episodeId,  String? loadingEpisodeId,  bool isPlaying,  bool isBuffering,  Duration? duration,  double speed)?  $default,) {final _that = this;
switch (_that) {
case _PodcastPlayerState() when $default != null:
return $default(_that.episodeId,_that.loadingEpisodeId,_that.isPlaying,_that.isBuffering,_that.duration,_that.speed);case _:
  return null;

}
}

}

/// @nodoc


class _PodcastPlayerState extends PodcastPlayerState {
  const _PodcastPlayerState({this.episodeId, this.loadingEpisodeId, this.isPlaying = false, this.isBuffering = false, this.duration, this.speed = 1.0}): super._();
  

@override final  String? episodeId;
@override final  String? loadingEpisodeId;
@override@JsonKey() final  bool isPlaying;
@override@JsonKey() final  bool isBuffering;
@override final  Duration? duration;
@override@JsonKey() final  double speed;

/// Create a copy of PodcastPlayerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PodcastPlayerStateCopyWith<_PodcastPlayerState> get copyWith => __$PodcastPlayerStateCopyWithImpl<_PodcastPlayerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PodcastPlayerState&&(identical(other.episodeId, episodeId) || other.episodeId == episodeId)&&(identical(other.loadingEpisodeId, loadingEpisodeId) || other.loadingEpisodeId == loadingEpisodeId)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.isBuffering, isBuffering) || other.isBuffering == isBuffering)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.speed, speed) || other.speed == speed));
}


@override
int get hashCode => Object.hash(runtimeType,episodeId,loadingEpisodeId,isPlaying,isBuffering,duration,speed);

@override
String toString() {
  return 'PodcastPlayerState(episodeId: $episodeId, loadingEpisodeId: $loadingEpisodeId, isPlaying: $isPlaying, isBuffering: $isBuffering, duration: $duration, speed: $speed)';
}


}

/// @nodoc
abstract mixin class _$PodcastPlayerStateCopyWith<$Res> implements $PodcastPlayerStateCopyWith<$Res> {
  factory _$PodcastPlayerStateCopyWith(_PodcastPlayerState value, $Res Function(_PodcastPlayerState) _then) = __$PodcastPlayerStateCopyWithImpl;
@override @useResult
$Res call({
 String? episodeId, String? loadingEpisodeId, bool isPlaying, bool isBuffering, Duration? duration, double speed
});




}
/// @nodoc
class __$PodcastPlayerStateCopyWithImpl<$Res>
    implements _$PodcastPlayerStateCopyWith<$Res> {
  __$PodcastPlayerStateCopyWithImpl(this._self, this._then);

  final _PodcastPlayerState _self;
  final $Res Function(_PodcastPlayerState) _then;

/// Create a copy of PodcastPlayerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? episodeId = freezed,Object? loadingEpisodeId = freezed,Object? isPlaying = null,Object? isBuffering = null,Object? duration = freezed,Object? speed = null,}) {
  return _then(_PodcastPlayerState(
episodeId: freezed == episodeId ? _self.episodeId : episodeId // ignore: cast_nullable_to_non_nullable
as String?,loadingEpisodeId: freezed == loadingEpisodeId ? _self.loadingEpisodeId : loadingEpisodeId // ignore: cast_nullable_to_non_nullable
as String?,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,isBuffering: null == isBuffering ? _self.isBuffering : isBuffering // ignore: cast_nullable_to_non_nullable
as bool,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration?,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
