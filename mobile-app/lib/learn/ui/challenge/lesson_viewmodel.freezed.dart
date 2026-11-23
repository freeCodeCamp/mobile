// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_viewmodel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LessonChallengeState {

 List<QuestionItem> get questions; List<int?> get selected; List<bool> get checked; List<bool> get results; List<bool> get assignments; bool get assignmentsDone; bool get passed; bool get canCompleteReading; int get firstPendingQuestion; bool get reviewed; int? get current;
/// Create a copy of LessonChallengeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonChallengeStateCopyWith<LessonChallengeState> get copyWith => _$LessonChallengeStateCopyWithImpl<LessonChallengeState>(this as LessonChallengeState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LessonChallengeState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonChallengeState&&const DeepCollectionEquality().equals(other.questions, _this.questions)&&const DeepCollectionEquality().equals(other.selected, _this.selected)&&const DeepCollectionEquality().equals(other.checked, _this.checked)&&const DeepCollectionEquality().equals(other.results, _this.results)&&const DeepCollectionEquality().equals(other.assignments, _this.assignments)&&(identical(other.assignmentsDone, _this.assignmentsDone) || other.assignmentsDone == _this.assignmentsDone)&&(identical(other.passed, _this.passed) || other.passed == _this.passed)&&(identical(other.canCompleteReading, _this.canCompleteReading) || other.canCompleteReading == _this.canCompleteReading)&&(identical(other.firstPendingQuestion, _this.firstPendingQuestion) || other.firstPendingQuestion == _this.firstPendingQuestion)&&(identical(other.reviewed, _this.reviewed) || other.reviewed == _this.reviewed)&&(identical(other.current, _this.current) || other.current == _this.current));
}


@override
int get hashCode {
  final _this = this as LessonChallengeState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.questions),const DeepCollectionEquality().hash(_this.selected),const DeepCollectionEquality().hash(_this.checked),const DeepCollectionEquality().hash(_this.results),const DeepCollectionEquality().hash(_this.assignments),_this.assignmentsDone,_this.passed,_this.canCompleteReading,_this.firstPendingQuestion,_this.reviewed,_this.current);
}

@override
String toString() {
  final _this = this as LessonChallengeState;
  return 'LessonChallengeState(questions: ${_this.questions}, selected: ${_this.selected}, checked: ${_this.checked}, results: ${_this.results}, assignments: ${_this.assignments}, assignmentsDone: ${_this.assignmentsDone}, passed: ${_this.passed}, canCompleteReading: ${_this.canCompleteReading}, firstPendingQuestion: ${_this.firstPendingQuestion}, reviewed: ${_this.reviewed}, current: ${_this.current})';
}


}

