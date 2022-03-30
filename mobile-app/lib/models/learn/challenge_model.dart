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
        instructions: data['instructions'],
        tests: ChallengeTest.returnChallengeTests(data['fields']['tests']),
        files: ChallengeFile.returnChallengeFiles(data['challengeFiles']));
  }
}

class ChallengeTest {
  final String instruction;
  final String javaScript;

  const ChallengeTest({required this.instruction, required this.javaScript});

  static List<ChallengeTest> returnChallengeTests(List tests) {
    List<ChallengeTest> challengeTests = [];

    for (Map<String, dynamic> test in tests) {
      challengeTests.add(ChallengeTest.fromJson(test));
    }

    return challengeTests;
  }

  factory ChallengeTest.fromJson(Map<String, dynamic> data) {
    return ChallengeTest(
        instruction: data['text'], javaScript: data['testString']);
  }
}

class ChallengeFile {
  final String fileName;
  final String fileExtension;
  final String fileContents;

  const ChallengeFile(
      {required this.fileName,
      required this.fileExtension,
      required this.fileContents});

  static List<ChallengeFile> returnChallengeFiles(List inComingFiles) {
    List<ChallengeFile> files = [];

    for (Map<String, dynamic> file in inComingFiles) {
      files.add(ChallengeFile.fromJson(file));
    }

    return files;
  }

  factory ChallengeFile.fromJson(Map<String, dynamic> data) {
    return ChallengeFile(
        fileName: data['name'],
        fileExtension: data['ext'],
        fileContents: data['contents']);
  }
}
