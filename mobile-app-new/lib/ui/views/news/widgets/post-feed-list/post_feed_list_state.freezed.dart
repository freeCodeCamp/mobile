// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_feed_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NewsFeedState {

 List<Post> get posts; String get cursor; bool get hasNextPage; bool get isLoadingMore; Object? get loadMoreError;
/// Create a copy of NewsFeedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NewsFeedStateCopyWith<NewsFeedState> get copyWith => _$NewsFeedStateCopyWithImpl<NewsFeedState>(this as NewsFeedState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewsFeedState&&const DeepCollectionEquality().equals(other.posts, posts)&&(identical(other.cursor, cursor) || other.cursor == cursor)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&const DeepCollectionEquality().equals(other.loadMoreError, loadMoreError));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(posts),cursor,hasNextPage,isLoadingMore,const DeepCollectionEquality().hash(loadMoreError));

@override
String toString() {
  return 'NewsFeedState(posts: $posts, cursor: $cursor, hasNextPage: $hasNextPage, isLoadingMore: $isLoadingMore, loadMoreError: $loadMoreError)';
}


}

/// @nodoc
abstract mixin class $NewsFeedStateCopyWith<$Res>  {
  factory $NewsFeedStateCopyWith(NewsFeedState value, $Res Function(NewsFeedState) _then) = _$NewsFeedStateCopyWithImpl;
@useResult
$Res call({
 List<Post> posts, String cursor, bool hasNextPage, bool isLoadingMore, Object? loadMoreError
});




}
/// @nodoc
class _$NewsFeedStateCopyWithImpl<$Res>
    implements $NewsFeedStateCopyWith<$Res> {
  _$NewsFeedStateCopyWithImpl(this._self, this._then);

  final NewsFeedState _self;
  final $Res Function(NewsFeedState) _then;

/// Create a copy of NewsFeedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? posts = null,Object? cursor = null,Object? hasNextPage = null,Object? isLoadingMore = null,Object? loadMoreError = freezed,}) {
  return _then(_self.copyWith(
posts: null == posts ? _self.posts : posts // ignore: cast_nullable_to_non_nullable
as List<Post>,cursor: null == cursor ? _self.cursor : cursor // ignore: cast_nullable_to_non_nullable
as String,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreError: freezed == loadMoreError ? _self.loadMoreError : loadMoreError ,
  ));
}

}


/// Adds pattern-matching-related methods to [NewsFeedState].
extension NewsFeedStatePatterns on NewsFeedState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NewsFeedState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NewsFeedState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NewsFeedState value)  $default,){
final _that = this;
switch (_that) {
case _NewsFeedState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NewsFeedState value)?  $default,){
final _that = this;
switch (_that) {
case _NewsFeedState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Post> posts,  String cursor,  bool hasNextPage,  bool isLoadingMore,  Object? loadMoreError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NewsFeedState() when $default != null:
return $default(_that.posts,_that.cursor,_that.hasNextPage,_that.isLoadingMore,_that.loadMoreError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Post> posts,  String cursor,  bool hasNextPage,  bool isLoadingMore,  Object? loadMoreError)  $default,) {final _that = this;
switch (_that) {
case _NewsFeedState():
return $default(_that.posts,_that.cursor,_that.hasNextPage,_that.isLoadingMore,_that.loadMoreError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Post> posts,  String cursor,  bool hasNextPage,  bool isLoadingMore,  Object? loadMoreError)?  $default,) {final _that = this;
switch (_that) {
case _NewsFeedState() when $default != null:
return $default(_that.posts,_that.cursor,_that.hasNextPage,_that.isLoadingMore,_that.loadMoreError);case _:
  return null;

}
}

}

/// @nodoc


class _NewsFeedState implements NewsFeedState {
  const _NewsFeedState({final  List<Post> posts = const [], this.cursor = '', this.hasNextPage = true, this.isLoadingMore = false, this.loadMoreError}): _posts = posts;
  

 final  List<Post> _posts;
@override@JsonKey() List<Post> get posts {
  if (_posts is EqualUnmodifiableListView) return _posts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_posts);
}

@override@JsonKey() final  String cursor;
@override@JsonKey() final  bool hasNextPage;
@override@JsonKey() final  bool isLoadingMore;
@override final  Object? loadMoreError;

/// Create a copy of NewsFeedState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NewsFeedStateCopyWith<_NewsFeedState> get copyWith => __$NewsFeedStateCopyWithImpl<_NewsFeedState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NewsFeedState&&const DeepCollectionEquality().equals(other._posts, _posts)&&(identical(other.cursor, cursor) || other.cursor == cursor)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&const DeepCollectionEquality().equals(other.loadMoreError, loadMoreError));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_posts),cursor,hasNextPage,isLoadingMore,const DeepCollectionEquality().hash(loadMoreError));

@override
String toString() {
  return 'NewsFeedState(posts: $posts, cursor: $cursor, hasNextPage: $hasNextPage, isLoadingMore: $isLoadingMore, loadMoreError: $loadMoreError)';
}


}

/// @nodoc
abstract mixin class _$NewsFeedStateCopyWith<$Res> implements $NewsFeedStateCopyWith<$Res> {
  factory _$NewsFeedStateCopyWith(_NewsFeedState value, $Res Function(_NewsFeedState) _then) = __$NewsFeedStateCopyWithImpl;
@override @useResult
$Res call({
 List<Post> posts, String cursor, bool hasNextPage, bool isLoadingMore, Object? loadMoreError
});




}
/// @nodoc
class __$NewsFeedStateCopyWithImpl<$Res>
    implements _$NewsFeedStateCopyWith<$Res> {
  __$NewsFeedStateCopyWithImpl(this._self, this._then);

  final _NewsFeedState _self;
  final $Res Function(_NewsFeedState) _then;

/// Create a copy of NewsFeedState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? posts = null,Object? cursor = null,Object? hasNextPage = null,Object? isLoadingMore = null,Object? loadMoreError = freezed,}) {
  return _then(_NewsFeedState(
posts: null == posts ? _self._posts : posts // ignore: cast_nullable_to_non_nullable
as List<Post>,cursor: null == cursor ? _self.cursor : cursor // ignore: cast_nullable_to_non_nullable
as String,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreError: freezed == loadMoreError ? _self.loadMoreError : loadMoreError ,
  ));
}


}

// dart format on
