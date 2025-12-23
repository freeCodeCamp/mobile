// TODO: Make the test customizable for specific superblocks, blocks, and challenges

import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/service/learn/learn_file_service.dart';
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
      'responsive-web-design-v9',
      'javascript-v9',
      'python-v9',
      'the-odin-project',
      'dev-playground'
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
    final babelWebView = widgetState.babelWebView;
    expect(babelWebView.isRunning(), true);

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
          if (![0, 1, 5, 6, 14, 20, 23, 25, 26, 27, 28, 29]
              .contains(currChallenge['challengeType'])) {
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
          print(
              'Challenge: ${challenge.id} - ${challenge.title} - ${challenge.challengeType}');

          String getLines(String contents, [List? range]) {
            if (range == null || range.isEmpty) {
              return challenge.files[0].contents;
            }

            final lines = contents.split('\n');
            final editableLines = (range[1] <= range[0])
                ? []
                : lines.sublist(
                    min(range[0], lines.length),
                    min(range[1] - 1, lines.length),
                  );

            return editableLines.join('\n');
          }

          final LearnFileService fileService = locator<LearnFileService>();

          ChallengeFile currentFile =
              await fileService.getCurrentEditedFileFromCache(
            challenge,
          );

          String editableRegion = getLines(
            currentFile.contents,
            challenge.files[0].editableRegionBoundaries,
          );

          ScriptBuilder builder = ScriptBuilder();
          bool testFailed = false;

          await testController!.callAsyncJavaScript(
            functionBody: ScriptBuilder.runnerScript,
            arguments: {
              'userCode': await builder.buildUserCode(
                challenge,
                babelWebView.webViewController,
                testing: true,
              ),
              'workerType': builder.getWorkerType(challenge.challengeType),
              'combinedCode': await builder.combinedCode(challenge),
              'editableRegionContent': editableRegion,
              'hooks': {
                'beforeAll': challenge.hooks.beforeAll,
                'beforeEach': challenge.hooks.beforeEach,
                'afterEach': challenge.hooks.afterEach,
              },
            },
          );

          for (ChallengeTest test in challenge.tests) {
            final testRes = await testController.callAsyncJavaScript(
              functionBody: ScriptBuilder.testExecutionScript,
              arguments: {
                'testStr': test.javaScript,
              },
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
