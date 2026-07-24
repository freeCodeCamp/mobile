// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tutorial_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Author {

 String get slug; String get id; String? get name; String? get profileImage; String? get bio; String? get website; String? get location; String? get facebook; String? get twitter;
/// Create a copy of Author
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthorCopyWith<Author> get copyWith => _$AuthorCopyWithImpl<Author>(this as Author, _$identity);

  /// Serializes this Author to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Author&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.profileImage, profileImage) || other.profileImage == profileImage)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.website, website) || other.website == website)&&(identical(other.location, location) || other.location == location)&&(identical(other.facebook, facebook) || other.facebook == facebook)&&(identical(other.twitter, twitter) || other.twitter == twitter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,slug,id,name,profileImage,bio,website,location,facebook,twitter);

@override
String toString() {
  return 'Author(slug: $slug, id: $id, name: $name, profileImage: $profileImage, bio: $bio, website: $website, location: $location, facebook: $facebook, twitter: $twitter)';
}


}

/// @nodoc
abstract mixin class $AuthorCopyWith<$Res>  {
  factory $AuthorCopyWith(Author value, $Res Function(Author) _then) = _$AuthorCopyWithImpl;
@useResult
$Res call({
 String slug, String id, String? name, String? profileImage, String? bio, String? website, String? location, String? facebook, String? twitter
});




}
/// @nodoc
class _$AuthorCopyWithImpl<$Res>
    implements $AuthorCopyWith<$Res> {
  _$AuthorCopyWithImpl(this._self, this._then);

  final Author _self;
  final $Res Function(Author) _then;

/// Create a copy of Author
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slug = null,Object? id = null,Object? name = freezed,Object? profileImage = freezed,Object? bio = freezed,Object? website = freezed,Object? location = freezed,Object? facebook = freezed,Object? twitter = freezed,}) {
  return _then(_self.copyWith(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,profileImage: freezed == profileImage ? _self.profileImage : profileImage // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,website: freezed == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,facebook: freezed == facebook ? _self.facebook : facebook // ignore: cast_nullable_to_non_nullable
as String?,twitter: freezed == twitter ? _self.twitter : twitter // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Author].
extension AuthorPatterns on Author {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Author value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Author() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Author value)  $default,){
final _that = this;
switch (_that) {
case _Author():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Author value)?  $default,){
final _that = this;
switch (_that) {
case _Author() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String slug,  String id,  String? name,  String? profileImage,  String? bio,  String? website,  String? location,  String? facebook,  String? twitter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Author() when $default != null:
return $default(_that.slug,_that.id,_that.name,_that.profileImage,_that.bio,_that.website,_that.location,_that.facebook,_that.twitter);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String slug,  String id,  String? name,  String? profileImage,  String? bio,  String? website,  String? location,  String? facebook,  String? twitter)  $default,) {final _that = this;
switch (_that) {
case _Author():
return $default(_that.slug,_that.id,_that.name,_that.profileImage,_that.bio,_that.website,_that.location,_that.facebook,_that.twitter);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String slug,  String id,  String? name,  String? profileImage,  String? bio,  String? website,  String? location,  String? facebook,  String? twitter)?  $default,) {final _that = this;
switch (_that) {
case _Author() when $default != null:
return $default(_that.slug,_that.id,_that.name,_that.profileImage,_that.bio,_that.website,_that.location,_that.facebook,_that.twitter);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Author implements Author {
  const _Author({required this.slug, required this.id, required this.name, required this.profileImage, required this.bio, this.website, this.location, this.facebook, this.twitter});
  factory _Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);

@override final  String slug;
@override final  String id;
@override final  String? name;
@override final  String? profileImage;
@override final  String? bio;
@override final  String? website;
@override final  String? location;
@override final  String? facebook;
@override final  String? twitter;

/// Create a copy of Author
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthorCopyWith<_Author> get copyWith => __$AuthorCopyWithImpl<_Author>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Author&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.profileImage, profileImage) || other.profileImage == profileImage)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.website, website) || other.website == website)&&(identical(other.location, location) || other.location == location)&&(identical(other.facebook, facebook) || other.facebook == facebook)&&(identical(other.twitter, twitter) || other.twitter == twitter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,slug,id,name,profileImage,bio,website,location,facebook,twitter);

@override
String toString() {
  return 'Author(slug: $slug, id: $id, name: $name, profileImage: $profileImage, bio: $bio, website: $website, location: $location, facebook: $facebook, twitter: $twitter)';
}


}

/// @nodoc
abstract mixin class _$AuthorCopyWith<$Res> implements $AuthorCopyWith<$Res> {
  factory _$AuthorCopyWith(_Author value, $Res Function(_Author) _then) = __$AuthorCopyWithImpl;
@override @useResult
$Res call({
 String slug, String id, String? name, String? profileImage, String? bio, String? website, String? location, String? facebook, String? twitter
});




}
/// @nodoc
class __$AuthorCopyWithImpl<$Res>
    implements _$AuthorCopyWith<$Res> {
  __$AuthorCopyWithImpl(this._self, this._then);

  final _Author _self;
  final $Res Function(_Author) _then;

/// Create a copy of Author
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slug = null,Object? id = null,Object? name = freezed,Object? profileImage = freezed,Object? bio = freezed,Object? website = freezed,Object? location = freezed,Object? facebook = freezed,Object? twitter = freezed,}) {
  return _then(_Author(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,profileImage: freezed == profileImage ? _self.profileImage : profileImage // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,website: freezed == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,facebook: freezed == facebook ? _self.facebook : facebook // ignore: cast_nullable_to_non_nullable
as String?,twitter: freezed == twitter ? _self.twitter : twitter // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
