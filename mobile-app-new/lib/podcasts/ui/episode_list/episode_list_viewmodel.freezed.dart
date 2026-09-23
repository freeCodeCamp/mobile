// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'episode_list_viewmodel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PodcastEpisodeSource {

 String get podcastId;
/// Create a copy of PodcastEpisodeSource
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PodcastEpisodeSourceCopyWith<PodcastEpisodeSource> get copyWith => _$PodcastEpisodeSourceCopyWithImpl<PodcastEpisodeSource>(this as PodcastEpisodeSource, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PodcastEpisodeSource&&(identical(other.podcastId, podcastId) || other.podcastId == podcastId));
}


@override
int get hashCode => Object.hash(runtimeType,podcastId);

@override
String toString() {
  return 'PodcastEpisodeSource(podcastId: $podcastId)';
}


}

/// @nodoc
abstract mixin class $PodcastEpisodeSourceCopyWith<$Res>  {
  factory $PodcastEpisodeSourceCopyWith(PodcastEpisodeSource value, $Res Function(PodcastEpisodeSource) _then) = _$PodcastEpisodeSourceCopyWithImpl;
@useResult
$Res call({
 String podcastId
});




}
/// @nodoc
class _$PodcastEpisodeSourceCopyWithImpl<$Res>
    implements $PodcastEpisodeSourceCopyWith<$Res> {
  _$PodcastEpisodeSourceCopyWithImpl(this._self, this._then);

  final PodcastEpisodeSource _self;
  final $Res Function(PodcastEpisodeSource) _then;

/// Create a copy of PodcastEpisodeSource
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? podcastId = null,}) {
  return _then(_self.copyWith(
podcastId: null == podcastId ? _self.podcastId : podcastId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PodcastEpisodeSource].
extension PodcastEpisodeSourcePatterns on PodcastEpisodeSource {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RemoteEpisodes value)?  remote,TResult Function( DownloadedEpisodes value)?  downloaded,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RemoteEpisodes() when remote != null:
return remote(_that);case DownloadedEpisodes() when downloaded != null:
return downloaded(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RemoteEpisodes value)  remote,required TResult Function( DownloadedEpisodes value)  downloaded,}){
final _that = this;
switch (_that) {
case RemoteEpisodes():
return remote(_that);case DownloadedEpisodes():
return downloaded(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RemoteEpisodes value)?  remote,TResult? Function( DownloadedEpisodes value)?  downloaded,}){
final _that = this;
switch (_that) {
case RemoteEpisodes() when remote != null:
return remote(_that);case DownloadedEpisodes() when downloaded != null:
return downloaded(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String podcastId)?  remote,TResult Function( String podcastId)?  downloaded,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RemoteEpisodes() when remote != null:
return remote(_that.podcastId);case DownloadedEpisodes() when downloaded != null:
return downloaded(_that.podcastId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String podcastId)  remote,required TResult Function( String podcastId)  downloaded,}) {final _that = this;
switch (_that) {
case RemoteEpisodes():
return remote(_that.podcastId);case DownloadedEpisodes():
return downloaded(_that.podcastId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String podcastId)?  remote,TResult? Function( String podcastId)?  downloaded,}) {final _that = this;
switch (_that) {
case RemoteEpisodes() when remote != null:
return remote(_that.podcastId);case DownloadedEpisodes() when downloaded != null:
return downloaded(_that.podcastId);case _:
  return null;

}
}

}

/// @nodoc


class RemoteEpisodes implements PodcastEpisodeSource {
  const RemoteEpisodes(this.podcastId);
  

@override final  String podcastId;

/// Create a copy of PodcastEpisodeSource
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoteEpisodesCopyWith<RemoteEpisodes> get copyWith => _$RemoteEpisodesCopyWithImpl<RemoteEpisodes>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteEpisodes&&(identical(other.podcastId, podcastId) || other.podcastId == podcastId));
}


@override
int get hashCode => Object.hash(runtimeType,podcastId);

@override
String toString() {
  return 'PodcastEpisodeSource.remote(podcastId: $podcastId)';
}


}

