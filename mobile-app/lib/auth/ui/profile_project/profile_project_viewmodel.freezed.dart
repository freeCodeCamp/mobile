// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_project_viewmodel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileProjectState {

 String get userId; Portfolio get original; Portfolio get draft; bool get isNew; bool get available; bool get saving; bool get navigationDirty; Map<String, String> get errors;
/// Create a copy of ProfileProjectState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileProjectStateCopyWith<ProfileProjectState> get copyWith => _$ProfileProjectStateCopyWithImpl<ProfileProjectState>(this as ProfileProjectState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProfileProjectState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileProjectState&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.original, _this.original) || other.original == _this.original)&&(identical(other.draft, _this.draft) || other.draft == _this.draft)&&(identical(other.isNew, _this.isNew) || other.isNew == _this.isNew)&&(identical(other.available, _this.available) || other.available == _this.available)&&(identical(other.saving, _this.saving) || other.saving == _this.saving)&&(identical(other.navigationDirty, _this.navigationDirty) || other.navigationDirty == _this.navigationDirty)&&const DeepCollectionEquality().equals(other.errors, _this.errors));
}


@override
int get hashCode {
  final _this = this as ProfileProjectState;
  return Object.hash(runtimeType,_this.userId,_this.original,_this.draft,_this.isNew,_this.available,_this.saving,_this.navigationDirty,const DeepCollectionEquality().hash(_this.errors));
}

@override
String toString() {
  final _this = this as ProfileProjectState;
  return 'ProfileProjectState(userId: ${_this.userId}, original: ${_this.original}, draft: ${_this.draft}, isNew: ${_this.isNew}, available: ${_this.available}, saving: ${_this.saving}, navigationDirty: ${_this.navigationDirty}, errors: ${_this.errors})';
}


}

/// @nodoc
abstract mixin class $ProfileProjectStateCopyWith<$Res>  {
  factory $ProfileProjectStateCopyWith(ProfileProjectState value, $Res Function(ProfileProjectState) _then) = _$ProfileProjectStateCopyWithImpl;
@useResult
$Res call({
 String userId, Portfolio original, Portfolio draft, bool isNew, bool available, bool saving, bool navigationDirty, Map<String, String> errors
});


$PortfolioCopyWith<$Res> get original;$PortfolioCopyWith<$Res> get draft;

}
/// @nodoc
class _$ProfileProjectStateCopyWithImpl<$Res>
    implements $ProfileProjectStateCopyWith<$Res> {
  _$ProfileProjectStateCopyWithImpl(this._self, this._then);

  final ProfileProjectState _self;
  final $Res Function(ProfileProjectState) _then;

/// Create a copy of ProfileProjectState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? original = null,Object? draft = null,Object? isNew = null,Object? available = null,Object? saving = null,Object? navigationDirty = null,Object? errors = null,}) {
  return _then(ProfileProjectState(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,original: null == original ? _self.original : original // ignore: cast_nullable_to_non_nullable
as Portfolio,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as Portfolio,isNew: null == isNew ? _self.isNew : isNew // ignore: cast_nullable_to_non_nullable
as bool,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,navigationDirty: null == navigationDirty ? _self.navigationDirty : navigationDirty // ignore: cast_nullable_to_non_nullable
as bool,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}
/// Create a copy of ProfileProjectState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PortfolioCopyWith<$Res> get original {
  
  return $PortfolioCopyWith<$Res>(_self.original, (value) {
    return _then(_self.copyWith(original: value));
  });
}/// Create a copy of ProfileProjectState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PortfolioCopyWith<$Res> get draft {
  
  return $PortfolioCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProfileProjectState].
