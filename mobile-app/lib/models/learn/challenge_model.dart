import 'package:freecodecamp/enums/ext_type.dart';

// NOTE: For reference
enum ChallengeType {
  html, // 0
  js, // 1
  backend, // 2
  zipline, // 3
  frontEndProject, // 3
  backEndProject, // 4
  jsProject, // 5
  modern, // 6
  step, // 7
  quiz, // 8
  invalid, // 9
  pythonProject, // 10
  video, // 11
  codeAllyPractice, // 12
  codeAllyCert, // 13
  multifileCertProject, // 14
  theOdinProject, // 15
  colab, // 16
  exam // 17
}

enum HelpCategory {
  javascript('JavaScript'),
  htmlCss('HTML-CSS'),
  python('Python'),
  backend('Backend Development'),
  cSharp('C-Sharp'),
  english('English'),
  chinese('Chinese Curriculum'),
  spanish('Spanish Curriculum'),
  odin('Odin'),
  euler('Euler'),
  rosetta('Rosetta');

  static HelpCategory fromValue(String value) {
    return HelpCategory.values.firstWhere(
      (category) => category.value == value,
      orElse: () => throw ArgumentError('Invalid help category value: $value'),
    );
  }

  final String value;
  const HelpCategory(this.value);
}

class Challenge {
  final String id;
  final String block;
  final String title;
  final String description;
  final String instructions;
  final String dashedName;
  final String superBlock;
  final String? videoId;
  final int challengeType;
  final HelpCategory helpCategory;
  final String? explanation;
  final String transcript;

  final List<ChallengeTest> tests;
  final List<ChallengeFile> files;
  final Hooks hooks;

  // English Challenges
  final FillInTheBlank? fillInTheBlank;
  final EnglishAudio? audio;
  final Scene? scene;

  // Nodules for interactive challenges
  final List<Nodules>? nodules;

  final List<Question>? questions;

  // Challenge Type 15 - Odin
  final List<String>? assignments;

  // Challenge Type 8 - Quiz
  // This list contains multiple sets of quiz
  final List<Quiz>? quizzes;

  Challenge({
    required this.id,
    required this.block,
    required this.title,
    required this.description,
    required this.instructions,
    required this.dashedName,
    required this.superBlock,
    this.videoId,
    required this.challengeType,
    required this.tests,
    required this.files,
    required this.helpCategory,
    this.explanation,
    required this.transcript,
    this.nodules,
    this.questions,
    this.assignments,
    this.fillInTheBlank,
    this.audio,
    this.scene,
    this.quizzes,
    required this.hooks,
  });

  factory Challenge.fromJson(Map<String, dynamic> data) {
    return Challenge(
      id: data['id'],
      block: data['block'],
      title: data['title'],
      description: data['description'] ?? '',
      instructions: data['instructions'] ?? '',
      dashedName: data['dashedName'],
      superBlock: data['superBlock'],
      videoId: data['videoId'],
      challengeType: data['challengeType'],
      helpCategory: HelpCategory.fromValue(data['helpCategory']),
      explanation: data['explanation'] ?? '',
      transcript: data['transcript'] ?? '',
      fillInTheBlank: data['fillInTheBlank'] != null
          ? FillInTheBlank.fromJson(data['fillInTheBlank'])
          : null,
      audio: data['scene'] != null
          ? EnglishAudio.fromJson(data['scene']['setup']['audio'])
          : null,
      tests: (data['tests'] ?? [])
          .map<ChallengeTest>((file) => ChallengeTest.fromJson(file))
          .toList(),
      files: (data['challengeFiles'] ?? [])
          .map<ChallengeFile>((file) => ChallengeFile.fromJson(file))
          .toList(),
      nodules: (data['nodules'] ?? [])
          .map<Nodules>((nodule) => Nodules.fromJson(nodule))
          .toList(),
      questions: (data['questions'] as List).isNotEmpty
          ? (data['questions'] as List)
              .map<Question>((q) => Question.fromJson(q))
              .toList()
          : null,
      assignments: data['assignments'] != null
          ? (data['assignments'] as List).cast<String>()
          : null,
      scene: data['scene'] != null ? Scene.fromJson(data['scene']) : null,
      hooks: Hooks.fromJson(
        data['hooks'] ?? {'beforeAll': ''},
      ),
      quizzes: (data['quizzes'] != null)
          ? (data['quizzes'] as List)
              .map<Quiz>((quiz) => Quiz.fromJson(quiz))
              .toList()
          : null,
    );
  }

