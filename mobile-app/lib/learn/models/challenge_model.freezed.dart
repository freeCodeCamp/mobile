// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'challenge_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Challenge {

 String get id; String get block; String get superBlock; String get title; String get dashedName; int get challengeType; String get helpCategory; String get description; String get instructions; String get explanation; String get transcript; String? get videoId; List<Question> get questions; List<String> get assignments; List<Quiz> get quizzes; List<Nodule> get nodules; FillInTheBlank? get fillInTheBlank; Scene? get scene; List<ChallengeTest> get tests; List<ChallengeFile> get challengeFiles; Hooks get hooks;
/// Create a copy of Challenge
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChallengeCopyWith<Challenge> get copyWith => _$ChallengeCopyWithImpl<Challenge>(this as Challenge, _$identity);

  /// Serializes this Challenge to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Challenge&&(identical(other.id, id) || other.id == id)&&(identical(other.block, block) || other.block == block)&&(identical(other.superBlock, superBlock) || other.superBlock == superBlock)&&(identical(other.title, title) || other.title == title)&&(identical(other.dashedName, dashedName) || other.dashedName == dashedName)&&(identical(other.challengeType, challengeType) || other.challengeType == challengeType)&&(identical(other.helpCategory, helpCategory) || other.helpCategory == helpCategory)&&(identical(other.description, description) || other.description == description)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.explanation, explanation) || other.explanation == explanation)&&(identical(other.transcript, transcript) || other.transcript == transcript)&&(identical(other.videoId, videoId) || other.videoId == videoId)&&const DeepCollectionEquality().equals(other.questions, questions)&&const DeepCollectionEquality().equals(other.assignments, assignments)&&const DeepCollectionEquality().equals(other.quizzes, quizzes)&&const DeepCollectionEquality().equals(other.nodules, nodules)&&(identical(other.fillInTheBlank, fillInTheBlank) || other.fillInTheBlank == fillInTheBlank)&&(identical(other.scene, scene) || other.scene == scene)&&const DeepCollectionEquality().equals(other.tests, tests)&&const DeepCollectionEquality().equals(other.challengeFiles, challengeFiles)&&(identical(other.hooks, hooks) || other.hooks == hooks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,block,superBlock,title,dashedName,challengeType,helpCategory,description,instructions,explanation,transcript,videoId,const DeepCollectionEquality().hash(questions),const DeepCollectionEquality().hash(assignments),const DeepCollectionEquality().hash(quizzes),const DeepCollectionEquality().hash(nodules),fillInTheBlank,scene,const DeepCollectionEquality().hash(tests),const DeepCollectionEquality().hash(challengeFiles),hooks]);

@override
String toString() {
  return 'Challenge(id: $id, block: $block, superBlock: $superBlock, title: $title, dashedName: $dashedName, challengeType: $challengeType, helpCategory: $helpCategory, description: $description, instructions: $instructions, explanation: $explanation, transcript: $transcript, videoId: $videoId, questions: $questions, assignments: $assignments, quizzes: $quizzes, nodules: $nodules, fillInTheBlank: $fillInTheBlank, scene: $scene, tests: $tests, challengeFiles: $challengeFiles, hooks: $hooks)';
}


}

/// @nodoc
abstract mixin class $ChallengeCopyWith<$Res>  {
  factory $ChallengeCopyWith(Challenge value, $Res Function(Challenge) _then) = _$ChallengeCopyWithImpl;
@useResult
$Res call({
 String id, String block, String superBlock, String title, String dashedName, int challengeType, String helpCategory, String description, String instructions, String explanation, String transcript, String? videoId, List<Question> questions, List<String> assignments, List<Quiz> quizzes, List<Nodule> nodules, FillInTheBlank? fillInTheBlank, Scene? scene, List<ChallengeTest> tests, List<ChallengeFile> challengeFiles, Hooks hooks
});


$FillInTheBlankCopyWith<$Res>? get fillInTheBlank;$SceneCopyWith<$Res>? get scene;$HooksCopyWith<$Res> get hooks;

}
/// @nodoc
class _$ChallengeCopyWithImpl<$Res>
    implements $ChallengeCopyWith<$Res> {
  _$ChallengeCopyWithImpl(this._self, this._then);

  final Challenge _self;
  final $Res Function(Challenge) _then;

/// Create a copy of Challenge
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? block = null,Object? superBlock = null,Object? title = null,Object? dashedName = null,Object? challengeType = null,Object? helpCategory = null,Object? description = null,Object? instructions = null,Object? explanation = null,Object? transcript = null,Object? videoId = freezed,Object? questions = null,Object? assignments = null,Object? quizzes = null,Object? nodules = null,Object? fillInTheBlank = freezed,Object? scene = freezed,Object? tests = null,Object? challengeFiles = null,Object? hooks = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,block: null == block ? _self.block : block // ignore: cast_nullable_to_non_nullable
as String,superBlock: null == superBlock ? _self.superBlock : superBlock // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,dashedName: null == dashedName ? _self.dashedName : dashedName // ignore: cast_nullable_to_non_nullable
as String,challengeType: null == challengeType ? _self.challengeType : challengeType // ignore: cast_nullable_to_non_nullable
as int,helpCategory: null == helpCategory ? _self.helpCategory : helpCategory // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String,explanation: null == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String,transcript: null == transcript ? _self.transcript : transcript // ignore: cast_nullable_to_non_nullable
as String,videoId: freezed == videoId ? _self.videoId : videoId // ignore: cast_nullable_to_non_nullable
as String?,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<Question>,assignments: null == assignments ? _self.assignments : assignments // ignore: cast_nullable_to_non_nullable
as List<String>,quizzes: null == quizzes ? _self.quizzes : quizzes // ignore: cast_nullable_to_non_nullable
as List<Quiz>,nodules: null == nodules ? _self.nodules : nodules // ignore: cast_nullable_to_non_nullable
as List<Nodule>,fillInTheBlank: freezed == fillInTheBlank ? _self.fillInTheBlank : fillInTheBlank // ignore: cast_nullable_to_non_nullable
as FillInTheBlank?,scene: freezed == scene ? _self.scene : scene // ignore: cast_nullable_to_non_nullable
as Scene?,tests: null == tests ? _self.tests : tests // ignore: cast_nullable_to_non_nullable
as List<ChallengeTest>,challengeFiles: null == challengeFiles ? _self.challengeFiles : challengeFiles // ignore: cast_nullable_to_non_nullable
as List<ChallengeFile>,hooks: null == hooks ? _self.hooks : hooks // ignore: cast_nullable_to_non_nullable
as Hooks,
  ));
}
/// Create a copy of Challenge
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FillInTheBlankCopyWith<$Res>? get fillInTheBlank {
    if (_self.fillInTheBlank == null) {
    return null;
  }

  return $FillInTheBlankCopyWith<$Res>(_self.fillInTheBlank!, (value) {
    return _then(_self.copyWith(fillInTheBlank: value));
  });
}/// Create a copy of Challenge
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SceneCopyWith<$Res>? get scene {
    if (_self.scene == null) {
    return null;
  }

  return $SceneCopyWith<$Res>(_self.scene!, (value) {
    return _then(_self.copyWith(scene: value));
  });
}/// Create a copy of Challenge
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HooksCopyWith<$Res> get hooks {
  
  return $HooksCopyWith<$Res>(_self.hooks, (value) {
    return _then(_self.copyWith(hooks: value));
  });
}
}


/// Adds pattern-matching-related methods to [Challenge].
extension ChallengePatterns on Challenge {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Challenge value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Challenge() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Challenge value)  $default,){
final _that = this;
switch (_that) {
case _Challenge():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Challenge value)?  $default,){
final _that = this;
switch (_that) {
case _Challenge() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String block,  String superBlock,  String title,  String dashedName,  int challengeType,  String helpCategory,  String description,  String instructions,  String explanation,  String transcript,  String? videoId,  List<Question> questions,  List<String> assignments,  List<Quiz> quizzes,  List<Nodule> nodules,  FillInTheBlank? fillInTheBlank,  Scene? scene,  List<ChallengeTest> tests,  List<ChallengeFile> challengeFiles,  Hooks hooks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Challenge() when $default != null:
return $default(_that.id,_that.block,_that.superBlock,_that.title,_that.dashedName,_that.challengeType,_that.helpCategory,_that.description,_that.instructions,_that.explanation,_that.transcript,_that.videoId,_that.questions,_that.assignments,_that.quizzes,_that.nodules,_that.fillInTheBlank,_that.scene,_that.tests,_that.challengeFiles,_that.hooks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String block,  String superBlock,  String title,  String dashedName,  int challengeType,  String helpCategory,  String description,  String instructions,  String explanation,  String transcript,  String? videoId,  List<Question> questions,  List<String> assignments,  List<Quiz> quizzes,  List<Nodule> nodules,  FillInTheBlank? fillInTheBlank,  Scene? scene,  List<ChallengeTest> tests,  List<ChallengeFile> challengeFiles,  Hooks hooks)  $default,) {final _that = this;
switch (_that) {
case _Challenge():
return $default(_that.id,_that.block,_that.superBlock,_that.title,_that.dashedName,_that.challengeType,_that.helpCategory,_that.description,_that.instructions,_that.explanation,_that.transcript,_that.videoId,_that.questions,_that.assignments,_that.quizzes,_that.nodules,_that.fillInTheBlank,_that.scene,_that.tests,_that.challengeFiles,_that.hooks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String block,  String superBlock,  String title,  String dashedName,  int challengeType,  String helpCategory,  String description,  String instructions,  String explanation,  String transcript,  String? videoId,  List<Question> questions,  List<String> assignments,  List<Quiz> quizzes,  List<Nodule> nodules,  FillInTheBlank? fillInTheBlank,  Scene? scene,  List<ChallengeTest> tests,  List<ChallengeFile> challengeFiles,  Hooks hooks)?  $default,) {final _that = this;
switch (_that) {
case _Challenge() when $default != null:
return $default(_that.id,_that.block,_that.superBlock,_that.title,_that.dashedName,_that.challengeType,_that.helpCategory,_that.description,_that.instructions,_that.explanation,_that.transcript,_that.videoId,_that.questions,_that.assignments,_that.quizzes,_that.nodules,_that.fillInTheBlank,_that.scene,_that.tests,_that.challengeFiles,_that.hooks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Challenge implements Challenge {
  const _Challenge({required this.id, required this.block, required this.superBlock, required this.title, required this.dashedName, required this.challengeType, this.helpCategory = '', this.description = '', this.instructions = '', this.explanation = '', this.transcript = '', this.videoId, final  List<Question> questions = const [], final  List<String> assignments = const [], final  List<Quiz> quizzes = const [], final  List<Nodule> nodules = const [], this.fillInTheBlank, this.scene, final  List<ChallengeTest> tests = const [], final  List<ChallengeFile> challengeFiles = const [], this.hooks = const Hooks()}): _questions = questions,_assignments = assignments,_quizzes = quizzes,_nodules = nodules,_tests = tests,_challengeFiles = challengeFiles;
  factory _Challenge.fromJson(Map<String, dynamic> json) => _$ChallengeFromJson(json);

@override final  String id;
@override final  String block;
@override final  String superBlock;
@override final  String title;
@override final  String dashedName;
@override final  int challengeType;
@override@JsonKey() final  String helpCategory;
@override@JsonKey() final  String description;
@override@JsonKey() final  String instructions;
@override@JsonKey() final  String explanation;
@override@JsonKey() final  String transcript;
@override final  String? videoId;
 final  List<Question> _questions;
@override@JsonKey() List<Question> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}

 final  List<String> _assignments;
@override@JsonKey() List<String> get assignments {
  if (_assignments is EqualUnmodifiableListView) return _assignments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assignments);
}

 final  List<Quiz> _quizzes;
@override@JsonKey() List<Quiz> get quizzes {
  if (_quizzes is EqualUnmodifiableListView) return _quizzes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_quizzes);
}

 final  List<Nodule> _nodules;
@override@JsonKey() List<Nodule> get nodules {
  if (_nodules is EqualUnmodifiableListView) return _nodules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_nodules);
}

@override final  FillInTheBlank? fillInTheBlank;
@override final  Scene? scene;
 final  List<ChallengeTest> _tests;
@override@JsonKey() List<ChallengeTest> get tests {
  if (_tests is EqualUnmodifiableListView) return _tests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tests);
}

 final  List<ChallengeFile> _challengeFiles;
@override@JsonKey() List<ChallengeFile> get challengeFiles {
  if (_challengeFiles is EqualUnmodifiableListView) return _challengeFiles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_challengeFiles);
}

@override@JsonKey() final  Hooks hooks;

