// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PostSummary {

 String get id; String get slug; String get title; Author get author; List<Tag> get tags; CoverImage? get coverImage; int get readTimeInMinutes; String get publishedAt;
/// Create a copy of PostSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostSummaryCopyWith<PostSummary> get copyWith => _$PostSummaryCopyWithImpl<PostSummary>(this as PostSummary, _$identity);

  /// Serializes this PostSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.coverImage, coverImage) || other.coverImage == coverImage)&&(identical(other.readTimeInMinutes, readTimeInMinutes) || other.readTimeInMinutes == readTimeInMinutes)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,title,author,const DeepCollectionEquality().hash(tags),coverImage,readTimeInMinutes,publishedAt);

@override
String toString() {
  return 'PostSummary(id: $id, slug: $slug, title: $title, author: $author, tags: $tags, coverImage: $coverImage, readTimeInMinutes: $readTimeInMinutes, publishedAt: $publishedAt)';
}


}

/// @nodoc
abstract mixin class $PostSummaryCopyWith<$Res>  {
  factory $PostSummaryCopyWith(PostSummary value, $Res Function(PostSummary) _then) = _$PostSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String slug, String title, Author author, List<Tag> tags, CoverImage? coverImage, int readTimeInMinutes, String publishedAt
});


$AuthorCopyWith<$Res> get author;$CoverImageCopyWith<$Res>? get coverImage;

}
/// @nodoc
class _$PostSummaryCopyWithImpl<$Res>
    implements $PostSummaryCopyWith<$Res> {
  _$PostSummaryCopyWithImpl(this._self, this._then);

  final PostSummary _self;
  final $Res Function(PostSummary) _then;

/// Create a copy of PostSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? title = null,Object? author = null,Object? tags = null,Object? coverImage = freezed,Object? readTimeInMinutes = null,Object? publishedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as Author,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<Tag>,coverImage: freezed == coverImage ? _self.coverImage : coverImage // ignore: cast_nullable_to_non_nullable
as CoverImage?,readTimeInMinutes: null == readTimeInMinutes ? _self.readTimeInMinutes : readTimeInMinutes // ignore: cast_nullable_to_non_nullable
as int,publishedAt: null == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of PostSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthorCopyWith<$Res> get author {
  
  return $AuthorCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}/// Create a copy of PostSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoverImageCopyWith<$Res>? get coverImage {
    if (_self.coverImage == null) {
    return null;
  }

  return $CoverImageCopyWith<$Res>(_self.coverImage!, (value) {
    return _then(_self.copyWith(coverImage: value));
  });
}
}


/// Adds pattern-matching-related methods to [PostSummary].
extension PostSummaryPatterns on PostSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostSummary value)  $default,){
final _that = this;
switch (_that) {
case _PostSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostSummary value)?  $default,){
final _that = this;
switch (_that) {
case _PostSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slug,  String title,  Author author,  List<Tag> tags,  CoverImage? coverImage,  int readTimeInMinutes,  String publishedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostSummary() when $default != null:
return $default(_that.id,_that.slug,_that.title,_that.author,_that.tags,_that.coverImage,_that.readTimeInMinutes,_that.publishedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slug,  String title,  Author author,  List<Tag> tags,  CoverImage? coverImage,  int readTimeInMinutes,  String publishedAt)  $default,) {final _that = this;
switch (_that) {
case _PostSummary():
return $default(_that.id,_that.slug,_that.title,_that.author,_that.tags,_that.coverImage,_that.readTimeInMinutes,_that.publishedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slug,  String title,  Author author,  List<Tag> tags,  CoverImage? coverImage,  int readTimeInMinutes,  String publishedAt)?  $default,) {final _that = this;
switch (_that) {
case _PostSummary() when $default != null:
return $default(_that.id,_that.slug,_that.title,_that.author,_that.tags,_that.coverImage,_that.readTimeInMinutes,_that.publishedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostSummary implements PostSummary {
  const _PostSummary({required this.id, required this.slug, required this.title, required this.author, final  List<Tag> tags = const [], this.coverImage, required this.readTimeInMinutes, required this.publishedAt}): _tags = tags;
  factory _PostSummary.fromJson(Map<String, dynamic> json) => _$PostSummaryFromJson(json);

@override final  String id;
@override final  String slug;
@override final  String title;
@override final  Author author;
 final  List<Tag> _tags;
@override@JsonKey() List<Tag> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  CoverImage? coverImage;
@override final  int readTimeInMinutes;
@override final  String publishedAt;

/// Create a copy of PostSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostSummaryCopyWith<_PostSummary> get copyWith => __$PostSummaryCopyWithImpl<_PostSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.coverImage, coverImage) || other.coverImage == coverImage)&&(identical(other.readTimeInMinutes, readTimeInMinutes) || other.readTimeInMinutes == readTimeInMinutes)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,title,author,const DeepCollectionEquality().hash(_tags),coverImage,readTimeInMinutes,publishedAt);

@override
String toString() {
  return 'PostSummary(id: $id, slug: $slug, title: $title, author: $author, tags: $tags, coverImage: $coverImage, readTimeInMinutes: $readTimeInMinutes, publishedAt: $publishedAt)';
}


}

/// @nodoc
abstract mixin class _$PostSummaryCopyWith<$Res> implements $PostSummaryCopyWith<$Res> {
  factory _$PostSummaryCopyWith(_PostSummary value, $Res Function(_PostSummary) _then) = __$PostSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String slug, String title, Author author, List<Tag> tags, CoverImage? coverImage, int readTimeInMinutes, String publishedAt
});


@override $AuthorCopyWith<$Res> get author;@override $CoverImageCopyWith<$Res>? get coverImage;

}
/// @nodoc
class __$PostSummaryCopyWithImpl<$Res>
    implements _$PostSummaryCopyWith<$Res> {
  __$PostSummaryCopyWithImpl(this._self, this._then);

  final _PostSummary _self;
  final $Res Function(_PostSummary) _then;

/// Create a copy of PostSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? title = null,Object? author = null,Object? tags = null,Object? coverImage = freezed,Object? readTimeInMinutes = null,Object? publishedAt = null,}) {
  return _then(_PostSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as Author,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<Tag>,coverImage: freezed == coverImage ? _self.coverImage : coverImage // ignore: cast_nullable_to_non_nullable
as CoverImage?,readTimeInMinutes: null == readTimeInMinutes ? _self.readTimeInMinutes : readTimeInMinutes // ignore: cast_nullable_to_non_nullable
as int,publishedAt: null == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of PostSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthorCopyWith<$Res> get author {
  
  return $AuthorCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}/// Create a copy of PostSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoverImageCopyWith<$Res>? get coverImage {
    if (_self.coverImage == null) {
    return null;
  }

  return $CoverImageCopyWith<$Res>(_self.coverImage!, (value) {
    return _then(_self.copyWith(coverImage: value));
  });
}
}

// dart format on