/// @nodoc
abstract mixin class $RemoteEpisodesCopyWith<$Res> implements $PodcastEpisodeSourceCopyWith<$Res> {
  factory $RemoteEpisodesCopyWith(RemoteEpisodes value, $Res Function(RemoteEpisodes) _then) = _$RemoteEpisodesCopyWithImpl;
@override @useResult
$Res call({
 String podcastId
});




}
/// @nodoc
class _$RemoteEpisodesCopyWithImpl<$Res>
    implements $RemoteEpisodesCopyWith<$Res> {
  _$RemoteEpisodesCopyWithImpl(this._self, this._then);

  final RemoteEpisodes _self;
  final $Res Function(RemoteEpisodes) _then;

/// Create a copy of PodcastEpisodeSource
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? podcastId = null,}) {
  return _then(RemoteEpisodes(
null == podcastId ? _self.podcastId : podcastId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class DownloadedEpisodes implements PodcastEpisodeSource {
  const DownloadedEpisodes(this.podcastId);
  

@override final  String podcastId;

/// Create a copy of PodcastEpisodeSource
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DownloadedEpisodesCopyWith<DownloadedEpisodes> get copyWith => _$DownloadedEpisodesCopyWithImpl<DownloadedEpisodes>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DownloadedEpisodes&&(identical(other.podcastId, podcastId) || other.podcastId == podcastId));
}


@override
int get hashCode => Object.hash(runtimeType,podcastId);

@override
String toString() {
  return 'PodcastEpisodeSource.downloaded(podcastId: $podcastId)';
}


}

/// @nodoc
abstract mixin class $DownloadedEpisodesCopyWith<$Res> implements $PodcastEpisodeSourceCopyWith<$Res> {
  factory $DownloadedEpisodesCopyWith(DownloadedEpisodes value, $Res Function(DownloadedEpisodes) _then) = _$DownloadedEpisodesCopyWithImpl;
@override @useResult
$Res call({
 String podcastId
});




}
/// @nodoc
class _$DownloadedEpisodesCopyWithImpl<$Res>
    implements $DownloadedEpisodesCopyWith<$Res> {
  _$DownloadedEpisodesCopyWithImpl(this._self, this._then);

  final DownloadedEpisodes _self;
  final $Res Function(DownloadedEpisodes) _then;

/// Create a copy of PodcastEpisodeSource
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? podcastId = null,}) {
  return _then(DownloadedEpisodes(
null == podcastId ? _self.podcastId : podcastId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$PodcastEpisodesState {

 Podcast get podcast; List<Episode> get episodes; int get page; bool get hasNextPage; bool get isLoadingMore; Object? get loadMoreError;
/// Create a copy of PodcastEpisodesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PodcastEpisodesStateCopyWith<PodcastEpisodesState> get copyWith => _$PodcastEpisodesStateCopyWithImpl<PodcastEpisodesState>(this as PodcastEpisodesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PodcastEpisodesState&&(identical(other.podcast, podcast) || other.podcast == podcast)&&const DeepCollectionEquality().equals(other.episodes, episodes)&&(identical(other.page, page) || other.page == page)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&const DeepCollectionEquality().equals(other.loadMoreError, loadMoreError));
}


@override
int get hashCode => Object.hash(runtimeType,podcast,const DeepCollectionEquality().hash(episodes),page,hasNextPage,isLoadingMore,const DeepCollectionEquality().hash(loadMoreError));

@override
String toString() {
  return 'PodcastEpisodesState(podcast: $podcast, episodes: $episodes, page: $page, hasNextPage: $hasNextPage, isLoadingMore: $isLoadingMore, loadMoreError: $loadMoreError)';
}


}

/// @nodoc
abstract mixin class $PodcastEpisodesStateCopyWith<$Res>  {
  factory $PodcastEpisodesStateCopyWith(PodcastEpisodesState value, $Res Function(PodcastEpisodesState) _then) = _$PodcastEpisodesStateCopyWithImpl;
@useResult
$Res call({
 Podcast podcast, List<Episode> episodes, int page, bool hasNextPage, bool isLoadingMore, Object? loadMoreError
});


$PodcastCopyWith<$Res> get podcast;

}
/// @nodoc
class _$PodcastEpisodesStateCopyWithImpl<$Res>
    implements $PodcastEpisodesStateCopyWith<$Res> {
  _$PodcastEpisodesStateCopyWithImpl(this._self, this._then);

  final PodcastEpisodesState _self;
  final $Res Function(PodcastEpisodesState) _then;

/// Create a copy of PodcastEpisodesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? podcast = null,Object? episodes = null,Object? page = null,Object? hasNextPage = null,Object? isLoadingMore = null,Object? loadMoreError = freezed,}) {
  return _then(_self.copyWith(
podcast: null == podcast ? _self.podcast : podcast // ignore: cast_nullable_to_non_nullable
as Podcast,episodes: null == episodes ? _self.episodes : episodes // ignore: cast_nullable_to_non_nullable
as List<Episode>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreError: freezed == loadMoreError ? _self.loadMoreError : loadMoreError ,
  ));
}
/// Create a copy of PodcastEpisodesState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PodcastCopyWith<$Res> get podcast {
  
  return $PodcastCopyWith<$Res>(_self.podcast, (value) {
    return _then(_self.copyWith(podcast: value));
  });
}
}