/// Create a copy of Challenge
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChallengeCopyWith<_Challenge> get copyWith => __$ChallengeCopyWithImpl<_Challenge>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChallengeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Challenge&&(identical(other.id, id) || other.id == id)&&(identical(other.block, block) || other.block == block)&&(identical(other.superBlock, superBlock) || other.superBlock == superBlock)&&(identical(other.title, title) || other.title == title)&&(identical(other.dashedName, dashedName) || other.dashedName == dashedName)&&(identical(other.challengeType, challengeType) || other.challengeType == challengeType)&&(identical(other.helpCategory, helpCategory) || other.helpCategory == helpCategory)&&(identical(other.description, description) || other.description == description)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.explanation, explanation) || other.explanation == explanation)&&(identical(other.transcript, transcript) || other.transcript == transcript)&&(identical(other.videoId, videoId) || other.videoId == videoId)&&const DeepCollectionEquality().equals(other._questions, _questions)&&const DeepCollectionEquality().equals(other._assignments, _assignments)&&const DeepCollectionEquality().equals(other._quizzes, _quizzes)&&const DeepCollectionEquality().equals(other._nodules, _nodules)&&(identical(other.fillInTheBlank, fillInTheBlank) || other.fillInTheBlank == fillInTheBlank)&&(identical(other.scene, scene) || other.scene == scene)&&const DeepCollectionEquality().equals(other._tests, _tests)&&const DeepCollectionEquality().equals(other._challengeFiles, _challengeFiles)&&(identical(other.hooks, hooks) || other.hooks == hooks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,block,superBlock,title,dashedName,challengeType,helpCategory,description,instructions,explanation,transcript,videoId,const DeepCollectionEquality().hash(_questions),const DeepCollectionEquality().hash(_assignments),const DeepCollectionEquality().hash(_quizzes),const DeepCollectionEquality().hash(_nodules),fillInTheBlank,scene,const DeepCollectionEquality().hash(_tests),const DeepCollectionEquality().hash(_challengeFiles),hooks]);

@override
String toString() {
  return 'Challenge(id: $id, block: $block, superBlock: $superBlock, title: $title, dashedName: $dashedName, challengeType: $challengeType, helpCategory: $helpCategory, description: $description, instructions: $instructions, explanation: $explanation, transcript: $transcript, videoId: $videoId, questions: $questions, assignments: $assignments, quizzes: $quizzes, nodules: $nodules, fillInTheBlank: $fillInTheBlank, scene: $scene, tests: $tests, challengeFiles: $challengeFiles, hooks: $hooks)';
}


}

/// @nodoc
abstract mixin class _$ChallengeCopyWith<$Res> implements $ChallengeCopyWith<$Res> {
  factory _$ChallengeCopyWith(_Challenge value, $Res Function(_Challenge) _then) = __$ChallengeCopyWithImpl;
@override @useResult
$Res call({
 String id, String block, String superBlock, String title, String dashedName, int challengeType, String helpCategory, String description, String instructions, String explanation, String transcript, String? videoId, List<Question> questions, List<String> assignments, List<Quiz> quizzes, List<Nodule> nodules, FillInTheBlank? fillInTheBlank, Scene? scene, List<ChallengeTest> tests, List<ChallengeFile> challengeFiles, Hooks hooks
});


@override $FillInTheBlankCopyWith<$Res>? get fillInTheBlank;@override $SceneCopyWith<$Res>? get scene;@override $HooksCopyWith<$Res> get hooks;

}
/// @nodoc
class __$ChallengeCopyWithImpl<$Res>
    implements _$ChallengeCopyWith<$Res> {
  __$ChallengeCopyWithImpl(this._self, this._then);

  final _Challenge _self;
  final $Res Function(_Challenge) _then;

/// Create a copy of Challenge
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? block = null,Object? superBlock = null,Object? title = null,Object? dashedName = null,Object? challengeType = null,Object? helpCategory = null,Object? description = null,Object? instructions = null,Object? explanation = null,Object? transcript = null,Object? videoId = freezed,Object? questions = null,Object? assignments = null,Object? quizzes = null,Object? nodules = null,Object? fillInTheBlank = freezed,Object? scene = freezed,Object? tests = null,Object? challengeFiles = null,Object? hooks = null,}) {
  return _then(_Challenge(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,block: null == block ? _self.block : block // ignore: cast_nullable_to_non_nullable
as String,superBlock: null == superBlock ? _self.superBlock : superBlock // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,dashedName: null == dashedName ? _self.dashedName : dashedName // ignore: cast_nullable_to_non_nullable
as String,challengeType: null == challengeType ? _self.challengeType : challengeType // ignore: cast_nullable_to_non_nullable
as int,helpCategory: null == helpCategory ? _self.helpCategory : helpCategory // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String,explanation: null == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String,transcript: null == transcript ? _self.transcript : transcript // ignore: cast_nullable_to_non_nullable
as String,videoId: freezed == videoId ? _self.videoId : videoId // ignore: cast_nullable_to_non_nullable
as String?,questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<Question>,assignments: null == assignments ? _self._assignments : assignments // ignore: cast_nullable_to_non_nullable
as List<String>,quizzes: null == quizzes ? _self._quizzes : quizzes // ignore: cast_nullable_to_non_nullable
as List<Quiz>,nodules: null == nodules ? _self._nodules : nodules // ignore: cast_nullable_to_non_nullable
as List<Nodule>,fillInTheBlank: freezed == fillInTheBlank ? _self.fillInTheBlank : fillInTheBlank // ignore: cast_nullable_to_non_nullable
as FillInTheBlank?,scene: freezed == scene ? _self.scene : scene // ignore: cast_nullable_to_non_nullable
as Scene?,tests: null == tests ? _self._tests : tests // ignore: cast_nullable_to_non_nullable
as List<ChallengeTest>,challengeFiles: null == challengeFiles ? _self._challengeFiles : challengeFiles // ignore: cast_nullable_to_non_nullable
as List<ChallengeFile>,hooks: null == hooks ? _self.hooks : hooks // ignore: cast_nullable_to_non_nullable
as Hooks,
  ));
}

/// Create a copy of Challenge
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FillInTheBlankCopyWith<$Res>? get fillInTheBlank {
    if (_self.fillInTheBlank == null) {
    return null;
  }

  return $FillInTheBlankCopyWith<$Res>(_self.fillInTheBlank!, (value) {
    return _then(_self.copyWith(fillInTheBlank: value));
  });
}/// Create a copy of Challenge
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SceneCopyWith<$Res>? get scene {
    if (_self.scene == null) {
    return null;
  }

  return $SceneCopyWith<$Res>(_self.scene!, (value) {
    return _then(_self.copyWith(scene: value));
  });
}/// Create a copy of Challenge
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HooksCopyWith<$Res> get hooks {
  
  return $HooksCopyWith<$Res>(_self.hooks, (value) {
    return _then(_self.copyWith(hooks: value));
  });
}
}


/// @nodoc
mixin _$ChallengeTest {

 String get text; String get testString;
/// Create a copy of ChallengeTest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChallengeTestCopyWith<ChallengeTest> get copyWith => _$ChallengeTestCopyWithImpl<ChallengeTest>(this as ChallengeTest, _$identity);

  /// Serializes this ChallengeTest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChallengeTest&&(identical(other.text, text) || other.text == text)&&(identical(other.testString, testString) || other.testString == testString));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,testString);

@override
String toString() {
  return 'ChallengeTest(text: $text, testString: $testString)';
}


}

