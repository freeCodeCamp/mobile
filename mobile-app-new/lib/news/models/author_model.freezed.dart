// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'author_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Bio {

 String get text;
/// Create a copy of Bio
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BioCopyWith<Bio> get copyWith => _$BioCopyWithImpl<Bio>(this as Bio, _$identity);

  /// Serializes this Bio to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Bio&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text);

@override
String toString() {
  return 'Bio(text: $text)';
}


}

/// @nodoc
abstract mixin class $BioCopyWith<$Res>  {
  factory $BioCopyWith(Bio value, $Res Function(Bio) _then) = _$BioCopyWithImpl;
@useResult
$Res call({
 String text
});




}
/// @nodoc
class _$BioCopyWithImpl<$Res>
    implements $BioCopyWith<$Res> {
  _$BioCopyWithImpl(this._self, this._then);

  final Bio _self;
  final $Res Function(Bio) _then;

/// Create a copy of Bio
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Bio].
extension BioPatterns on Bio {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Bio value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Bio() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Bio value)  $default,){
final _that = this;
switch (_that) {
case _Bio():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Bio value)?  $default,){
final _that = this;
switch (_that) {
case _Bio() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Bio() when $default != null:
return $default(_that.text);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text)  $default,) {final _that = this;
switch (_that) {
case _Bio():
return $default(_that.text);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text)?  $default,) {final _that = this;
switch (_that) {
case _Bio() when $default != null:
return $default(_that.text);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Bio implements Bio {
  const _Bio({required this.text});
  factory _Bio.fromJson(Map<String, dynamic> json) => _$BioFromJson(json);

@override final  String text;

/// Create a copy of Bio
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BioCopyWith<_Bio> get copyWith => __$BioCopyWithImpl<_Bio>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BioToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Bio&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text);

@override
String toString() {
  return 'Bio(text: $text)';
}


}

/// @nodoc
abstract mixin class _$BioCopyWith<$Res> implements $BioCopyWith<$Res> {
  factory _$BioCopyWith(_Bio value, $Res Function(_Bio) _then) = __$BioCopyWithImpl;
@override @useResult
$Res call({
 String text
});




}
/// @nodoc
class __$BioCopyWithImpl<$Res>
    implements _$BioCopyWith<$Res> {
  __$BioCopyWithImpl(this._self, this._then);

  final _Bio _self;
  final $Res Function(_Bio) _then;

/// Create a copy of Bio
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,}) {
  return _then(_Bio(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SocialMediaLinks {

 String? get website; String? get twitter; String? get facebook;
/// Create a copy of SocialMediaLinks
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SocialMediaLinksCopyWith<SocialMediaLinks> get copyWith => _$SocialMediaLinksCopyWithImpl<SocialMediaLinks>(this as SocialMediaLinks, _$identity);

  /// Serializes this SocialMediaLinks to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SocialMediaLinks&&(identical(other.website, website) || other.website == website)&&(identical(other.twitter, twitter) || other.twitter == twitter)&&(identical(other.facebook, facebook) || other.facebook == facebook));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,website,twitter,facebook);

@override
String toString() {
  return 'SocialMediaLinks(website: $website, twitter: $twitter, facebook: $facebook)';
}


}

/// @nodoc
abstract mixin class $SocialMediaLinksCopyWith<$Res>  {
  factory $SocialMediaLinksCopyWith(SocialMediaLinks value, $Res Function(SocialMediaLinks) _then) = _$SocialMediaLinksCopyWithImpl;
@useResult
$Res call({
 String? website, String? twitter, String? facebook
});




}
/// @nodoc
class _$SocialMediaLinksCopyWithImpl<$Res>
    implements $SocialMediaLinksCopyWith<$Res> {
  _$SocialMediaLinksCopyWithImpl(this._self, this._then);

  final SocialMediaLinks _self;
  final $Res Function(SocialMediaLinks) _then;

/// Create a copy of SocialMediaLinks
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? website = freezed,Object? twitter = freezed,Object? facebook = freezed,}) {
  return _then(_self.copyWith(
website: freezed == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String?,twitter: freezed == twitter ? _self.twitter : twitter // ignore: cast_nullable_to_non_nullable
as String?,facebook: freezed == facebook ? _self.facebook : facebook // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SocialMediaLinks].
extension SocialMediaLinksPatterns on SocialMediaLinks {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SocialMediaLinks value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SocialMediaLinks() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SocialMediaLinks value)  $default,){
final _that = this;
switch (_that) {
case _SocialMediaLinks():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SocialMediaLinks value)?  $default,){
final _that = this;
switch (_that) {
case _SocialMediaLinks() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? website,  String? twitter,  String? facebook)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SocialMediaLinks() when $default != null:
return $default(_that.website,_that.twitter,_that.facebook);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? website,  String? twitter,  String? facebook)  $default,) {final _that = this;
switch (_that) {
case _SocialMediaLinks():
return $default(_that.website,_that.twitter,_that.facebook);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? website,  String? twitter,  String? facebook)?  $default,) {final _that = this;
switch (_that) {
case _SocialMediaLinks() when $default != null:
return $default(_that.website,_that.twitter,_that.facebook);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SocialMediaLinks implements SocialMediaLinks {
  const _SocialMediaLinks({this.website, this.twitter, this.facebook});
  factory _SocialMediaLinks.fromJson(Map<String, dynamic> json) => _$SocialMediaLinksFromJson(json);

@override final  String? website;
@override final  String? twitter;
@override final  String? facebook;

/// Create a copy of SocialMediaLinks
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SocialMediaLinksCopyWith<_SocialMediaLinks> get copyWith => __$SocialMediaLinksCopyWithImpl<_SocialMediaLinks>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SocialMediaLinksToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SocialMediaLinks&&(identical(other.website, website) || other.website == website)&&(identical(other.twitter, twitter) || other.twitter == twitter)&&(identical(other.facebook, facebook) || other.facebook == facebook));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,website,twitter,facebook);

@override
String toString() {
  return 'SocialMediaLinks(website: $website, twitter: $twitter, facebook: $facebook)';
}


}

/// @nodoc
abstract mixin class _$SocialMediaLinksCopyWith<$Res> implements $SocialMediaLinksCopyWith<$Res> {
  factory _$SocialMediaLinksCopyWith(_SocialMediaLinks value, $Res Function(_SocialMediaLinks) _then) = __$SocialMediaLinksCopyWithImpl;
@override @useResult
$Res call({
 String? website, String? twitter, String? facebook
});




}
/// @nodoc
class __$SocialMediaLinksCopyWithImpl<$Res>
    implements _$SocialMediaLinksCopyWith<$Res> {
  __$SocialMediaLinksCopyWithImpl(this._self, this._then);

  final _SocialMediaLinks _self;
  final $Res Function(_SocialMediaLinks) _then;

/// Create a copy of SocialMediaLinks
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? website = freezed,Object? twitter = freezed,Object? facebook = freezed,}) {
  return _then(_SocialMediaLinks(
website: freezed == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String?,twitter: freezed == twitter ? _self.twitter : twitter // ignore: cast_nullable_to_non_nullable
as String?,facebook: freezed == facebook ? _self.facebook : facebook // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Author {

 String get username; String get id; String get name; String? get profilePicture; Bio? get bio; String? get location; SocialMediaLinks? get socialMediaLinks;
/// Create a copy of Author
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthorCopyWith<Author> get copyWith => _$AuthorCopyWithImpl<Author>(this as Author, _$identity);

  /// Serializes this Author to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Author&&(identical(other.username, username) || other.username == username)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.profilePicture, profilePicture) || other.profilePicture == profilePicture)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.location, location) || other.location == location)&&(identical(other.socialMediaLinks, socialMediaLinks) || other.socialMediaLinks == socialMediaLinks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,username,id,name,profilePicture,bio,location,socialMediaLinks);

@override
String toString() {
  return 'Author(username: $username, id: $id, name: $name, profilePicture: $profilePicture, bio: $bio, location: $location, socialMediaLinks: $socialMediaLinks)';
}


}

/// @nodoc
abstract mixin class $AuthorCopyWith<$Res>  {
  factory $AuthorCopyWith(Author value, $Res Function(Author) _then) = _$AuthorCopyWithImpl;
@useResult
$Res call({
 String username, String id, String name, String? profilePicture, Bio? bio, String? location, SocialMediaLinks? socialMediaLinks
});


$BioCopyWith<$Res>? get bio;$SocialMediaLinksCopyWith<$Res>? get socialMediaLinks;

}
/// @nodoc
class _$AuthorCopyWithImpl<$Res>
    implements $AuthorCopyWith<$Res> {
  _$AuthorCopyWithImpl(this._self, this._then);

  final Author _self;
  final $Res Function(Author) _then;

/// Create a copy of Author
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? username = null,Object? id = null,Object? name = null,Object? profilePicture = freezed,Object? bio = freezed,Object? location = freezed,Object? socialMediaLinks = freezed,}) {
  return _then(_self.copyWith(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,profilePicture: freezed == profilePicture ? _self.profilePicture : profilePicture // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as Bio?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,socialMediaLinks: freezed == socialMediaLinks ? _self.socialMediaLinks : socialMediaLinks // ignore: cast_nullable_to_non_nullable
as SocialMediaLinks?,
  ));
}
/// Create a copy of Author
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BioCopyWith<$Res>? get bio {
    if (_self.bio == null) {
    return null;
  }

  return $BioCopyWith<$Res>(_self.bio!, (value) {
    return _then(_self.copyWith(bio: value));
  });
}/// Create a copy of Author
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SocialMediaLinksCopyWith<$Res>? get socialMediaLinks {
    if (_self.socialMediaLinks == null) {
    return null;
  }

  return $SocialMediaLinksCopyWith<$Res>(_self.socialMediaLinks!, (value) {
    return _then(_self.copyWith(socialMediaLinks: value));
  });
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String username,  String id,  String name,  String? profilePicture,  Bio? bio,  String? location,  SocialMediaLinks? socialMediaLinks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Author() when $default != null:
return $default(_that.username,_that.id,_that.name,_that.profilePicture,_that.bio,_that.location,_that.socialMediaLinks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String username,  String id,  String name,  String? profilePicture,  Bio? bio,  String? location,  SocialMediaLinks? socialMediaLinks)  $default,) {final _that = this;
switch (_that) {
case _Author():
return $default(_that.username,_that.id,_that.name,_that.profilePicture,_that.bio,_that.location,_that.socialMediaLinks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String username,  String id,  String name,  String? profilePicture,  Bio? bio,  String? location,  SocialMediaLinks? socialMediaLinks)?  $default,) {final _that = this;
switch (_that) {
case _Author() when $default != null:
return $default(_that.username,_that.id,_that.name,_that.profilePicture,_that.bio,_that.location,_that.socialMediaLinks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Author implements Author {
  const _Author({required this.username, required this.id, required this.name, this.profilePicture, this.bio, this.location, this.socialMediaLinks});
  factory _Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);

@override final  String username;
@override final  String id;
@override final  String name;
@override final  String? profilePicture;
@override final  Bio? bio;
@override final  String? location;
@override final  SocialMediaLinks? socialMediaLinks;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Author&&(identical(other.username, username) || other.username == username)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.profilePicture, profilePicture) || other.profilePicture == profilePicture)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.location, location) || other.location == location)&&(identical(other.socialMediaLinks, socialMediaLinks) || other.socialMediaLinks == socialMediaLinks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,username,id,name,profilePicture,bio,location,socialMediaLinks);

@override
String toString() {
  return 'Author(username: $username, id: $id, name: $name, profilePicture: $profilePicture, bio: $bio, location: $location, socialMediaLinks: $socialMediaLinks)';
}


}

/// @nodoc
abstract mixin class _$AuthorCopyWith<$Res> implements $AuthorCopyWith<$Res> {
  factory _$AuthorCopyWith(_Author value, $Res Function(_Author) _then) = __$AuthorCopyWithImpl;
@override @useResult
$Res call({
 String username, String id, String name, String? profilePicture, Bio? bio, String? location, SocialMediaLinks? socialMediaLinks
});


@override $BioCopyWith<$Res>? get bio;@override $SocialMediaLinksCopyWith<$Res>? get socialMediaLinks;

}
/// @nodoc
class __$AuthorCopyWithImpl<$Res>
    implements _$AuthorCopyWith<$Res> {
  __$AuthorCopyWithImpl(this._self, this._then);

  final _Author _self;
  final $Res Function(_Author) _then;

/// Create a copy of Author
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? username = null,Object? id = null,Object? name = null,Object? profilePicture = freezed,Object? bio = freezed,Object? location = freezed,Object? socialMediaLinks = freezed,}) {
  return _then(_Author(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,profilePicture: freezed == profilePicture ? _self.profilePicture : profilePicture // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as Bio?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,socialMediaLinks: freezed == socialMediaLinks ? _self.socialMediaLinks : socialMediaLinks // ignore: cast_nullable_to_non_nullable
as SocialMediaLinks?,
  ));
}

/// Create a copy of Author
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BioCopyWith<$Res>? get bio {
    if (_self.bio == null) {
    return null;
  }

  return $BioCopyWith<$Res>(_self.bio!, (value) {
    return _then(_self.copyWith(bio: value));
  });
}/// Create a copy of Author
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SocialMediaLinksCopyWith<$Res>? get socialMediaLinks {
    if (_self.socialMediaLinks == null) {
    return null;
  }

  return $SocialMediaLinksCopyWith<$Res>(_self.socialMediaLinks!, (value) {
    return _then(_self.copyWith(socialMediaLinks: value));
  });
}
}

// dart format on