/// @nodoc
abstract mixin class $LessonChallengeStateCopyWith<$Res>  {
  factory $LessonChallengeStateCopyWith(LessonChallengeState value, $Res Function(LessonChallengeState) _then) = _$LessonChallengeStateCopyWithImpl;
@useResult
$Res call({
 List<QuestionItem> questions, List<int?> selected, List<bool> checked, List<bool> results, List<bool> assignments, bool assignmentsDone, bool passed, bool canCompleteReading, int firstPendingQuestion, bool reviewed, int? current
});




}
/// @nodoc
class _$LessonChallengeStateCopyWithImpl<$Res>
    implements $LessonChallengeStateCopyWith<$Res> {
  _$LessonChallengeStateCopyWithImpl(this._self, this._then);

  final LessonChallengeState _self;
  final $Res Function(LessonChallengeState) _then;

/// Create a copy of LessonChallengeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questions = null,Object? selected = null,Object? checked = null,Object? results = null,Object? assignments = null,Object? assignmentsDone = null,Object? passed = null,Object? canCompleteReading = null,Object? firstPendingQuestion = null,Object? reviewed = null,Object? current = freezed,}) {
  return _then(LessonChallengeState(
questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<QuestionItem>,selected: null == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as List<int?>,checked: null == checked ? _self.checked : checked // ignore: cast_nullable_to_non_nullable
as List<bool>,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<bool>,assignments: null == assignments ? _self.assignments : assignments // ignore: cast_nullable_to_non_nullable
as List<bool>,assignmentsDone: null == assignmentsDone ? _self.assignmentsDone : assignmentsDone // ignore: cast_nullable_to_non_nullable
as bool,passed: null == passed ? _self.passed : passed // ignore: cast_nullable_to_non_nullable
as bool,canCompleteReading: null == canCompleteReading ? _self.canCompleteReading : canCompleteReading // ignore: cast_nullable_to_non_nullable
as bool,firstPendingQuestion: null == firstPendingQuestion ? _self.firstPendingQuestion : firstPendingQuestion // ignore: cast_nullable_to_non_nullable
as int,reviewed: null == reviewed ? _self.reviewed : reviewed // ignore: cast_nullable_to_non_nullable
as bool,current: freezed == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [LessonChallengeState].
extension LessonChallengeStatePatterns on LessonChallengeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonChallengeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonChallengeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonChallengeState value)  $default,){
final _that = this;
switch (_that) {
case _LessonChallengeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonChallengeState value)?  $default,){
final _that = this;
switch (_that) {
case _LessonChallengeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<QuestionItem> questions,  List<int?> selected,  List<bool> checked,  List<bool> results,  List<bool> assignments,  bool assignmentsDone,  bool passed,  bool canCompleteReading,  int firstPendingQuestion,  bool reviewed,  int? current)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonChallengeState() when $default != null:
return $default(_that.questions,_that.selected,_that.checked,_that.results,_that.assignments,_that.assignmentsDone,_that.passed,_that.canCompleteReading,_that.firstPendingQuestion,_that.reviewed,_that.current);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<QuestionItem> questions,  List<int?> selected,  List<bool> checked,  List<bool> results,  List<bool> assignments,  bool assignmentsDone,  bool passed,  bool canCompleteReading,  int firstPendingQuestion,  bool reviewed,  int? current)  $default,) {final _that = this;
switch (_that) {
case _LessonChallengeState():
return $default(_that.questions,_that.selected,_that.checked,_that.results,_that.assignments,_that.assignmentsDone,_that.passed,_that.canCompleteReading,_that.firstPendingQuestion,_that.reviewed,_that.current);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<QuestionItem> questions,  List<int?> selected,  List<bool> checked,  List<bool> results,  List<bool> assignments,  bool assignmentsDone,  bool passed,  bool canCompleteReading,  int firstPendingQuestion,  bool reviewed,  int? current)?  $default,) {final _that = this;
switch (_that) {
case _LessonChallengeState() when $default != null:
return $default(_that.questions,_that.selected,_that.checked,_that.results,_that.assignments,_that.assignmentsDone,_that.passed,_that.canCompleteReading,_that.firstPendingQuestion,_that.reviewed,_that.current);case _:
  return null;

}
}

}

/// @nodoc


class _LessonChallengeState implements LessonChallengeState {
  const _LessonChallengeState({required  List<QuestionItem> questions, required  List<int?> selected, required  List<bool> checked, required  List<bool> results, required  List<bool> assignments, required this.assignmentsDone, required this.passed, required this.canCompleteReading, this.firstPendingQuestion = 0, this.reviewed = false, this.current}): _questions = questions,_selected = selected,_checked = checked,_results = results,_assignments = assignments;
  

 final  List<QuestionItem> _questions;
@override List<QuestionItem> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}

 final  List<int?> _selected;
@override List<int?> get selected {
  if (_selected is EqualUnmodifiableListView) return _selected;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selected);
}

 final  List<bool> _checked;
@override List<bool> get checked {
  if (_checked is EqualUnmodifiableListView) return _checked;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_checked);
}

 final  List<bool> _results;
@override List<bool> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

 final  List<bool> _assignments;
@override List<bool> get assignments {
  if (_assignments is EqualUnmodifiableListView) return _assignments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assignments);
}

@override final  bool assignmentsDone;
@override final  bool passed;
@override final  bool canCompleteReading;
@override@JsonKey() final  int firstPendingQuestion;
@override@JsonKey() final  bool reviewed;
@override final  int? current;

