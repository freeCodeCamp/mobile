// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/enums/ext_type.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/ui/views/learn/test_runner.dart';

void main() {
  testWidgets('Testing widgest testing', (tester) async {
    print('Generating test files');
    await setupLocator();

    List<String> publicSBs = [
      '2022/responsive-web-design',
      // 'responsive-web-design',
      // 'javascript-algorithms-and-data-structures',
      // 'the-odin-project',
    ];

    var curriculumFile = File('../../freeCodeCamp/shared/config/curriculum.json');
    Map curriculumData = jsonDecode(curriculumFile.readAsStringSync());

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

          List<ChallengeFile> firstHtmlChallenge = challenge.files
              .where((file) => (file.ext == Ext.css || file.ext == Ext.html)
                  ? file.ext == Ext.html
                  : file.ext == Ext.html)
              .toList();

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

          FrameBuilder frameBuilder = FrameBuilder(
            builder: TestRunnerBuilder(
              source: firstHtmlChallenge[0].contents,
              code: Code(contents: firstHtmlChallenge[0].contents),
              workerType: getWorkerType(challenge.challengeType),
              testing: true,
            ),
            challenge: challenge,
          );

          File genTestFile = File(
            'generated-tests/$currSuperBlock/${challenge.block}/${challenge.id}.html',
          );

          var (buildFrame, document) = await frameBuilder.buildFrame();

          genTestFile.createSync(recursive: true);
          genTestFile.writeAsStringSync(document);
        }
      }
    }
    print('\nEditor challenge types: $editorChallengeTypes');
    print('Done');
  });
}
