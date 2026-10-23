// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'episode_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Episode {

@JsonKey(name: '_id') String get id; String get podcastId; String get title; String get description; DateTime? get publicationDate; String get audioUrl;@DurationConverter() Duration? get duration;
/// Create a copy of Episode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EpisodeCopyWith<Episode> get copyWith => _$EpisodeCopyWithImpl<Episode>(this as Episode, _$identity);

  /// Serializes this Episode to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Episode&&(identical(other.id, id) || other.id == id)&&(identical(other.podcastId, podcastId) || other.podcastId == podcastId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.publicationDate, publicationDate) || other.publicationDate == publicationDate)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&(identical(other.duration, duration) || other.duration == duration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,podcastId,title,description,publicationDate,audioUrl,duration);

@override
String toString() {
  return 'Episode(id: $id, podcastId: $podcastId, title: $title, description: $description, publicationDate: $publicationDate, audioUrl: $audioUrl, duration: $duration)';
}


}

/// @nodoc
abstract mixin class $EpisodeCopyWith<$Res>  {
  factory $EpisodeCopyWith(Episode value, $Res Function(Episode) _then) = _$EpisodeCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '_id') String id, String podcastId, String title, String description, DateTime? publicationDate, String audioUrl,@DurationConverter() Duration? duration
});




}
/// @nodoc
class _$EpisodeCopyWithImpl<$Res>
    implements $EpisodeCopyWith<$Res> {
  _$EpisodeCopyWithImpl(this._self, this._then);

  final Episode _self;
  final $Res Function(Episode) _then;

/// Create a copy of Episode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? podcastId = null,Object? title = null,Object? description = null,Object? publicationDate = freezed,Object? audioUrl = null,Object? duration = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,podcastId: null == podcastId ? _self.podcastId : podcastId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,publicationDate: freezed == publicationDate ? _self.publicationDate : publicationDate // ignore: cast_nullable_to_non_nullable
as DateTime?,audioUrl: null == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration?,
  ));
}

}


/// Adds pattern-matching-related methods to [Episode].
extension EpisodePatterns on Episode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Episode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Episode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Episode value)  $default,){
final _that = this;
switch (_that) {
case _Episode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Episode value)?  $default,){
final _that = this;
switch (_that) {
case _Episode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String podcastId,  String title,  String description,  DateTime? publicationDate,  String audioUrl, @DurationConverter()  Duration? duration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Episode() when $default != null:
return $default(_that.id,_that.podcastId,_that.title,_that.description,_that.publicationDate,_that.audioUrl,_that.duration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String podcastId,  String title,  String description,  DateTime? publicationDate,  String audioUrl, @DurationConverter()  Duration? duration)  $default,) {final _that = this;
switch (_that) {
case _Episode():
return $default(_that.id,_that.podcastId,_that.title,_that.description,_that.publicationDate,_that.audioUrl,_that.duration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '_id')  String id,  String podcastId,  String title,  String description,  DateTime? publicationDate,  String audioUrl, @DurationConverter()  Duration? duration)?  $default,) {final _that = this;
switch (_that) {
case _Episode() when $default != null:
return $default(_that.id,_that.podcastId,_that.title,_that.description,_that.publicationDate,_that.audioUrl,_that.duration);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Episode implements Episode {
  const _Episode({@JsonKey(name: '_id') required this.id, required this.podcastId, required this.title, this.description = '', this.publicationDate, required this.audioUrl, @DurationConverter() this.duration});
  factory _Episode.fromJson(Map<String, dynamic> json) => _$EpisodeFromJson(json);

@override@JsonKey(name: '_id') final  String id;
@override final  String podcastId;
@override final  String title;
@override@JsonKey() final  String description;
@override final  DateTime? publicationDate;
@override final  String audioUrl;
@override@DurationConverter() final  Duration? duration;

/// Create a copy of Episode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EpisodeCopyWith<_Episode> get copyWith => __$EpisodeCopyWithImpl<_Episode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EpisodeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Episode&&(identical(other.id, id) || other.id == id)&&(identical(other.podcastId, podcastId) || other.podcastId == podcastId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.publicationDate, publicationDate) || other.publicationDate == publicationDate)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&(identical(other.duration, duration) || other.duration == duration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,podcastId,title,description,publicationDate,audioUrl,duration);

@override
String toString() {
  return 'Episode(id: $id, podcastId: $podcastId, title: $title, description: $description, publicationDate: $publicationDate, audioUrl: $audioUrl, duration: $duration)';
}


}

/// @nodoc
abstract mixin class _$EpisodeCopyWith<$Res> implements $EpisodeCopyWith<$Res> {
  factory _$EpisodeCopyWith(_Episode value, $Res Function(_Episode) _then) = __$EpisodeCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '_id') String id, String podcastId, String title, String description, DateTime? publicationDate, String audioUrl,@DurationConverter() Duration? duration
});




}
/// @nodoc
class __$EpisodeCopyWithImpl<$Res>
    implements _$EpisodeCopyWith<$Res> {
  __$EpisodeCopyWithImpl(this._self, this._then);

  final _Episode _self;
  final $Res Function(_Episode) _then;

/// Create a copy of Episode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? podcastId = null,Object? title = null,Object? description = null,Object? publicationDate = freezed,Object? audioUrl = null,Object? duration = freezed,}) {
  return _then(_Episode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,podcastId: null == podcastId ? _self.podcastId : podcastId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,publicationDate: freezed == publicationDate ? _self.publicationDate : publicationDate // ignore: cast_nullable_to_non_nullable
as DateTime?,audioUrl: null == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration?,
  ));
}


}

// dart format on
