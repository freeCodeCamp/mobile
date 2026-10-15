// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Challenge _$ChallengeFromJson(Map<String, dynamic> json) => _Challenge(
  id: json['id'] as String,
  block: json['block'] as String,
  superBlock: json['superBlock'] as String,
  title: json['title'] as String,
  dashedName: json['dashedName'] as String,
  challengeType: (json['challengeType'] as num).toInt(),
  helpCategory: json['helpCategory'] as String? ?? '',
  description: json['description'] as String? ?? '',
  instructions: json['instructions'] as String? ?? '',
  explanation: json['explanation'] as String? ?? '',
  transcript: json['transcript'] as String? ?? '',
  videoId: json['videoId'] as String?,
  questions:
      (json['questions'] as List<dynamic>?)
          ?.map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  assignments:
      (json['assignments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  quizzes:
      (json['quizzes'] as List<dynamic>?)
          ?.map((e) => Quiz.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  nodules:
      (json['nodules'] as List<dynamic>?)
          ?.map((e) => Nodule.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  fillInTheBlank: json['fillInTheBlank'] == null
      ? null
      : FillInTheBlank.fromJson(json['fillInTheBlank'] as Map<String, dynamic>),
  scene: json['scene'] == null
      ? null
      : Scene.fromJson(json['scene'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChallengeToJson(_Challenge instance) =>
    <String, dynamic>{
      'id': instance.id,
      'block': instance.block,
      'superBlock': instance.superBlock,
      'title': instance.title,
      'dashedName': instance.dashedName,
      'challengeType': instance.challengeType,
      'helpCategory': instance.helpCategory,
      'description': instance.description,
      'instructions': instance.instructions,
      'explanation': instance.explanation,
      'transcript': instance.transcript,
      'videoId': instance.videoId,
      'questions': instance.questions,
      'assignments': instance.assignments,
      'quizzes': instance.quizzes,
      'nodules': instance.nodules,
      'fillInTheBlank': instance.fillInTheBlank,
      'scene': instance.scene,
    };

_Question _$QuestionFromJson(Map<String, dynamic> json) => _Question(
  text: json['text'] as String,
  answers: (json['answers'] as List<dynamic>)
      .map((e) => Answer.fromJson(e as Map<String, dynamic>))
      .toList(),
  solution: (json['solution'] as num).toInt(),
);

Map<String, dynamic> _$QuestionToJson(_Question instance) => <String, dynamic>{
  'text': instance.text,
  'answers': instance.answers,
  'solution': instance.solution,
};

_Answer _$AnswerFromJson(Map<String, dynamic> json) => _Answer(
  answer: json['answer'] as String,
  feedback: json['feedback'] as String?,
);

Map<String, dynamic> _$AnswerToJson(_Answer instance) => <String, dynamic>{
  'answer': instance.answer,
  'feedback': instance.feedback,
};

_Quiz _$QuizFromJson(Map<String, dynamic> json) => _Quiz(
  questions: (json['questions'] as List<dynamic>)
      .map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$QuizToJson(_Quiz instance) => <String, dynamic>{
  'questions': instance.questions,
};

_QuizQuestion _$QuizQuestionFromJson(Map<String, dynamic> json) =>
    _QuizQuestion(
      text: json['text'] as String,
      answer: json['answer'] as String,
      distractors: (json['distractors'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      audioData: json['audioData'] == null
          ? null
          : QuizAudioData.fromJson(json['audioData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QuizQuestionToJson(_QuizQuestion instance) =>
    <String, dynamic>{
      'text': instance.text,
      'answer': instance.answer,
      'distractors': instance.distractors,
      'audioData': instance.audioData,
    };

_QuizAudioData _$QuizAudioDataFromJson(Map<String, dynamic> json) =>
    _QuizAudioData(
      audio: AudioClip.fromJson(json['audio'] as Map<String, dynamic>),
      transcript:
          (json['transcript'] as List<dynamic>?)
              ?.map((e) => TranscriptLine.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$QuizAudioDataToJson(_QuizAudioData instance) =>
    <String, dynamic>{
      'audio': instance.audio,
      'transcript': instance.transcript,
    };

_TranscriptLine _$TranscriptLineFromJson(Map<String, dynamic> json) =>
    _TranscriptLine(
      character: json['character'] as String,
      text: json['text'] as String,
    );

Map<String, dynamic> _$TranscriptLineToJson(_TranscriptLine instance) =>
    <String, dynamic>{'character': instance.character, 'text': instance.text};

_AudioClip _$AudioClipFromJson(Map<String, dynamic> json) => _AudioClip(
  filename: json['filename'] as String,
  startTime: json['startTime'] as num? ?? 0,
  startTimestamp: json['startTimestamp'] as num?,
  finishTimestamp: json['finishTimestamp'] as num?,
);

Map<String, dynamic> _$AudioClipToJson(_AudioClip instance) =>
    <String, dynamic>{
      'filename': instance.filename,
      'startTime': instance.startTime,
      'startTimestamp': instance.startTimestamp,
      'finishTimestamp': instance.finishTimestamp,
    };

_FillInTheBlank _$FillInTheBlankFromJson(Map<String, dynamic> json) =>
    _FillInTheBlank(
      sentence: json['sentence'] as String,
      blanks: (json['blanks'] as List<dynamic>)
          .map((e) => Blank.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FillInTheBlankToJson(_FillInTheBlank instance) =>
    <String, dynamic>{'sentence': instance.sentence, 'blanks': instance.blanks};

_Blank _$BlankFromJson(Map<String, dynamic> json) => _Blank(
  answer: json['answer'] as String,
  feedback: json['feedback'] as String? ?? '',
);

Map<String, dynamic> _$BlankToJson(_Blank instance) => <String, dynamic>{
  'answer': instance.answer,
  'feedback': instance.feedback,
};

ParagraphNodule _$ParagraphNoduleFromJson(Map<String, dynamic> json) =>
    ParagraphNodule(
      contents: _readNoduleContents(json, 'contents') as String,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$ParagraphNoduleToJson(ParagraphNodule instance) =>
    <String, dynamic>{'contents': instance.contents, 'type': instance.$type};

InteractiveEditorNodule _$InteractiveEditorNoduleFromJson(
  Map<String, dynamic> json,
) => InteractiveEditorNodule(
  files: (_readNoduleContents(json, 'files') as List<dynamic>)
      .map((e) => NoduleFile.fromJson(e as Map<String, dynamic>))
      .toList(),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$InteractiveEditorNoduleToJson(
  InteractiveEditorNodule instance,
) => <String, dynamic>{'files': instance.files, 'type': instance.$type};

_NoduleFile _$NoduleFileFromJson(Map<String, dynamic> json) => _NoduleFile(
  name: json['name'] as String,
  ext: json['ext'] as String,
  contents: json['contents'] as String,
);

Map<String, dynamic> _$NoduleFileToJson(_NoduleFile instance) =>
    <String, dynamic>{
      'name': instance.name,
      'ext': instance.ext,
      'contents': instance.contents,
    };

_Scene _$SceneFromJson(Map<String, dynamic> json) => _Scene(
  setup: SceneSetup.fromJson(json['setup'] as Map<String, dynamic>),
  commands: (json['commands'] as List<dynamic>)
      .map((e) => SceneCommand.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SceneToJson(_Scene instance) => <String, dynamic>{
  'setup': instance.setup,
  'commands': instance.commands,
};

_SceneSetup _$SceneSetupFromJson(Map<String, dynamic> json) => _SceneSetup(
  background: json['background'] as String,
  audio: AudioClip.fromJson(json['audio'] as Map<String, dynamic>),
  characters: (json['characters'] as List<dynamic>)
      .map((e) => SceneCharacter.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SceneSetupToJson(_SceneSetup instance) =>
    <String, dynamic>{
      'background': instance.background,
      'audio': instance.audio,
      'characters': instance.characters,
    };

_SceneCharacter _$SceneCharacterFromJson(Map<String, dynamic> json) =>
    _SceneCharacter(
      character: json['character'] as String,
      position: ScenePosition.fromJson(
        json['position'] as Map<String, dynamic>,
      ),
      opacity: json['opacity'] as num?,
    );

Map<String, dynamic> _$SceneCharacterToJson(_SceneCharacter instance) =>
    <String, dynamic>{
      'character': instance.character,
      'position': instance.position,
      'opacity': instance.opacity,
    };

_ScenePosition _$ScenePositionFromJson(Map<String, dynamic> json) =>
    _ScenePosition(
      x: json['x'] as num,
      y: json['y'] as num,
      z: json['z'] as num,
    );

Map<String, dynamic> _$ScenePositionToJson(_ScenePosition instance) =>
    <String, dynamic>{'x': instance.x, 'y': instance.y, 'z': instance.z};

_SceneCommand _$SceneCommandFromJson(Map<String, dynamic> json) =>
    _SceneCommand(
      character: json['character'] as String,
      startTime: json['startTime'] as num,
      finishTime: json['finishTime'] as num?,
      background: json['background'] as String?,
      position: json['position'] == null
          ? null
          : ScenePosition.fromJson(json['position'] as Map<String, dynamic>),
      opacity: json['opacity'] as num?,
      dialogue: json['dialogue'] == null
          ? null
          : SceneDialogue.fromJson(json['dialogue'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SceneCommandToJson(_SceneCommand instance) =>
    <String, dynamic>{
      'character': instance.character,
      'startTime': instance.startTime,
      'finishTime': instance.finishTime,
      'background': instance.background,
      'position': instance.position,
      'opacity': instance.opacity,
      'dialogue': instance.dialogue,
    };

_SceneDialogue _$SceneDialogueFromJson(Map<String, dynamic> json) =>
    _SceneDialogue(
      text: json['text'] as String,
      align: json['align'] as String,
    );

Map<String, dynamic> _$SceneDialogueToJson(_SceneDialogue instance) =>
    <String, dynamic>{'text': instance.text, 'align': instance.align};
