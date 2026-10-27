// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_edit_viewmodel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileEditPresentation {

 Map<String, String> get fields; String get usernameHint; Map<String, String> get experienceDetails; String? get errorMessage;
/// Create a copy of ProfileEditPresentation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileEditPresentationCopyWith<ProfileEditPresentation> get copyWith => _$ProfileEditPresentationCopyWithImpl<ProfileEditPresentation>(this as ProfileEditPresentation, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileEditPresentation&&const DeepCollectionEquality().equals(other.fields, fields)&&(identical(other.usernameHint, usernameHint) || other.usernameHint == usernameHint)&&const DeepCollectionEquality().equals(other.experienceDetails, experienceDetails)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(fields),usernameHint,const DeepCollectionEquality().hash(experienceDetails),errorMessage);

@override
String toString() {
  return 'ProfileEditPresentation(fields: $fields, usernameHint: $usernameHint, experienceDetails: $experienceDetails, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $ProfileEditPresentationCopyWith<$Res>  {
  factory $ProfileEditPresentationCopyWith(ProfileEditPresentation value, $Res Function(ProfileEditPresentation) _then) = _$ProfileEditPresentationCopyWithImpl;
@useResult
$Res call({
 Map<String, String> fields, String usernameHint, Map<String, String> experienceDetails, String? errorMessage
});




}
/// @nodoc
class _$ProfileEditPresentationCopyWithImpl<$Res>
    implements $ProfileEditPresentationCopyWith<$Res> {
  _$ProfileEditPresentationCopyWithImpl(this._self, this._then);

  final ProfileEditPresentation _self;
  final $Res Function(ProfileEditPresentation) _then;

/// Create a copy of ProfileEditPresentation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fields = null,Object? usernameHint = null,Object? experienceDetails = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
fields: null == fields ? _self.fields : fields // ignore: cast_nullable_to_non_nullable
as Map<String, String>,usernameHint: null == usernameHint ? _self.usernameHint : usernameHint // ignore: cast_nullable_to_non_nullable
as String,experienceDetails: null == experienceDetails ? _self.experienceDetails : experienceDetails // ignore: cast_nullable_to_non_nullable
as Map<String, String>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileEditPresentation].
extension ProfileEditPresentationPatterns on ProfileEditPresentation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileEditPresentation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileEditPresentation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileEditPresentation value)  $default,){
final _that = this;
switch (_that) {
case _ProfileEditPresentation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileEditPresentation value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileEditPresentation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, String> fields,  String usernameHint,  Map<String, String> experienceDetails,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileEditPresentation() when $default != null:
return $default(_that.fields,_that.usernameHint,_that.experienceDetails,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, String> fields,  String usernameHint,  Map<String, String> experienceDetails,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _ProfileEditPresentation():
return $default(_that.fields,_that.usernameHint,_that.experienceDetails,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, String> fields,  String usernameHint,  Map<String, String> experienceDetails,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _ProfileEditPresentation() when $default != null:
return $default(_that.fields,_that.usernameHint,_that.experienceDetails,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileEditPresentation implements ProfileEditPresentation {
  const _ProfileEditPresentation({required final  Map<String, String> fields, required this.usernameHint, required final  Map<String, String> experienceDetails, this.errorMessage}): _fields = fields,_experienceDetails = experienceDetails;
  

 final  Map<String, String> _fields;
@override Map<String, String> get fields {
  if (_fields is EqualUnmodifiableMapView) return _fields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_fields);
}

@override final  String usernameHint;
 final  Map<String, String> _experienceDetails;
@override Map<String, String> get experienceDetails {
  if (_experienceDetails is EqualUnmodifiableMapView) return _experienceDetails;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_experienceDetails);
}

@override final  String? errorMessage;

/// Create a copy of ProfileEditPresentation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileEditPresentationCopyWith<_ProfileEditPresentation> get copyWith => __$ProfileEditPresentationCopyWithImpl<_ProfileEditPresentation>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileEditPresentation&&const DeepCollectionEquality().equals(other._fields, _fields)&&(identical(other.usernameHint, usernameHint) || other.usernameHint == usernameHint)&&const DeepCollectionEquality().equals(other._experienceDetails, _experienceDetails)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_fields),usernameHint,const DeepCollectionEquality().hash(_experienceDetails),errorMessage);

@override
String toString() {
  return 'ProfileEditPresentation(fields: $fields, usernameHint: $usernameHint, experienceDetails: $experienceDetails, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$ProfileEditPresentationCopyWith<$Res> implements $ProfileEditPresentationCopyWith<$Res> {
  factory _$ProfileEditPresentationCopyWith(_ProfileEditPresentation value, $Res Function(_ProfileEditPresentation) _then) = __$ProfileEditPresentationCopyWithImpl;
@override @useResult
$Res call({
 Map<String, String> fields, String usernameHint, Map<String, String> experienceDetails, String? errorMessage
});




}
/// @nodoc
class __$ProfileEditPresentationCopyWithImpl<$Res>
    implements _$ProfileEditPresentationCopyWith<$Res> {
  __$ProfileEditPresentationCopyWithImpl(this._self, this._then);

  final _ProfileEditPresentation _self;
  final $Res Function(_ProfileEditPresentation) _then;

/// Create a copy of ProfileEditPresentation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fields = null,Object? usernameHint = null,Object? experienceDetails = null,Object? errorMessage = freezed,}) {
  return _then(_ProfileEditPresentation(
fields: null == fields ? _self._fields : fields // ignore: cast_nullable_to_non_nullable
as Map<String, String>,usernameHint: null == usernameHint ? _self.usernameHint : usernameHint // ignore: cast_nullable_to_non_nullable
as String,experienceDetails: null == experienceDetails ? _self._experienceDetails : experienceDetails // ignore: cast_nullable_to_non_nullable
as Map<String, String>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