extension ProfileProjectStatePatterns on ProfileProjectState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileProjectState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileProjectState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileProjectState value)  $default,){
final _that = this;
switch (_that) {
case _ProfileProjectState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileProjectState value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileProjectState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  Portfolio original,  Portfolio draft,  bool isNew,  bool available,  bool saving,  bool navigationDirty,  Map<String, String> errors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileProjectState() when $default != null:
return $default(_that.userId,_that.original,_that.draft,_that.isNew,_that.available,_that.saving,_that.navigationDirty,_that.errors);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  Portfolio original,  Portfolio draft,  bool isNew,  bool available,  bool saving,  bool navigationDirty,  Map<String, String> errors)  $default,) {final _that = this;
switch (_that) {
case _ProfileProjectState():
return $default(_that.userId,_that.original,_that.draft,_that.isNew,_that.available,_that.saving,_that.navigationDirty,_that.errors);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  Portfolio original,  Portfolio draft,  bool isNew,  bool available,  bool saving,  bool navigationDirty,  Map<String, String> errors)?  $default,) {final _that = this;
switch (_that) {
case _ProfileProjectState() when $default != null:
return $default(_that.userId,_that.original,_that.draft,_that.isNew,_that.available,_that.saving,_that.navigationDirty,_that.errors);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileProjectState extends ProfileProjectState {
  const _ProfileProjectState({required this.userId, required this.original, required this.draft, required this.isNew, this.available = true, this.saving = false, this.navigationDirty = false,  Map<String, String> errors = const {}}): _errors = errors,super._();
  

@override final  String userId;
@override final  Portfolio original;
@override final  Portfolio draft;
@override final  bool isNew;
@override@JsonKey() final  bool available;
@override@JsonKey() final  bool saving;
@override@JsonKey() final  bool navigationDirty;
 final  Map<String, String> _errors;
@override@JsonKey() Map<String, String> get errors {
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_errors);
}


/// Create a copy of ProfileProjectState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileProjectStateCopyWith<_ProfileProjectState> get copyWith => __$ProfileProjectStateCopyWithImpl<_ProfileProjectState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileProjectState&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.original, original) || other.original == original)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.isNew, isNew) || other.isNew == isNew)&&(identical(other.available, available) || other.available == available)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.navigationDirty, navigationDirty) || other.navigationDirty == navigationDirty)&&const DeepCollectionEquality().equals(other.errors, _errors));
}


@override
int get hashCode {
    return Object.hash(runtimeType,userId,original,draft,isNew,available,saving,navigationDirty,const DeepCollectionEquality().hash(_errors));
}

@override
String toString() {
    return 'ProfileProjectState(userId: $userId, original: $original, draft: $draft, isNew: $isNew, available: $available, saving: $saving, navigationDirty: $navigationDirty, errors: $errors)';
}


}

/// @nodoc
abstract mixin class _$ProfileProjectStateCopyWith<$Res> implements $ProfileProjectStateCopyWith<$Res> {
  factory _$ProfileProjectStateCopyWith(_ProfileProjectState value, $Res Function(_ProfileProjectState) _then) = __$ProfileProjectStateCopyWithImpl;
@override @useResult
$Res call({
 String userId, Portfolio original, Portfolio draft, bool isNew, bool available, bool saving, bool navigationDirty, Map<String, String> errors
});


@override $PortfolioCopyWith<$Res> get original;@override $PortfolioCopyWith<$Res> get draft;

}
/// @nodoc
class __$ProfileProjectStateCopyWithImpl<$Res>
    implements _$ProfileProjectStateCopyWith<$Res> {
  __$ProfileProjectStateCopyWithImpl(this._self, this._then);

  final _ProfileProjectState _self;
  final $Res Function(_ProfileProjectState) _then;

/// Create a copy of ProfileProjectState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? original = null,Object? draft = null,Object? isNew = null,Object? available = null,Object? saving = null,Object? navigationDirty = null,Object? errors = null,}) {
  return _then(_ProfileProjectState(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,original: null == original ? _self.original : original // ignore: cast_nullable_to_non_nullable
as Portfolio,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as Portfolio,isNew: null == isNew ? _self.isNew : isNew // ignore: cast_nullable_to_non_nullable
as bool,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,navigationDirty: null == navigationDirty ? _self.navigationDirty : navigationDirty // ignore: cast_nullable_to_non_nullable
as bool,errors: null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

/// Create a copy of ProfileProjectState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PortfolioCopyWith<$Res> get original {
  
  return $PortfolioCopyWith<$Res>(_self.original, (value) {
    return _then(_self.copyWith(original: value));
  });
}/// Create a copy of ProfileProjectState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PortfolioCopyWith<$Res> get draft {
  
  return $PortfolioCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}

// dart format on
