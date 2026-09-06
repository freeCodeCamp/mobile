import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';

void main() {
  group('Block.fromJson', () {
    test('filters challenge order entries from other superblocks', () {
      final block = Block.fromJson(
        {
          'name': 'Build a Greeting Bot',
          'blockLayout': 'challenge-grid',
          'blockLabel': 'workshop',
          'challengeOrder': [
            {
              'id': 'js-step-1',
              'title': 'Step 1',
              'superBlock': 'javascript-v9',
            },
            {
              'id': 'js-step-2',
              'title': 'Step 2',
              'superBlock': 'javascript-v9',
            },
            {
              'id': 'rwd-step-1',
              'title': 'Step 1',
              'superBlock': 'responsive-web-design-v9',
            },
            {
              'id': 'rwd-step-2',
              'title': 'Step 2',
              'superBlock': 'responsive-web-design-v9',
            },
          ],
        },
        [],
        'workshop-greeting-bot',
        'javascript-v9',
        'JavaScript Certification',
      );

      expect(block.challenges.map((challenge) => challenge.id), [
        'js-step-1',
        'js-step-2',
      ]);
      expect(block.challengeTiles.map((challenge) => challenge.id), [
        'js-step-1',
        'js-step-2',
      ]);
    });

    test('deduplicates repeated challenge ids', () {
      final block = Block.fromJson(
        {
          'name': 'Build a Greeting Bot',
          'blockLayout': 'challenge-grid',
          'blockLabel': 'workshop',
          'challengeOrder': [
            {'id': 'step-1', 'title': 'Step 1'},
            {'id': 'step-2', 'title': 'Step 2'},
            {'id': 'step-1', 'title': 'Step 1'},
            {'id': 'step-2', 'title': 'Step 2'},
          ],
        },
        [],
        'workshop-greeting-bot',
        'javascript-v9',
        'JavaScript Certification',
      );

      expect(block.challenges.map((challenge) => challenge.id), [
        'step-1',
        'step-2',
      ]);
      expect(block.challengeTiles.length, 2);
    });

    test('supports legacy list challenge order entries', () {
      final block = Block.fromJson(
        {
          'name': 'Legacy Block',
          'blockLayout': 'challenge-list',
          'blockLabel': 'legacy',
          'challengeOrder': [
            ['step-1', 'Step 1'],
            ['step-2', 'Step 2'],
          ],
        },
        [],
        'legacy-block',
        'responsive-web-design',
        'Responsive Web Design',
      );

      expect(block.challenges.map((challenge) => challenge.id), [
        'step-1',
        'step-2',
      ]);
      expect(block.challengeTiles.map((challenge) => challenge.dashedName), [
        'step-1',
        'step-2',
      ]);
    });
  });
}
