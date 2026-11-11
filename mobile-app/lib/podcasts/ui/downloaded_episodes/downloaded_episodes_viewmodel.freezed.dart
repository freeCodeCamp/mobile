// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'downloaded_episodes_viewmodel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PodcastDownloadedEpisodesState {

 Podcast? get podcast; List<Episode> get episodes;
/// Create a copy of PodcastDownloadedEpisodesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PodcastDownloadedEpisodesStateCopyWith<PodcastDownloadedEpisodesState> get copyWith => _$PodcastDownloadedEpisodesStateCopyWithImpl<PodcastDownloadedEpisodesState>(this as PodcastDownloadedEpisodesState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PodcastDownloadedEpisodesState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PodcastDownloadedEpisodesState&&(identical(other.podcast, _this.podcast) || other.podcast == _this.podcast)&&const DeepCollectionEquality().equals(other.episodes, _this.episodes));
}


@override
int get hashCode {
  final _this = this as PodcastDownloadedEpisodesState;
  return Object.hash(runtimeType,_this.podcast,const DeepCollectionEquality().hash(_this.episodes));
}

@override
String toString() {
  final _this = this as PodcastDownloadedEpisodesState;
  return 'PodcastDownloadedEpisodesState(podcast: ${_this.podcast}, episodes: ${_this.episodes})';
}


}

/// @nodoc
abstract mixin class $PodcastDownloadedEpisodesStateCopyWith<$Res>  {
  factory $PodcastDownloadedEpisodesStateCopyWith(PodcastDownloadedEpisodesState value, $Res Function(PodcastDownloadedEpisodesState) _then) = _$PodcastDownloadedEpisodesStateCopyWithImpl;
@useResult
$Res call({
 Podcast? podcast, List<Episode> episodes
});


$PodcastCopyWith<$Res>? get podcast;

}
/// @nodoc
class _$PodcastDownloadedEpisodesStateCopyWithImpl<$Res>
    implements $PodcastDownloadedEpisodesStateCopyWith<$Res> {
  _$PodcastDownloadedEpisodesStateCopyWithImpl(this._self, this._then);

  final PodcastDownloadedEpisodesState _self;
  final $Res Function(PodcastDownloadedEpisodesState) _then;

/// Create a copy of PodcastDownloadedEpisodesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? podcast = freezed,Object? episodes = null,}) {
  return _then(PodcastDownloadedEpisodesState(
podcast: freezed == podcast ? _self.podcast : podcast // ignore: cast_nullable_to_non_nullable
as Podcast?,episodes: null == episodes ? _self.episodes : episodes // ignore: cast_nullable_to_non_nullable
as List<Episode>,
  ));
}
/// Create a copy of PodcastDownloadedEpisodesState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PodcastCopyWith<$Res>? get podcast {
    if (_self.podcast == null) {
    return null;
  }

  return $PodcastCopyWith<$Res>(_self.podcast!, (value) {
    return _then(_self.copyWith(podcast: value));
  });
}
}


/// Adds pattern-matching-related methods to [PodcastDownloadedEpisodesState].
extension PodcastDownloadedEpisodesStatePatterns on PodcastDownloadedEpisodesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PodcastDownloadedEpisodesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PodcastDownloadedEpisodesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PodcastDownloadedEpisodesState value)  $default,){
final _that = this;
switch (_that) {
case _PodcastDownloadedEpisodesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PodcastDownloadedEpisodesState value)?  $default,){
final _that = this;
switch (_that) {
case _PodcastDownloadedEpisodesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Podcast? podcast,  List<Episode> episodes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PodcastDownloadedEpisodesState() when $default != null:
return $default(_that.podcast,_that.episodes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Podcast? podcast,  List<Episode> episodes)  $default,) {final _that = this;
switch (_that) {
case _PodcastDownloadedEpisodesState():
return $default(_that.podcast,_that.episodes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Podcast? podcast,  List<Episode> episodes)?  $default,) {final _that = this;
switch (_that) {
case _PodcastDownloadedEpisodesState() when $default != null:
return $default(_that.podcast,_that.episodes);case _:
  return null;

}
}

}

/// @nodoc


class _PodcastDownloadedEpisodesState implements PodcastDownloadedEpisodesState {
  const _PodcastDownloadedEpisodesState({this.podcast,  List<Episode> episodes = const []}): _episodes = episodes;
  

@override final  Podcast? podcast;
 final  List<Episode> _episodes;
@override@JsonKey() List<Episode> get episodes {
  if (_episodes is EqualUnmodifiableListView) return _episodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_episodes);
}


/// Create a copy of PodcastDownloadedEpisodesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PodcastDownloadedEpisodesStateCopyWith<_PodcastDownloadedEpisodesState> get copyWith => __$PodcastDownloadedEpisodesStateCopyWithImpl<_PodcastDownloadedEpisodesState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PodcastDownloadedEpisodesState&&(identical(other.podcast, podcast) || other.podcast == podcast)&&const DeepCollectionEquality().equals(other.episodes, _episodes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,podcast,const DeepCollectionEquality().hash(_episodes));
}

@override
String toString() {
    return 'PodcastDownloadedEpisodesState(podcast: $podcast, episodes: $episodes)';
}


}

/// @nodoc
abstract mixin class _$PodcastDownloadedEpisodesStateCopyWith<$Res> implements $PodcastDownloadedEpisodesStateCopyWith<$Res> {
  factory _$PodcastDownloadedEpisodesStateCopyWith(_PodcastDownloadedEpisodesState value, $Res Function(_PodcastDownloadedEpisodesState) _then) = __$PodcastDownloadedEpisodesStateCopyWithImpl;
@override @useResult
$Res call({
 Podcast? podcast, List<Episode> episodes
});


@override $PodcastCopyWith<$Res>? get podcast;

}
/// @nodoc
class __$PodcastDownloadedEpisodesStateCopyWithImpl<$Res>
    implements _$PodcastDownloadedEpisodesStateCopyWith<$Res> {
  __$PodcastDownloadedEpisodesStateCopyWithImpl(this._self, this._then);

  final _PodcastDownloadedEpisodesState _self;
  final $Res Function(_PodcastDownloadedEpisodesState) _then;

/// Create a copy of PodcastDownloadedEpisodesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? podcast = freezed,Object? episodes = null,}) {
  return _then(_PodcastDownloadedEpisodesState(
podcast: freezed == podcast ? _self.podcast : podcast // ignore: cast_nullable_to_non_nullable
as Podcast?,episodes: null == episodes ? _self._episodes : episodes // ignore: cast_nullable_to_non_nullable
as List<Episode>,
  ));
}

/// Create a copy of PodcastDownloadedEpisodesState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PodcastCopyWith<$Res>? get podcast {
    if (_self.podcast == null) {
    return null;
  }

  return $PodcastCopyWith<$Res>(_self.podcast!, (value) {
    return _then(_self.copyWith(podcast: value));
  });
}
}

// dart format on
