// TODO: Make the test customizable for specific superblocks, blocks, and challenges

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/ui/views/learn/test_runner.dart';
import 'package:integration_test/integration_test.dart';

import 'test_runner_view.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Curriculum Test Runner', (WidgetTester tester) async {
    tester.printToConsole('Test starting');

    // Setup the test environment with constants and functions
    await setupLocator();

    List<String> publicSBs = [
      '2022/responsive-web-design',
      'responsive-web-design',
      // 'javascript-algorithms-and-data-structures',
      // 'the-odin-project',
    ];

    String curriculumFilePath = 'assets/learn/curriculum.json';
    String curriculumFile = await rootBundle.loadString(curriculumFilePath);
    Map curriculumData = jsonDecode(curriculumFile);
    bool didTestsFail = false;

    // Setup the test widget and check web controller is not null
    await tester.pumpWidget(CurriculumTestRunner());
    await tester.pumpAndSettle();
    // NOTE: To be on the safe side, we wait for 30 seconds to make sure the webview is loaded
    await Future.delayed(Duration(seconds: 30));
    final widgetState = tester
        .state<CurriculumTestRunnerState>(find.byType(CurriculumTestRunner));
    expect(widgetState.webViewController, isNotNull);
    final testController = widgetState.webViewController;

    // Run the curriculum tests one by one
    var editorChallengeTypes = <int>{};
    for (var currSuperBlock in publicSBs) {
      print('\nSUPERBLOCK: $currSuperBlock');
      for (var currBlock in curriculumData[currSuperBlock]['blocks'].values) {
        print('Block: ${currBlock['meta']['name']}');
        List challenges = currBlock['challenges']
          ..sort((a, b) =>
              a['challengeOrder'].compareTo(b['challengeOrder']) as int);
        for (var i = 0; i < challenges.length; i++) {
          var currChallenge = challenges[i];
          editorChallengeTypes.add(currChallenge['challengeType']);

          // Skip non-editor challenges
          if (![0, 1, 5, 6, 14].contains(currChallenge['challengeType'])) {
            continue;
          }

          // "solutions" is present only for legacy certificates and last step for new cert challenges
          // New certificates checks against next challenge
          if (currChallenge['solutions'].isEmpty) {
            var nextChallenge = challenges[i + 1];
            for (var challengeFile in nextChallenge['challengeFiles']) {
              int fileIndex = currChallenge['challengeFiles'].indexWhere(
                  (element) => element['name'] == challengeFile['name']);
              if (fileIndex != -1) {
                currChallenge['challengeFiles'][fileIndex]['contents'] =
                    challengeFile['contents'];
              }
            }
          } else {
            for (var challengeFile in currChallenge['solutions'][0]) {
              int fileIndex = currChallenge['challengeFiles'].indexWhere(
                  (element) => element['name'] == challengeFile['name']);
              if (fileIndex != -1) {
                currChallenge['challengeFiles'][fileIndex]['contents'] =
                    challengeFile['contents'];
              }
            }
          }

          Challenge challenge = Challenge.fromJson(currChallenge);
          ScriptBuilder builder = ScriptBuilder(challenge: challenge);
          bool testFailed = false;

          await testController!.callAsyncJavaScript(
            functionBody: await builder.runnerScript(),
          );

          for (ChallengeTest test in challenge.tests) {
            String testString = test.javaScript
                .replaceAll('\\', '\\\\')
                .replaceAll('`', '\\`')
                .replaceAll('\$', r'\$');
            final testRes = await testController.callAsyncJavaScript(
              functionBody: '''
const testRes = await window.testRunner.runTest(`$testString`);
return testRes;
            ''',
            );
            if (testRes?.value['pass'] == null || testRes?.error != null) {
              print(
                  'TEST FAILED: ${challenge.id} - ${challenge.title} - ${test.instruction} - ${test.javaScript} - $testRes\n');
              testFailed = true;
              didTestsFail = true;
            }
          }

          if (testFailed) {
            print(
                'Test(s) failed for challenge: ${challenge.id} - ${challenge.title}');
          } else {
            print(
                'Test(s) passed for challenge: ${challenge.id} - ${challenge.title}');
          }
        }
      }
    }

    // Fail the integration test if any challenge tests failed
    expect(didTestsFail, false);
  });
}