  static toJson(Challenge challenge) {
    return {
      'id': challenge.id,
      'block': challenge.block,
      'title': challenge.title,
      'description': challenge.description,
      'instructions': challenge.instructions,
      'dashedName': challenge.dashedName,
      'superBlock': challenge.superBlock,
      'videoId': challenge.videoId,
      'challengeType': challenge.challengeType,
      'helpCategory': challenge.helpCategory.value,
      'transcript': challenge.transcript,
      'tests': challenge.tests
          .map(
            (challengeTest) => {
              'text': challengeTest.instruction,
              'testString': challengeTest.javaScript
            },
          )
          .toList(),
      'challengeFiles': challenge.files
          .map(
            (challengeFile) => {
              'ext': challengeFile.ext.name,
              'name': challengeFile.name,
              'head': challengeFile.head,
              'tail': challengeFile.tail,
              'contents': challengeFile.contents,
              'editableRegionBoundaries':
                  challengeFile.editableRegionBoundaries,
              'history': challengeFile.history,
              'fileKey': challengeFile.fileKey,
            },
          )
          .toList(),
      'questions': challenge.questions
          ?.map((question) => {
                'text': question.text,
                'answers': question.answers,
                'solution': question.solution,
              })
          .toList(),
      'quizzes': challenge.quizzes
          ?.map((quiz) => {
                'questions': quiz.questions
                    .map((question) => {
                          'text': question.text,
                          'answers': question.answers,
                          'solution': question.solution,
                        })
                    .toList(),
              })
          .toList(),
    };
  }
}

class Hooks {
  final String beforeAll;
  final String beforeEach;
  final String afterEach;

  Hooks({
    required this.beforeAll,
    required this.beforeEach,
    required this.afterEach,
  });

  factory Hooks.fromJson(Map<String, dynamic> data) {
    return Hooks(
      beforeAll: data['beforeAll'] ?? '',
      beforeEach: data['beforeEach'] ?? '',
      afterEach: data['afterEach'] ?? '',
    );
  }
}

sealed class StringOrList {}

enum NoduleType {
  paragraph('paragraph'),
  interactiveEditor('interactiveEditor');

  final String type;

  const NoduleType(this.type);
}

class NoduleTypeString extends StringOrList {
  final String value;

  NoduleTypeString(this.value);
}

class NoduleTypeList extends StringOrList {
  final List<InterActiveFile> value;

  NoduleTypeList(this.value);
}

class Nodules {
  final NoduleType type;
  final StringOrList data;

  Nodules({
    required this.type,
    required this.data,
  });

  String asString() {
    return (data as NoduleTypeString).value;
  }

  List<InterActiveFile> asList() {
    return (data as NoduleTypeList).value;
  }

  factory Nodules.fromJson(Map<String, dynamic> data) {
    final noduleType = NoduleType.values.firstWhere(
      (type) => type.type == data['type'],
      orElse: () => throw ArgumentError('Invalid nodule type: ${data['type']}'),
    );

    final noduleData = data['data'];
    if (noduleType == NoduleType.paragraph) {
      return Nodules(
        type: noduleType,
        data: NoduleTypeString(noduleData),
      );
    } else if (noduleType == NoduleType.interactiveEditor) {
      return Nodules(
        type: noduleType,
        data: NoduleTypeList(
          noduleData
              .map<InterActiveFile>(
                (item) => InterActiveFile.fromJson(item),
              )
              .toList(),
        ),
      );
    } else {
      throw ArgumentError(
          'Invalid nodule data type: ${noduleData.runtimeType}');
    }
  }
}

