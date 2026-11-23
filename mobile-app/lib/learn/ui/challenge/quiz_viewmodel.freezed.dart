// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_viewmodel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuizState {

 List<QuestionItem> get questions; List<int?> get selected; int get requiredCorrect; int get current; bool get validated; List<bool> get results; int get correct; bool get passed;
/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizStateCopyWith<QuizState> get copyWith => _$QuizStateCopyWithImpl<QuizState>(this as QuizState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as QuizState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizState&&const DeepCollectionEquality().equals(other.questions, _this.questions)&&const DeepCollectionEquality().equals(other.selected, _this.selected)&&(identical(other.requiredCorrect, _this.requiredCorrect) || other.requiredCorrect == _this.requiredCorrect)&&(identical(other.current, _this.current) || other.current == _this.current)&&(identical(other.validated, _this.validated) || other.validated == _this.validated)&&const DeepCollectionEquality().equals(other.results, _this.results)&&(identical(other.correct, _this.correct) || other.correct == _this.correct)&&(identical(other.passed, _this.passed) || other.passed == _this.passed));
}


@override
int get hashCode {
  final _this = this as QuizState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.questions),const DeepCollectionEquality().hash(_this.selected),_this.requiredCorrect,_this.current,_this.validated,const DeepCollectionEquality().hash(_this.results),_this.correct,_this.passed);
}

@override
String toString() {
  final _this = this as QuizState;
  return 'QuizState(questions: ${_this.questions}, selected: ${_this.selected}, requiredCorrect: ${_this.requiredCorrect}, current: ${_this.current}, validated: ${_this.validated}, results: ${_this.results}, correct: ${_this.correct}, passed: ${_this.passed})';
}


}

/// @nodoc
abstract mixin class $QuizStateCopyWith<$Res>  {
  factory $QuizStateCopyWith(QuizState value, $Res Function(QuizState) _then) = _$QuizStateCopyWithImpl;
@useResult
$Res call({
 List<QuestionItem> questions, List<int?> selected, int requiredCorrect, int current, bool validated, List<bool> results, int correct, bool passed
});




}
/// @nodoc
class _$QuizStateCopyWithImpl<$Res>
    implements $QuizStateCopyWith<$Res> {
  _$QuizStateCopyWithImpl(this._self, this._then);

  final QuizState _self;
  final $Res Function(QuizState) _then;

/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questions = null,Object? selected = null,Object? requiredCorrect = null,Object? current = null,Object? validated = null,Object? results = null,Object? correct = null,Object? passed = null,}) {
  return _then(QuizState(
questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<QuestionItem>,selected: null == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as List<int?>,requiredCorrect: null == requiredCorrect ? _self.requiredCorrect : requiredCorrect // ignore: cast_nullable_to_non_nullable
as int,current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as int,validated: null == validated ? _self.validated : validated // ignore: cast_nullable_to_non_nullable
as bool,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<bool>,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,passed: null == passed ? _self.passed : passed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [QuizState].
extension QuizStatePatterns on QuizState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizState value)  $default,){
final _that = this;
switch (_that) {
case _QuizState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizState value)?  $default,){
final _that = this;
switch (_that) {
case _QuizState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<QuestionItem> questions,  List<int?> selected,  int requiredCorrect,  int current,  bool validated,  List<bool> results,  int correct,  bool passed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizState() when $default != null:
return $default(_that.questions,_that.selected,_that.requiredCorrect,_that.current,_that.validated,_that.results,_that.correct,_that.passed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<QuestionItem> questions,  List<int?> selected,  int requiredCorrect,  int current,  bool validated,  List<bool> results,  int correct,  bool passed)  $default,) {final _that = this;
switch (_that) {
case _QuizState():
return $default(_that.questions,_that.selected,_that.requiredCorrect,_that.current,_that.validated,_that.results,_that.correct,_that.passed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<QuestionItem> questions,  List<int?> selected,  int requiredCorrect,  int current,  bool validated,  List<bool> results,  int correct,  bool passed)?  $default,) {final _that = this;
switch (_that) {
case _QuizState() when $default != null:
return $default(_that.questions,_that.selected,_that.requiredCorrect,_that.current,_that.validated,_that.results,_that.correct,_that.passed);case _:
  return null;

}
}

}

/// @nodoc


class _QuizState extends QuizState {
  const _QuizState({required  List<QuestionItem> questions, required  List<int?> selected, required this.requiredCorrect, this.current = 0, this.validated = false,  List<bool> results = const [], this.correct = 0, this.passed = false}): _questions = questions,_selected = selected,_results = results,super._();
  

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

@override final  int requiredCorrect;
@override@JsonKey() final  int current;
@override@JsonKey() final  bool validated;
 final  List<bool> _results;
@override@JsonKey() List<bool> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

@override@JsonKey() final  int correct;
@override@JsonKey() final  bool passed;

/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizStateCopyWith<_QuizState> get copyWith => __$QuizStateCopyWithImpl<_QuizState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizState&&const DeepCollectionEquality().equals(other.questions, _questions)&&const DeepCollectionEquality().equals(other.selected, _selected)&&(identical(other.requiredCorrect, requiredCorrect) || other.requiredCorrect == requiredCorrect)&&(identical(other.current, current) || other.current == current)&&(identical(other.validated, validated) || other.validated == validated)&&const DeepCollectionEquality().equals(other.results, _results)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.passed, passed) || other.passed == passed));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_questions),const DeepCollectionEquality().hash(_selected),requiredCorrect,current,validated,const DeepCollectionEquality().hash(_results),correct,passed);
}

@override
String toString() {
    return 'QuizState(questions: $questions, selected: $selected, requiredCorrect: $requiredCorrect, current: $current, validated: $validated, results: $results, correct: $correct, passed: $passed)';
}


}

/// @nodoc
abstract mixin class _$QuizStateCopyWith<$Res> implements $QuizStateCopyWith<$Res> {
  factory _$QuizStateCopyWith(_QuizState value, $Res Function(_QuizState) _then) = __$QuizStateCopyWithImpl;
@override @useResult
$Res call({
 List<QuestionItem> questions, List<int?> selected, int requiredCorrect, int current, bool validated, List<bool> results, int correct, bool passed
});




}
/// @nodoc
class __$QuizStateCopyWithImpl<$Res>
    implements _$QuizStateCopyWith<$Res> {
  __$QuizStateCopyWithImpl(this._self, this._then);

  final _QuizState _self;
  final $Res Function(_QuizState) _then;

/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questions = null,Object? selected = null,Object? requiredCorrect = null,Object? current = null,Object? validated = null,Object? results = null,Object? correct = null,Object? passed = null,}) {
  return _then(_QuizState(
questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<QuestionItem>,selected: null == selected ? _self._selected : selected // ignore: cast_nullable_to_non_nullable
as List<int?>,requiredCorrect: null == requiredCorrect ? _self.requiredCorrect : requiredCorrect // ignore: cast_nullable_to_non_nullable
as int,current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as int,validated: null == validated ? _self.validated : validated // ignore: cast_nullable_to_non_nullable
as bool,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<bool>,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,passed: null == passed ? _self.passed : passed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
