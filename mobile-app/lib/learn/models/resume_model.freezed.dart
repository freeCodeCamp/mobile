// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resume_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LearningResume {

 SuperBlockSummary get course; Block get block; ChallengeOrder get challenge; int get completed; bool get isReturning;
/// Create a copy of LearningResume
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LearningResumeCopyWith<LearningResume> get copyWith => _$LearningResumeCopyWithImpl<LearningResume>(this as LearningResume, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LearningResume;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LearningResume&&(identical(other.course, _this.course) || other.course == _this.course)&&(identical(other.block, _this.block) || other.block == _this.block)&&(identical(other.challenge, _this.challenge) || other.challenge == _this.challenge)&&(identical(other.completed, _this.completed) || other.completed == _this.completed)&&(identical(other.isReturning, _this.isReturning) || other.isReturning == _this.isReturning));
}


@override
int get hashCode {
  final _this = this as LearningResume;
  return Object.hash(runtimeType,_this.course,_this.block,_this.challenge,_this.completed,_this.isReturning);
}

@override
String toString() {
  final _this = this as LearningResume;
  return 'LearningResume(course: ${_this.course}, block: ${_this.block}, challenge: ${_this.challenge}, completed: ${_this.completed}, isReturning: ${_this.isReturning})';
}


}

/// @nodoc
abstract mixin class $LearningResumeCopyWith<$Res>  {
  factory $LearningResumeCopyWith(LearningResume value, $Res Function(LearningResume) _then) = _$LearningResumeCopyWithImpl;
@useResult
$Res call({
 SuperBlockSummary course, Block block, ChallengeOrder challenge, int completed, bool isReturning
});


$SuperBlockSummaryCopyWith<$Res> get course;$BlockCopyWith<$Res> get block;$ChallengeOrderCopyWith<$Res> get challenge;

}
/// @nodoc
class _$LearningResumeCopyWithImpl<$Res>
    implements $LearningResumeCopyWith<$Res> {
  _$LearningResumeCopyWithImpl(this._self, this._then);

  final LearningResume _self;
  final $Res Function(LearningResume) _then;

/// Create a copy of LearningResume
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? course = null,Object? block = null,Object? challenge = null,Object? completed = null,Object? isReturning = null,}) {
  return _then(LearningResume(
course: null == course ? _self.course : course // ignore: cast_nullable_to_non_nullable
as SuperBlockSummary,block: null == block ? _self.block : block // ignore: cast_nullable_to_non_nullable
as Block,challenge: null == challenge ? _self.challenge : challenge // ignore: cast_nullable_to_non_nullable
as ChallengeOrder,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as int,isReturning: null == isReturning ? _self.isReturning : isReturning // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of LearningResume
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SuperBlockSummaryCopyWith<$Res> get course {

  return $SuperBlockSummaryCopyWith<$Res>(_self.course, (value) {
    return _then(_self.copyWith(course: value));
  });
}/// Create a copy of LearningResume
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockCopyWith<$Res> get block {

  return $BlockCopyWith<$Res>(_self.block, (value) {
    return _then(_self.copyWith(block: value));
  });
}/// Create a copy of LearningResume
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChallengeOrderCopyWith<$Res> get challenge {

  return $ChallengeOrderCopyWith<$Res>(_self.challenge, (value) {
    return _then(_self.copyWith(challenge: value));
  });
}
}


/// Adds pattern-matching-related methods to [LearningResume].
extension LearningResumePatterns on LearningResume {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LearningResume value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LearningResume() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LearningResume value)  $default,){
final _that = this;
switch (_that) {
case _LearningResume():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LearningResume value)?  $default,){
final _that = this;
switch (_that) {
case _LearningResume() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SuperBlockSummary course,  Block block,  ChallengeOrder challenge,  int completed,  bool isReturning)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LearningResume() when $default != null:
return $default(_that.course,_that.block,_that.challenge,_that.completed,_that.isReturning);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SuperBlockSummary course,  Block block,  ChallengeOrder challenge,  int completed,  bool isReturning)  $default,) {final _that = this;
switch (_that) {
case _LearningResume():
return $default(_that.course,_that.block,_that.challenge,_that.completed,_that.isReturning);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SuperBlockSummary course,  Block block,  ChallengeOrder challenge,  int completed,  bool isReturning)?  $default,) {final _that = this;
switch (_that) {
case _LearningResume() when $default != null:
return $default(_that.course,_that.block,_that.challenge,_that.completed,_that.isReturning);case _:
  return null;

}
}

}

/// @nodoc


class _LearningResume extends LearningResume {
  const _LearningResume({required this.course, required this.block, required this.challenge, required this.completed, required this.isReturning}): super._();


@override final  SuperBlockSummary course;
@override final  Block block;
@override final  ChallengeOrder challenge;
@override final  int completed;
@override final  bool isReturning;

/// Create a copy of LearningResume
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LearningResumeCopyWith<_LearningResume> get copyWith => __$LearningResumeCopyWithImpl<_LearningResume>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LearningResume&&(identical(other.course, course) || other.course == course)&&(identical(other.block, block) || other.block == block)&&(identical(other.challenge, challenge) || other.challenge == challenge)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.isReturning, isReturning) || other.isReturning == isReturning));
}


@override
int get hashCode {
    return Object.hash(runtimeType,course,block,challenge,completed,isReturning);
}

@override
String toString() {
    return 'LearningResume(course: $course, block: $block, challenge: $challenge, completed: $completed, isReturning: $isReturning)';
}


}

/// @nodoc
abstract mixin class _$LearningResumeCopyWith<$Res> implements $LearningResumeCopyWith<$Res> {
  factory _$LearningResumeCopyWith(_LearningResume value, $Res Function(_LearningResume) _then) = __$LearningResumeCopyWithImpl;
@override @useResult
$Res call({
 SuperBlockSummary course, Block block, ChallengeOrder challenge, int completed, bool isReturning
});


@override $SuperBlockSummaryCopyWith<$Res> get course;@override $BlockCopyWith<$Res> get block;@override $ChallengeOrderCopyWith<$Res> get challenge;

}
/// @nodoc
class __$LearningResumeCopyWithImpl<$Res>
    implements _$LearningResumeCopyWith<$Res> {
  __$LearningResumeCopyWithImpl(this._self, this._then);

  final _LearningResume _self;
  final $Res Function(_LearningResume) _then;

/// Create a copy of LearningResume
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? course = null,Object? block = null,Object? challenge = null,Object? completed = null,Object? isReturning = null,}) {
  return _then(_LearningResume(
course: null == course ? _self.course : course // ignore: cast_nullable_to_non_nullable
as SuperBlockSummary,block: null == block ? _self.block : block // ignore: cast_nullable_to_non_nullable
as Block,challenge: null == challenge ? _self.challenge : challenge // ignore: cast_nullable_to_non_nullable
as ChallengeOrder,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as int,isReturning: null == isReturning ? _self.isReturning : isReturning // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of LearningResume
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SuperBlockSummaryCopyWith<$Res> get course {

  return $SuperBlockSummaryCopyWith<$Res>(_self.course, (value) {
    return _then(_self.copyWith(course: value));
  });
}/// Create a copy of LearningResume
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockCopyWith<$Res> get block {

  return $BlockCopyWith<$Res>(_self.block, (value) {
    return _then(_self.copyWith(block: value));
  });
}/// Create a copy of LearningResume
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChallengeOrderCopyWith<$Res> get challenge {

  return $ChallengeOrderCopyWith<$Res>(_self.challenge, (value) {
    return _then(_self.copyWith(challenge: value));
  });
}
}

// dart format on
