import 'package:freecodecamp/enums/challenge_test_state_type.dart';
import 'package:freecodecamp/enums/ext_type.dart';

class Challenge {
  final String id;
  final String block;
  final String title;
  final String description;
  final String instructions;
  final String slug;
  final String superBlock;
  final int challengeType;

  final List<ChallengeTest> tests;
  final List<ChallengeFile> files;
  List<ChallengeFile> solutions;

  Challenge(
      {required this.id,
      required this.block,
      required this.title,
      required this.description,
      required this.instructions,
      required this.slug,
      required this.superBlock,
      required this.challengeType,
      required this.tests,
      required this.files,
      required this.solutions});

  factory Challenge.fromJson(Map<String, dynamic> data,
      {bool testing = false}) {
    return Challenge(
        id: data['id'],
        block: data['block'],
        title: data['title'],
        description: data['description'],
        instructions: data['instructions'] ?? '',
        slug: testing ? '' : data['fields']['slug'],
        superBlock: data['superBlock'],
        challengeType: data['challengeType'],
        tests: ((testing ? data['tests'] : data['fields']['tests']) as List)
            .map<ChallengeTest>((file) => ChallengeTest.fromJson(file))
            .toList(),
        files: (data['challengeFiles'] as List)
            .map<ChallengeFile>((file) => ChallengeFile.fromJson(file))
            .toList(),
        solutions: ((data['solutions'] as List))
            .map<ChallengeFile>((file) => ChallengeFile.fromJson(file[0]))
            .toList());
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
  final String? head;
  final String? tail;
  final String contents;
  final List<String> history;
  final List editableRegionBoundaries;
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