class InterActiveFile {
  final String name;
  final String contents;
  final String ext;

  InterActiveFile({
    required this.ext,
    required this.name,
    required this.contents,
  });

  factory InterActiveFile.fromJson(Map<String, dynamic> data) {
    return InterActiveFile(
      ext: data['ext'],
      name: data['name'],
      contents: data['contents'],
    );
  }
}

class Question {
  final String text;
  final List<Answer> answers;
  final int solution;

  Question({
    required this.text,
    required this.answers,
    required this.solution,
  });

  factory Question.fromJson(Map<String, dynamic> data) {
    return Question(
      text: data['text'],
      answers: (data['answers'] ?? [])
          .map<Answer>(
            (answer) => Answer.fromJson(answer),
          )
          .toList(),
      solution: data['solution'],
    );
  }
}

class Answer {
  final String answer;
  String? feedback;

  Answer({
    required this.answer,
    this.feedback,
  });

  factory Answer.fromJson(Map<String, dynamic> data) {
    return Answer(
      answer: data['answer'],
      feedback: data['feedback'],
    );
  }
}

class ChallengeTest {
  final String instruction;
  final String javaScript;

  ChallengeTest({
    required this.instruction,
    required this.javaScript,
  });

  factory ChallengeTest.fromJson(Map<String, dynamic> data) {
    return ChallengeTest(
      instruction: data['text'],
      javaScript: data['testString'],
    );
  }
}

class ChallengeFile {
  final Ext ext;
  final String name;
  final String? head;
  final String? tail;
  final String contents;
  final List<String> history;
  List editableRegionBoundaries;
  final String fileKey;

  ChallengeFile({
    required this.ext,
    required this.name,
    this.head,
    this.tail,
    required this.editableRegionBoundaries,
    required this.contents,
    required this.history,
    required this.fileKey,
  });

  factory ChallengeFile.fromJson(Map<String, dynamic> data) {
    return ChallengeFile(
      ext: parseExt(data['ext']),
      name: data['name'],
      head: data['head'],
      tail: data['tail'],
      contents: data['contents'],
      editableRegionBoundaries: data['editableRegionBoundaries'] ?? [],
      history: ((data['history'] ?? []) as List).cast<String>(),
      fileKey: data['fileKey'] ?? data['name'] + data['ext'],
    );
  }
}

class FillInTheBlank {
  final String sentence;
  final List<Blank> blanks;

  const FillInTheBlank({required this.sentence, required this.blanks});

  factory FillInTheBlank.fromJson(Map<String, dynamic> data) {
    return FillInTheBlank(
      sentence: data['sentence'],
      blanks: data['blanks']
          .map<Blank>(
            (blank) => Blank.fromJson(blank),
          )
          .toList(),
    );
  }
}

class Blank {
  final String answer;
  final String feedback;

  const Blank({
    required this.answer,
    required this.feedback,
  });

  factory Blank.fromJson(Map<String, dynamic> data) {
    return Blank(
      answer: data['answer'],
      feedback: data['feedback'] ?? '',
    );
  }
}

class QuizQuestion {
  final String text;
  final List<Answer> answers;
  final int solution;

  const QuizQuestion({
    required this.text,
    required this.answers,
    required this.solution,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> data) {
    // Quiz data has answer and distractors as separate fields rather than in a single array.
    // We combine them into one so that the question schema
    // is consistent with the other MCQ challenges.
    final allAnswers = [
      ...(data['distractors'] as List)
          .map<Answer>((item) => Answer(answer: item)),
      Answer(answer: data['answer'])
    ];

    // shuffle so the correct answer is not always the last
    allAnswers.shuffle();

    // Solution is the index of the correct answer in the shuffled list.
    // + 1 here so that it matches the 1-based index used in the UI logic.
    final solutionIndex =
        allAnswers.indexWhere((a) => a.answer == data['answer']) + 1;

    return QuizQuestion(
        text: data['text'], answers: allAnswers, solution: solutionIndex);
  }
}

class Quiz {
  final List<QuizQuestion> questions;

