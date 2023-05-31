import 'package:freecodecamp/enums/challenge_test_state_type.dart';
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

  final List<ChallengeTest> tests;
  final List<ChallengeFile> files;

  // Challenge Type 11 - Video
  Question? question;

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
    this.question,
  });

  factory Challenge.fromJson(Map<String, dynamic> data) {
    return Challenge(
      id: data['id'],
      block: data['block'],
      title: data['title'],
      description: data['description'],
      instructions: data['instructions'] ?? '',
      dashedName: data['dashedName'],
      superBlock: data['superBlock'],
      videoId: data['videoId'],
      challengeType: data['challengeType'],
      tests: (data['tests'] ?? [])
          .map<ChallengeTest>((file) => ChallengeTest.fromJson(file))
          .toList(),
      files: (data['challengeFiles'] ?? [])
          .map<ChallengeFile>((file) => ChallengeFile.fromJson(file))
          .toList(),
      question:
          data['question'] != null ? Question.fromJson(data['question']) : null,
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
              'editableRegionBoundries': challengeFile.editableRegionBoundaries,
              'history': challengeFile.history,
              'fileKey': challengeFile.fileKey,
            },
          )
          .toList(),
      'question': challenge.question != null
          ? {
              'text': challenge.question!.text,
              'answers': challenge.question!.answers,
              'solution': challenge.question!.solution,
            }
          : null,
    };
  }
}

class Question {
  final String text;
  final List<String> answers;
  final int solution;

  Question({
    required this.text,
    required this.answers,
    required this.solution,
  });

  factory Question.fromJson(Map<String, dynamic> data) {
    return Question(
      text: data['text'],
      answers: (data['answers'] as List).cast<String>(),
      solution: data['solution'],
    );
  }
}

class ChallengeTest {
  final String instruction;
  final String javaScript;
  ChallengeTestState testState;

  ChallengeTest({
    required this.instruction,
    this.testState = ChallengeTestState.waiting,
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