/// Create a copy of LessonChallengeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonChallengeStateCopyWith<_LessonChallengeState> get copyWith => __$LessonChallengeStateCopyWithImpl<_LessonChallengeState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonChallengeState&&const DeepCollectionEquality().equals(other.questions, _questions)&&const DeepCollectionEquality().equals(other.selected, _selected)&&const DeepCollectionEquality().equals(other.checked, _checked)&&const DeepCollectionEquality().equals(other.results, _results)&&const DeepCollectionEquality().equals(other.assignments, _assignments)&&(identical(other.assignmentsDone, assignmentsDone) || other.assignmentsDone == assignmentsDone)&&(identical(other.passed, passed) || other.passed == passed)&&(identical(other.canCompleteReading, canCompleteReading) || other.canCompleteReading == canCompleteReading)&&(identical(other.firstPendingQuestion, firstPendingQuestion) || other.firstPendingQuestion == firstPendingQuestion)&&(identical(other.reviewed, reviewed) || other.reviewed == reviewed)&&(identical(other.current, current) || other.current == current));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_questions),const DeepCollectionEquality().hash(_selected),const DeepCollectionEquality().hash(_checked),const DeepCollectionEquality().hash(_results),const DeepCollectionEquality().hash(_assignments),assignmentsDone,passed,canCompleteReading,firstPendingQuestion,reviewed,current);
}

@override
String toString() {
    return 'LessonChallengeState(questions: $questions, selected: $selected, checked: $checked, results: $results, assignments: $assignments, assignmentsDone: $assignmentsDone, passed: $passed, canCompleteReading: $canCompleteReading, firstPendingQuestion: $firstPendingQuestion, reviewed: $reviewed, current: $current)';
}


}

/// @nodoc
abstract mixin class _$LessonChallengeStateCopyWith<$Res> implements $LessonChallengeStateCopyWith<$Res> {
  factory _$LessonChallengeStateCopyWith(_LessonChallengeState value, $Res Function(_LessonChallengeState) _then) = __$LessonChallengeStateCopyWithImpl;
@override @useResult
$Res call({
 List<QuestionItem> questions, List<int?> selected, List<bool> checked, List<bool> results, List<bool> assignments, bool assignmentsDone, bool passed, bool canCompleteReading, int firstPendingQuestion, bool reviewed, int? current
});




}
/// @nodoc
class __$LessonChallengeStateCopyWithImpl<$Res>
    implements _$LessonChallengeStateCopyWith<$Res> {
  __$LessonChallengeStateCopyWithImpl(this._self, this._then);

  final _LessonChallengeState _self;
  final $Res Function(_LessonChallengeState) _then;

/// Create a copy of LessonChallengeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questions = null,Object? selected = null,Object? checked = null,Object? results = null,Object? assignments = null,Object? assignmentsDone = null,Object? passed = null,Object? canCompleteReading = null,Object? firstPendingQuestion = null,Object? reviewed = null,Object? current = freezed,}) {
  return _then(_LessonChallengeState(
questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<QuestionItem>,selected: null == selected ? _self._selected : selected // ignore: cast_nullable_to_non_nullable
as List<int?>,checked: null == checked ? _self._checked : checked // ignore: cast_nullable_to_non_nullable
as List<bool>,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<bool>,assignments: null == assignments ? _self._assignments : assignments // ignore: cast_nullable_to_non_nullable
as List<bool>,assignmentsDone: null == assignmentsDone ? _self.assignmentsDone : assignmentsDone // ignore: cast_nullable_to_non_nullable
as bool,passed: null == passed ? _self.passed : passed // ignore: cast_nullable_to_non_nullable
as bool,canCompleteReading: null == canCompleteReading ? _self.canCompleteReading : canCompleteReading // ignore: cast_nullable_to_non_nullable
as bool,firstPendingQuestion: null == firstPendingQuestion ? _self.firstPendingQuestion : firstPendingQuestion // ignore: cast_nullable_to_non_nullable
as int,reviewed: null == reviewed ? _self.reviewed : reviewed // ignore: cast_nullable_to_non_nullable
as bool,current: freezed == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
