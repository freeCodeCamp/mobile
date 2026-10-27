// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_visibility_viewmodel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileVisibilityState {

 FccUserModel get original; ProfileUI get draft; bool get saving; bool get needsRefresh; String? get error;
/// Create a copy of ProfileVisibilityState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileVisibilityStateCopyWith<ProfileVisibilityState> get copyWith => _$ProfileVisibilityStateCopyWithImpl<ProfileVisibilityState>(this as ProfileVisibilityState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileVisibilityState&&(identical(other.original, original) || other.original == original)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.needsRefresh, needsRefresh) || other.needsRefresh == needsRefresh)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,original,draft,saving,needsRefresh,error);

@override
String toString() {
  return 'ProfileVisibilityState(original: $original, draft: $draft, saving: $saving, needsRefresh: $needsRefresh, error: $error)';
}


}

/// @nodoc
abstract mixin class $ProfileVisibilityStateCopyWith<$Res>  {
  factory $ProfileVisibilityStateCopyWith(ProfileVisibilityState value, $Res Function(ProfileVisibilityState) _then) = _$ProfileVisibilityStateCopyWithImpl;
@useResult
$Res call({
 FccUserModel original, ProfileUI draft, bool saving, bool needsRefresh, String? error
});


$FccUserModelCopyWith<$Res> get original;$ProfileUICopyWith<$Res> get draft;

}
/// @nodoc
class _$ProfileVisibilityStateCopyWithImpl<$Res>
    implements $ProfileVisibilityStateCopyWith<$Res> {
  _$ProfileVisibilityStateCopyWithImpl(this._self, this._then);

  final ProfileVisibilityState _self;
  final $Res Function(ProfileVisibilityState) _then;

/// Create a copy of ProfileVisibilityState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? original = null,Object? draft = null,Object? saving = null,Object? needsRefresh = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
original: null == original ? _self.original : original // ignore: cast_nullable_to_non_nullable
as FccUserModel,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as ProfileUI,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,needsRefresh: null == needsRefresh ? _self.needsRefresh : needsRefresh // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ProfileVisibilityState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FccUserModelCopyWith<$Res> get original {
  
  return $FccUserModelCopyWith<$Res>(_self.original, (value) {
    return _then(_self.copyWith(original: value));
  });
}/// Create a copy of ProfileVisibilityState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileUICopyWith<$Res> get draft {
  
  return $ProfileUICopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProfileVisibilityState].
extension ProfileVisibilityStatePatterns on ProfileVisibilityState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileVisibilityState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileVisibilityState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileVisibilityState value)  $default,){
final _that = this;
switch (_that) {
case _ProfileVisibilityState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileVisibilityState value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileVisibilityState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FccUserModel original,  ProfileUI draft,  bool saving,  bool needsRefresh,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileVisibilityState() when $default != null:
return $default(_that.original,_that.draft,_that.saving,_that.needsRefresh,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FccUserModel original,  ProfileUI draft,  bool saving,  bool needsRefresh,  String? error)  $default,) {final _that = this;
switch (_that) {
case _ProfileVisibilityState():
return $default(_that.original,_that.draft,_that.saving,_that.needsRefresh,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FccUserModel original,  ProfileUI draft,  bool saving,  bool needsRefresh,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _ProfileVisibilityState() when $default != null:
return $default(_that.original,_that.draft,_that.saving,_that.needsRefresh,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileVisibilityState extends ProfileVisibilityState {
  const _ProfileVisibilityState({required this.original, required this.draft, this.saving = false, this.needsRefresh = false, this.error}): super._();
  

@override final  FccUserModel original;
@override final  ProfileUI draft;
@override@JsonKey() final  bool saving;
@override@JsonKey() final  bool needsRefresh;
@override final  String? error;

/// Create a copy of ProfileVisibilityState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileVisibilityStateCopyWith<_ProfileVisibilityState> get copyWith => __$ProfileVisibilityStateCopyWithImpl<_ProfileVisibilityState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileVisibilityState&&(identical(other.original, original) || other.original == original)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.needsRefresh, needsRefresh) || other.needsRefresh == needsRefresh)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,original,draft,saving,needsRefresh,error);

@override
String toString() {
  return 'ProfileVisibilityState(original: $original, draft: $draft, saving: $saving, needsRefresh: $needsRefresh, error: $error)';
}


}

/// @nodoc
abstract mixin class _$ProfileVisibilityStateCopyWith<$Res> implements $ProfileVisibilityStateCopyWith<$Res> {
  factory _$ProfileVisibilityStateCopyWith(_ProfileVisibilityState value, $Res Function(_ProfileVisibilityState) _then) = __$ProfileVisibilityStateCopyWithImpl;
@override @useResult
$Res call({
 FccUserModel original, ProfileUI draft, bool saving, bool needsRefresh, String? error
});


@override $FccUserModelCopyWith<$Res> get original;@override $ProfileUICopyWith<$Res> get draft;

}
/// @nodoc
class __$ProfileVisibilityStateCopyWithImpl<$Res>
    implements _$ProfileVisibilityStateCopyWith<$Res> {
  __$ProfileVisibilityStateCopyWithImpl(this._self, this._then);

  final _ProfileVisibilityState _self;
  final $Res Function(_ProfileVisibilityState) _then;

/// Create a copy of ProfileVisibilityState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? original = null,Object? draft = null,Object? saving = null,Object? needsRefresh = null,Object? error = freezed,}) {
  return _then(_ProfileVisibilityState(
original: null == original ? _self.original : original // ignore: cast_nullable_to_non_nullable
as FccUserModel,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as ProfileUI,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,needsRefresh: null == needsRefresh ? _self.needsRefresh : needsRefresh // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ProfileVisibilityState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FccUserModelCopyWith<$Res> get original {
  
  return $FccUserModelCopyWith<$Res>(_self.original, (value) {
    return _then(_self.copyWith(original: value));
  });
}/// Create a copy of ProfileVisibilityState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileUICopyWith<$Res> get draft {
  
  return $ProfileUICopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}

// dart format on