/// @nodoc
abstract mixin class $ChallengeTestCopyWith<$Res>  {
  factory $ChallengeTestCopyWith(ChallengeTest value, $Res Function(ChallengeTest) _then) = _$ChallengeTestCopyWithImpl;
@useResult
$Res call({
 String text, String testString
});




}
/// @nodoc
class _$ChallengeTestCopyWithImpl<$Res>
    implements $ChallengeTestCopyWith<$Res> {
  _$ChallengeTestCopyWithImpl(this._self, this._then);

  final ChallengeTest _self;
  final $Res Function(ChallengeTest) _then;

/// Create a copy of ChallengeTest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? testString = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,testString: null == testString ? _self.testString : testString // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChallengeTest].
extension ChallengeTestPatterns on ChallengeTest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChallengeTest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChallengeTest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChallengeTest value)  $default,){
final _that = this;
switch (_that) {
case _ChallengeTest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChallengeTest value)?  $default,){
final _that = this;
switch (_that) {
case _ChallengeTest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  String testString)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChallengeTest() when $default != null:
return $default(_that.text,_that.testString);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  String testString)  $default,) {final _that = this;
switch (_that) {
case _ChallengeTest():
return $default(_that.text,_that.testString);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  String testString)?  $default,) {final _that = this;
switch (_that) {
case _ChallengeTest() when $default != null:
return $default(_that.text,_that.testString);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChallengeTest implements ChallengeTest {
  const _ChallengeTest({required this.text, required this.testString});
  factory _ChallengeTest.fromJson(Map<String, dynamic> json) => _$ChallengeTestFromJson(json);

@override final  String text;
@override final  String testString;

/// Create a copy of ChallengeTest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChallengeTestCopyWith<_ChallengeTest> get copyWith => __$ChallengeTestCopyWithImpl<_ChallengeTest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChallengeTestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChallengeTest&&(identical(other.text, text) || other.text == text)&&(identical(other.testString, testString) || other.testString == testString));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,testString);

@override
String toString() {
  return 'ChallengeTest(text: $text, testString: $testString)';
}


}

/// @nodoc
abstract mixin class _$ChallengeTestCopyWith<$Res> implements $ChallengeTestCopyWith<$Res> {
  factory _$ChallengeTestCopyWith(_ChallengeTest value, $Res Function(_ChallengeTest) _then) = __$ChallengeTestCopyWithImpl;
@override @useResult
$Res call({
 String text, String testString
});




}
/// @nodoc
class __$ChallengeTestCopyWithImpl<$Res>
    implements _$ChallengeTestCopyWith<$Res> {
  __$ChallengeTestCopyWithImpl(this._self, this._then);

  final _ChallengeTest _self;
  final $Res Function(_ChallengeTest) _then;

/// Create a copy of ChallengeTest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? testString = null,}) {
  return _then(_ChallengeTest(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,testString: null == testString ? _self.testString : testString // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Hooks {

 String get beforeAll; String get beforeEach; String get afterEach;
/// Create a copy of Hooks
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HooksCopyWith<Hooks> get copyWith => _$HooksCopyWithImpl<Hooks>(this as Hooks, _$identity);

  /// Serializes this Hooks to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Hooks&&(identical(other.beforeAll, beforeAll) || other.beforeAll == beforeAll)&&(identical(other.beforeEach, beforeEach) || other.beforeEach == beforeEach)&&(identical(other.afterEach, afterEach) || other.afterEach == afterEach));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,beforeAll,beforeEach,afterEach);

@override
String toString() {
  return 'Hooks(beforeAll: $beforeAll, beforeEach: $beforeEach, afterEach: $afterEach)';
}


}

/// @nodoc
abstract mixin class $HooksCopyWith<$Res>  {
  factory $HooksCopyWith(Hooks value, $Res Function(Hooks) _then) = _$HooksCopyWithImpl;
@useResult
$Res call({
 String beforeAll, String beforeEach, String afterEach
});




}
/// @nodoc
class _$HooksCopyWithImpl<$Res>
    implements $HooksCopyWith<$Res> {
  _$HooksCopyWithImpl(this._self, this._then);

  final Hooks _self;
  final $Res Function(Hooks) _then;

/// Create a copy of Hooks
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? beforeAll = null,Object? beforeEach = null,Object? afterEach = null,}) {
  return _then(_self.copyWith(
beforeAll: null == beforeAll ? _self.beforeAll : beforeAll // ignore: cast_nullable_to_non_nullable
as String,beforeEach: null == beforeEach ? _self.beforeEach : beforeEach // ignore: cast_nullable_to_non_nullable
as String,afterEach: null == afterEach ? _self.afterEach : afterEach // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Hooks].
extension HooksPatterns on Hooks {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Hooks value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Hooks() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Hooks value)  $default,){
final _that = this;
switch (_that) {
case _Hooks():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Hooks value)?  $default,){
final _that = this;
switch (_that) {
case _Hooks() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String beforeAll,  String beforeEach,  String afterEach)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Hooks() when $default != null:
return $default(_that.beforeAll,_that.beforeEach,_that.afterEach);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String beforeAll,  String beforeEach,  String afterEach)  $default,) {final _that = this;
switch (_that) {
case _Hooks():
return $default(_that.beforeAll,_that.beforeEach,_that.afterEach);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String beforeAll,  String beforeEach,  String afterEach)?  $default,) {final _that = this;
switch (_that) {
case _Hooks() when $default != null:
return $default(_that.beforeAll,_that.beforeEach,_that.afterEach);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Hooks implements Hooks {
  const _Hooks({this.beforeAll = '', this.beforeEach = '', this.afterEach = ''});
  factory _Hooks.fromJson(Map<String, dynamic> json) => _$HooksFromJson(json);

@override@JsonKey() final  String beforeAll;
@override@JsonKey() final  String beforeEach;
@override@JsonKey() final  String afterEach;

/// Create a copy of Hooks
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HooksCopyWith<_Hooks> get copyWith => __$HooksCopyWithImpl<_Hooks>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HooksToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Hooks&&(identical(other.beforeAll, beforeAll) || other.beforeAll == beforeAll)&&(identical(other.beforeEach, beforeEach) || other.beforeEach == beforeEach)&&(identical(other.afterEach, afterEach) || other.afterEach == afterEach));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,beforeAll,beforeEach,afterEach);

@override
String toString() {
  return 'Hooks(beforeAll: $beforeAll, beforeEach: $beforeEach, afterEach: $afterEach)';
}


}

/// @nodoc
abstract mixin class _$HooksCopyWith<$Res> implements $HooksCopyWith<$Res> {
  factory _$HooksCopyWith(_Hooks value, $Res Function(_Hooks) _then) = __$HooksCopyWithImpl;
@override @useResult
$Res call({
 String beforeAll, String beforeEach, String afterEach
});




}
/// @nodoc
class __$HooksCopyWithImpl<$Res>
    implements _$HooksCopyWith<$Res> {
  __$HooksCopyWithImpl(this._self, this._then);

  final _Hooks _self;
  final $Res Function(_Hooks) _then;

/// Create a copy of Hooks
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? beforeAll = null,Object? beforeEach = null,Object? afterEach = null,}) {
  return _then(_Hooks(
beforeAll: null == beforeAll ? _self.beforeAll : beforeAll // ignore: cast_nullable_to_non_nullable
as String,beforeEach: null == beforeEach ? _self.beforeEach : beforeEach // ignore: cast_nullable_to_non_nullable
as String,afterEach: null == afterEach ? _self.afterEach : afterEach // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Question {

 String get text; List<Answer> get answers; int get solution;
/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionCopyWith<Question> get copyWith => _$QuestionCopyWithImpl<Question>(this as Question, _$identity);

  /// Serializes this Question to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Question&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other.answers, answers)&&(identical(other.solution, solution) || other.solution == solution));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,const DeepCollectionEquality().hash(answers),solution);

@override
String toString() {
  return 'Question(text: $text, answers: $answers, solution: $solution)';
}


}

/// @nodoc
abstract mixin class $QuestionCopyWith<$Res>  {
  factory $QuestionCopyWith(Question value, $Res Function(Question) _then) = _$QuestionCopyWithImpl;
@useResult
$Res call({
 String text, List<Answer> answers, int solution
});




}
/// @nodoc
class _$QuestionCopyWithImpl<$Res>
    implements $QuestionCopyWith<$Res> {
  _$QuestionCopyWithImpl(this._self, this._then);

  final Question _self;
  final $Res Function(Question) _then;

/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? answers = null,Object? solution = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as List<Answer>,solution: null == solution ? _self.solution : solution // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Question].
extension QuestionPatterns on Question {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Question value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Question() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Question value)  $default,){
final _that = this;
switch (_that) {
case _Question():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Question value)?  $default,){
final _that = this;
switch (_that) {
case _Question() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  List<Answer> answers,  int solution)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Question() when $default != null:
return $default(_that.text,_that.answers,_that.solution);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  List<Answer> answers,  int solution)  $default,) {final _that = this;
switch (_that) {
case _Question():
return $default(_that.text,_that.answers,_that.solution);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  List<Answer> answers,  int solution)?  $default,) {final _that = this;
switch (_that) {
case _Question() when $default != null:
return $default(_that.text,_that.answers,_that.solution);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Question implements Question {
  const _Question({required this.text, required final  List<Answer> answers, required this.solution}): _answers = answers;
  factory _Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);

@override final  String text;
 final  List<Answer> _answers;
@override List<Answer> get answers {
  if (_answers is EqualUnmodifiableListView) return _answers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_answers);
}

@override final  int solution;

/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionCopyWith<_Question> get copyWith => __$QuestionCopyWithImpl<_Question>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Question&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other._answers, _answers)&&(identical(other.solution, solution) || other.solution == solution));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,const DeepCollectionEquality().hash(_answers),solution);

@override
String toString() {
  return 'Question(text: $text, answers: $answers, solution: $solution)';
}


}

/// @nodoc
abstract mixin class _$QuestionCopyWith<$Res> implements $QuestionCopyWith<$Res> {
  factory _$QuestionCopyWith(_Question value, $Res Function(_Question) _then) = __$QuestionCopyWithImpl;
@override @useResult
$Res call({
 String text, List<Answer> answers, int solution
});




}
/// @nodoc
class __$QuestionCopyWithImpl<$Res>
    implements _$QuestionCopyWith<$Res> {
  __$QuestionCopyWithImpl(this._self, this._then);

  final _Question _self;
  final $Res Function(_Question) _then;

/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? answers = null,Object? solution = null,}) {
  return _then(_Question(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,answers: null == answers ? _self._answers : answers // ignore: cast_nullable_to_non_nullable
as List<Answer>,solution: null == solution ? _self.solution : solution // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Answer {

 String get answer; String? get feedback;
/// Create a copy of Answer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnswerCopyWith<Answer> get copyWith => _$AnswerCopyWithImpl<Answer>(this as Answer, _$identity);

  /// Serializes this Answer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Answer&&(identical(other.answer, answer) || other.answer == answer)&&(identical(other.feedback, feedback) || other.feedback == feedback));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,answer,feedback);

@override
String toString() {
  return 'Answer(answer: $answer, feedback: $feedback)';
}


}

/// @nodoc
abstract mixin class $AnswerCopyWith<$Res>  {
  factory $AnswerCopyWith(Answer value, $Res Function(Answer) _then) = _$AnswerCopyWithImpl;
@useResult
$Res call({
 String answer, String? feedback
});




}
/// @nodoc
class _$AnswerCopyWithImpl<$Res>
    implements $AnswerCopyWith<$Res> {
  _$AnswerCopyWithImpl(this._self, this._then);

  final Answer _self;
  final $Res Function(Answer) _then;

/// Create a copy of Answer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? answer = null,Object? feedback = freezed,}) {
  return _then(_self.copyWith(
answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,feedback: freezed == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Answer].
extension AnswerPatterns on Answer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Answer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Answer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Answer value)  $default,){
final _that = this;
switch (_that) {
case _Answer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Answer value)?  $default,){
final _that = this;
switch (_that) {
case _Answer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String answer,  String? feedback)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Answer() when $default != null:
return $default(_that.answer,_that.feedback);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String answer,  String? feedback)  $default,) {final _that = this;
switch (_that) {
case _Answer():
return $default(_that.answer,_that.feedback);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String answer,  String? feedback)?  $default,) {final _that = this;
switch (_that) {
case _Answer() when $default != null:
return $default(_that.answer,_that.feedback);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Answer implements Answer {
  const _Answer({required this.answer, this.feedback});
  factory _Answer.fromJson(Map<String, dynamic> json) => _$AnswerFromJson(json);

@override final  String answer;
@override final  String? feedback;

/// Create a copy of Answer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnswerCopyWith<_Answer> get copyWith => __$AnswerCopyWithImpl<_Answer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnswerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Answer&&(identical(other.answer, answer) || other.answer == answer)&&(identical(other.feedback, feedback) || other.feedback == feedback));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,answer,feedback);

@override
String toString() {
  return 'Answer(answer: $answer, feedback: $feedback)';
}


}

/// @nodoc
abstract mixin class _$AnswerCopyWith<$Res> implements $AnswerCopyWith<$Res> {
  factory _$AnswerCopyWith(_Answer value, $Res Function(_Answer) _then) = __$AnswerCopyWithImpl;
@override @useResult
$Res call({
 String answer, String? feedback
});




}
/// @nodoc
class __$AnswerCopyWithImpl<$Res>
    implements _$AnswerCopyWith<$Res> {
  __$AnswerCopyWithImpl(this._self, this._then);

  final _Answer _self;
  final $Res Function(_Answer) _then;

/// Create a copy of Answer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? answer = null,Object? feedback = freezed,}) {
  return _then(_Answer(
answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,feedback: freezed == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Quiz {

 List<QuizQuestion> get questions;
/// Create a copy of Quiz
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizCopyWith<Quiz> get copyWith => _$QuizCopyWithImpl<Quiz>(this as Quiz, _$identity);

  /// Serializes this Quiz to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Quiz&&const DeepCollectionEquality().equals(other.questions, questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(questions));

@override
String toString() {
  return 'Quiz(questions: $questions)';
}


}

/// @nodoc
abstract mixin class $QuizCopyWith<$Res>  {
  factory $QuizCopyWith(Quiz value, $Res Function(Quiz) _then) = _$QuizCopyWithImpl;
@useResult
$Res call({
 List<QuizQuestion> questions
});




}
/// @nodoc
class _$QuizCopyWithImpl<$Res>
    implements $QuizCopyWith<$Res> {
  _$QuizCopyWithImpl(this._self, this._then);

  final Quiz _self;
  final $Res Function(Quiz) _then;

/// Create a copy of Quiz
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questions = null,}) {
  return _then(_self.copyWith(
questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<QuizQuestion>,
  ));
}

}


/// Adds pattern-matching-related methods to [Quiz].
extension QuizPatterns on Quiz {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Quiz value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Quiz() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Quiz value)  $default,){
final _that = this;
switch (_that) {
case _Quiz():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Quiz value)?  $default,){
final _that = this;
switch (_that) {
case _Quiz() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<QuizQuestion> questions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Quiz() when $default != null:
return $default(_that.questions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<QuizQuestion> questions)  $default,) {final _that = this;
switch (_that) {
case _Quiz():
return $default(_that.questions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<QuizQuestion> questions)?  $default,) {final _that = this;
switch (_that) {
case _Quiz() when $default != null:
return $default(_that.questions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Quiz implements Quiz {
  const _Quiz({required final  List<QuizQuestion> questions}): _questions = questions;
  factory _Quiz.fromJson(Map<String, dynamic> json) => _$QuizFromJson(json);

 final  List<QuizQuestion> _questions;
@override List<QuizQuestion> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}


/// Create a copy of Quiz
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizCopyWith<_Quiz> get copyWith => __$QuizCopyWithImpl<_Quiz>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuizToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Quiz&&const DeepCollectionEquality().equals(other._questions, _questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_questions));

@override
String toString() {
  return 'Quiz(questions: $questions)';
}


}

/// @nodoc
abstract mixin class _$QuizCopyWith<$Res> implements $QuizCopyWith<$Res> {
  factory _$QuizCopyWith(_Quiz value, $Res Function(_Quiz) _then) = __$QuizCopyWithImpl;
@override @useResult
$Res call({
 List<QuizQuestion> questions
});




}
/// @nodoc
class __$QuizCopyWithImpl<$Res>
    implements _$QuizCopyWith<$Res> {
  __$QuizCopyWithImpl(this._self, this._then);

  final _Quiz _self;
  final $Res Function(_Quiz) _then;

/// Create a copy of Quiz
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questions = null,}) {
  return _then(_Quiz(
questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<QuizQuestion>,
  ));
}


}


/// @nodoc
mixin _$QuizQuestion {

 String get text; String get answer; List<String> get distractors; QuizAudioData? get audioData;
/// Create a copy of QuizQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizQuestionCopyWith<QuizQuestion> get copyWith => _$QuizQuestionCopyWithImpl<QuizQuestion>(this as QuizQuestion, _$identity);

  /// Serializes this QuizQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizQuestion&&(identical(other.text, text) || other.text == text)&&(identical(other.answer, answer) || other.answer == answer)&&const DeepCollectionEquality().equals(other.distractors, distractors)&&(identical(other.audioData, audioData) || other.audioData == audioData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,answer,const DeepCollectionEquality().hash(distractors),audioData);

@override
String toString() {
  return 'QuizQuestion(text: $text, answer: $answer, distractors: $distractors, audioData: $audioData)';
}


}

/// @nodoc
abstract mixin class $QuizQuestionCopyWith<$Res>  {
  factory $QuizQuestionCopyWith(QuizQuestion value, $Res Function(QuizQuestion) _then) = _$QuizQuestionCopyWithImpl;
@useResult
$Res call({
 String text, String answer, List<String> distractors, QuizAudioData? audioData
});


$QuizAudioDataCopyWith<$Res>? get audioData;

}
/// @nodoc
class _$QuizQuestionCopyWithImpl<$Res>
    implements $QuizQuestionCopyWith<$Res> {
  _$QuizQuestionCopyWithImpl(this._self, this._then);

  final QuizQuestion _self;
  final $Res Function(QuizQuestion) _then;

/// Create a copy of QuizQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? answer = null,Object? distractors = null,Object? audioData = freezed,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,distractors: null == distractors ? _self.distractors : distractors // ignore: cast_nullable_to_non_nullable
as List<String>,audioData: freezed == audioData ? _self.audioData : audioData // ignore: cast_nullable_to_non_nullable
as QuizAudioData?,
  ));
}
/// Create a copy of QuizQuestion
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


/// Adds pattern-matching-related methods to [QuizQuestion].
extension QuizQuestionPatterns on QuizQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizQuestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizQuestion value)  $default,){
final _that = this;
switch (_that) {
case _QuizQuestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _QuizQuestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  String answer,  List<String> distractors,  QuizAudioData? audioData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizQuestion() when $default != null:
return $default(_that.text,_that.answer,_that.distractors,_that.audioData);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  String answer,  List<String> distractors,  QuizAudioData? audioData)  $default,) {final _that = this;
switch (_that) {
case _QuizQuestion():
return $default(_that.text,_that.answer,_that.distractors,_that.audioData);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  String answer,  List<String> distractors,  QuizAudioData? audioData)?  $default,) {final _that = this;
switch (_that) {
case _QuizQuestion() when $default != null:
return $default(_that.text,_that.answer,_that.distractors,_that.audioData);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuizQuestion implements QuizQuestion {
  const _QuizQuestion({required this.text, required this.answer, required final  List<String> distractors, this.audioData}): _distractors = distractors;
  factory _QuizQuestion.fromJson(Map<String, dynamic> json) => _$QuizQuestionFromJson(json);

@override final  String text;
@override final  String answer;
 final  List<String> _distractors;
@override List<String> get distractors {
  if (_distractors is EqualUnmodifiableListView) return _distractors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_distractors);
}

@override final  QuizAudioData? audioData;

/// Create a copy of QuizQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizQuestionCopyWith<_QuizQuestion> get copyWith => __$QuizQuestionCopyWithImpl<_QuizQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuizQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizQuestion&&(identical(other.text, text) || other.text == text)&&(identical(other.answer, answer) || other.answer == answer)&&const DeepCollectionEquality().equals(other._distractors, _distractors)&&(identical(other.audioData, audioData) || other.audioData == audioData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,answer,const DeepCollectionEquality().hash(_distractors),audioData);

@override
String toString() {
  return 'QuizQuestion(text: $text, answer: $answer, distractors: $distractors, audioData: $audioData)';
}


}

/// @nodoc
abstract mixin class _$QuizQuestionCopyWith<$Res> implements $QuizQuestionCopyWith<$Res> {
  factory _$QuizQuestionCopyWith(_QuizQuestion value, $Res Function(_QuizQuestion) _then) = __$QuizQuestionCopyWithImpl;
@override @useResult
$Res call({
 String text, String answer, List<String> distractors, QuizAudioData? audioData
});


@override $QuizAudioDataCopyWith<$Res>? get audioData;

}
/// @nodoc
class __$QuizQuestionCopyWithImpl<$Res>
    implements _$QuizQuestionCopyWith<$Res> {
  __$QuizQuestionCopyWithImpl(this._self, this._then);

  final _QuizQuestion _self;
  final $Res Function(_QuizQuestion) _then;

/// Create a copy of QuizQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? answer = null,Object? distractors = null,Object? audioData = freezed,}) {
  return _then(_QuizQuestion(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,distractors: null == distractors ? _self._distractors : distractors // ignore: cast_nullable_to_non_nullable
as List<String>,audioData: freezed == audioData ? _self.audioData : audioData // ignore: cast_nullable_to_non_nullable
as QuizAudioData?,
  ));
}

/// Create a copy of QuizQuestion
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


/// @nodoc
mixin _$QuizAudioData {

 AudioClip get audio; List<TranscriptLine> get transcript;
/// Create a copy of QuizAudioData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizAudioDataCopyWith<QuizAudioData> get copyWith => _$QuizAudioDataCopyWithImpl<QuizAudioData>(this as QuizAudioData, _$identity);

  /// Serializes this QuizAudioData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizAudioData&&(identical(other.audio, audio) || other.audio == audio)&&const DeepCollectionEquality().equals(other.transcript, transcript));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,audio,const DeepCollectionEquality().hash(transcript));

@override
String toString() {
  return 'QuizAudioData(audio: $audio, transcript: $transcript)';
}


}

/// @nodoc
abstract mixin class $QuizAudioDataCopyWith<$Res>  {
  factory $QuizAudioDataCopyWith(QuizAudioData value, $Res Function(QuizAudioData) _then) = _$QuizAudioDataCopyWithImpl;
@useResult
$Res call({
 AudioClip audio, List<TranscriptLine> transcript
});


$AudioClipCopyWith<$Res> get audio;

}
/// @nodoc
class _$QuizAudioDataCopyWithImpl<$Res>
    implements $QuizAudioDataCopyWith<$Res> {
  _$QuizAudioDataCopyWithImpl(this._self, this._then);

  final QuizAudioData _self;
  final $Res Function(QuizAudioData) _then;

/// Create a copy of QuizAudioData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? audio = null,Object? transcript = null,}) {
  return _then(_self.copyWith(
audio: null == audio ? _self.audio : audio // ignore: cast_nullable_to_non_nullable
as AudioClip,transcript: null == transcript ? _self.transcript : transcript // ignore: cast_nullable_to_non_nullable
as List<TranscriptLine>,
  ));
}
/// Create a copy of QuizAudioData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AudioClipCopyWith<$Res> get audio {
  
  return $AudioClipCopyWith<$Res>(_self.audio, (value) {
    return _then(_self.copyWith(audio: value));
  });
}
}


