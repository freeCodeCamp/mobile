// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'podcast_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Podcast {

@JsonKey(name: '_id') String get id; String get feedUrl; String get podcastLink; String get title; String get description; String get imageLink; String get copyright; int get numOfEps;
/// Create a copy of Podcast
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PodcastCopyWith<Podcast> get copyWith => _$PodcastCopyWithImpl<Podcast>(this as Podcast, _$identity);

  /// Serializes this Podcast to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Podcast&&(identical(other.id, id) || other.id == id)&&(identical(other.feedUrl, feedUrl) || other.feedUrl == feedUrl)&&(identical(other.podcastLink, podcastLink) || other.podcastLink == podcastLink)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageLink, imageLink) || other.imageLink == imageLink)&&(identical(other.copyright, copyright) || other.copyright == copyright)&&(identical(other.numOfEps, numOfEps) || other.numOfEps == numOfEps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,feedUrl,podcastLink,title,description,imageLink,copyright,numOfEps);

@override
String toString() {
  return 'Podcast(id: $id, feedUrl: $feedUrl, podcastLink: $podcastLink, title: $title, description: $description, imageLink: $imageLink, copyright: $copyright, numOfEps: $numOfEps)';
}


}

/// @nodoc
abstract mixin class $PodcastCopyWith<$Res>  {
  factory $PodcastCopyWith(Podcast value, $Res Function(Podcast) _then) = _$PodcastCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '_id') String id, String feedUrl, String podcastLink, String title, String description, String imageLink, String copyright, int numOfEps
});




}
/// @nodoc
class _$PodcastCopyWithImpl<$Res>
    implements $PodcastCopyWith<$Res> {
  _$PodcastCopyWithImpl(this._self, this._then);

  final Podcast _self;
  final $Res Function(Podcast) _then;

/// Create a copy of Podcast
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? feedUrl = null,Object? podcastLink = null,Object? title = null,Object? description = null,Object? imageLink = null,Object? copyright = null,Object? numOfEps = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,feedUrl: null == feedUrl ? _self.feedUrl : feedUrl // ignore: cast_nullable_to_non_nullable
as String,podcastLink: null == podcastLink ? _self.podcastLink : podcastLink // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageLink: null == imageLink ? _self.imageLink : imageLink // ignore: cast_nullable_to_non_nullable
as String,copyright: null == copyright ? _self.copyright : copyright // ignore: cast_nullable_to_non_nullable
as String,numOfEps: null == numOfEps ? _self.numOfEps : numOfEps // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Podcast].
extension PodcastPatterns on Podcast {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Podcast value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Podcast() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Podcast value)  $default,){
final _that = this;
switch (_that) {
case _Podcast():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Podcast value)?  $default,){
final _that = this;
switch (_that) {
case _Podcast() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String feedUrl,  String podcastLink,  String title,  String description,  String imageLink,  String copyright,  int numOfEps)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Podcast() when $default != null:
return $default(_that.id,_that.feedUrl,_that.podcastLink,_that.title,_that.description,_that.imageLink,_that.copyright,_that.numOfEps);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String feedUrl,  String podcastLink,  String title,  String description,  String imageLink,  String copyright,  int numOfEps)  $default,) {final _that = this;
switch (_that) {
case _Podcast():
return $default(_that.id,_that.feedUrl,_that.podcastLink,_that.title,_that.description,_that.imageLink,_that.copyright,_that.numOfEps);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '_id')  String id,  String feedUrl,  String podcastLink,  String title,  String description,  String imageLink,  String copyright,  int numOfEps)?  $default,) {final _that = this;
switch (_that) {
case _Podcast() when $default != null:
return $default(_that.id,_that.feedUrl,_that.podcastLink,_that.title,_that.description,_that.imageLink,_that.copyright,_that.numOfEps);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Podcast implements Podcast {
  const _Podcast({@JsonKey(name: '_id') required this.id, required this.feedUrl, required this.podcastLink, required this.title, this.description = '', required this.imageLink, this.copyright = '', this.numOfEps = 0});
  factory _Podcast.fromJson(Map<String, dynamic> json) => _$PodcastFromJson(json);

@override@JsonKey(name: '_id') final  String id;
@override final  String feedUrl;
@override final  String podcastLink;
@override final  String title;
@override@JsonKey() final  String description;
@override final  String imageLink;
@override@JsonKey() final  String copyright;
@override@JsonKey() final  int numOfEps;

/// Create a copy of Podcast
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PodcastCopyWith<_Podcast> get copyWith => __$PodcastCopyWithImpl<_Podcast>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PodcastToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Podcast&&(identical(other.id, id) || other.id == id)&&(identical(other.feedUrl, feedUrl) || other.feedUrl == feedUrl)&&(identical(other.podcastLink, podcastLink) || other.podcastLink == podcastLink)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageLink, imageLink) || other.imageLink == imageLink)&&(identical(other.copyright, copyright) || other.copyright == copyright)&&(identical(other.numOfEps, numOfEps) || other.numOfEps == numOfEps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,feedUrl,podcastLink,title,description,imageLink,copyright,numOfEps);

@override
String toString() {
  return 'Podcast(id: $id, feedUrl: $feedUrl, podcastLink: $podcastLink, title: $title, description: $description, imageLink: $imageLink, copyright: $copyright, numOfEps: $numOfEps)';
}


}

/// @nodoc
abstract mixin class _$PodcastCopyWith<$Res> implements $PodcastCopyWith<$Res> {
  factory _$PodcastCopyWith(_Podcast value, $Res Function(_Podcast) _then) = __$PodcastCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '_id') String id, String feedUrl, String podcastLink, String title, String description, String imageLink, String copyright, int numOfEps
});




}
/// @nodoc
class __$PodcastCopyWithImpl<$Res>
    implements _$PodcastCopyWith<$Res> {
  __$PodcastCopyWithImpl(this._self, this._then);

  final _Podcast _self;
  final $Res Function(_Podcast) _then;

/// Create a copy of Podcast
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? feedUrl = null,Object? podcastLink = null,Object? title = null,Object? description = null,Object? imageLink = null,Object? copyright = null,Object? numOfEps = null,}) {
  return _then(_Podcast(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,feedUrl: null == feedUrl ? _self.feedUrl : feedUrl // ignore: cast_nullable_to_non_nullable
as String,podcastLink: null == podcastLink ? _self.podcastLink : podcastLink // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageLink: null == imageLink ? _self.imageLink : imageLink // ignore: cast_nullable_to_non_nullable
as String,copyright: null == copyright ? _self.copyright : copyright // ignore: cast_nullable_to_non_nullable
as String,numOfEps: null == numOfEps ? _self.numOfEps : numOfEps // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
