// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'editor_challenge_viewmodel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditorChallengeState {

 ChallengeFile get file; EditorPanel get panel; EditorBody get body; bool get testsRunning; bool get passed; String get hint; List<String> get testConsole; List<String> get userConsole; List<bool>? get testResults; int get resetCount;
/// Create a copy of EditorChallengeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditorChallengeStateCopyWith<EditorChallengeState> get copyWith => _$EditorChallengeStateCopyWithImpl<EditorChallengeState>(this as EditorChallengeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditorChallengeState&&(identical(other.file, file) || other.file == file)&&(identical(other.panel, panel) || other.panel == panel)&&(identical(other.body, body) || other.body == body)&&(identical(other.testsRunning, testsRunning) || other.testsRunning == testsRunning)&&(identical(other.passed, passed) || other.passed == passed)&&(identical(other.hint, hint) || other.hint == hint)&&const DeepCollectionEquality().equals(other.testConsole, testConsole)&&const DeepCollectionEquality().equals(other.userConsole, userConsole)&&const DeepCollectionEquality().equals(other.testResults, testResults)&&(identical(other.resetCount, resetCount) || other.resetCount == resetCount));
}


@override
int get hashCode => Object.hash(runtimeType,file,panel,body,testsRunning,passed,hint,const DeepCollectionEquality().hash(testConsole),const DeepCollectionEquality().hash(userConsole),const DeepCollectionEquality().hash(testResults),resetCount);

@override
String toString() {
  return 'EditorChallengeState(file: $file, panel: $panel, body: $body, testsRunning: $testsRunning, passed: $passed, hint: $hint, testConsole: $testConsole, userConsole: $userConsole, testResults: $testResults, resetCount: $resetCount)';
}


}

/// @nodoc
abstract mixin class $EditorChallengeStateCopyWith<$Res>  {
  factory $EditorChallengeStateCopyWith(EditorChallengeState value, $Res Function(EditorChallengeState) _then) = _$EditorChallengeStateCopyWithImpl;
@useResult
$Res call({
 ChallengeFile file, EditorPanel panel, EditorBody body, bool testsRunning, bool passed, String hint, List<String> testConsole, List<String> userConsole, List<bool>? testResults, int resetCount
});


$ChallengeFileCopyWith<$Res> get file;

}
/// @nodoc
class _$EditorChallengeStateCopyWithImpl<$Res>
    implements $EditorChallengeStateCopyWith<$Res> {
  _$EditorChallengeStateCopyWithImpl(this._self, this._then);

  final EditorChallengeState _self;
  final $Res Function(EditorChallengeState) _then;

/// Create a copy of EditorChallengeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? file = null,Object? panel = null,Object? body = null,Object? testsRunning = null,Object? passed = null,Object? hint = null,Object? testConsole = null,Object? userConsole = null,Object? testResults = freezed,Object? resetCount = null,}) {
  return _then(_self.copyWith(
file: null == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as ChallengeFile,panel: null == panel ? _self.panel : panel // ignore: cast_nullable_to_non_nullable
as EditorPanel,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as EditorBody,testsRunning: null == testsRunning ? _self.testsRunning : testsRunning // ignore: cast_nullable_to_non_nullable
as bool,passed: null == passed ? _self.passed : passed // ignore: cast_nullable_to_non_nullable
as bool,hint: null == hint ? _self.hint : hint // ignore: cast_nullable_to_non_nullable
as String,testConsole: null == testConsole ? _self.testConsole : testConsole // ignore: cast_nullable_to_non_nullable
as List<String>,userConsole: null == userConsole ? _self.userConsole : userConsole // ignore: cast_nullable_to_non_nullable
as List<String>,testResults: freezed == testResults ? _self.testResults : testResults // ignore: cast_nullable_to_non_nullable
as List<bool>?,resetCount: null == resetCount ? _self.resetCount : resetCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of EditorChallengeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChallengeFileCopyWith<$Res> get file {

  return $ChallengeFileCopyWith<$Res>(_self.file, (value) {
    return _then(_self.copyWith(file: value));
  });
}
}


/// Adds pattern-matching-related methods to [EditorChallengeState].
extension EditorChallengeStatePatterns on EditorChallengeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditorChallengeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditorChallengeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditorChallengeState value)  $default,){
final _that = this;
switch (_that) {
case _EditorChallengeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditorChallengeState value)?  $default,){
final _that = this;
switch (_that) {
case _EditorChallengeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ChallengeFile file,  EditorPanel panel,  EditorBody body,  bool testsRunning,  bool passed,  String hint,  List<String> testConsole,  List<String> userConsole,  List<bool>? testResults,  int resetCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditorChallengeState() when $default != null:
return $default(_that.file,_that.panel,_that.body,_that.testsRunning,_that.passed,_that.hint,_that.testConsole,_that.userConsole,_that.testResults,_that.resetCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ChallengeFile file,  EditorPanel panel,  EditorBody body,  bool testsRunning,  bool passed,  String hint,  List<String> testConsole,  List<String> userConsole,  List<bool>? testResults,  int resetCount)  $default,) {final _that = this;
switch (_that) {
case _EditorChallengeState():
return $default(_that.file,_that.panel,_that.body,_that.testsRunning,_that.passed,_that.hint,_that.testConsole,_that.userConsole,_that.testResults,_that.resetCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ChallengeFile file,  EditorPanel panel,  EditorBody body,  bool testsRunning,  bool passed,  String hint,  List<String> testConsole,  List<String> userConsole,  List<bool>? testResults,  int resetCount)?  $default,) {final _that = this;
switch (_that) {
case _EditorChallengeState() when $default != null:
return $default(_that.file,_that.panel,_that.body,_that.testsRunning,_that.passed,_that.hint,_that.testConsole,_that.userConsole,_that.testResults,_that.resetCount);case _:
  return null;

}
}

}

/// @nodoc


class _EditorChallengeState implements EditorChallengeState {
  const _EditorChallengeState({required this.file, this.panel = EditorPanel.instruction, this.body = EditorBody.editor, this.testsRunning = false, this.passed = false, this.hint = '', final  List<String> testConsole = const [], final  List<String> userConsole = const [], final  List<bool>? testResults, this.resetCount = 0}): _testConsole = testConsole,_userConsole = userConsole,_testResults = testResults;


@override final  ChallengeFile file;
@override@JsonKey() final  EditorPanel panel;
@override@JsonKey() final  EditorBody body;
@override@JsonKey() final  bool testsRunning;
@override@JsonKey() final  bool passed;
@override@JsonKey() final  String hint;
 final  List<String> _testConsole;
@override@JsonKey() List<String> get testConsole {
  if (_testConsole is EqualUnmodifiableListView) return _testConsole;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_testConsole);
}

 final  List<String> _userConsole;
@override@JsonKey() List<String> get userConsole {
  if (_userConsole is EqualUnmodifiableListView) return _userConsole;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_userConsole);
}

 final  List<bool>? _testResults;
