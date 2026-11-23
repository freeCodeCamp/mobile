// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'english_viewmodel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EnglishChallengeState {

 List<String> get answers; List<bool> get assignments; List<bool>? get results; bool get allCorrect; bool get canCheck; bool get assignmentsDone; String get feedback; bool get exercise;
/// Create a copy of EnglishChallengeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnglishChallengeStateCopyWith<EnglishChallengeState> get copyWith => _$EnglishChallengeStateCopyWithImpl<EnglishChallengeState>(this as EnglishChallengeState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as EnglishChallengeState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnglishChallengeState&&const DeepCollectionEquality().equals(other.answers, _this.answers)&&const DeepCollectionEquality().equals(other.assignments, _this.assignments)&&const DeepCollectionEquality().equals(other.results, _this.results)&&(identical(other.allCorrect, _this.allCorrect) || other.allCorrect == _this.allCorrect)&&(identical(other.canCheck, _this.canCheck) || other.canCheck == _this.canCheck)&&(identical(other.assignmentsDone, _this.assignmentsDone) || other.assignmentsDone == _this.assignmentsDone)&&(identical(other.feedback, _this.feedback) || other.feedback == _this.feedback)&&(identical(other.exercise, _this.exercise) || other.exercise == _this.exercise));
}


@override
int get hashCode {
  final _this = this as EnglishChallengeState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.answers),const DeepCollectionEquality().hash(_this.assignments),const DeepCollectionEquality().hash(_this.results),_this.allCorrect,_this.canCheck,_this.assignmentsDone,_this.feedback,_this.exercise);
}

@override
String toString() {
  final _this = this as EnglishChallengeState;
  return 'EnglishChallengeState(answers: ${_this.answers}, assignments: ${_this.assignments}, results: ${_this.results}, allCorrect: ${_this.allCorrect}, canCheck: ${_this.canCheck}, assignmentsDone: ${_this.assignmentsDone}, feedback: ${_this.feedback}, exercise: ${_this.exercise})';
}


}

/// @nodoc
abstract mixin class $EnglishChallengeStateCopyWith<$Res>  {
  factory $EnglishChallengeStateCopyWith(EnglishChallengeState value, $Res Function(EnglishChallengeState) _then) = _$EnglishChallengeStateCopyWithImpl;
@useResult
$Res call({
 List<String> answers, List<bool> assignments, List<bool>? results, bool allCorrect, bool canCheck, bool assignmentsDone, String feedback, bool exercise
});




}
/// @nodoc
class _$EnglishChallengeStateCopyWithImpl<$Res>
    implements $EnglishChallengeStateCopyWith<$Res> {
  _$EnglishChallengeStateCopyWithImpl(this._self, this._then);

  final EnglishChallengeState _self;
  final $Res Function(EnglishChallengeState) _then;

/// Create a copy of EnglishChallengeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? answers = null,Object? assignments = null,Object? results = freezed,Object? allCorrect = null,Object? canCheck = null,Object? assignmentsDone = null,Object? feedback = null,Object? exercise = null,}) {
  return _then(EnglishChallengeState(
answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as List<String>,assignments: null == assignments ? _self.assignments : assignments // ignore: cast_nullable_to_non_nullable
as List<bool>,results: freezed == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<bool>?,allCorrect: null == allCorrect ? _self.allCorrect : allCorrect // ignore: cast_nullable_to_non_nullable
as bool,canCheck: null == canCheck ? _self.canCheck : canCheck // ignore: cast_nullable_to_non_nullable
as bool,assignmentsDone: null == assignmentsDone ? _self.assignmentsDone : assignmentsDone // ignore: cast_nullable_to_non_nullable
as bool,feedback: null == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as String,exercise: null == exercise ? _self.exercise : exercise // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [EnglishChallengeState].
extension EnglishChallengeStatePatterns on EnglishChallengeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EnglishChallengeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EnglishChallengeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EnglishChallengeState value)  $default,){
final _that = this;
switch (_that) {
case _EnglishChallengeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EnglishChallengeState value)?  $default,){
final _that = this;
switch (_that) {
case _EnglishChallengeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> answers,  List<bool> assignments,  List<bool>? results,  bool allCorrect,  bool canCheck,  bool assignmentsDone,  String feedback,  bool exercise)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EnglishChallengeState() when $default != null:
return $default(_that.answers,_that.assignments,_that.results,_that.allCorrect,_that.canCheck,_that.assignmentsDone,_that.feedback,_that.exercise);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> answers,  List<bool> assignments,  List<bool>? results,  bool allCorrect,  bool canCheck,  bool assignmentsDone,  String feedback,  bool exercise)  $default,) {final _that = this;
switch (_that) {
case _EnglishChallengeState():
return $default(_that.answers,_that.assignments,_that.results,_that.allCorrect,_that.canCheck,_that.assignmentsDone,_that.feedback,_that.exercise);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> answers,  List<bool> assignments,  List<bool>? results,  bool allCorrect,  bool canCheck,  bool assignmentsDone,  String feedback,  bool exercise)?  $default,) {final _that = this;
switch (_that) {
case _EnglishChallengeState() when $default != null:
return $default(_that.answers,_that.assignments,_that.results,_that.allCorrect,_that.canCheck,_that.assignmentsDone,_that.feedback,_that.exercise);case _:
  return null;

}
}

}

