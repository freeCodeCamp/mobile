// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'python_project_viewmodel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PythonProjectState {

 String get link; bool get valid; bool get canCheck; String? get error;
/// Create a copy of PythonProjectState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PythonProjectStateCopyWith<PythonProjectState> get copyWith => _$PythonProjectStateCopyWithImpl<PythonProjectState>(this as PythonProjectState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PythonProjectState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PythonProjectState&&(identical(other.link, _this.link) || other.link == _this.link)&&(identical(other.valid, _this.valid) || other.valid == _this.valid)&&(identical(other.canCheck, _this.canCheck) || other.canCheck == _this.canCheck)&&(identical(other.error, _this.error) || other.error == _this.error));
}


@override
int get hashCode {
  final _this = this as PythonProjectState;
  return Object.hash(runtimeType,_this.link,_this.valid,_this.canCheck,_this.error);
}

@override
String toString() {
  final _this = this as PythonProjectState;
  return 'PythonProjectState(link: ${_this.link}, valid: ${_this.valid}, canCheck: ${_this.canCheck}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $PythonProjectStateCopyWith<$Res>  {
  factory $PythonProjectStateCopyWith(PythonProjectState value, $Res Function(PythonProjectState) _then) = _$PythonProjectStateCopyWithImpl;
@useResult
$Res call({
 String link, bool valid, bool canCheck, String? error
});




}
/// @nodoc
class _$PythonProjectStateCopyWithImpl<$Res>
    implements $PythonProjectStateCopyWith<$Res> {
  _$PythonProjectStateCopyWithImpl(this._self, this._then);

  final PythonProjectState _self;
  final $Res Function(PythonProjectState) _then;

/// Create a copy of PythonProjectState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? link = null,Object? valid = null,Object? canCheck = null,Object? error = freezed,}) {
  return _then(PythonProjectState(
link: null == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String,valid: null == valid ? _self.valid : valid // ignore: cast_nullable_to_non_nullable
as bool,canCheck: null == canCheck ? _self.canCheck : canCheck // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PythonProjectState].
extension PythonProjectStatePatterns on PythonProjectState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PythonProjectState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PythonProjectState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PythonProjectState value)  $default,){
final _that = this;
switch (_that) {
case _PythonProjectState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PythonProjectState value)?  $default,){
final _that = this;
switch (_that) {
case _PythonProjectState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String link,  bool valid,  bool canCheck,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PythonProjectState() when $default != null:
return $default(_that.link,_that.valid,_that.canCheck,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String link,  bool valid,  bool canCheck,  String? error)  $default,) {final _that = this;
switch (_that) {
case _PythonProjectState():
return $default(_that.link,_that.valid,_that.canCheck,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String link,  bool valid,  bool canCheck,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _PythonProjectState() when $default != null:
return $default(_that.link,_that.valid,_that.canCheck,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _PythonProjectState implements PythonProjectState {
  const _PythonProjectState({this.link = '', this.valid = false, this.canCheck = false, this.error});
  

@override@JsonKey() final  String link;
@override@JsonKey() final  bool valid;
@override@JsonKey() final  bool canCheck;
@override final  String? error;

/// Create a copy of PythonProjectState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PythonProjectStateCopyWith<_PythonProjectState> get copyWith => __$PythonProjectStateCopyWithImpl<_PythonProjectState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PythonProjectState&&(identical(other.link, link) || other.link == link)&&(identical(other.valid, valid) || other.valid == valid)&&(identical(other.canCheck, canCheck) || other.canCheck == canCheck)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,link,valid,canCheck,error);
}

@override
String toString() {
    return 'PythonProjectState(link: $link, valid: $valid, canCheck: $canCheck, error: $error)';
}


}

/// @nodoc
abstract mixin class _$PythonProjectStateCopyWith<$Res> implements $PythonProjectStateCopyWith<$Res> {
  factory _$PythonProjectStateCopyWith(_PythonProjectState value, $Res Function(_PythonProjectState) _then) = __$PythonProjectStateCopyWithImpl;
@override @useResult
$Res call({
 String link, bool valid, bool canCheck, String? error
});




}
/// @nodoc
class __$PythonProjectStateCopyWithImpl<$Res>
    implements _$PythonProjectStateCopyWith<$Res> {
  __$PythonProjectStateCopyWithImpl(this._self, this._then);

  final _PythonProjectState _self;
  final $Res Function(_PythonProjectState) _then;

/// Create a copy of PythonProjectState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? link = null,Object? valid = null,Object? canCheck = null,Object? error = freezed,}) {
  return _then(_PythonProjectState(
link: null == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String,valid: null == valid ? _self.valid : valid // ignore: cast_nullable_to_non_nullable
as bool,canCheck: null == canCheck ? _self.canCheck : canCheck // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
