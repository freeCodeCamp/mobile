// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bookmarked_post_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookmarkedPost {

 String get id; String get title; String get authorName; String get text;
/// Create a copy of BookmarkedPost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookmarkedPostCopyWith<BookmarkedPost> get copyWith => _$BookmarkedPostCopyWithImpl<BookmarkedPost>(this as BookmarkedPost, _$identity);

  /// Serializes this BookmarkedPost to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookmarkedPost&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,authorName,text);

@override
String toString() {
  return 'BookmarkedPost(id: $id, title: $title, authorName: $authorName, text: $text)';
}


}

/// @nodoc
abstract mixin class $BookmarkedPostCopyWith<$Res>  {
  factory $BookmarkedPostCopyWith(BookmarkedPost value, $Res Function(BookmarkedPost) _then) = _$BookmarkedPostCopyWithImpl;
@useResult
$Res call({
 String id, String title, String authorName, String text
});




}
/// @nodoc
class _$BookmarkedPostCopyWithImpl<$Res>
    implements $BookmarkedPostCopyWith<$Res> {
  _$BookmarkedPostCopyWithImpl(this._self, this._then);

  final BookmarkedPost _self;
  final $Res Function(BookmarkedPost) _then;

/// Create a copy of BookmarkedPost
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? authorName = null,Object? text = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BookmarkedPost].
extension BookmarkedPostPatterns on BookmarkedPost {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookmarkedPost value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookmarkedPost() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookmarkedPost value)  $default,){
final _that = this;
switch (_that) {
case _BookmarkedPost():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookmarkedPost value)?  $default,){
final _that = this;
switch (_that) {
case _BookmarkedPost() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String authorName,  String text)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookmarkedPost() when $default != null:
return $default(_that.id,_that.title,_that.authorName,_that.text);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String authorName,  String text)  $default,) {final _that = this;
switch (_that) {
case _BookmarkedPost():
return $default(_that.id,_that.title,_that.authorName,_that.text);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String authorName,  String text)?  $default,) {final _that = this;
switch (_that) {
case _BookmarkedPost() when $default != null:
return $default(_that.id,_that.title,_that.authorName,_that.text);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookmarkedPost implements BookmarkedPost {
  const _BookmarkedPost({required this.id, required this.title, required this.authorName, required this.text});
  factory _BookmarkedPost.fromJson(Map<String, dynamic> json) => _$BookmarkedPostFromJson(json);

@override final  String id;
@override final  String title;
@override final  String authorName;
@override final  String text;

/// Create a copy of BookmarkedPost
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookmarkedPostCopyWith<_BookmarkedPost> get copyWith => __$BookmarkedPostCopyWithImpl<_BookmarkedPost>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookmarkedPostToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookmarkedPost&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,authorName,text);

@override
String toString() {
  return 'BookmarkedPost(id: $id, title: $title, authorName: $authorName, text: $text)';
}


}

/// @nodoc
abstract mixin class _$BookmarkedPostCopyWith<$Res> implements $BookmarkedPostCopyWith<$Res> {
  factory _$BookmarkedPostCopyWith(_BookmarkedPost value, $Res Function(_BookmarkedPost) _then) = __$BookmarkedPostCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String authorName, String text
});




}
/// @nodoc
class __$BookmarkedPostCopyWithImpl<$Res>
    implements _$BookmarkedPostCopyWith<$Res> {
  __$BookmarkedPostCopyWithImpl(this._self, this._then);

  final _BookmarkedPost _self;
  final $Res Function(_BookmarkedPost) _then;

/// Create a copy of BookmarkedPost
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? authorName = null,Object? text = null,}) {
  return _then(_BookmarkedPost(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
