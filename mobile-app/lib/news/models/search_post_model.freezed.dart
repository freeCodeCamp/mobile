// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_post_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchAuthor {

 String get name; String? get profileImage;
/// Create a copy of SearchAuthor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchAuthorCopyWith<SearchAuthor> get copyWith => _$SearchAuthorCopyWithImpl<SearchAuthor>(this as SearchAuthor, _$identity);

  /// Serializes this SearchAuthor to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchAuthor&&(identical(other.name, name) || other.name == name)&&(identical(other.profileImage, profileImage) || other.profileImage == profileImage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,profileImage);

@override
String toString() {
  return 'SearchAuthor(name: $name, profileImage: $profileImage)';
}


}

/// @nodoc
abstract mixin class $SearchAuthorCopyWith<$Res>  {
  factory $SearchAuthorCopyWith(SearchAuthor value, $Res Function(SearchAuthor) _then) = _$SearchAuthorCopyWithImpl;
@useResult
$Res call({
 String name, String? profileImage
});




}
/// @nodoc
class _$SearchAuthorCopyWithImpl<$Res>
    implements $SearchAuthorCopyWith<$Res> {
  _$SearchAuthorCopyWithImpl(this._self, this._then);

  final SearchAuthor _self;
  final $Res Function(SearchAuthor) _then;

/// Create a copy of SearchAuthor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? profileImage = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,profileImage: freezed == profileImage ? _self.profileImage : profileImage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchAuthor].
extension SearchAuthorPatterns on SearchAuthor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchAuthor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchAuthor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchAuthor value)  $default,){
final _that = this;
switch (_that) {
case _SearchAuthor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchAuthor value)?  $default,){
final _that = this;
switch (_that) {
case _SearchAuthor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? profileImage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchAuthor() when $default != null:
return $default(_that.name,_that.profileImage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? profileImage)  $default,) {final _that = this;
switch (_that) {
case _SearchAuthor():
return $default(_that.name,_that.profileImage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? profileImage)?  $default,) {final _that = this;
switch (_that) {
case _SearchAuthor() when $default != null:
return $default(_that.name,_that.profileImage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchAuthor implements SearchAuthor {
  const _SearchAuthor({required this.name, this.profileImage});
  factory _SearchAuthor.fromJson(Map<String, dynamic> json) => _$SearchAuthorFromJson(json);

@override final  String name;
@override final  String? profileImage;

/// Create a copy of SearchAuthor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchAuthorCopyWith<_SearchAuthor> get copyWith => __$SearchAuthorCopyWithImpl<_SearchAuthor>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchAuthorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchAuthor&&(identical(other.name, name) || other.name == name)&&(identical(other.profileImage, profileImage) || other.profileImage == profileImage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,profileImage);

@override
String toString() {
  return 'SearchAuthor(name: $name, profileImage: $profileImage)';
}


}

/// @nodoc
abstract mixin class _$SearchAuthorCopyWith<$Res> implements $SearchAuthorCopyWith<$Res> {
  factory _$SearchAuthorCopyWith(_SearchAuthor value, $Res Function(_SearchAuthor) _then) = __$SearchAuthorCopyWithImpl;
@override @useResult
$Res call({
 String name, String? profileImage
});




}
/// @nodoc
class __$SearchAuthorCopyWithImpl<$Res>
    implements _$SearchAuthorCopyWith<$Res> {
  __$SearchAuthorCopyWithImpl(this._self, this._then);

  final _SearchAuthor _self;
  final $Res Function(_SearchAuthor) _then;

/// Create a copy of SearchAuthor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? profileImage = freezed,}) {
  return _then(_SearchAuthor(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,profileImage: freezed == profileImage ? _self.profileImage : profileImage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SearchPost {

 String get objectID; String get title; String get url; SearchAuthor get author; String? get featureImage; String? get publishedAt;
/// Create a copy of SearchPost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchPostCopyWith<SearchPost> get copyWith => _$SearchPostCopyWithImpl<SearchPost>(this as SearchPost, _$identity);

  /// Serializes this SearchPost to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchPost&&(identical(other.objectID, objectID) || other.objectID == objectID)&&(identical(other.title, title) || other.title == title)&&(identical(other.url, url) || other.url == url)&&(identical(other.author, author) || other.author == author)&&(identical(other.featureImage, featureImage) || other.featureImage == featureImage)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,objectID,title,url,author,featureImage,publishedAt);

@override
String toString() {
  return 'SearchPost(objectID: $objectID, title: $title, url: $url, author: $author, featureImage: $featureImage, publishedAt: $publishedAt)';
}


}

/// @nodoc
abstract mixin class $SearchPostCopyWith<$Res>  {
  factory $SearchPostCopyWith(SearchPost value, $Res Function(SearchPost) _then) = _$SearchPostCopyWithImpl;
@useResult
$Res call({
 String objectID, String title, String url, SearchAuthor author, String? featureImage, String? publishedAt
});


$SearchAuthorCopyWith<$Res> get author;

}
/// @nodoc
class _$SearchPostCopyWithImpl<$Res>
    implements $SearchPostCopyWith<$Res> {
  _$SearchPostCopyWithImpl(this._self, this._then);

  final SearchPost _self;
  final $Res Function(SearchPost) _then;

/// Create a copy of SearchPost
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? objectID = null,Object? title = null,Object? url = null,Object? author = null,Object? featureImage = freezed,Object? publishedAt = freezed,}) {
  return _then(_self.copyWith(
objectID: null == objectID ? _self.objectID : objectID // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as SearchAuthor,featureImage: freezed == featureImage ? _self.featureImage : featureImage // ignore: cast_nullable_to_non_nullable
as String?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of SearchPost
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchAuthorCopyWith<$Res> get author {
  
  return $SearchAuthorCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}


/// Adds pattern-matching-related methods to [SearchPost].
extension SearchPostPatterns on SearchPost {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchPost value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchPost() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchPost value)  $default,){
final _that = this;
switch (_that) {
case _SearchPost():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchPost value)?  $default,){
final _that = this;
switch (_that) {
case _SearchPost() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String objectID,  String title,  String url,  SearchAuthor author,  String? featureImage,  String? publishedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchPost() when $default != null:
return $default(_that.objectID,_that.title,_that.url,_that.author,_that.featureImage,_that.publishedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String objectID,  String title,  String url,  SearchAuthor author,  String? featureImage,  String? publishedAt)  $default,) {final _that = this;
switch (_that) {
case _SearchPost():
return $default(_that.objectID,_that.title,_that.url,_that.author,_that.featureImage,_that.publishedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String objectID,  String title,  String url,  SearchAuthor author,  String? featureImage,  String? publishedAt)?  $default,) {final _that = this;
switch (_that) {
case _SearchPost() when $default != null:
return $default(_that.objectID,_that.title,_that.url,_that.author,_that.featureImage,_that.publishedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchPost extends SearchPost {
  const _SearchPost({required this.objectID, required this.title, required this.url, required this.author, this.featureImage, this.publishedAt}): super._();
  factory _SearchPost.fromJson(Map<String, dynamic> json) => _$SearchPostFromJson(json);

@override final  String objectID;
@override final  String title;
@override final  String url;
@override final  SearchAuthor author;
@override final  String? featureImage;
@override final  String? publishedAt;

/// Create a copy of SearchPost
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchPostCopyWith<_SearchPost> get copyWith => __$SearchPostCopyWithImpl<_SearchPost>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchPostToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchPost&&(identical(other.objectID, objectID) || other.objectID == objectID)&&(identical(other.title, title) || other.title == title)&&(identical(other.url, url) || other.url == url)&&(identical(other.author, author) || other.author == author)&&(identical(other.featureImage, featureImage) || other.featureImage == featureImage)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,objectID,title,url,author,featureImage,publishedAt);

@override
String toString() {
  return 'SearchPost(objectID: $objectID, title: $title, url: $url, author: $author, featureImage: $featureImage, publishedAt: $publishedAt)';
}


}

/// @nodoc
abstract mixin class _$SearchPostCopyWith<$Res> implements $SearchPostCopyWith<$Res> {
  factory _$SearchPostCopyWith(_SearchPost value, $Res Function(_SearchPost) _then) = __$SearchPostCopyWithImpl;
@override @useResult
$Res call({
 String objectID, String title, String url, SearchAuthor author, String? featureImage, String? publishedAt
});


@override $SearchAuthorCopyWith<$Res> get author;

}
/// @nodoc
class __$SearchPostCopyWithImpl<$Res>
    implements _$SearchPostCopyWith<$Res> {
  __$SearchPostCopyWithImpl(this._self, this._then);

  final _SearchPost _self;
  final $Res Function(_SearchPost) _then;

/// Create a copy of SearchPost
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? objectID = null,Object? title = null,Object? url = null,Object? author = null,Object? featureImage = freezed,Object? publishedAt = freezed,}) {
  return _then(_SearchPost(
objectID: null == objectID ? _self.objectID : objectID // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as SearchAuthor,featureImage: freezed == featureImage ? _self.featureImage : featureImage // ignore: cast_nullable_to_non_nullable
as String?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of SearchPost
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchAuthorCopyWith<$Res> get author {
  
  return $SearchAuthorCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}

// dart format on
