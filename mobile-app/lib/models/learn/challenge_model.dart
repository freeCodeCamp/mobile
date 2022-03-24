class Challenge {
  final String block;
  final String title;
  final String description;
  final String instructions;

  final List<ChallengeTest> tests;

  const Challenge(
      {required this.block,
      required this.title,
      required this.description,
      required this.instructions,
      required this.tests});

  factory Challenge.fromJson(Map<String, dynamic> data) {
    return Challenge(
        block: data['block'],
        title: data['title'],
        description: data['description'],
        instructions: data['instructions'],
        tests: ChallengeTest.returnChallengeTests(data['fields']['tests']));
  }
}

class ChallengeTest {
  final String instruction;
  final String test;

  const ChallengeTest({required this.instruction, required this.test});

  static List<ChallengeTest> returnChallengeTests(List tests) {
    List<ChallengeTest> challengeTests = [];

    for (Map<String, String> test in tests) {
      challengeTests.add(ChallengeTest.fromJson(test));
    }

    return challengeTests;
  }

  factory ChallengeTest.fromJson(Map<String, dynamic> data) {
    return ChallengeTest(instruction: data['text'], test: data['testString']);
  }
}
