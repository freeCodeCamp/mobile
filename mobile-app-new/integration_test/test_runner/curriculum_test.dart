import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/repositories/prefs_repository.dart';
import 'package:mobile_app_new/learn/services/code_service.dart';
import 'package:mobile_app_new/learn/services/test_runner_service.dart';

// NOTE: integration_test_runner.dart --curriculum copies this in from freeCodeCamp/curriculum/generated.
const _curriculumPath = 'assets/learn/curriculum.json';

const _superBlocks = [
  'responsive-web-design-v9',
  'javascript-v9',
  'python-v9',
  'the-odin-project',
  'dev-playground',
];

const _editorTypes = {0, 1, 5, 6, 14, 20, 23, 25, 26, 27, 28, 29};

// NOTE: Ignores saved code on the device so every challenge runs its own solution.
class _NoPrefs implements LearnPrefsRepository {
  @override
  Future<String?> read(String key) async => null;

  @override
  Future<void> write(String key, String value) async {}

  @override
  Future<void> remove(String key) async {}
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Curriculum Test Runner', (WidgetTester tester) async {
    tester.printToConsole('Test starting');

    final container = ProviderContainer.test(
      overrides: [learnPrefsRepositoryProvider.overrideWithValue(_NoPrefs())],
    );

    final runners = <String, LearnTestRunnerService>{};
    for (final workerType in ['dom', 'javascript', 'python']) {
      final provider = learnTestRunnerServiceProvider(workerType);
      container.listen(provider, (_, _) {});
      runners[workerType] = await container.read(provider.future);
    }
    final code = container.read(learnCodeServiceProvider);

    final curriculum =
        jsonDecode(await rootBundle.loadString(_curriculumPath))
            as Map<String, dynamic>;
    // NOTE: Sent back through reportData; stdout from a device drops lines on long runs.
    var total = 0;
    final failedChallenges = <String>[];
    final failures = <String>[];

    for (final superBlock in _superBlocks) {
      tester.printToConsole('\nSUPERBLOCK: $superBlock');
      final blocks = curriculum[superBlock]['blocks'] as Map<String, dynamic>;

      for (final block in blocks.values) {
        tester.printToConsole('Block: ${block['meta']['dashedName']}');
        final challenges = (block['challenges'] as List)
          ..sort(
            (a, b) => (a['challengeOrder'] as int).compareTo(
              b['challengeOrder'] as int,
            ),
          );

        for (final (i, raw) in challenges.indexed) {
          if (!_editorTypes.contains(raw['challengeType'])) continue;

          final solution = (raw['solutions'] as List).isEmpty
              ? challenges[i + 1]['challengeFiles'] as List
              : (raw['solutions'] as List).first as List;
          for (final file in raw['challengeFiles'] as List) {
            final solved = solution.firstWhere(
              (s) => s['name'] == file['name'],
              orElse: () => null,
            );
            if (solved != null) file['contents'] = solved['contents'];
          }

          final id = raw['id'];
          final title = raw['title'];
          tester.printToConsole(
            'Challenge: $id - $title - ${raw['challengeType']}',
          );

          var challengeFailed = false;
          try {
            final challenge = Challenge.fromJson(raw as Map<String, dynamic>);
            final runner = runners[workerTypeOf(challenge.challengeType)]!;

            final results = await runner.run(
              userCode: await code.userCode(
                challenge,
                (js) => runner.transpile(js, challengeId: challenge.id),
              ),
              combinedCode: await code.combinedCode(challenge),
              editableContents: await code.editableContents(challenge),
              hooks: challenge.hooks,
              tests: challenge.tests,
            );

            for (final (j, result) in results.indexed) {
              if (result.pass) continue;
              final test = challenge.tests[j];
              failures.add(
                'TEST FAILED: $id - $title - ${test.text} - ${test.testString} - ${result.err}',
              );
              challengeFailed = true;
            }
          } catch (e) {
            failures.add('TEST FAILED: $id - $title - $e');
            challengeFailed = true;
          }

          total++;
          if (challengeFailed) failedChallenges.add('$id - $title');
          tester.printToConsole(
            challengeFailed
                ? 'Test(s) failed for challenge: $id - $title'
                : 'Test(s) passed for challenge: $id - $title',
          );
        }
      }
    }

    binding.reportData = {
      'curriculum': {
        'total': total,
        'failedChallenges': failedChallenges,
        'failures': failures,
      },
    };
    expect(failedChallenges, isEmpty);
  });
}
