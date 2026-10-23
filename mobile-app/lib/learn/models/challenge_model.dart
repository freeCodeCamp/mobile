import 'package:freecodecamp/learn/models/challenge_file_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'challenge_model.freezed.dart';
part 'challenge_model.g.dart';

@freezed
abstract class Challenge with _$Challenge {
  const factory Challenge({
    required String id,
    required String block,
    required String superBlock,
    required String title,
    required String dashedName,
    required int challengeType,
    @Default('') String helpCategory,
    @Default('') String description,
    @Default('') String instructions,
    @Default('') String explanation,
    @Default('') String transcript,
    String? videoId,
    @Default([]) List<Question> questions,
    @Default([]) List<String> assignments,
    @Default([]) List<Quiz> quizzes,
    @Default([]) List<Nodule> nodules,
    FillInTheBlank? fillInTheBlank,
    Scene? scene,
    @Default([]) List<ChallengeTest> tests,
    @Default([]) List<ChallengeFile> challengeFiles,
    @Default(Hooks()) Hooks hooks,
  }) = _Challenge;

  factory Challenge.fromJson(Map<String, dynamic> json) =>
      _$ChallengeFromJson(json);
}

@freezed
abstract class ChallengeTest with _$ChallengeTest {
  const factory ChallengeTest({
    required String text,
    required String testString,
  }) = _ChallengeTest;

  factory ChallengeTest.fromJson(Map<String, dynamic> json) =>
      _$ChallengeTestFromJson(json);
}

@freezed
abstract class Hooks with _$Hooks {
  const factory Hooks({
    @Default('') String beforeAll,
    @Default('') String beforeEach,
    @Default('') String afterEach,
  }) = _Hooks;

  factory Hooks.fromJson(Map<String, dynamic> json) => _$HooksFromJson(json);
}

@freezed
abstract class Question with _$Question {
  const factory Question({
    required String text,
    required List<Answer> answers,
    // NOTE: 1-based index into answers.
    required int solution,
  }) = _Question;

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
}

@freezed
abstract class Answer with _$Answer {
  const factory Answer({required String answer, String? feedback}) = _Answer;

  factory Answer.fromJson(Map<String, dynamic> json) => _$AnswerFromJson(json);
}

@freezed
abstract class Quiz with _$Quiz {
  const factory Quiz({required List<QuizQuestion> questions}) = _Quiz;

  factory Quiz.fromJson(Map<String, dynamic> json) => _$QuizFromJson(json);
}

@freezed
abstract class QuizQuestion with _$QuizQuestion {
  const factory QuizQuestion({
    required String text,
    required String answer,
    required List<String> distractors,
    QuizAudioData? audioData,
  }) = _QuizQuestion;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) =>
      _$QuizQuestionFromJson(json);
}

@freezed
abstract class QuizAudioData with _$QuizAudioData {
  const factory QuizAudioData({
    required AudioClip audio,
    @Default([]) List<TranscriptLine> transcript,
  }) = _QuizAudioData;

  factory QuizAudioData.fromJson(Map<String, dynamic> json) =>
      _$QuizAudioDataFromJson(json);
}

@freezed
abstract class TranscriptLine with _$TranscriptLine {
  const factory TranscriptLine({
    required String character,
    required String text,
  }) = _TranscriptLine;

  factory TranscriptLine.fromJson(Map<String, dynamic> json) =>
      _$TranscriptLineFromJson(json);
}

// NOTE: Timestamps are seconds into the file; a scene's startTime is its delay before the audio starts.
@freezed
abstract class AudioClip with _$AudioClip {
  const factory AudioClip({
    required String filename,
    @Default(0) num startTime,
    num? startTimestamp,
    num? finishTimestamp,
  }) = _AudioClip;

  const AudioClip._();

  Uri get url => Uri.parse(
    'https://cdn.freecodecamp.org/curriculum/english/animation-assets/sounds/$filename',
  );

