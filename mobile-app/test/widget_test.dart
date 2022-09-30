// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/ui/views/learn/test_runner.dart';

void main() {
  testWidgets('Testing widgest testing', (tester) async {
    print('Generating test files');
    TestRunner runner = TestRunner();
    List<String> publicSBs = [
      '2022/responsive-web-design',
      'responsive-web-design',
      'javascript-algorithms-and-data-structures',
    ];

    var curriculumFile = File('curriculum.json');
    Map curriculumData = jsonDecode(curriculumFile.readAsStringSync());

    for (var currSuperBlock in publicSBs) {
      print('\nSUPERBLOCK: $currSuperBlock');
      for (var currBlock in curriculumData[currSuperBlock]['blocks'].values) {
        print('Block: ${currBlock['meta']['name']}');
        List challenges = currBlock['challenges']
          ..sort((a, b) =>
              a['challengeOrder'].compareTo(b['challengeOrder']) as int);
        for (var i = 0; i < challenges.length; i++) {
          var currChallenge = challenges[i];

          Challenge challenge = Challenge.fromJson(
            currChallenge,
            testing: true,
          );

          if (currChallenge['solutions'].isEmpty) {
            Challenge nextChallenge = Challenge.fromJson(
              challenges[i + 1],
              testing: true,
            );

            challenge.solutions = nextChallenge.files;
          }

          String code = await runner.setWebViewContent(
            challenge,
            testing: true,
          );

          File genTestFile = File(
            'generated-tests/$currSuperBlock/${challenge.block}/${challenge.id}.html',
          );

          genTestFile.createSync(recursive: true);
          genTestFile.writeAsStringSync(code);
        }
      }
    }
    print('Done');
  });
}
