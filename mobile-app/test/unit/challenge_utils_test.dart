import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/utils/challenge_utils.dart';

void main() {
  Challenge createChallenge({
    required String id,
    required String title,
  }) {
    return Challenge(
      id: id,
      block: 'block1',
      title: title,
      description: '',
      instructions: '',
      dashedName: 'challenge-$id',
      superBlock: 'superblock',
      challengeType: 0,
      tests: [],
      files: [],
      helpCategory: HelpCategory.htmlCss,
      transcript: '',
      hooks: Hooks(beforeAll: '', beforeEach: '', afterEach: ''),
    );
  }

  Block createBlock(List<Challenge> challenges) {
    return Block(
      superBlock: SuperBlock(dashedName: 'superblock', name: 'Super Block'),
      layout: BlockLayout.challengeList,
      label: BlockLabel.lecture,
      name: 'Block 1',
      dashedName: 'block-1',
      description: [],
      challenges: challenges
          .map((c) => ChallengeOrder(id: c.id, title: c.title))
          .toList(),
      challengeTiles: [],
    );
  }

  group('handleChallengeTitle', () {
    test('should return empty string if the block contains a single challenge',
        () {
      final challenge = createChallenge(id: '1', title: 'HTML Review');
      final block = createBlock([challenge]);

      expect(handleChallengeTitle(challenge, block), '');
    });

    test("should return empty string when challenge title contains 'Dialogue'",
        () {
      final challenge = createChallenge(id: '1', title: 'Dialogue 1');
      final block = createBlock([challenge]);

      expect(handleChallengeTitle(challenge, block), '');
    });

    test("should return empty string when challenge title contains 'Step'", () {
      final challenge = createChallenge(id: '1', title: 'Step 1');
      final other = createChallenge(id: '2', title: 'Task 1');
      final block = createBlock([challenge, other]);

      expect(handleChallengeTitle(challenge, block), '');
    });

    test('should return correct Task title with count', () {
      final dialogue = createChallenge(id: '3', title: 'Dialogue 1');
      final challenge1 = createChallenge(id: '1', title: 'Task 1');
      final challenge2 = createChallenge(id: '2', title: 'Task 2');
      final challenge3 = createChallenge(id: '3', title: 'Task 3');
      final block = createBlock([dialogue, challenge1, challenge2, challenge3]);

      expect(handleChallengeTitle(challenge1, block), 'Task 1 of 3');
      expect(handleChallengeTitle(challenge2, block), 'Task 2 of 3');
      expect(handleChallengeTitle(challenge3, block), 'Task 3 of 3');
    });

    test('should return correct Step title with count', () {
      final challenge1 = createChallenge(id: '1', title: 'Intro');
      final challenge2 = createChallenge(id: '2', title: 'Content');
      final block = createBlock([challenge1, challenge2]);

      expect(handleChallengeTitle(challenge1, block), 'Step 1 of 2');
      expect(handleChallengeTitle(challenge2, block), 'Step 2 of 2');
    });
  });

  group('formatMonthFromDate', () {
    test('should format date correctly', () {
      final date = DateTime(2025, 1, 15);
      expect(formatMonthFromDate(date), 'January 2025');
    });
  });

  group('parseMonthYear', () {
    test('should parse date correctly', () {
      final result = parseMonthYear('January 2025');
      expect(result.year, 2025);
      expect(result.month, 1);
      expect(result.day, 1);
    });
  });

  group('formatChallengeDate', () {
    test('formats single-digit month and day with leading zeros', () {
      final date = DateTime(2025, 3, 7);
      expect(formatChallengeDate(date), '2025-03-07');
    });

    test('formats double-digit month and day correctly', () {
      final date = DateTime(2025, 12, 31);
      expect(formatChallengeDate(date), '2025-12-31');
    });
  });
}