  const Quiz({
    required this.questions,
  });

  factory Quiz.fromJson(Map<String, dynamic> data) {
    return Quiz(
      questions: (data['questions'] as List)
          .map<QuizQuestion>((item) => QuizQuestion.fromJson(item))
          .toList(),
    );
  }
}

class Scene {
  final SceneSetup setup;
  final List<SceneCommand> commands;

  const Scene({
    required this.setup,
    required this.commands,
  });

  factory Scene.fromJson(Map<String, dynamic> data) {
    return Scene(
      setup: SceneSetup.fromJson(data['setup']),
      commands: data['commands']
          .map<SceneCommand>(
            (command) => SceneCommand.fromjson(command),
          )
          .toList(),
    );
  }
}

class SceneSetup {
  final String background;
  final bool? alwaysShowDialogue;
  final EnglishAudio audio;
  final List<SceneCharacter> characters;

  const SceneSetup({
    required this.background,
    required this.audio,
    required this.characters,
    this.alwaysShowDialogue,
  });

  factory SceneSetup.fromJson(Map<String, dynamic> data) {
    return SceneSetup(
      background: data['background'],
      audio: EnglishAudio.fromJson(data['audio']),
      characters: data['characters']
          .map<SceneCharacter>(
            (character) => SceneCharacter.fromJson(character),
          )
          .toList(),
    );
  }
}

class SceneCommand {
  final String? background;
  final String character;
  final SceneCharacterPosition? position;
  final num? opacity;
  final num startTime;
  final num? finishTime;
  final SceneDialogue? dialogue;

  const SceneCommand({
    this.background,
    required this.character,
    this.position,
    this.opacity,
    required this.startTime,
    this.finishTime,
    this.dialogue,
  });

  factory SceneCommand.fromjson(Map<String, dynamic> data) {
    return SceneCommand(
      background: data['background'],
      character: data['character'],
      position: data['position'] != null
          ? SceneCharacterPosition.fromJson(data['position'])
          : null,
      opacity: data['opacity'],
      startTime: data['startTime'],
      finishTime: data['finishTime'],
      dialogue: data['dialogue'] != null
          ? SceneDialogue.fromJson(
              data['dialogue'],
            )
          : null,
    );
  }
}

class SceneCharacter {
  final String character;
  final num? opacity;
  final SceneCharacterPosition position;

  const SceneCharacter({
    required this.character,
    this.opacity,
    required this.position,
  });

  factory SceneCharacter.fromJson(Map<String, dynamic> data) {
    return SceneCharacter(
      character: data['character'],
      opacity: data['opacity'],
      position: SceneCharacterPosition.fromJson(
        data['position'],
      ),
    );
  }
}

class SceneCharacterPosition {
  final num x;
  final num y;
  final num z;

  const SceneCharacterPosition({
    required this.x,
    required this.y,
    required this.z,
  });

  factory SceneCharacterPosition.fromJson(Map<String, dynamic> data) {
    return SceneCharacterPosition(x: data['x'], y: data['y'], z: data['z']);
  }
}

class SceneDialogue {
  final String text;
  final String align;

  const SceneDialogue({
    required this.text,
    required this.align,
  });

  factory SceneDialogue.fromJson(Map<String, dynamic> data) {
    return SceneDialogue(
      text: data['text'],
      align: data['align'],
    );
  }
}

class EnglishAudio {
  final String fileName;
  final String startTime;
  final String? startTimeStamp;
  final String? finishTimeStamp;

  const EnglishAudio({
    required this.fileName,
    required this.startTime,
    required this.startTimeStamp,
    required this.finishTimeStamp,
  });

  factory EnglishAudio.fromJson(Map<String, dynamic> data) {
    return EnglishAudio(
      fileName: data['filename'],
      startTime: data['startTime'].toString(),
      startTimeStamp: data['startTimestamp']?.toString(),
      finishTimeStamp: data['finishTimestamp']?.toString(),
    );
  }
}
