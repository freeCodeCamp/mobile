// Command to run: flutter drive --no-pub --driver=test_driver/integration_test.dart --target=test/curriculum_test_runner.dart --dart-define CURRENT_DIR=$(pwd)
// TODO: Add above command to integration_test_runner.dart
// TODO: Possibly think of a better file name

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/enums/ext_type.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/service/learn/learn_file_service.dart';
import 'package:freecodecamp/ui/views/learn/test_runner.dart';
import 'package:freecodecamp/ui/views/test/curriculum_test_runner.dart';
import 'package:integration_test/integration_test.dart';

final dio = Dio();

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding();
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Curriculum Test Runner', (WidgetTester tester) async {
    tester.printToConsole('Test starting');

    // Setup the test environment with constants and functions
    await setupLocator();
    final LearnFileService fileService = locator<LearnFileService>();

    Future<String> htmlFlow(
      Challenge challenge,
      Ext ext, {
      bool testing = true,
    }) async {
      String firstHTMlfile = await fileService.getFirstFileFromCache(
        challenge,
        ext,
        testing: testing,
      );

      firstHTMlfile = fileService.removeExcessiveScriptsInHTMLdocument(
        firstHTMlfile,
      );

      String parsedWithStyleTags =
          await fileService.parseCssDocmentsAsStyleTags(
        challenge,
        firstHTMlfile,
        testing: testing,
      );

      if (challenge.id != '646c48df8674cf2b91020ecc') {
        firstHTMlfile = fileService.changeActiveFileLinks(
          parsedWithStyleTags,
        );
      }

      return firstHTMlfile;
    }

    Future<String> combinedCode(Challenge challenge) async {
      String combinedCode = '';

      for (ChallengeFile file in challenge.files) {
        combinedCode +=
            await fileService.getExactFileFromCache(challenge, file);
      }

      return combinedCode;
    }

    WorkerType getWorkerType(int challengeType) {
      switch (challengeType) {
        case 0:
        case 14:
        case 25:
          return WorkerType.frame;
        case 1:
        case 26:
          return WorkerType.worker;
        case 20:
        case 23:
          return WorkerType.python;
      }

      return WorkerType.frame;
    }

    List<String> publicSBs = [
      '2022/responsive-web-design',
      'responsive-web-design',
      // 'javascript-algorithms-and-data-structures',
      // 'the-odin-project',
    ];

    Directory.current = const String.fromEnvironment('CURRENT_DIR');
    File curriculumFile =
        File('../../freeCodeCamp/shared/config/curriculum.json');
    Map curriculumData = jsonDecode(curriculumFile.readAsStringSync());

    // Setup the test widget and check web controller is not null
    await tester.pumpWidget(CurriculumTestRunner());
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();
    // NOTE: To be on the safe side, we wait for 30 seconds to make sure the webview is loaded
    await Future.delayed(Duration(seconds: 30));
    await binding.takeScreenshot('curriculum_test_runner');
    final widgetState = tester
        .state<CurriculumTestRunnerState>(find.byType(CurriculumTestRunner));
    expect(widgetState.webViewController, isNotNull);

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

          bool testFailed = false;

          String firstHtmlFile = await htmlFlow(challenge, Ext.html);
          String sourceContents =
              '<!DOCTYPE html>$hideFccHeaderStyle$firstHtmlFile';
          String updateFunction = '''
window.testRunner = await window.FCCSandbox.createTestRunner({
  source: `$sourceContents`,
  type: "${getWorkerType(challenge.challengeType).name}",
  assetPath: "/",
  code: {
    contents: `${await combinedCode(challenge)}`,
  },
})
''';

          await widgetState.webViewController!.callAsyncJavaScript(
            functionBody: updateFunction,
          );

          for (ChallengeTest test in challenge.tests) {
            String testString = test.javaScript
                .replaceAll('\\', '\\\\')
                .replaceAll('`', '\\`')
                .replaceAll('\$', r'\$');
            final testRes =
                await widgetState.webViewController!.callAsyncJavaScript(
              functionBody: '''
const testRes = await window.testRunner.runTest(`$testString`);
return testRes;
            ''',
            );
            if (testRes?.value['pass'] == null) {
              print(
                  'TEST FAILED: ${test.instruction} - ${test.javaScript} - ${testRes?.value['error']}');
              testFailed = true;
            }
          }

          if (testFailed) {
            print(
                'Test failed for challenge: ${challenge.id} - ${challenge.title}');
            // throw Exception(
            //   'Test failed for challenge: ${challenge.id} - ${challenge.title}',
            // );
          } else {
            print('Test passed for challenge: ${challenge.id}');
          }
        }
      }
    }
  });
}
