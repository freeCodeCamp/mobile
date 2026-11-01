// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_editor_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileEditorState {

 FccUserModel get original; FccUserModel get draft; bool get saving; Map<String, String> get errors; String? get errorMessage; bool get needsRefresh; bool get usernameChecking; bool? get usernameAvailable;
/// Create a copy of ProfileEditorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileEditorStateCopyWith<ProfileEditorState> get copyWith => _$ProfileEditorStateCopyWithImpl<ProfileEditorState>(this as ProfileEditorState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileEditorState&&(identical(other.original, original) || other.original == original)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.saving, saving) || other.saving == saving)&&const DeepCollectionEquality().equals(other.errors, errors)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.needsRefresh, needsRefresh) || other.needsRefresh == needsRefresh)&&(identical(other.usernameChecking, usernameChecking) || other.usernameChecking == usernameChecking)&&(identical(other.usernameAvailable, usernameAvailable) || other.usernameAvailable == usernameAvailable));
}


@override
int get hashCode => Object.hash(runtimeType,original,draft,saving,const DeepCollectionEquality().hash(errors),errorMessage,needsRefresh,usernameChecking,usernameAvailable);

@override
String toString() {
  return 'ProfileEditorState(original: $original, draft: $draft, saving: $saving, errors: $errors, errorMessage: $errorMessage, needsRefresh: $needsRefresh, usernameChecking: $usernameChecking, usernameAvailable: $usernameAvailable)';
}


}