  Duration get start => _seconds(startTimestamp) ?? Duration.zero;

  Duration? get end => _seconds(finishTimestamp);

  String get id => '$filename-$startTimestamp-$finishTimestamp';

  static Duration? _seconds(num? value) =>
      value == null ? null : Duration(milliseconds: (value * 1000).round());

  factory AudioClip.fromJson(Map<String, dynamic> json) =>
      _$AudioClipFromJson(json);
}

@freezed
abstract class FillInTheBlank with _$FillInTheBlank {
  const factory FillInTheBlank({
    required String sentence,
    required List<Blank> blanks,
  }) = _FillInTheBlank;

  factory FillInTheBlank.fromJson(Map<String, dynamic> json) =>
      _$FillInTheBlankFromJson(json);
}

@freezed
abstract class Blank with _$Blank {
  const factory Blank({required String answer, @Default('') String feedback}) =
      _Blank;

  factory Blank.fromJson(Map<String, dynamic> json) => _$BlankFromJson(json);
}

Object? _readNoduleContents(Map<dynamic, dynamic> json, String key) =>
    json[key] ?? json['data'];

@Freezed(unionKey: 'type')
sealed class Nodule with _$Nodule {
  const factory Nodule.paragraph({
    @JsonKey(readValue: _readNoduleContents) required String contents,
  }) = ParagraphNodule;

  const factory Nodule.interactiveEditor({
    @JsonKey(readValue: _readNoduleContents) required List<NoduleFile> files,
  }) = InteractiveEditorNodule;

  factory Nodule.fromJson(Map<String, dynamic> json) => _$NoduleFromJson(json);
}

@freezed
abstract class NoduleFile with _$NoduleFile {
  const factory NoduleFile({
    required String name,
    required String ext,
    required String contents,
  }) = _NoduleFile;

  factory NoduleFile.fromJson(Map<String, dynamic> json) =>
      _$NoduleFileFromJson(json);
}

@freezed
abstract class Scene with _$Scene {
  const factory Scene({
    required SceneSetup setup,
    required List<SceneCommand> commands,
  }) = _Scene;

  factory Scene.fromJson(Map<String, dynamic> json) => _$SceneFromJson(json);
}

@freezed
abstract class SceneSetup with _$SceneSetup {
  const factory SceneSetup({
    required String background,
    required AudioClip audio,
    required List<SceneCharacter> characters,
  }) = _SceneSetup;

  factory SceneSetup.fromJson(Map<String, dynamic> json) =>
      _$SceneSetupFromJson(json);
}

@freezed
abstract class SceneCharacter with _$SceneCharacter {
  const factory SceneCharacter({
    required String character,
    required ScenePosition position,
    num? opacity,
  }) = _SceneCharacter;

  factory SceneCharacter.fromJson(Map<String, dynamic> json) =>
      _$SceneCharacterFromJson(json);
}

@freezed
abstract class ScenePosition with _$ScenePosition {
  const factory ScenePosition({
    required num x,
    required num y,
    required num z,
  }) = _ScenePosition;

  factory ScenePosition.fromJson(Map<String, dynamic> json) =>
      _$ScenePositionFromJson(json);
}

@freezed
abstract class SceneCommand with _$SceneCommand {
  const factory SceneCommand({
    required String character,
    required num startTime,
    num? finishTime,
    String? background,
    ScenePosition? position,
    num? opacity,
    SceneDialogue? dialogue,
  }) = _SceneCommand;

  factory SceneCommand.fromJson(Map<String, dynamic> json) =>
      _$SceneCommandFromJson(json);
}

@freezed
abstract class SceneDialogue with _$SceneDialogue {
  const factory SceneDialogue({required String text, required String align}) =
      _SceneDialogue;

  factory SceneDialogue.fromJson(Map<String, dynamic> json) =>
      _$SceneDialogueFromJson(json);
}