/// Adds pattern-matching-related methods to [QuizAudioData].
extension QuizAudioDataPatterns on QuizAudioData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizAudioData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizAudioData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizAudioData value)  $default,){
final _that = this;
switch (_that) {
case _QuizAudioData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizAudioData value)?  $default,){
final _that = this;
switch (_that) {
case _QuizAudioData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AudioClip audio,  List<TranscriptLine> transcript)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizAudioData() when $default != null:
return $default(_that.audio,_that.transcript);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AudioClip audio,  List<TranscriptLine> transcript)  $default,) {final _that = this;
switch (_that) {
case _QuizAudioData():
return $default(_that.audio,_that.transcript);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AudioClip audio,  List<TranscriptLine> transcript)?  $default,) {final _that = this;
switch (_that) {
case _QuizAudioData() when $default != null:
return $default(_that.audio,_that.transcript);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuizAudioData implements QuizAudioData {
  const _QuizAudioData({required this.audio, final  List<TranscriptLine> transcript = const []}): _transcript = transcript;
  factory _QuizAudioData.fromJson(Map<String, dynamic> json) => _$QuizAudioDataFromJson(json);

@override final  AudioClip audio;
 final  List<TranscriptLine> _transcript;
@override@JsonKey() List<TranscriptLine> get transcript {
  if (_transcript is EqualUnmodifiableListView) return _transcript;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transcript);
}


/// Create a copy of QuizAudioData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizAudioDataCopyWith<_QuizAudioData> get copyWith => __$QuizAudioDataCopyWithImpl<_QuizAudioData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuizAudioDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizAudioData&&(identical(other.audio, audio) || other.audio == audio)&&const DeepCollectionEquality().equals(other._transcript, _transcript));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,audio,const DeepCollectionEquality().hash(_transcript));

@override
String toString() {
  return 'QuizAudioData(audio: $audio, transcript: $transcript)';
}


}

/// @nodoc
abstract mixin class _$QuizAudioDataCopyWith<$Res> implements $QuizAudioDataCopyWith<$Res> {
  factory _$QuizAudioDataCopyWith(_QuizAudioData value, $Res Function(_QuizAudioData) _then) = __$QuizAudioDataCopyWithImpl;
@override @useResult
$Res call({
 AudioClip audio, List<TranscriptLine> transcript
});


@override $AudioClipCopyWith<$Res> get audio;

}
/// @nodoc
class __$QuizAudioDataCopyWithImpl<$Res>
    implements _$QuizAudioDataCopyWith<$Res> {
  __$QuizAudioDataCopyWithImpl(this._self, this._then);

  final _QuizAudioData _self;
  final $Res Function(_QuizAudioData) _then;

/// Create a copy of QuizAudioData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? audio = null,Object? transcript = null,}) {
  return _then(_QuizAudioData(
audio: null == audio ? _self.audio : audio // ignore: cast_nullable_to_non_nullable
as AudioClip,transcript: null == transcript ? _self._transcript : transcript // ignore: cast_nullable_to_non_nullable
as List<TranscriptLine>,
  ));
}

/// Create a copy of QuizAudioData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AudioClipCopyWith<$Res> get audio {
  
  return $AudioClipCopyWith<$Res>(_self.audio, (value) {
    return _then(_self.copyWith(audio: value));
  });
}
}


/// @nodoc
mixin _$TranscriptLine {

 String get character; String get text;
/// Create a copy of TranscriptLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TranscriptLineCopyWith<TranscriptLine> get copyWith => _$TranscriptLineCopyWithImpl<TranscriptLine>(this as TranscriptLine, _$identity);

  /// Serializes this TranscriptLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TranscriptLine&&(identical(other.character, character) || other.character == character)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,character,text);

@override
String toString() {
  return 'TranscriptLine(character: $character, text: $text)';
}


}