@override List<bool>? get testResults {
  final value = _testResults;
  if (value == null) return null;
  if (_testResults is EqualUnmodifiableListView) return _testResults;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey() final  int resetCount;

/// Create a copy of EditorChallengeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditorChallengeStateCopyWith<_EditorChallengeState> get copyWith => __$EditorChallengeStateCopyWithImpl<_EditorChallengeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditorChallengeState&&(identical(other.file, file) || other.file == file)&&(identical(other.panel, panel) || other.panel == panel)&&(identical(other.body, body) || other.body == body)&&(identical(other.testsRunning, testsRunning) || other.testsRunning == testsRunning)&&(identical(other.passed, passed) || other.passed == passed)&&(identical(other.hint, hint) || other.hint == hint)&&const DeepCollectionEquality().equals(other._testConsole, _testConsole)&&const DeepCollectionEquality().equals(other._userConsole, _userConsole)&&const DeepCollectionEquality().equals(other._testResults, _testResults)&&(identical(other.resetCount, resetCount) || other.resetCount == resetCount));
}


@override
int get hashCode => Object.hash(runtimeType,file,panel,body,testsRunning,passed,hint,const DeepCollectionEquality().hash(_testConsole),const DeepCollectionEquality().hash(_userConsole),const DeepCollectionEquality().hash(_testResults),resetCount);

@override
String toString() {
  return 'EditorChallengeState(file: $file, panel: $panel, body: $body, testsRunning: $testsRunning, passed: $passed, hint: $hint, testConsole: $testConsole, userConsole: $userConsole, testResults: $testResults, resetCount: $resetCount)';
}


}

/// @nodoc
abstract mixin class _$EditorChallengeStateCopyWith<$Res> implements $EditorChallengeStateCopyWith<$Res> {
  factory _$EditorChallengeStateCopyWith(_EditorChallengeState value, $Res Function(_EditorChallengeState) _then) = __$EditorChallengeStateCopyWithImpl;
@override @useResult
$Res call({
 ChallengeFile file, EditorPanel panel, EditorBody body, bool testsRunning, bool passed, String hint, List<String> testConsole, List<String> userConsole, List<bool>? testResults, int resetCount
});


@override $ChallengeFileCopyWith<$Res> get file;

}
/// @nodoc
class __$EditorChallengeStateCopyWithImpl<$Res>
    implements _$EditorChallengeStateCopyWith<$Res> {
  __$EditorChallengeStateCopyWithImpl(this._self, this._then);

  final _EditorChallengeState _self;
  final $Res Function(_EditorChallengeState) _then;

/// Create a copy of EditorChallengeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? file = null,Object? panel = null,Object? body = null,Object? testsRunning = null,Object? passed = null,Object? hint = null,Object? testConsole = null,Object? userConsole = null,Object? testResults = freezed,Object? resetCount = null,}) {
  return _then(_EditorChallengeState(
file: null == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as ChallengeFile,panel: null == panel ? _self.panel : panel // ignore: cast_nullable_to_non_nullable
as EditorPanel,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as EditorBody,testsRunning: null == testsRunning ? _self.testsRunning : testsRunning // ignore: cast_nullable_to_non_nullable
as bool,passed: null == passed ? _self.passed : passed // ignore: cast_nullable_to_non_nullable
as bool,hint: null == hint ? _self.hint : hint // ignore: cast_nullable_to_non_nullable
as String,testConsole: null == testConsole ? _self._testConsole : testConsole // ignore: cast_nullable_to_non_nullable
as List<String>,userConsole: null == userConsole ? _self._userConsole : userConsole // ignore: cast_nullable_to_non_nullable
as List<String>,testResults: freezed == testResults ? _self._testResults : testResults // ignore: cast_nullable_to_non_nullable
as List<bool>?,resetCount: null == resetCount ? _self.resetCount : resetCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of EditorChallengeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChallengeFileCopyWith<$Res> get file {

  return $ChallengeFileCopyWith<$Res>(_self.file, (value) {
    return _then(_self.copyWith(file: value));
  });
}
}

// dart format on
