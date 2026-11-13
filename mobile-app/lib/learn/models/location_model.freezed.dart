// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LearnLocation {

 String get superBlock; String get block; String get challengeId;
/// Create a copy of LearnLocation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LearnLocationCopyWith<LearnLocation> get copyWith => _$LearnLocationCopyWithImpl<LearnLocation>(this as LearnLocation, _$identity);

  /// Serializes this LearnLocation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LearnLocation;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LearnLocation&&(identical(other.superBlock, _this.superBlock) || other.superBlock == _this.superBlock)&&(identical(other.block, _this.block) || other.block == _this.block)&&(identical(other.challengeId, _this.challengeId) || other.challengeId == _this.challengeId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LearnLocation;
  return Object.hash(runtimeType,_this.superBlock,_this.block,_this.challengeId);
}

@override
String toString() {
  final _this = this as LearnLocation;
  return 'LearnLocation(superBlock: ${_this.superBlock}, block: ${_this.block}, challengeId: ${_this.challengeId})';
}


}

/// @nodoc
abstract mixin class $LearnLocationCopyWith<$Res>  {
  factory $LearnLocationCopyWith(LearnLocation value, $Res Function(LearnLocation) _then) = _$LearnLocationCopyWithImpl;
@useResult
$Res call({
 String superBlock, String block, String challengeId
});




}
/// @nodoc
class _$LearnLocationCopyWithImpl<$Res>
    implements $LearnLocationCopyWith<$Res> {
  _$LearnLocationCopyWithImpl(this._self, this._then);

  final LearnLocation _self;
  final $Res Function(LearnLocation) _then;

/// Create a copy of LearnLocation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? superBlock = null,Object? block = null,Object? challengeId = null,}) {
  return _then(LearnLocation(
superBlock: null == superBlock ? _self.superBlock : superBlock // ignore: cast_nullable_to_non_nullable
as String,block: null == block ? _self.block : block // ignore: cast_nullable_to_non_nullable
as String,challengeId: null == challengeId ? _self.challengeId : challengeId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LearnLocation].
extension LearnLocationPatterns on LearnLocation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LearnLocation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LearnLocation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LearnLocation value)  $default,){
final _that = this;
switch (_that) {
case _LearnLocation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LearnLocation value)?  $default,){
final _that = this;
switch (_that) {
case _LearnLocation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String superBlock,  String block,  String challengeId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LearnLocation() when $default != null:
return $default(_that.superBlock,_that.block,_that.challengeId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String superBlock,  String block,  String challengeId)  $default,) {final _that = this;
switch (_that) {
case _LearnLocation():
return $default(_that.superBlock,_that.block,_that.challengeId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String superBlock,  String block,  String challengeId)?  $default,) {final _that = this;
switch (_that) {
case _LearnLocation() when $default != null:
return $default(_that.superBlock,_that.block,_that.challengeId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LearnLocation implements LearnLocation {
  const _LearnLocation({required this.superBlock, required this.block, required this.challengeId});
  factory _LearnLocation.fromJson(Map<String, dynamic> json) => _$LearnLocationFromJson(json);

@override final  String superBlock;
@override final  String block;
@override final  String challengeId;

/// Create a copy of LearnLocation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LearnLocationCopyWith<_LearnLocation> get copyWith => __$LearnLocationCopyWithImpl<_LearnLocation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LearnLocationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LearnLocation&&(identical(other.superBlock, superBlock) || other.superBlock == superBlock)&&(identical(other.block, block) || other.block == block)&&(identical(other.challengeId, challengeId) || other.challengeId == challengeId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,superBlock,block,challengeId);
}

@override
String toString() {
    return 'LearnLocation(superBlock: $superBlock, block: $block, challengeId: $challengeId)';
}


}

/// @nodoc
abstract mixin class _$LearnLocationCopyWith<$Res> implements $LearnLocationCopyWith<$Res> {
  factory _$LearnLocationCopyWith(_LearnLocation value, $Res Function(_LearnLocation) _then) = __$LearnLocationCopyWithImpl;
@override @useResult
$Res call({
 String superBlock, String block, String challengeId
});




}
/// @nodoc
class __$LearnLocationCopyWithImpl<$Res>
    implements _$LearnLocationCopyWith<$Res> {
  __$LearnLocationCopyWithImpl(this._self, this._then);

  final _LearnLocation _self;
  final $Res Function(_LearnLocation) _then;

/// Create a copy of LearnLocation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? superBlock = null,Object? block = null,Object? challengeId = null,}) {
  return _then(_LearnLocation(
superBlock: null == superBlock ? _self.superBlock : superBlock // ignore: cast_nullable_to_non_nullable
as String,block: null == block ? _self.block : block // ignore: cast_nullable_to_non_nullable
as String,challengeId: null == challengeId ? _self.challengeId : challengeId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