/// @nodoc
abstract mixin class $TranscriptLineCopyWith<$Res>  {
  factory $TranscriptLineCopyWith(TranscriptLine value, $Res Function(TranscriptLine) _then) = _$TranscriptLineCopyWithImpl;
@useResult
$Res call({
 String character, String text
});




}
/// @nodoc
class _$TranscriptLineCopyWithImpl<$Res>
    implements $TranscriptLineCopyWith<$Res> {
  _$TranscriptLineCopyWithImpl(this._self, this._then);

  final TranscriptLine _self;
  final $Res Function(TranscriptLine) _then;

/// Create a copy of TranscriptLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? character = null,Object? text = null,}) {
  return _then(_self.copyWith(
character: null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TranscriptLine].
extension TranscriptLinePatterns on TranscriptLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TranscriptLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TranscriptLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TranscriptLine value)  $default,){
final _that = this;
switch (_that) {
case _TranscriptLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TranscriptLine value)?  $default,){
final _that = this;
switch (_that) {
case _TranscriptLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String character,  String text)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TranscriptLine() when $default != null:
return $default(_that.character,_that.text);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String character,  String text)  $default,) {final _that = this;
switch (_that) {
case _TranscriptLine():
return $default(_that.character,_that.text);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String character,  String text)?  $default,) {final _that = this;
switch (_that) {
case _TranscriptLine() when $default != null:
return $default(_that.character,_that.text);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TranscriptLine implements TranscriptLine {
  const _TranscriptLine({required this.character, required this.text});
  factory _TranscriptLine.fromJson(Map<String, dynamic> json) => _$TranscriptLineFromJson(json);

@override final  String character;
@override final  String text;

/// Create a copy of TranscriptLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TranscriptLineCopyWith<_TranscriptLine> get copyWith => __$TranscriptLineCopyWithImpl<_TranscriptLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TranscriptLineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TranscriptLine&&(identical(other.character, character) || other.character == character)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,character,text);

@override
String toString() {
  return 'TranscriptLine(character: $character, text: $text)';
}


}

/// @nodoc
abstract mixin class _$TranscriptLineCopyWith<$Res> implements $TranscriptLineCopyWith<$Res> {
  factory _$TranscriptLineCopyWith(_TranscriptLine value, $Res Function(_TranscriptLine) _then) = __$TranscriptLineCopyWithImpl;
@override @useResult
$Res call({
 String character, String text
});




}
/// @nodoc
class __$TranscriptLineCopyWithImpl<$Res>
    implements _$TranscriptLineCopyWith<$Res> {
  __$TranscriptLineCopyWithImpl(this._self, this._then);

  final _TranscriptLine _self;
  final $Res Function(_TranscriptLine) _then;

/// Create a copy of TranscriptLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? character = null,Object? text = null,}) {
  return _then(_TranscriptLine(
character: null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AudioClip {

 String get filename; num get startTime; num? get startTimestamp; num? get finishTimestamp;
/// Create a copy of AudioClip
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudioClipCopyWith<AudioClip> get copyWith => _$AudioClipCopyWithImpl<AudioClip>(this as AudioClip, _$identity);

  /// Serializes this AudioClip to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudioClip&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.startTimestamp, startTimestamp) || other.startTimestamp == startTimestamp)&&(identical(other.finishTimestamp, finishTimestamp) || other.finishTimestamp == finishTimestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,filename,startTime,startTimestamp,finishTimestamp);

@override
String toString() {
  return 'AudioClip(filename: $filename, startTime: $startTime, startTimestamp: $startTimestamp, finishTimestamp: $finishTimestamp)';
}


}

/// @nodoc
abstract mixin class $AudioClipCopyWith<$Res>  {
  factory $AudioClipCopyWith(AudioClip value, $Res Function(AudioClip) _then) = _$AudioClipCopyWithImpl;
@useResult
$Res call({
 String filename, num startTime, num? startTimestamp, num? finishTimestamp
});




}
/// @nodoc
class _$AudioClipCopyWithImpl<$Res>
    implements $AudioClipCopyWith<$Res> {
  _$AudioClipCopyWithImpl(this._self, this._then);

  final AudioClip _self;
  final $Res Function(AudioClip) _then;

/// Create a copy of AudioClip
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? filename = null,Object? startTime = null,Object? startTimestamp = freezed,Object? finishTimestamp = freezed,}) {
  return _then(_self.copyWith(
filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as num,startTimestamp: freezed == startTimestamp ? _self.startTimestamp : startTimestamp // ignore: cast_nullable_to_non_nullable
as num?,finishTimestamp: freezed == finishTimestamp ? _self.finishTimestamp : finishTimestamp // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

}


/// Adds pattern-matching-related methods to [AudioClip].
extension AudioClipPatterns on AudioClip {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AudioClip value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AudioClip() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AudioClip value)  $default,){
final _that = this;
switch (_that) {
case _AudioClip():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AudioClip value)?  $default,){
final _that = this;
switch (_that) {
case _AudioClip() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String filename,  num startTime,  num? startTimestamp,  num? finishTimestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AudioClip() when $default != null:
return $default(_that.filename,_that.startTime,_that.startTimestamp,_that.finishTimestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String filename,  num startTime,  num? startTimestamp,  num? finishTimestamp)  $default,) {final _that = this;
switch (_that) {
case _AudioClip():
return $default(_that.filename,_that.startTime,_that.startTimestamp,_that.finishTimestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String filename,  num startTime,  num? startTimestamp,  num? finishTimestamp)?  $default,) {final _that = this;
switch (_that) {
case _AudioClip() when $default != null:
return $default(_that.filename,_that.startTime,_that.startTimestamp,_that.finishTimestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AudioClip extends AudioClip {
  const _AudioClip({required this.filename, this.startTime = 0, this.startTimestamp, this.finishTimestamp}): super._();
  factory _AudioClip.fromJson(Map<String, dynamic> json) => _$AudioClipFromJson(json);

@override final  String filename;
@override@JsonKey() final  num startTime;
@override final  num? startTimestamp;
@override final  num? finishTimestamp;

/// Create a copy of AudioClip
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AudioClipCopyWith<_AudioClip> get copyWith => __$AudioClipCopyWithImpl<_AudioClip>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AudioClipToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AudioClip&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.startTimestamp, startTimestamp) || other.startTimestamp == startTimestamp)&&(identical(other.finishTimestamp, finishTimestamp) || other.finishTimestamp == finishTimestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,filename,startTime,startTimestamp,finishTimestamp);

@override
String toString() {
  return 'AudioClip(filename: $filename, startTime: $startTime, startTimestamp: $startTimestamp, finishTimestamp: $finishTimestamp)';
}


}

/// @nodoc
abstract mixin class _$AudioClipCopyWith<$Res> implements $AudioClipCopyWith<$Res> {
  factory _$AudioClipCopyWith(_AudioClip value, $Res Function(_AudioClip) _then) = __$AudioClipCopyWithImpl;
@override @useResult
$Res call({
 String filename, num startTime, num? startTimestamp, num? finishTimestamp
});




}
/// @nodoc
class __$AudioClipCopyWithImpl<$Res>
    implements _$AudioClipCopyWith<$Res> {
  __$AudioClipCopyWithImpl(this._self, this._then);

  final _AudioClip _self;
  final $Res Function(_AudioClip) _then;

/// Create a copy of AudioClip
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? filename = null,Object? startTime = null,Object? startTimestamp = freezed,Object? finishTimestamp = freezed,}) {
  return _then(_AudioClip(
filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as num,startTimestamp: freezed == startTimestamp ? _self.startTimestamp : startTimestamp // ignore: cast_nullable_to_non_nullable
as num?,finishTimestamp: freezed == finishTimestamp ? _self.finishTimestamp : finishTimestamp // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}


}


/// @nodoc
mixin _$FillInTheBlank {

 String get sentence; List<Blank> get blanks;
/// Create a copy of FillInTheBlank
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FillInTheBlankCopyWith<FillInTheBlank> get copyWith => _$FillInTheBlankCopyWithImpl<FillInTheBlank>(this as FillInTheBlank, _$identity);

  /// Serializes this FillInTheBlank to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FillInTheBlank&&(identical(other.sentence, sentence) || other.sentence == sentence)&&const DeepCollectionEquality().equals(other.blanks, blanks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sentence,const DeepCollectionEquality().hash(blanks));

@override
String toString() {
  return 'FillInTheBlank(sentence: $sentence, blanks: $blanks)';
}


}

/// @nodoc
abstract mixin class $FillInTheBlankCopyWith<$Res>  {
  factory $FillInTheBlankCopyWith(FillInTheBlank value, $Res Function(FillInTheBlank) _then) = _$FillInTheBlankCopyWithImpl;
@useResult
$Res call({
 String sentence, List<Blank> blanks
});




}
/// @nodoc
class _$FillInTheBlankCopyWithImpl<$Res>
    implements $FillInTheBlankCopyWith<$Res> {
  _$FillInTheBlankCopyWithImpl(this._self, this._then);

  final FillInTheBlank _self;
  final $Res Function(FillInTheBlank) _then;

/// Create a copy of FillInTheBlank
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sentence = null,Object? blanks = null,}) {
  return _then(_self.copyWith(
sentence: null == sentence ? _self.sentence : sentence // ignore: cast_nullable_to_non_nullable
as String,blanks: null == blanks ? _self.blanks : blanks // ignore: cast_nullable_to_non_nullable
as List<Blank>,
  ));
}

}


/// Adds pattern-matching-related methods to [FillInTheBlank].
extension FillInTheBlankPatterns on FillInTheBlank {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FillInTheBlank value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FillInTheBlank() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FillInTheBlank value)  $default,){
final _that = this;
switch (_that) {
case _FillInTheBlank():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FillInTheBlank value)?  $default,){
final _that = this;
switch (_that) {
case _FillInTheBlank() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sentence,  List<Blank> blanks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FillInTheBlank() when $default != null:
return $default(_that.sentence,_that.blanks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sentence,  List<Blank> blanks)  $default,) {final _that = this;
switch (_that) {
case _FillInTheBlank():
return $default(_that.sentence,_that.blanks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sentence,  List<Blank> blanks)?  $default,) {final _that = this;
switch (_that) {
case _FillInTheBlank() when $default != null:
return $default(_that.sentence,_that.blanks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FillInTheBlank implements FillInTheBlank {
  const _FillInTheBlank({required this.sentence, required final  List<Blank> blanks}): _blanks = blanks;
  factory _FillInTheBlank.fromJson(Map<String, dynamic> json) => _$FillInTheBlankFromJson(json);

@override final  String sentence;
 final  List<Blank> _blanks;
@override List<Blank> get blanks {
  if (_blanks is EqualUnmodifiableListView) return _blanks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_blanks);
}


/// Create a copy of FillInTheBlank
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FillInTheBlankCopyWith<_FillInTheBlank> get copyWith => __$FillInTheBlankCopyWithImpl<_FillInTheBlank>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FillInTheBlankToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FillInTheBlank&&(identical(other.sentence, sentence) || other.sentence == sentence)&&const DeepCollectionEquality().equals(other._blanks, _blanks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sentence,const DeepCollectionEquality().hash(_blanks));

@override
String toString() {
  return 'FillInTheBlank(sentence: $sentence, blanks: $blanks)';
}


}

/// @nodoc
abstract mixin class _$FillInTheBlankCopyWith<$Res> implements $FillInTheBlankCopyWith<$Res> {
  factory _$FillInTheBlankCopyWith(_FillInTheBlank value, $Res Function(_FillInTheBlank) _then) = __$FillInTheBlankCopyWithImpl;
@override @useResult
$Res call({
 String sentence, List<Blank> blanks
});




}
/// @nodoc
class __$FillInTheBlankCopyWithImpl<$Res>
    implements _$FillInTheBlankCopyWith<$Res> {
  __$FillInTheBlankCopyWithImpl(this._self, this._then);

  final _FillInTheBlank _self;
  final $Res Function(_FillInTheBlank) _then;

/// Create a copy of FillInTheBlank
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sentence = null,Object? blanks = null,}) {
  return _then(_FillInTheBlank(
sentence: null == sentence ? _self.sentence : sentence // ignore: cast_nullable_to_non_nullable
as String,blanks: null == blanks ? _self._blanks : blanks // ignore: cast_nullable_to_non_nullable
as List<Blank>,
  ));
}


}


/// @nodoc
mixin _$Blank {

 String get answer; String get feedback;
/// Create a copy of Blank
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlankCopyWith<Blank> get copyWith => _$BlankCopyWithImpl<Blank>(this as Blank, _$identity);

  /// Serializes this Blank to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Blank&&(identical(other.answer, answer) || other.answer == answer)&&(identical(other.feedback, feedback) || other.feedback == feedback));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,answer,feedback);

@override
String toString() {
  return 'Blank(answer: $answer, feedback: $feedback)';
}


}

/// @nodoc
abstract mixin class $BlankCopyWith<$Res>  {
  factory $BlankCopyWith(Blank value, $Res Function(Blank) _then) = _$BlankCopyWithImpl;
@useResult
$Res call({
 String answer, String feedback
});




}
/// @nodoc
class _$BlankCopyWithImpl<$Res>
    implements $BlankCopyWith<$Res> {
  _$BlankCopyWithImpl(this._self, this._then);

  final Blank _self;
  final $Res Function(Blank) _then;

/// Create a copy of Blank
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? answer = null,Object? feedback = null,}) {
  return _then(_self.copyWith(
answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,feedback: null == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Blank].
extension BlankPatterns on Blank {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Blank value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Blank() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Blank value)  $default,){
final _that = this;
switch (_that) {
case _Blank():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Blank value)?  $default,){
final _that = this;
switch (_that) {
case _Blank() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String answer,  String feedback)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Blank() when $default != null:
return $default(_that.answer,_that.feedback);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String answer,  String feedback)  $default,) {final _that = this;
switch (_that) {
case _Blank():
return $default(_that.answer,_that.feedback);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String answer,  String feedback)?  $default,) {final _that = this;
switch (_that) {
case _Blank() when $default != null:
return $default(_that.answer,_that.feedback);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Blank implements Blank {
  const _Blank({required this.answer, this.feedback = ''});
  factory _Blank.fromJson(Map<String, dynamic> json) => _$BlankFromJson(json);

@override final  String answer;
@override@JsonKey() final  String feedback;

/// Create a copy of Blank
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlankCopyWith<_Blank> get copyWith => __$BlankCopyWithImpl<_Blank>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlankToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Blank&&(identical(other.answer, answer) || other.answer == answer)&&(identical(other.feedback, feedback) || other.feedback == feedback));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,answer,feedback);

@override
String toString() {
  return 'Blank(answer: $answer, feedback: $feedback)';
}


}

/// @nodoc
abstract mixin class _$BlankCopyWith<$Res> implements $BlankCopyWith<$Res> {
  factory _$BlankCopyWith(_Blank value, $Res Function(_Blank) _then) = __$BlankCopyWithImpl;
@override @useResult
$Res call({
 String answer, String feedback
});




}
/// @nodoc
class __$BlankCopyWithImpl<$Res>
    implements _$BlankCopyWith<$Res> {
  __$BlankCopyWithImpl(this._self, this._then);

  final _Blank _self;
  final $Res Function(_Blank) _then;

/// Create a copy of Blank
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? answer = null,Object? feedback = null,}) {
  return _then(_Blank(
answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,feedback: null == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

Nodule _$NoduleFromJson(
  Map<String, dynamic> json
) {
        switch (json['type']) {
                  case 'paragraph':
          return ParagraphNodule.fromJson(
            json
          );
                case 'interactiveEditor':
          return InteractiveEditorNodule.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'type',
  'Nodule',
  'Invalid union type "${json['type']}"!'
);
        }
      
}

/// @nodoc
mixin _$Nodule {



  /// Serializes this Nodule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Nodule);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Nodule()';
}


}

/// @nodoc
class $NoduleCopyWith<$Res>  {
$NoduleCopyWith(Nodule _, $Res Function(Nodule) __);
}


/// Adds pattern-matching-related methods to [Nodule].
extension NodulePatterns on Nodule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ParagraphNodule value)?  paragraph,TResult Function( InteractiveEditorNodule value)?  interactiveEditor,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ParagraphNodule() when paragraph != null:
return paragraph(_that);case InteractiveEditorNodule() when interactiveEditor != null:
return interactiveEditor(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ParagraphNodule value)  paragraph,required TResult Function( InteractiveEditorNodule value)  interactiveEditor,}){
final _that = this;
switch (_that) {
case ParagraphNodule():
return paragraph(_that);case InteractiveEditorNodule():
return interactiveEditor(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ParagraphNodule value)?  paragraph,TResult? Function( InteractiveEditorNodule value)?  interactiveEditor,}){
final _that = this;
switch (_that) {
case ParagraphNodule() when paragraph != null:
return paragraph(_that);case InteractiveEditorNodule() when interactiveEditor != null:
return interactiveEditor(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function(@JsonKey(readValue: _readNoduleContents)  String contents)?  paragraph,TResult Function(@JsonKey(readValue: _readNoduleContents)  List<NoduleFile> files)?  interactiveEditor,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ParagraphNodule() when paragraph != null:
return paragraph(_that.contents);case InteractiveEditorNodule() when interactiveEditor != null:
return interactiveEditor(_that.files);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function(@JsonKey(readValue: _readNoduleContents)  String contents)  paragraph,required TResult Function(@JsonKey(readValue: _readNoduleContents)  List<NoduleFile> files)  interactiveEditor,}) {final _that = this;
switch (_that) {
case ParagraphNodule():
return paragraph(_that.contents);case InteractiveEditorNodule():
return interactiveEditor(_that.files);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function(@JsonKey(readValue: _readNoduleContents)  String contents)?  paragraph,TResult? Function(@JsonKey(readValue: _readNoduleContents)  List<NoduleFile> files)?  interactiveEditor,}) {final _that = this;
switch (_that) {
case ParagraphNodule() when paragraph != null:
return paragraph(_that.contents);case InteractiveEditorNodule() when interactiveEditor != null:
return interactiveEditor(_that.files);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class ParagraphNodule implements Nodule {
  const ParagraphNodule({@JsonKey(readValue: _readNoduleContents) required this.contents, final  String? $type}): $type = $type ?? 'paragraph';
  factory ParagraphNodule.fromJson(Map<String, dynamic> json) => _$ParagraphNoduleFromJson(json);

@JsonKey(readValue: _readNoduleContents) final  String contents;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of Nodule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParagraphNoduleCopyWith<ParagraphNodule> get copyWith => _$ParagraphNoduleCopyWithImpl<ParagraphNodule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParagraphNoduleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParagraphNodule&&(identical(other.contents, contents) || other.contents == contents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contents);

@override
String toString() {
  return 'Nodule.paragraph(contents: $contents)';
}


}

/// @nodoc
abstract mixin class $ParagraphNoduleCopyWith<$Res> implements $NoduleCopyWith<$Res> {
  factory $ParagraphNoduleCopyWith(ParagraphNodule value, $Res Function(ParagraphNodule) _then) = _$ParagraphNoduleCopyWithImpl;
@useResult
$Res call({
@JsonKey(readValue: _readNoduleContents) String contents
});




}
/// @nodoc
class _$ParagraphNoduleCopyWithImpl<$Res>
    implements $ParagraphNoduleCopyWith<$Res> {
  _$ParagraphNoduleCopyWithImpl(this._self, this._then);

  final ParagraphNodule _self;
  final $Res Function(ParagraphNodule) _then;

/// Create a copy of Nodule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? contents = null,}) {
  return _then(ParagraphNodule(
contents: null == contents ? _self.contents : contents // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class InteractiveEditorNodule implements Nodule {
  const InteractiveEditorNodule({@JsonKey(readValue: _readNoduleContents) required final  List<NoduleFile> files, final  String? $type}): _files = files,$type = $type ?? 'interactiveEditor';
  factory InteractiveEditorNodule.fromJson(Map<String, dynamic> json) => _$InteractiveEditorNoduleFromJson(json);

 final  List<NoduleFile> _files;
@JsonKey(readValue: _readNoduleContents) List<NoduleFile> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}


@JsonKey(name: 'type')
final String $type;


/// Create a copy of Nodule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InteractiveEditorNoduleCopyWith<InteractiveEditorNodule> get copyWith => _$InteractiveEditorNoduleCopyWithImpl<InteractiveEditorNodule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InteractiveEditorNoduleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InteractiveEditorNodule&&const DeepCollectionEquality().equals(other._files, _files));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_files));

@override
String toString() {
  return 'Nodule.interactiveEditor(files: $files)';
}


}

/// @nodoc
abstract mixin class $InteractiveEditorNoduleCopyWith<$Res> implements $NoduleCopyWith<$Res> {
  factory $InteractiveEditorNoduleCopyWith(InteractiveEditorNodule value, $Res Function(InteractiveEditorNodule) _then) = _$InteractiveEditorNoduleCopyWithImpl;
@useResult
$Res call({
@JsonKey(readValue: _readNoduleContents) List<NoduleFile> files
});




}
/// @nodoc
class _$InteractiveEditorNoduleCopyWithImpl<$Res>
    implements $InteractiveEditorNoduleCopyWith<$Res> {
  _$InteractiveEditorNoduleCopyWithImpl(this._self, this._then);

  final InteractiveEditorNodule _self;
  final $Res Function(InteractiveEditorNodule) _then;

/// Create a copy of Nodule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? files = null,}) {
  return _then(InteractiveEditorNodule(
files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<NoduleFile>,
  ));
}


}


/// @nodoc
mixin _$NoduleFile {

 String get name; String get ext; String get contents;
/// Create a copy of NoduleFile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoduleFileCopyWith<NoduleFile> get copyWith => _$NoduleFileCopyWithImpl<NoduleFile>(this as NoduleFile, _$identity);

  /// Serializes this NoduleFile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoduleFile&&(identical(other.name, name) || other.name == name)&&(identical(other.ext, ext) || other.ext == ext)&&(identical(other.contents, contents) || other.contents == contents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,ext,contents);

@override
String toString() {
  return 'NoduleFile(name: $name, ext: $ext, contents: $contents)';
}


}

/// @nodoc
abstract mixin class $NoduleFileCopyWith<$Res>  {
  factory $NoduleFileCopyWith(NoduleFile value, $Res Function(NoduleFile) _then) = _$NoduleFileCopyWithImpl;
@useResult
$Res call({
 String name, String ext, String contents
});




}
/// @nodoc
class _$NoduleFileCopyWithImpl<$Res>
    implements $NoduleFileCopyWith<$Res> {
  _$NoduleFileCopyWithImpl(this._self, this._then);

  final NoduleFile _self;
  final $Res Function(NoduleFile) _then;

/// Create a copy of NoduleFile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? ext = null,Object? contents = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,ext: null == ext ? _self.ext : ext // ignore: cast_nullable_to_non_nullable
as String,contents: null == contents ? _self.contents : contents // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [NoduleFile].
extension NoduleFilePatterns on NoduleFile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NoduleFile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NoduleFile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NoduleFile value)  $default,){
final _that = this;
switch (_that) {
case _NoduleFile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NoduleFile value)?  $default,){
final _that = this;
switch (_that) {
case _NoduleFile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String ext,  String contents)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NoduleFile() when $default != null:
return $default(_that.name,_that.ext,_that.contents);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String ext,  String contents)  $default,) {final _that = this;
switch (_that) {
case _NoduleFile():
return $default(_that.name,_that.ext,_that.contents);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String ext,  String contents)?  $default,) {final _that = this;
switch (_that) {
case _NoduleFile() when $default != null:
return $default(_that.name,_that.ext,_that.contents);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NoduleFile implements NoduleFile {
  const _NoduleFile({required this.name, required this.ext, required this.contents});
  factory _NoduleFile.fromJson(Map<String, dynamic> json) => _$NoduleFileFromJson(json);

@override final  String name;
@override final  String ext;
@override final  String contents;

/// Create a copy of NoduleFile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoduleFileCopyWith<_NoduleFile> get copyWith => __$NoduleFileCopyWithImpl<_NoduleFile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NoduleFileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoduleFile&&(identical(other.name, name) || other.name == name)&&(identical(other.ext, ext) || other.ext == ext)&&(identical(other.contents, contents) || other.contents == contents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,ext,contents);

@override
String toString() {
  return 'NoduleFile(name: $name, ext: $ext, contents: $contents)';
}


}

/// @nodoc
abstract mixin class _$NoduleFileCopyWith<$Res> implements $NoduleFileCopyWith<$Res> {
  factory _$NoduleFileCopyWith(_NoduleFile value, $Res Function(_NoduleFile) _then) = __$NoduleFileCopyWithImpl;
@override @useResult
$Res call({
 String name, String ext, String contents
});




}
/// @nodoc
class __$NoduleFileCopyWithImpl<$Res>
    implements _$NoduleFileCopyWith<$Res> {
  __$NoduleFileCopyWithImpl(this._self, this._then);

  final _NoduleFile _self;
  final $Res Function(_NoduleFile) _then;

/// Create a copy of NoduleFile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? ext = null,Object? contents = null,}) {
  return _then(_NoduleFile(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,ext: null == ext ? _self.ext : ext // ignore: cast_nullable_to_non_nullable
as String,contents: null == contents ? _self.contents : contents // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Scene {

 SceneSetup get setup; List<SceneCommand> get commands;
/// Create a copy of Scene
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SceneCopyWith<Scene> get copyWith => _$SceneCopyWithImpl<Scene>(this as Scene, _$identity);

  /// Serializes this Scene to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Scene&&(identical(other.setup, setup) || other.setup == setup)&&const DeepCollectionEquality().equals(other.commands, commands));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,setup,const DeepCollectionEquality().hash(commands));

@override
String toString() {
  return 'Scene(setup: $setup, commands: $commands)';
}


}

/// @nodoc
abstract mixin class $SceneCopyWith<$Res>  {
  factory $SceneCopyWith(Scene value, $Res Function(Scene) _then) = _$SceneCopyWithImpl;
@useResult
$Res call({
 SceneSetup setup, List<SceneCommand> commands
});


$SceneSetupCopyWith<$Res> get setup;

}
/// @nodoc
class _$SceneCopyWithImpl<$Res>
    implements $SceneCopyWith<$Res> {
  _$SceneCopyWithImpl(this._self, this._then);

  final Scene _self;
  final $Res Function(Scene) _then;

/// Create a copy of Scene
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? setup = null,Object? commands = null,}) {
  return _then(_self.copyWith(
setup: null == setup ? _self.setup : setup // ignore: cast_nullable_to_non_nullable
as SceneSetup,commands: null == commands ? _self.commands : commands // ignore: cast_nullable_to_non_nullable
as List<SceneCommand>,
  ));
}
/// Create a copy of Scene
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SceneSetupCopyWith<$Res> get setup {
  
  return $SceneSetupCopyWith<$Res>(_self.setup, (value) {
    return _then(_self.copyWith(setup: value));
  });
}
}


/// Adds pattern-matching-related methods to [Scene].
extension ScenePatterns on Scene {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Scene value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Scene() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Scene value)  $default,){
final _that = this;
switch (_that) {
case _Scene():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Scene value)?  $default,){
final _that = this;
switch (_that) {
case _Scene() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SceneSetup setup,  List<SceneCommand> commands)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Scene() when $default != null:
return $default(_that.setup,_that.commands);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SceneSetup setup,  List<SceneCommand> commands)  $default,) {final _that = this;
switch (_that) {
case _Scene():
return $default(_that.setup,_that.commands);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SceneSetup setup,  List<SceneCommand> commands)?  $default,) {final _that = this;
switch (_that) {
case _Scene() when $default != null:
return $default(_that.setup,_that.commands);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Scene implements Scene {
  const _Scene({required this.setup, required final  List<SceneCommand> commands}): _commands = commands;
  factory _Scene.fromJson(Map<String, dynamic> json) => _$SceneFromJson(json);

@override final  SceneSetup setup;
 final  List<SceneCommand> _commands;
@override List<SceneCommand> get commands {
  if (_commands is EqualUnmodifiableListView) return _commands;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_commands);
}


/// Create a copy of Scene
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SceneCopyWith<_Scene> get copyWith => __$SceneCopyWithImpl<_Scene>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SceneToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Scene&&(identical(other.setup, setup) || other.setup == setup)&&const DeepCollectionEquality().equals(other._commands, _commands));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,setup,const DeepCollectionEquality().hash(_commands));

@override
String toString() {
  return 'Scene(setup: $setup, commands: $commands)';
}


}

/// @nodoc
abstract mixin class _$SceneCopyWith<$Res> implements $SceneCopyWith<$Res> {
  factory _$SceneCopyWith(_Scene value, $Res Function(_Scene) _then) = __$SceneCopyWithImpl;
@override @useResult
$Res call({
 SceneSetup setup, List<SceneCommand> commands
});


@override $SceneSetupCopyWith<$Res> get setup;

}
/// @nodoc
class __$SceneCopyWithImpl<$Res>
    implements _$SceneCopyWith<$Res> {
  __$SceneCopyWithImpl(this._self, this._then);

  final _Scene _self;
  final $Res Function(_Scene) _then;

/// Create a copy of Scene
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? setup = null,Object? commands = null,}) {
  return _then(_Scene(
setup: null == setup ? _self.setup : setup // ignore: cast_nullable_to_non_nullable
as SceneSetup,commands: null == commands ? _self._commands : commands // ignore: cast_nullable_to_non_nullable
as List<SceneCommand>,
  ));
}

/// Create a copy of Scene
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SceneSetupCopyWith<$Res> get setup {
  
  return $SceneSetupCopyWith<$Res>(_self.setup, (value) {
    return _then(_self.copyWith(setup: value));
  });
}
}


/// @nodoc
mixin _$SceneSetup {

 String get background; AudioClip get audio; List<SceneCharacter> get characters;
/// Create a copy of SceneSetup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SceneSetupCopyWith<SceneSetup> get copyWith => _$SceneSetupCopyWithImpl<SceneSetup>(this as SceneSetup, _$identity);

  /// Serializes this SceneSetup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SceneSetup&&(identical(other.background, background) || other.background == background)&&(identical(other.audio, audio) || other.audio == audio)&&const DeepCollectionEquality().equals(other.characters, characters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,background,audio,const DeepCollectionEquality().hash(characters));

@override
String toString() {
  return 'SceneSetup(background: $background, audio: $audio, characters: $characters)';
}


}

/// @nodoc
abstract mixin class $SceneSetupCopyWith<$Res>  {
  factory $SceneSetupCopyWith(SceneSetup value, $Res Function(SceneSetup) _then) = _$SceneSetupCopyWithImpl;
@useResult
$Res call({
 String background, AudioClip audio, List<SceneCharacter> characters
});


$AudioClipCopyWith<$Res> get audio;

}
/// @nodoc
class _$SceneSetupCopyWithImpl<$Res>
    implements $SceneSetupCopyWith<$Res> {
  _$SceneSetupCopyWithImpl(this._self, this._then);

  final SceneSetup _self;
  final $Res Function(SceneSetup) _then;

/// Create a copy of SceneSetup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? background = null,Object? audio = null,Object? characters = null,}) {
  return _then(_self.copyWith(
background: null == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as String,audio: null == audio ? _self.audio : audio // ignore: cast_nullable_to_non_nullable
as AudioClip,characters: null == characters ? _self.characters : characters // ignore: cast_nullable_to_non_nullable
as List<SceneCharacter>,
  ));
}
/// Create a copy of SceneSetup
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AudioClipCopyWith<$Res> get audio {
  
  return $AudioClipCopyWith<$Res>(_self.audio, (value) {
    return _then(_self.copyWith(audio: value));
  });
}
}


/// Adds pattern-matching-related methods to [SceneSetup].
extension SceneSetupPatterns on SceneSetup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SceneSetup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SceneSetup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SceneSetup value)  $default,){
final _that = this;
switch (_that) {
case _SceneSetup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SceneSetup value)?  $default,){
final _that = this;
switch (_that) {
case _SceneSetup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String background,  AudioClip audio,  List<SceneCharacter> characters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SceneSetup() when $default != null:
return $default(_that.background,_that.audio,_that.characters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String background,  AudioClip audio,  List<SceneCharacter> characters)  $default,) {final _that = this;
switch (_that) {
case _SceneSetup():
return $default(_that.background,_that.audio,_that.characters);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String background,  AudioClip audio,  List<SceneCharacter> characters)?  $default,) {final _that = this;
switch (_that) {
case _SceneSetup() when $default != null:
return $default(_that.background,_that.audio,_that.characters);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SceneSetup implements SceneSetup {
  const _SceneSetup({required this.background, required this.audio, required final  List<SceneCharacter> characters}): _characters = characters;
  factory _SceneSetup.fromJson(Map<String, dynamic> json) => _$SceneSetupFromJson(json);

@override final  String background;
@override final  AudioClip audio;
 final  List<SceneCharacter> _characters;
@override List<SceneCharacter> get characters {
  if (_characters is EqualUnmodifiableListView) return _characters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_characters);
}


/// Create a copy of SceneSetup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SceneSetupCopyWith<_SceneSetup> get copyWith => __$SceneSetupCopyWithImpl<_SceneSetup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SceneSetupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SceneSetup&&(identical(other.background, background) || other.background == background)&&(identical(other.audio, audio) || other.audio == audio)&&const DeepCollectionEquality().equals(other._characters, _characters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,background,audio,const DeepCollectionEquality().hash(_characters));

@override
String toString() {
  return 'SceneSetup(background: $background, audio: $audio, characters: $characters)';
}


}

/// @nodoc
abstract mixin class _$SceneSetupCopyWith<$Res> implements $SceneSetupCopyWith<$Res> {
  factory _$SceneSetupCopyWith(_SceneSetup value, $Res Function(_SceneSetup) _then) = __$SceneSetupCopyWithImpl;
@override @useResult
$Res call({
 String background, AudioClip audio, List<SceneCharacter> characters
});


@override $AudioClipCopyWith<$Res> get audio;

}
/// @nodoc
class __$SceneSetupCopyWithImpl<$Res>
    implements _$SceneSetupCopyWith<$Res> {
  __$SceneSetupCopyWithImpl(this._self, this._then);

  final _SceneSetup _self;
  final $Res Function(_SceneSetup) _then;

/// Create a copy of SceneSetup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? background = null,Object? audio = null,Object? characters = null,}) {
  return _then(_SceneSetup(
background: null == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as String,audio: null == audio ? _self.audio : audio // ignore: cast_nullable_to_non_nullable
as AudioClip,characters: null == characters ? _self._characters : characters // ignore: cast_nullable_to_non_nullable
as List<SceneCharacter>,
  ));
}

/// Create a copy of SceneSetup
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AudioClipCopyWith<$Res> get audio {
  
  return $AudioClipCopyWith<$Res>(_self.audio, (value) {
    return _then(_self.copyWith(audio: value));
  });
}
}


/// @nodoc
mixin _$SceneCharacter {

 String get character; ScenePosition get position; num? get opacity;
/// Create a copy of SceneCharacter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SceneCharacterCopyWith<SceneCharacter> get copyWith => _$SceneCharacterCopyWithImpl<SceneCharacter>(this as SceneCharacter, _$identity);

  /// Serializes this SceneCharacter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SceneCharacter&&(identical(other.character, character) || other.character == character)&&(identical(other.position, position) || other.position == position)&&(identical(other.opacity, opacity) || other.opacity == opacity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,character,position,opacity);

@override
String toString() {
  return 'SceneCharacter(character: $character, position: $position, opacity: $opacity)';
}


}

/// @nodoc
abstract mixin class $SceneCharacterCopyWith<$Res>  {
  factory $SceneCharacterCopyWith(SceneCharacter value, $Res Function(SceneCharacter) _then) = _$SceneCharacterCopyWithImpl;
@useResult
$Res call({
 String character, ScenePosition position, num? opacity
});


$ScenePositionCopyWith<$Res> get position;

}
/// @nodoc
class _$SceneCharacterCopyWithImpl<$Res>
    implements $SceneCharacterCopyWith<$Res> {
  _$SceneCharacterCopyWithImpl(this._self, this._then);

  final SceneCharacter _self;
  final $Res Function(SceneCharacter) _then;

/// Create a copy of SceneCharacter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? character = null,Object? position = null,Object? opacity = freezed,}) {
  return _then(_self.copyWith(
character: null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as ScenePosition,opacity: freezed == opacity ? _self.opacity : opacity // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}
/// Create a copy of SceneCharacter
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScenePositionCopyWith<$Res> get position {
  
  return $ScenePositionCopyWith<$Res>(_self.position, (value) {
    return _then(_self.copyWith(position: value));
  });
}
}


/// Adds pattern-matching-related methods to [SceneCharacter].
extension SceneCharacterPatterns on SceneCharacter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SceneCharacter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SceneCharacter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SceneCharacter value)  $default,){
final _that = this;
switch (_that) {
case _SceneCharacter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SceneCharacter value)?  $default,){
final _that = this;
switch (_that) {
case _SceneCharacter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String character,  ScenePosition position,  num? opacity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SceneCharacter() when $default != null:
return $default(_that.character,_that.position,_that.opacity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String character,  ScenePosition position,  num? opacity)  $default,) {final _that = this;
switch (_that) {
case _SceneCharacter():
return $default(_that.character,_that.position,_that.opacity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String character,  ScenePosition position,  num? opacity)?  $default,) {final _that = this;
switch (_that) {
case _SceneCharacter() when $default != null:
return $default(_that.character,_that.position,_that.opacity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SceneCharacter implements SceneCharacter {
  const _SceneCharacter({required this.character, required this.position, this.opacity});
  factory _SceneCharacter.fromJson(Map<String, dynamic> json) => _$SceneCharacterFromJson(json);

@override final  String character;
@override final  ScenePosition position;
@override final  num? opacity;

/// Create a copy of SceneCharacter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SceneCharacterCopyWith<_SceneCharacter> get copyWith => __$SceneCharacterCopyWithImpl<_SceneCharacter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SceneCharacterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SceneCharacter&&(identical(other.character, character) || other.character == character)&&(identical(other.position, position) || other.position == position)&&(identical(other.opacity, opacity) || other.opacity == opacity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,character,position,opacity);

@override
String toString() {
  return 'SceneCharacter(character: $character, position: $position, opacity: $opacity)';
}


}

/// @nodoc
abstract mixin class _$SceneCharacterCopyWith<$Res> implements $SceneCharacterCopyWith<$Res> {
  factory _$SceneCharacterCopyWith(_SceneCharacter value, $Res Function(_SceneCharacter) _then) = __$SceneCharacterCopyWithImpl;
@override @useResult
$Res call({
 String character, ScenePosition position, num? opacity
});


@override $ScenePositionCopyWith<$Res> get position;

}
/// @nodoc
class __$SceneCharacterCopyWithImpl<$Res>
    implements _$SceneCharacterCopyWith<$Res> {
  __$SceneCharacterCopyWithImpl(this._self, this._then);

  final _SceneCharacter _self;
  final $Res Function(_SceneCharacter) _then;

/// Create a copy of SceneCharacter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? character = null,Object? position = null,Object? opacity = freezed,}) {
  return _then(_SceneCharacter(
character: null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as ScenePosition,opacity: freezed == opacity ? _self.opacity : opacity // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

/// Create a copy of SceneCharacter
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScenePositionCopyWith<$Res> get position {
  
  return $ScenePositionCopyWith<$Res>(_self.position, (value) {
    return _then(_self.copyWith(position: value));
  });
}
}


/// @nodoc
mixin _$ScenePosition {

 num get x; num get y; num get z;
/// Create a copy of ScenePosition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScenePositionCopyWith<ScenePosition> get copyWith => _$ScenePositionCopyWithImpl<ScenePosition>(this as ScenePosition, _$identity);

  /// Serializes this ScenePosition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScenePosition&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.z, z) || other.z == z));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,x,y,z);

@override
String toString() {
  return 'ScenePosition(x: $x, y: $y, z: $z)';
}


}

/// @nodoc
abstract mixin class $ScenePositionCopyWith<$Res>  {
  factory $ScenePositionCopyWith(ScenePosition value, $Res Function(ScenePosition) _then) = _$ScenePositionCopyWithImpl;
@useResult
$Res call({
 num x, num y, num z
});




}
/// @nodoc
class _$ScenePositionCopyWithImpl<$Res>
    implements $ScenePositionCopyWith<$Res> {
  _$ScenePositionCopyWithImpl(this._self, this._then);

  final ScenePosition _self;
  final $Res Function(ScenePosition) _then;

/// Create a copy of ScenePosition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? x = null,Object? y = null,Object? z = null,}) {
  return _then(_self.copyWith(
x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as num,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as num,z: null == z ? _self.z : z // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [ScenePosition].
extension ScenePositionPatterns on ScenePosition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScenePosition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScenePosition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScenePosition value)  $default,){
final _that = this;
switch (_that) {
case _ScenePosition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScenePosition value)?  $default,){
final _that = this;
switch (_that) {
case _ScenePosition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( num x,  num y,  num z)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScenePosition() when $default != null:
return $default(_that.x,_that.y,_that.z);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( num x,  num y,  num z)  $default,) {final _that = this;
switch (_that) {
case _ScenePosition():
return $default(_that.x,_that.y,_that.z);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( num x,  num y,  num z)?  $default,) {final _that = this;
switch (_that) {
case _ScenePosition() when $default != null:
return $default(_that.x,_that.y,_that.z);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScenePosition implements ScenePosition {
  const _ScenePosition({required this.x, required this.y, required this.z});
  factory _ScenePosition.fromJson(Map<String, dynamic> json) => _$ScenePositionFromJson(json);

@override final  num x;
@override final  num y;
@override final  num z;

/// Create a copy of ScenePosition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScenePositionCopyWith<_ScenePosition> get copyWith => __$ScenePositionCopyWithImpl<_ScenePosition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScenePositionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScenePosition&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.z, z) || other.z == z));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,x,y,z);

@override
String toString() {
  return 'ScenePosition(x: $x, y: $y, z: $z)';
}


}

/// @nodoc
abstract mixin class _$ScenePositionCopyWith<$Res> implements $ScenePositionCopyWith<$Res> {
  factory _$ScenePositionCopyWith(_ScenePosition value, $Res Function(_ScenePosition) _then) = __$ScenePositionCopyWithImpl;
@override @useResult
$Res call({
 num x, num y, num z
});




}
/// @nodoc
class __$ScenePositionCopyWithImpl<$Res>
    implements _$ScenePositionCopyWith<$Res> {
  __$ScenePositionCopyWithImpl(this._self, this._then);

  final _ScenePosition _self;
  final $Res Function(_ScenePosition) _then;

/// Create a copy of ScenePosition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? x = null,Object? y = null,Object? z = null,}) {
  return _then(_ScenePosition(
x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as num,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as num,z: null == z ? _self.z : z // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}


/// @nodoc
mixin _$SceneCommand {

 String get character; num get startTime; num? get finishTime; String? get background; ScenePosition? get position; num? get opacity; SceneDialogue? get dialogue;
/// Create a copy of SceneCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SceneCommandCopyWith<SceneCommand> get copyWith => _$SceneCommandCopyWithImpl<SceneCommand>(this as SceneCommand, _$identity);

  /// Serializes this SceneCommand to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SceneCommand&&(identical(other.character, character) || other.character == character)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.finishTime, finishTime) || other.finishTime == finishTime)&&(identical(other.background, background) || other.background == background)&&(identical(other.position, position) || other.position == position)&&(identical(other.opacity, opacity) || other.opacity == opacity)&&(identical(other.dialogue, dialogue) || other.dialogue == dialogue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,character,startTime,finishTime,background,position,opacity,dialogue);

@override
String toString() {
  return 'SceneCommand(character: $character, startTime: $startTime, finishTime: $finishTime, background: $background, position: $position, opacity: $opacity, dialogue: $dialogue)';
}


}

/// @nodoc
abstract mixin class $SceneCommandCopyWith<$Res>  {
  factory $SceneCommandCopyWith(SceneCommand value, $Res Function(SceneCommand) _then) = _$SceneCommandCopyWithImpl;
@useResult
$Res call({
 String character, num startTime, num? finishTime, String? background, ScenePosition? position, num? opacity, SceneDialogue? dialogue
});


$ScenePositionCopyWith<$Res>? get position;$SceneDialogueCopyWith<$Res>? get dialogue;

}
/// @nodoc
class _$SceneCommandCopyWithImpl<$Res>
    implements $SceneCommandCopyWith<$Res> {
  _$SceneCommandCopyWithImpl(this._self, this._then);

  final SceneCommand _self;
  final $Res Function(SceneCommand) _then;

/// Create a copy of SceneCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? character = null,Object? startTime = null,Object? finishTime = freezed,Object? background = freezed,Object? position = freezed,Object? opacity = freezed,Object? dialogue = freezed,}) {
  return _then(_self.copyWith(
character: null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as num,finishTime: freezed == finishTime ? _self.finishTime : finishTime // ignore: cast_nullable_to_non_nullable
as num?,background: freezed == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as String?,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as ScenePosition?,opacity: freezed == opacity ? _self.opacity : opacity // ignore: cast_nullable_to_non_nullable
as num?,dialogue: freezed == dialogue ? _self.dialogue : dialogue // ignore: cast_nullable_to_non_nullable
as SceneDialogue?,
  ));
}
/// Create a copy of SceneCommand
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScenePositionCopyWith<$Res>? get position {
    if (_self.position == null) {
    return null;
  }

  return $ScenePositionCopyWith<$Res>(_self.position!, (value) {
    return _then(_self.copyWith(position: value));
  });
}/// Create a copy of SceneCommand
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SceneDialogueCopyWith<$Res>? get dialogue {
    if (_self.dialogue == null) {
    return null;
  }

  return $SceneDialogueCopyWith<$Res>(_self.dialogue!, (value) {
    return _then(_self.copyWith(dialogue: value));
  });
}
}


/// Adds pattern-matching-related methods to [SceneCommand].
extension SceneCommandPatterns on SceneCommand {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SceneCommand value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SceneCommand() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SceneCommand value)  $default,){
final _that = this;
switch (_that) {
case _SceneCommand():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SceneCommand value)?  $default,){
final _that = this;
switch (_that) {
case _SceneCommand() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String character,  num startTime,  num? finishTime,  String? background,  ScenePosition? position,  num? opacity,  SceneDialogue? dialogue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SceneCommand() when $default != null:
return $default(_that.character,_that.startTime,_that.finishTime,_that.background,_that.position,_that.opacity,_that.dialogue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String character,  num startTime,  num? finishTime,  String? background,  ScenePosition? position,  num? opacity,  SceneDialogue? dialogue)  $default,) {final _that = this;
switch (_that) {
case _SceneCommand():
return $default(_that.character,_that.startTime,_that.finishTime,_that.background,_that.position,_that.opacity,_that.dialogue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String character,  num startTime,  num? finishTime,  String? background,  ScenePosition? position,  num? opacity,  SceneDialogue? dialogue)?  $default,) {final _that = this;
switch (_that) {
case _SceneCommand() when $default != null:
return $default(_that.character,_that.startTime,_that.finishTime,_that.background,_that.position,_that.opacity,_that.dialogue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SceneCommand implements SceneCommand {
  const _SceneCommand({required this.character, required this.startTime, this.finishTime, this.background, this.position, this.opacity, this.dialogue});
  factory _SceneCommand.fromJson(Map<String, dynamic> json) => _$SceneCommandFromJson(json);

@override final  String character;
@override final  num startTime;
@override final  num? finishTime;
@override final  String? background;
@override final  ScenePosition? position;
@override final  num? opacity;
@override final  SceneDialogue? dialogue;

/// Create a copy of SceneCommand
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SceneCommandCopyWith<_SceneCommand> get copyWith => __$SceneCommandCopyWithImpl<_SceneCommand>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SceneCommandToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SceneCommand&&(identical(other.character, character) || other.character == character)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.finishTime, finishTime) || other.finishTime == finishTime)&&(identical(other.background, background) || other.background == background)&&(identical(other.position, position) || other.position == position)&&(identical(other.opacity, opacity) || other.opacity == opacity)&&(identical(other.dialogue, dialogue) || other.dialogue == dialogue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,character,startTime,finishTime,background,position,opacity,dialogue);

@override
String toString() {
  return 'SceneCommand(character: $character, startTime: $startTime, finishTime: $finishTime, background: $background, position: $position, opacity: $opacity, dialogue: $dialogue)';
}


}

/// @nodoc
abstract mixin class _$SceneCommandCopyWith<$Res> implements $SceneCommandCopyWith<$Res> {
  factory _$SceneCommandCopyWith(_SceneCommand value, $Res Function(_SceneCommand) _then) = __$SceneCommandCopyWithImpl;
@override @useResult
$Res call({
 String character, num startTime, num? finishTime, String? background, ScenePosition? position, num? opacity, SceneDialogue? dialogue
});


@override $ScenePositionCopyWith<$Res>? get position;@override $SceneDialogueCopyWith<$Res>? get dialogue;

}
/// @nodoc
class __$SceneCommandCopyWithImpl<$Res>
    implements _$SceneCommandCopyWith<$Res> {
  __$SceneCommandCopyWithImpl(this._self, this._then);

  final _SceneCommand _self;
  final $Res Function(_SceneCommand) _then;

/// Create a copy of SceneCommand
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? character = null,Object? startTime = null,Object? finishTime = freezed,Object? background = freezed,Object? position = freezed,Object? opacity = freezed,Object? dialogue = freezed,}) {
  return _then(_SceneCommand(
character: null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as num,finishTime: freezed == finishTime ? _self.finishTime : finishTime // ignore: cast_nullable_to_non_nullable
as num?,background: freezed == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as String?,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as ScenePosition?,opacity: freezed == opacity ? _self.opacity : opacity // ignore: cast_nullable_to_non_nullable
as num?,dialogue: freezed == dialogue ? _self.dialogue : dialogue // ignore: cast_nullable_to_non_nullable
as SceneDialogue?,
  ));
}

/// Create a copy of SceneCommand
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScenePositionCopyWith<$Res>? get position {
    if (_self.position == null) {
    return null;
  }

  return $ScenePositionCopyWith<$Res>(_self.position!, (value) {
    return _then(_self.copyWith(position: value));
  });
}/// Create a copy of SceneCommand
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SceneDialogueCopyWith<$Res>? get dialogue {
    if (_self.dialogue == null) {
    return null;
  }

  return $SceneDialogueCopyWith<$Res>(_self.dialogue!, (value) {
    return _then(_self.copyWith(dialogue: value));
  });
}
}


/// @nodoc
mixin _$SceneDialogue {

 String get text; String get align;
/// Create a copy of SceneDialogue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SceneDialogueCopyWith<SceneDialogue> get copyWith => _$SceneDialogueCopyWithImpl<SceneDialogue>(this as SceneDialogue, _$identity);

  /// Serializes this SceneDialogue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SceneDialogue&&(identical(other.text, text) || other.text == text)&&(identical(other.align, align) || other.align == align));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,align);

@override
String toString() {
  return 'SceneDialogue(text: $text, align: $align)';
}


}

/// @nodoc
abstract mixin class $SceneDialogueCopyWith<$Res>  {
  factory $SceneDialogueCopyWith(SceneDialogue value, $Res Function(SceneDialogue) _then) = _$SceneDialogueCopyWithImpl;
@useResult
$Res call({
 String text, String align
});




}
/// @nodoc
class _$SceneDialogueCopyWithImpl<$Res>
    implements $SceneDialogueCopyWith<$Res> {
  _$SceneDialogueCopyWithImpl(this._self, this._then);

  final SceneDialogue _self;
  final $Res Function(SceneDialogue) _then;

/// Create a copy of SceneDialogue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? align = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,align: null == align ? _self.align : align // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SceneDialogue].
extension SceneDialoguePatterns on SceneDialogue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SceneDialogue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SceneDialogue() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SceneDialogue value)  $default,){
final _that = this;
switch (_that) {
case _SceneDialogue():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SceneDialogue value)?  $default,){
final _that = this;
switch (_that) {
case _SceneDialogue() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  String align)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SceneDialogue() when $default != null:
return $default(_that.text,_that.align);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  String align)  $default,) {final _that = this;
switch (_that) {
case _SceneDialogue():
return $default(_that.text,_that.align);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  String align)?  $default,) {final _that = this;
switch (_that) {
case _SceneDialogue() when $default != null:
return $default(_that.text,_that.align);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SceneDialogue implements SceneDialogue {
  const _SceneDialogue({required this.text, required this.align});
  factory _SceneDialogue.fromJson(Map<String, dynamic> json) => _$SceneDialogueFromJson(json);

@override final  String text;
@override final  String align;

/// Create a copy of SceneDialogue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SceneDialogueCopyWith<_SceneDialogue> get copyWith => __$SceneDialogueCopyWithImpl<_SceneDialogue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SceneDialogueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SceneDialogue&&(identical(other.text, text) || other.text == text)&&(identical(other.align, align) || other.align == align));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,align);

@override
String toString() {
  return 'SceneDialogue(text: $text, align: $align)';
}


}

/// @nodoc
abstract mixin class _$SceneDialogueCopyWith<$Res> implements $SceneDialogueCopyWith<$Res> {
  factory _$SceneDialogueCopyWith(_SceneDialogue value, $Res Function(_SceneDialogue) _then) = __$SceneDialogueCopyWithImpl;
@override @useResult
$Res call({
 String text, String align
});




}
/// @nodoc
class __$SceneDialogueCopyWithImpl<$Res>
    implements _$SceneDialogueCopyWith<$Res> {
  __$SceneDialogueCopyWithImpl(this._self, this._then);

  final _SceneDialogue _self;
  final $Res Function(_SceneDialogue) _then;

/// Create a copy of SceneDialogue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? align = null,}) {
  return _then(_SceneDialogue(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,align: null == align ? _self.align : align // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
