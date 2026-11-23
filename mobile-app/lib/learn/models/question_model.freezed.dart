// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuestionItem {

 String get text; List<Answer> get answers; int get solution; QuizAudioData? get audioData;
/// Create a copy of QuestionItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionItemCopyWith<QuestionItem> get copyWith => _$QuestionItemCopyWithImpl<QuestionItem>(this as QuestionItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as QuestionItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionItem&&(identical(other.text, _this.text) || other.text == _this.text)&&const DeepCollectionEquality().equals(other.answers, _this.answers)&&(identical(other.solution, _this.solution) || other.solution == _this.solution)&&(identical(other.audioData, _this.audioData) || other.audioData == _this.audioData));
}


@override
int get hashCode {
  final _this = this as QuestionItem;
  return Object.hash(runtimeType,_this.text,const DeepCollectionEquality().hash(_this.answers),_this.solution,_this.audioData);
}

@override
String toString() {
  final _this = this as QuestionItem;
  return 'QuestionItem(text: ${_this.text}, answers: ${_this.answers}, solution: ${_this.solution}, audioData: ${_this.audioData})';
}


}

/// @nodoc
abstract mixin class $QuestionItemCopyWith<$Res>  {
  factory $QuestionItemCopyWith(QuestionItem value, $Res Function(QuestionItem) _then) = _$QuestionItemCopyWithImpl;
@useResult
$Res call({
 String text, List<Answer> answers, int solution, QuizAudioData? audioData
});


$QuizAudioDataCopyWith<$Res>? get audioData;

}
/// @nodoc
class _$QuestionItemCopyWithImpl<$Res>
    implements $QuestionItemCopyWith<$Res> {
  _$QuestionItemCopyWithImpl(this._self, this._then);

  final QuestionItem _self;
  final $Res Function(QuestionItem) _then;

/// Create a copy of QuestionItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? answers = null,Object? solution = null,Object? audioData = freezed,}) {
  return _then(QuestionItem(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as List<Answer>,solution: null == solution ? _self.solution : solution // ignore: cast_nullable_to_non_nullable
as int,audioData: freezed == audioData ? _self.audioData : audioData // ignore: cast_nullable_to_non_nullable
as QuizAudioData?,
  ));
}
/// Create a copy of QuestionItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuizAudioDataCopyWith<$Res>? get audioData {
    if (_self.audioData == null) {
    return null;
  }

  return $QuizAudioDataCopyWith<$Res>(_self.audioData!, (value) {
    return _then(_self.copyWith(audioData: value));
  });
}
}


/// Adds pattern-matching-related methods to [QuestionItem].
extension QuestionItemPatterns on QuestionItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestionItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestionItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestionItem value)  $default,){
final _that = this;
switch (_that) {
case _QuestionItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestionItem value)?  $default,){
final _that = this;
switch (_that) {
case _QuestionItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  List<Answer> answers,  int solution,  QuizAudioData? audioData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestionItem() when $default != null:
return $default(_that.text,_that.answers,_that.solution,_that.audioData);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  List<Answer> answers,  int solution,  QuizAudioData? audioData)  $default,) {final _that = this;
switch (_that) {
case _QuestionItem():
return $default(_that.text,_that.answers,_that.solution,_that.audioData);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  List<Answer> answers,  int solution,  QuizAudioData? audioData)?  $default,) {final _that = this;
switch (_that) {
case _QuestionItem() when $default != null:
return $default(_that.text,_that.answers,_that.solution,_that.audioData);case _:
  return null;

}
}

}

/// @nodoc


class _QuestionItem implements QuestionItem {
  const _QuestionItem({required this.text, required  List<Answer> answers, required this.solution, this.audioData}): _answers = answers;
  

@override final  String text;
 final  List<Answer> _answers;
@override List<Answer> get answers {
  if (_answers is EqualUnmodifiableListView) return _answers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_answers);
}

@override final  int solution;
@override final  QuizAudioData? audioData;

/// Create a copy of QuestionItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionItemCopyWith<_QuestionItem> get copyWith => __$QuestionItemCopyWithImpl<_QuestionItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionItem&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other.answers, _answers)&&(identical(other.solution, solution) || other.solution == solution)&&(identical(other.audioData, audioData) || other.audioData == audioData));
}


@override
int get hashCode {
    return Object.hash(runtimeType,text,const DeepCollectionEquality().hash(_answers),solution,audioData);
}

@override
String toString() {
    return 'QuestionItem(text: $text, answers: $answers, solution: $solution, audioData: $audioData)';
}


}

/// @nodoc
abstract mixin class _$QuestionItemCopyWith<$Res> implements $QuestionItemCopyWith<$Res> {
  factory _$QuestionItemCopyWith(_QuestionItem value, $Res Function(_QuestionItem) _then) = __$QuestionItemCopyWithImpl;
@override @useResult
$Res call({
 String text, List<Answer> answers, int solution, QuizAudioData? audioData
});


@override $QuizAudioDataCopyWith<$Res>? get audioData;

}
/// @nodoc
class __$QuestionItemCopyWithImpl<$Res>
    implements _$QuestionItemCopyWith<$Res> {
  __$QuestionItemCopyWithImpl(this._self, this._then);

  final _QuestionItem _self;
  final $Res Function(_QuestionItem) _then;

/// Create a copy of QuestionItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? answers = null,Object? solution = null,Object? audioData = freezed,}) {
  return _then(_QuestionItem(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,answers: null == answers ? _self._answers : answers // ignore: cast_nullable_to_non_nullable
as List<Answer>,solution: null == solution ? _self.solution : solution // ignore: cast_nullable_to_non_nullable
as int,audioData: freezed == audioData ? _self.audioData : audioData // ignore: cast_nullable_to_non_nullable
as QuizAudioData?,
  ));
}

/// Create a copy of QuestionItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuizAudioDataCopyWith<$Res>? get audioData {
    if (_self.audioData == null) {
    return null;
  }

  return $QuizAudioDataCopyWith<$Res>(_self.audioData!, (value) {
    return _then(_self.copyWith(audioData: value));
  });
}
}

// dart format on
