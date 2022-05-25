import 'package:freecodecamp/enums/challenge_test_state_type.dart';
import 'package:freecodecamp/enums/ext_type.dart';

class Challenge {
  final String block;
  final String title;
  final String description;
  final String instructions;

  final List<ChallengeTest> tests;
  final List<ChallengeFile> files;

  const Challenge(
      {required this.block,
      required this.title,
      required this.description,
      required this.instructions,
      required this.tests,
      required this.files});

  factory Challenge.fromJson(Map<String, dynamic> data) {
    return Challenge(
      block: data['block'],
      title: data['title'],
      description: data['description'],
      instructions: data['instructions'] ?? '',
      tests: (data['fields']['tests'] as List)
          .map<ChallengeTest>((file) => ChallengeTest.fromJson(file))
          .toList(),
      files: (data['challengeFiles'] as List)
          .map<ChallengeFile>((file) => ChallengeFile.fromJson(file))
          .toList(),
    );
  }
}

class ChallengeTest {
  final String instruction;
  final String javaScript;
  ChallengeTestState testState;

  ChallengeTest(
      {required this.instruction,
      this.testState = ChallengeTestState.waiting,
      required this.javaScript});

  factory ChallengeTest.fromJson(Map<String, dynamic> data) {
    return ChallengeTest(
        instruction: data['text'], javaScript: data['testString']);
  }
}

class ChallengeFile {
  final Ext ext;
  final String name;
  final String contents;

  ChallengeFile({
    required this.ext,
    required this.name,
    required this.contents,
  });

  factory ChallengeFile.fromJson(Map<String, dynamic> data) {
    return ChallengeFile(
      ext: parseExt(data['ext']),
      name: data['name'],
      contents: data['contents'],
    );
  }
}