/// @nodoc
abstract mixin class $ProfileEditorStateCopyWith<$Res>  {
  factory $ProfileEditorStateCopyWith(ProfileEditorState value, $Res Function(ProfileEditorState) _then) = _$ProfileEditorStateCopyWithImpl;
@useResult
$Res call({
 FccUserModel original, FccUserModel draft, bool saving, Map<String, String> errors, String? errorMessage, bool needsRefresh, bool usernameChecking, bool? usernameAvailable
});


$FccUserModelCopyWith<$Res> get original;$FccUserModelCopyWith<$Res> get draft;

}
/// @nodoc
class _$ProfileEditorStateCopyWithImpl<$Res>
    implements $ProfileEditorStateCopyWith<$Res> {
  _$ProfileEditorStateCopyWithImpl(this._self, this._then);

  final ProfileEditorState _self;
  final $Res Function(ProfileEditorState) _then;

/// Create a copy of ProfileEditorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? original = null,Object? draft = null,Object? saving = null,Object? errors = null,Object? errorMessage = freezed,Object? needsRefresh = null,Object? usernameChecking = null,Object? usernameAvailable = freezed,}) {
  return _then(_self.copyWith(
original: null == original ? _self.original : original // ignore: cast_nullable_to_non_nullable
as FccUserModel,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as FccUserModel,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, String>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,needsRefresh: null == needsRefresh ? _self.needsRefresh : needsRefresh // ignore: cast_nullable_to_non_nullable
as bool,usernameChecking: null == usernameChecking ? _self.usernameChecking : usernameChecking // ignore: cast_nullable_to_non_nullable
as bool,usernameAvailable: freezed == usernameAvailable ? _self.usernameAvailable : usernameAvailable // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}
/// Create a copy of ProfileEditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FccUserModelCopyWith<$Res> get original {
  
  return $FccUserModelCopyWith<$Res>(_self.original, (value) {
    return _then(_self.copyWith(original: value));
  });
}/// Create a copy of ProfileEditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FccUserModelCopyWith<$Res> get draft {
  
  return $FccUserModelCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProfileEditorState].
extension ProfileEditorStatePatterns on ProfileEditorState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileEditorState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileEditorState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileEditorState value)  $default,){
final _that = this;
switch (_that) {
case _ProfileEditorState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileEditorState value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileEditorState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FccUserModel original,  FccUserModel draft,  bool saving,  Map<String, String> errors,  String? errorMessage,  bool needsRefresh,  bool usernameChecking,  bool? usernameAvailable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileEditorState() when $default != null:
return $default(_that.original,_that.draft,_that.saving,_that.errors,_that.errorMessage,_that.needsRefresh,_that.usernameChecking,_that.usernameAvailable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FccUserModel original,  FccUserModel draft,  bool saving,  Map<String, String> errors,  String? errorMessage,  bool needsRefresh,  bool usernameChecking,  bool? usernameAvailable)  $default,) {final _that = this;
switch (_that) {
case _ProfileEditorState():
return $default(_that.original,_that.draft,_that.saving,_that.errors,_that.errorMessage,_that.needsRefresh,_that.usernameChecking,_that.usernameAvailable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FccUserModel original,  FccUserModel draft,  bool saving,  Map<String, String> errors,  String? errorMessage,  bool needsRefresh,  bool usernameChecking,  bool? usernameAvailable)?  $default,) {final _that = this;
switch (_that) {
case _ProfileEditorState() when $default != null:
return $default(_that.original,_that.draft,_that.saving,_that.errors,_that.errorMessage,_that.needsRefresh,_that.usernameChecking,_that.usernameAvailable);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileEditorState extends ProfileEditorState {
  const _ProfileEditorState({required this.original, required this.draft, this.saving = false, final  Map<String, String> errors = const {}, this.errorMessage, this.needsRefresh = false, this.usernameChecking = false, this.usernameAvailable}): _errors = errors,super._();
  

@override final  FccUserModel original;
@override final  FccUserModel draft;
@override@JsonKey() final  bool saving;
 final  Map<String, String> _errors;
@override@JsonKey() Map<String, String> get errors {
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_errors);
}

@override final  String? errorMessage;
@override@JsonKey() final  bool needsRefresh;
@override@JsonKey() final  bool usernameChecking;
@override final  bool? usernameAvailable;

/// Create a copy of ProfileEditorState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileEditorStateCopyWith<_ProfileEditorState> get copyWith => __$ProfileEditorStateCopyWithImpl<_ProfileEditorState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileEditorState&&(identical(other.original, original) || other.original == original)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.saving, saving) || other.saving == saving)&&const DeepCollectionEquality().equals(other._errors, _errors)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.needsRefresh, needsRefresh) || other.needsRefresh == needsRefresh)&&(identical(other.usernameChecking, usernameChecking) || other.usernameChecking == usernameChecking)&&(identical(other.usernameAvailable, usernameAvailable) || other.usernameAvailable == usernameAvailable));
}


@override
int get hashCode => Object.hash(runtimeType,original,draft,saving,const DeepCollectionEquality().hash(_errors),errorMessage,needsRefresh,usernameChecking,usernameAvailable);

@override
String toString() {
  return 'ProfileEditorState(original: $original, draft: $draft, saving: $saving, errors: $errors, errorMessage: $errorMessage, needsRefresh: $needsRefresh, usernameChecking: $usernameChecking, usernameAvailable: $usernameAvailable)';
}


}

/// @nodoc
abstract mixin class _$ProfileEditorStateCopyWith<$Res> implements $ProfileEditorStateCopyWith<$Res> {
  factory _$ProfileEditorStateCopyWith(_ProfileEditorState value, $Res Function(_ProfileEditorState) _then) = __$ProfileEditorStateCopyWithImpl;
@override @useResult
$Res call({
 FccUserModel original, FccUserModel draft, bool saving, Map<String, String> errors, String? errorMessage, bool needsRefresh, bool usernameChecking, bool? usernameAvailable
});


@override $FccUserModelCopyWith<$Res> get original;@override $FccUserModelCopyWith<$Res> get draft;

}
/// @nodoc
class __$ProfileEditorStateCopyWithImpl<$Res>
    implements _$ProfileEditorStateCopyWith<$Res> {
  __$ProfileEditorStateCopyWithImpl(this._self, this._then);

  final _ProfileEditorState _self;
  final $Res Function(_ProfileEditorState) _then;

/// Create a copy of ProfileEditorState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? original = null,Object? draft = null,Object? saving = null,Object? errors = null,Object? errorMessage = freezed,Object? needsRefresh = null,Object? usernameChecking = null,Object? usernameAvailable = freezed,}) {
  return _then(_ProfileEditorState(
original: null == original ? _self.original : original // ignore: cast_nullable_to_non_nullable
as FccUserModel,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as FccUserModel,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,errors: null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, String>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,needsRefresh: null == needsRefresh ? _self.needsRefresh : needsRefresh // ignore: cast_nullable_to_non_nullable
as bool,usernameChecking: null == usernameChecking ? _self.usernameChecking : usernameChecking // ignore: cast_nullable_to_non_nullable
as bool,usernameAvailable: freezed == usernameAvailable ? _self.usernameAvailable : usernameAvailable // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

/// Create a copy of ProfileEditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FccUserModelCopyWith<$Res> get original {
  
  return $FccUserModelCopyWith<$Res>(_self.original, (value) {
    return _then(_self.copyWith(original: value));
  });
}/// Create a copy of ProfileEditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FccUserModelCopyWith<$Res> get draft {
  
  return $FccUserModelCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}

// dart format on