/// Adds pattern-matching-related methods to [PodcastEpisodesState].
extension PodcastEpisodesStatePatterns on PodcastEpisodesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PodcastEpisodesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PodcastEpisodesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PodcastEpisodesState value)  $default,){
final _that = this;
switch (_that) {
case _PodcastEpisodesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PodcastEpisodesState value)?  $default,){
final _that = this;
switch (_that) {
case _PodcastEpisodesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Podcast podcast,  List<Episode> episodes,  int page,  bool hasNextPage,  bool isLoadingMore,  Object? loadMoreError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PodcastEpisodesState() when $default != null:
return $default(_that.podcast,_that.episodes,_that.page,_that.hasNextPage,_that.isLoadingMore,_that.loadMoreError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Podcast podcast,  List<Episode> episodes,  int page,  bool hasNextPage,  bool isLoadingMore,  Object? loadMoreError)  $default,) {final _that = this;
switch (_that) {
case _PodcastEpisodesState():
return $default(_that.podcast,_that.episodes,_that.page,_that.hasNextPage,_that.isLoadingMore,_that.loadMoreError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Podcast podcast,  List<Episode> episodes,  int page,  bool hasNextPage,  bool isLoadingMore,  Object? loadMoreError)?  $default,) {final _that = this;
switch (_that) {
case _PodcastEpisodesState() when $default != null:
return $default(_that.podcast,_that.episodes,_that.page,_that.hasNextPage,_that.isLoadingMore,_that.loadMoreError);case _:
  return null;

}
}

}

/// @nodoc


class _PodcastEpisodesState implements PodcastEpisodesState {
  const _PodcastEpisodesState({required this.podcast, final  List<Episode> episodes = const [], this.page = 0, this.hasNextPage = false, this.isLoadingMore = false, this.loadMoreError}): _episodes = episodes;
  

@override final  Podcast podcast;
 final  List<Episode> _episodes;
@override@JsonKey() List<Episode> get episodes {
  if (_episodes is EqualUnmodifiableListView) return _episodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_episodes);
}

@override@JsonKey() final  int page;
@override@JsonKey() final  bool hasNextPage;
@override@JsonKey() final  bool isLoadingMore;
@override final  Object? loadMoreError;

/// Create a copy of PodcastEpisodesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PodcastEpisodesStateCopyWith<_PodcastEpisodesState> get copyWith => __$PodcastEpisodesStateCopyWithImpl<_PodcastEpisodesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PodcastEpisodesState&&(identical(other.podcast, podcast) || other.podcast == podcast)&&const DeepCollectionEquality().equals(other._episodes, _episodes)&&(identical(other.page, page) || other.page == page)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&const DeepCollectionEquality().equals(other.loadMoreError, loadMoreError));
}


@override
int get hashCode => Object.hash(runtimeType,podcast,const DeepCollectionEquality().hash(_episodes),page,hasNextPage,isLoadingMore,const DeepCollectionEquality().hash(loadMoreError));

@override
String toString() {
  return 'PodcastEpisodesState(podcast: $podcast, episodes: $episodes, page: $page, hasNextPage: $hasNextPage, isLoadingMore: $isLoadingMore, loadMoreError: $loadMoreError)';
}


}

/// @nodoc
abstract mixin class _$PodcastEpisodesStateCopyWith<$Res> implements $PodcastEpisodesStateCopyWith<$Res> {
  factory _$PodcastEpisodesStateCopyWith(_PodcastEpisodesState value, $Res Function(_PodcastEpisodesState) _then) = __$PodcastEpisodesStateCopyWithImpl;
@override @useResult
$Res call({
 Podcast podcast, List<Episode> episodes, int page, bool hasNextPage, bool isLoadingMore, Object? loadMoreError
});


@override $PodcastCopyWith<$Res> get podcast;

}
/// @nodoc
class __$PodcastEpisodesStateCopyWithImpl<$Res>
    implements _$PodcastEpisodesStateCopyWith<$Res> {
  __$PodcastEpisodesStateCopyWithImpl(this._self, this._then);

  final _PodcastEpisodesState _self;
  final $Res Function(_PodcastEpisodesState) _then;

/// Create a copy of PodcastEpisodesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? podcast = null,Object? episodes = null,Object? page = null,Object? hasNextPage = null,Object? isLoadingMore = null,Object? loadMoreError = freezed,}) {
  return _then(_PodcastEpisodesState(
podcast: null == podcast ? _self.podcast : podcast // ignore: cast_nullable_to_non_nullable
as Podcast,episodes: null == episodes ? _self._episodes : episodes // ignore: cast_nullable_to_non_nullable
as List<Episode>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreError: freezed == loadMoreError ? _self.loadMoreError : loadMoreError ,
  ));
}

/// Create a copy of PodcastEpisodesState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PodcastCopyWith<$Res> get podcast {
  
  return $PodcastCopyWith<$Res>(_self.podcast, (value) {
    return _then(_self.copyWith(podcast: value));
  });
}
}

// dart format on
