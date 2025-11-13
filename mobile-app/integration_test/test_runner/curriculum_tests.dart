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
      '2022/responsive-web-design',
      'responsive-web-design',
      // 'javascript-algorithms-and-data-structures-v8',
      // 'javascript-algorithms-and-data-structures',
      'the-odin-project',
      'full-stack-developer',
      'dev-playground',

      // Python SBs
      // 'scientific-computing-with-python',
    ];

    List<String> publicFwdBlocks = [
      // HTML Chapter
      'workshop-curriculum-outline',
      'lab-debug-camperbots-profile-page',
      'workshop-cat-photo-app',
      'lab-recipe-page',
      'lab-travel-agency-page',
      'lab-video-compilation-page',
      'workshop-blog-page',
      'lab-event-hub',
      'workshop-hotel-feedback-form',
      'lab-survey-form',
      'workshop-final-exams-table',
      'lab-book-catalog-table',
      'lab-checkout-page',
      'lab-movie-review-page',
      'lab-multimedia-player',

      // CSS Chapter
      'workshop-cafe-menu',
      'lab-business-card',
      'lab-stylized-to-do-list',
      'lab-blog-post-card',
      'lab-event-flyer-page',
      'workshop-greeting-card',
      'lab-job-application-form',
      'workshop-colored-markers',
      'lab-colored-boxes',
      'workshop-registration-form',
      'lab-contact-form',
      'workshop-rothko-painting',
      'lab-confidential-email-page',
      'workshop-flexbox-photo-gallery',
      'lab-page-of-playing-cards',
      'workshop-nutritional-label',
      'lab-newspaper-article',
      'workshop-accessibility-quiz',
      'lab-tribute-page',
      'workshop-cat-painting',
      'lab-house-painting',
      'workshop-balance-sheet',
      'lab-book-inventory-app',
      'workshop-piano',
      'lab-technical-documentation-page',
      'workshop-city-skyline',
      'lab-availability-table',
      'workshop-magazine',
      'lab-magazine-layout',
      'lab-product-landing-page',
      'workshop-ferris-wheel',
      'lab-moon-orbit',
      'workshop-flappy-penguin',
      'lab-personal-portfolio',

      // JavaScript Chapter
      'workshop-greeting-bot',
      'lab-javascript-trivia-bot',
      'lab-sentence-maker',
      'workshop-teacher-chatbot',
      'workshop-mathbot',
      'lab-fortune-teller',
      'workshop-calculator',
      'lab-email-masker',
      'workshop-loan-qualification-checker',
      'lab-leap-year-calculator',
      'lab-truncate-string',
      'workshop-shopping-list',
      'lab-lunch-picker-program',
      'workshop-recipe-tracker',
      'lab-quiz-game',
      'workshop-sentence-analyzer',
      'lab-factorial-calculator',
      'lab-mutations',
      'lab-chunky-monkey',
      'lab-slice-and-splice',
      'lab-pyramid-generator',
      'lab-gradebook-app',
      'lab-inventory-management-program',
      'lab-password-generator',
      'lab-sum-all-numbers-algorithm',
      'workshop-library-manager',
      'lab-book-organizer',
      'workshop-storytelling-app',
      'lab-favorite-icon-toggler',
      'workshop-music-instrument-filter',
      'lab-real-time-counter',
      'lab-lightbox-viewer',
      'workshop-rps-game',
      'lab-football-team-cards',
      'lab-random-background-color-changer',
      'workshop-spam-filter',
      'lab-palindrome-checker',
      'lab-markdown-to-html-converter',
      'lab-regex-sandbox',
      'workshop-calorie-counter',
      'lab-customer-complaint-form',
      'lab-date-conversion',
      'workshop-music-player', // Step 21 Failed - Safari bug
      'lab-drum-machine',
      'workshop-plant-nursery-catalog',
      'lab-voting-system',
      'workshop-todo-app',
      'lab-bookmark-manager-app',
      'workshop-shopping-cart',
      'lab-project-idea-board',
      'lab-bank-account-manager',
      'workshop-decimal-to-binary-converter',
      'lab-permutation-generator',
      'workshop-recipe-ingredient-converter',
      'lab-sorting-visualizer',
      'workshop-fcc-authors-page',
      'lab-fcc-forum-leaderboard',
      'lab-weather-app',

      // Python Chapter
      // 'workshop-caesar-cipher',
      // 'lab-rpg-character',
      // 'workshop-pin-extractor',
      // 'lab-number-pattern-generator',
      // 'workshop-placeholder-dictionaries-and-sets',
      // 'lab-placeholder-dictionaries-and-sets',
      // 'lab-isbn-validator',
      // 'workshop-placeholder-classes-and-objects',
      // 'lab-budget-app',
      // 'workshop-placeholder-oop-1',
      // 'lab-placeholder-oop-1',
      // 'workshop-placeholder-oop-2',
      // 'lab-polygon-area-calculator',
      // 'workshop-placeholder-oop-3',
      // 'lab-placeholder-oop-3',
      // 'workshop-linked-list-class',
      // 'lab-hash-table',
      // 'workshop-binary-search',
      // 'lab-bisection-method',
      // 'workshop-merge-sort',
      // 'lab-quicksort',
      // 'lab-selection-sort',
      // 'lab-luhn-algorithm',
      // 'workshop-shortest-path-algorithm',
      // 'lab-adjacency-list-matrix-converter',
      // 'workshop-breadth-first-search',
      // 'lab-depth-first-search',
      // 'lab-nth-fibonacci-number'
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
        // NOTE: Skip blocks which are not public in the mobile app
        if (currSuperBlock == 'full-stack-developer' &&
            !publicFwdBlocks.contains(currBlock['meta']['dashedName'])) {
          continue;
        }

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
              'Challenge: ${challenge.id} - ${challenge.title} - ${challenge.challengeType.index}');

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