/// @nodoc


class _EnglishChallengeState implements EnglishChallengeState {
  const _EnglishChallengeState({required  List<String> answers, required  List<bool> assignments,  List<bool>? results, this.allCorrect = false, this.canCheck = false, required this.assignmentsDone, this.feedback = '', this.exercise = false}): _answers = answers,_assignments = assignments,_results = results;
  

 final  List<String> _answers;
@override List<String> get answers {
  if (_answers is EqualUnmodifiableListView) return _answers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_answers);
}

 final  List<bool> _assignments;
@override List<bool> get assignments {
  if (_assignments is EqualUnmodifiableListView) return _assignments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assignments);
}

 final  List<bool>? _results;
@override List<bool>? get results {
  final value = _results;
  if (value == null) return null;
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey() final  bool allCorrect;
@override@JsonKey() final  bool canCheck;
@override final  bool assignmentsDone;
@override@JsonKey() final  String feedback;
@override@JsonKey() final  bool exercise;

/// Create a copy of EnglishChallengeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EnglishChallengeStateCopyWith<_EnglishChallengeState> get copyWith => __$EnglishChallengeStateCopyWithImpl<_EnglishChallengeState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EnglishChallengeState&&const DeepCollectionEquality().equals(other.answers, _answers)&&const DeepCollectionEquality().equals(other.assignments, _assignments)&&const DeepCollectionEquality().equals(other.results, _results)&&(identical(other.allCorrect, allCorrect) || other.allCorrect == allCorrect)&&(identical(other.canCheck, canCheck) || other.canCheck == canCheck)&&(identical(other.assignmentsDone, assignmentsDone) || other.assignmentsDone == assignmentsDone)&&(identical(other.feedback, feedback) || other.feedback == feedback)&&(identical(other.exercise, exercise) || other.exercise == exercise));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_answers),const DeepCollectionEquality().hash(_assignments),const DeepCollectionEquality().hash(_results),allCorrect,canCheck,assignmentsDone,feedback,exercise);
}

@override
String toString() {
    return 'EnglishChallengeState(answers: $answers, assignments: $assignments, results: $results, allCorrect: $allCorrect, canCheck: $canCheck, assignmentsDone: $assignmentsDone, feedback: $feedback, exercise: $exercise)';
}


}

/// @nodoc
abstract mixin class _$EnglishChallengeStateCopyWith<$Res> implements $EnglishChallengeStateCopyWith<$Res> {
  factory _$EnglishChallengeStateCopyWith(_EnglishChallengeState value, $Res Function(_EnglishChallengeState) _then) = __$EnglishChallengeStateCopyWithImpl;
@override @useResult
$Res call({
 List<String> answers, List<bool> assignments, List<bool>? results, bool allCorrect, bool canCheck, bool assignmentsDone, String feedback, bool exercise
});




}
/// @nodoc
class __$EnglishChallengeStateCopyWithImpl<$Res>
    implements _$EnglishChallengeStateCopyWith<$Res> {
  __$EnglishChallengeStateCopyWithImpl(this._self, this._then);

  final _EnglishChallengeState _self;
  final $Res Function(_EnglishChallengeState) _then;

/// Create a copy of EnglishChallengeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? answers = null,Object? assignments = null,Object? results = freezed,Object? allCorrect = null,Object? canCheck = null,Object? assignmentsDone = null,Object? feedback = null,Object? exercise = null,}) {
  return _then(_EnglishChallengeState(
answers: null == answers ? _self._answers : answers // ignore: cast_nullable_to_non_nullable
as List<String>,assignments: null == assignments ? _self._assignments : assignments // ignore: cast_nullable_to_non_nullable
as List<bool>,results: freezed == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<bool>?,allCorrect: null == allCorrect ? _self.allCorrect : allCorrect // ignore: cast_nullable_to_non_nullable
as bool,canCheck: null == canCheck ? _self.canCheck : canCheck // ignore: cast_nullable_to_non_nullable
as bool,assignmentsDone: null == assignmentsDone ? _self.assignmentsDone : assignmentsDone // ignore: cast_nullable_to_non_nullable
as bool,feedback: null == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as String,exercise: null == exercise ? _self.exercise : exercise // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
