import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_new/auth/models/user_model.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/models/curriculum_model.dart';
import 'package:mobile_app_new/learn/ui/challenge/english_view.dart';
import 'package:mobile_app_new/learn/ui/challenge/lesson_view.dart';
import 'package:mobile_app_new/learn/ui/challenge/python_project_view.dart';
import 'package:mobile_app_new/learn/ui/challenge/quiz_view.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/parsed_html.dart';
import 'package:mobile_app_new/services/auth_service.dart';

const _lesson = Challenge(
  id: 'lesson',
  block: 'html-basics',
  superBlock: 'responsive-web-design-v9',
  title: 'Understanding HTML attributes',
  dashedName: 'understanding-html-attributes',
  challengeType: 11,
  description:
      '<p>Attributes give an element additional information. '
      'An image uses the <code>src</code> attribute to locate its file.</p>',
  assignments: ['<p>Read the lesson before answering.</p>'],
  questions: [
    Question(
      text: '<p>Which attribute sets an image source?</p>',
      answers: [
        Answer(
          answer: '<p>src</p>',
          feedback: '<p>The source points to the image file.</p>',
        ),
        Answer(
          answer: '<p>href</p>',
          feedback: '<p>Links use href. Images use another attribute.</p>',
        ),
      ],
      solution: 1,
    ),
    Question(
      text: '<p>Which attribute provides alternative text?</p>',
      answers: [
        Answer(answer: '<p>alt</p>'),
        Answer(answer: '<p>id</p>'),
      ],
      solution: 1,
    ),
  ],
);

Challenge _quiz({int count = 10}) => Challenge(
  id: 'quiz',
  block: 'html-basics',
  superBlock: 'responsive-web-design-v9',
  title: 'HTML knowledge quiz',
  dashedName: 'html-knowledge-quiz',
  challengeType: 25,
  description: '<p>Check what you have learned about HTML.</p>',
  quizzes: [
    Quiz(
      questions: [
        for (var i = 1; i <= count; i++)
          QuizQuestion(
            text: '<p>Choose the correct answer for question $i.</p>',
            answer: '<p>Correct choice $i</p>',
            distractors: ['<p>Other choice $i</p>', '<p>Another choice $i</p>'],
          ),
      ],
    ),
  ],
);

const _english = Challenge(
  id: 'english',
  block: 'introductions',
  superBlock: 'a2-english',
  title: 'Introduce yourself',
  dashedName: 'introduce-yourself',
  challengeType: 22,
  description: '<p>Complete the sentence with the missing words.</p>',
  fillInTheBlank: FillInTheBlank(
    sentence: 'Hello, BLANK name is BLANK.',
    blanks: [
      Blank(
        answer: 'my',
        feedback: '<p>Use the possessive word for yourself.</p>',
      ),
      Blank(answer: 'Tom', feedback: '<p>Use the name Tom.</p>'),
    ],
  ),
  explanation: '<p>Use “my” to introduce your name.</p>',
);

const _project = Challenge(
  id: 'project',
  block: 'python-projects',
  superBlock: 'scientific-computing-with-python',
  title: 'Build an arithmetic formatter',
  dashedName: 'arithmetic-formatter',
  challengeType: 10,
  description:
      '<p>Create a function that arranges arithmetic problems vertically.</p>',
  instructions:
      '<p>Complete the project and share a public link to your solution.</p>',
);

Block _block(Challenge challenge) => Block(
  superBlock: challenge.superBlock,
  dashedName: challenge.block,
  name: 'Learning the fundamentals',
  layout: BlockLayout.challengeList,
  label: BlockLabel.lecture,
  description: [],
  challenges: [ChallengeOrder(id: challenge.id, title: challenge.title)],
);

class _GuestAuth extends AuthNotifier {
  @override
  Future<FccUserModel?> build() async => null;
}

final _capture = GlobalKey();

Future<void> _pump(
  WidgetTester tester,
  Widget page, {
  bool dark = false,
  double width = 390,
  double scale = 1,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 844);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [authProvider.overrideWith(_GuestAuth.new)],
      child: RepaintBoundary(
        key: _capture,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: dark ? FccTheme.themeDark : FccTheme.themeLight,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(scale)),
            child: child!,
          ),
          home: page,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Finder _text(String text) => find.text(text, findRichText: true);
Finder _button(String label) => find.widgetWithText(FilledButton, label);

Future<void> _tap(WidgetTester tester, Finder target) async {
  expect(target, findsOneWidget);
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  final ignored = find.ancestor(
    of: target,
    matching: find.byWidgetPredicate(
      (widget) => widget is IgnorePointer && widget.ignoring,
    ),
  );
  if (ignored.evaluate().isNotEmpty) {
    // Answer labels delegate the gesture to their card; tap the actual label
    // position without requiring the deliberately ignored child in the hit test.
    await tester.tapAt(tester.getCenter(target));
  } else {
    await tester.tap(target);
  }
  await tester.pumpAndSettle();
}

Future<void> _startLesson(WidgetTester tester) async {
  await _tap(tester, find.byType(CheckboxListTile));
  await _tap(tester, _button('Continue to questions'));
}

Future<void> _answerQuiz(
  WidgetTester tester, {
  required int correct,
  int count = 10,
}) async {
  for (var i = 1; i <= count; i++) {
    await _tap(
      tester,
      _text(i <= correct ? 'Correct choice $i' : 'Other choice $i'),
    );
    await _tap(tester, _button(i == count ? 'Submit quiz' : 'Next question'));
  }
}

Future<void> _screenshot(WidgetTester tester, String name) async {
  const dir = String.fromEnvironment('UI_SCREENSHOT_DIR');
  if (dir.isEmpty) return;
  await tester.runAsync(() async {
    final boundary =
        _capture.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 2);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File('$dir/$name.png');
    await file.parent.create(recursive: true);
    await file.writeAsBytes(data!.buffer.asUint8List());
    image.dispose();
  });
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    for (final font in {
      'Lato': 'assets/fonts/Lato-Regular.ttf',
      'monospace': 'assets/fonts/Hack-Regular.ttf',
      'MaterialIcons': 'fonts/MaterialIcons-Regular.otf',
    }.entries) {
      await (FontLoader(font.key)..addFont(rootBundle.load(font.value))).load();
    }
  });

  testWidgets(
    'plain answer strings and mixed inline markup retain all their text',
    (tester) async {
      final lesson = _lesson.copyWith(
        assignments: [],
        questions: const [
          Question(
            text: 'Which action should you take?',
            answers: [
              Answer(answer: 'Open the editor'),
              Answer(answer: 'Close the browser'),
            ],
            solution: 1,
          ),
        ],
      );
      await _pump(tester, LessonView(challenge: lesson, block: _block(lesson)));
      await _tap(tester, _button('Continue to questions'));
      expect(_text('Which action should you take?'), findsOneWidget);
      await _tap(tester, _text('Open the editor'));
      await _tap(tester, _button('Check answer'));
      expect(find.text('Correct!'), findsOneWidget);
      await _pump(
        tester,
        const Scaffold(
          body: ParsedHtml(
            'Before <code>const value = 1;</code> after. <strong>Keep learning.</strong>',
          ),
        ),
      );
      expect(find.textContaining('Before ', findRichText: true), findsWidgets);
      expect(
        find.textContaining('const value = 1;', findRichText: true),
        findsWidgets,
      );
      expect(find.textContaining(' after.', findRichText: true), findsWidgets);
      expect(
        find.textContaining('Keep learning.', findRichText: true),
        findsWidgets,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'tapping inline code in an answer selects the answer without copying',
    (tester) async {
      final clipboardWrites = <Object?>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.setData') {
            clipboardWrites.add(call.arguments);
          }
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      final lesson = _lesson.copyWith(
        assignments: [],
        questions: const [
          Question(
            text: '<p>Choose the image attribute.</p>',
            answers: [
              Answer(answer: '<p>Use <code>src</code></p>'),
              Answer(answer: '<p>Use <code>href</code></p>'),
            ],
            solution: 1,
          ),
        ],
      );
      await _pump(tester, LessonView(challenge: lesson, block: _block(lesson)));
      await _tap(tester, _button('Continue to questions'));
      await _tap(tester, _text('src'));
      expect(
        tester.widget<FilledButton>(_button('Check answer')).onPressed,
        isNotNull,
      );
      expect(clipboardWrites, isEmpty);
      await _tap(tester, _button('Check answer'));
      expect(find.text('Correct!'), findsOneWidget);
      expect(clipboardWrites, isEmpty);
    },
  );

  testWidgets(
    'lesson assignments gate questions and checked answers advance sequentially',
    (tester) async {
      await _pump(
        tester,
        LessonView(challenge: _lesson, block: _block(_lesson)),
      );
      expect(
        tester.widget<FilledButton>(_button('Continue to questions')).onPressed,
        isNull,
      );
      await _startLesson(tester);
      expect(_text('Which attribute sets an image source?'), findsOneWidget);
      expect(
        tester.widget<FilledButton>(_button('Check answer')).onPressed,
        isNull,
      );
      await _tap(tester, _text('src'));
      expect(find.text('Correct!'), findsNothing);
      await _tap(tester, _button('Check answer'));
      expect(find.text('Correct!'), findsOneWidget);
      await _tap(tester, _button('Next question'));
      expect(
        _text('Which attribute provides alternative text?'),
        findsOneWidget,
      );
      expect(
        tester.widget<FilledButton>(_button('Check answer')).onPressed,
        isNull,
      );
      await _tap(tester, _text('alt'));
      await _tap(tester, _button('Check answer'));
      expect(
        tester.widget<FilledButton>(_button('Continue')).onPressed,
        isNotNull,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'wrong lesson answer survives a lesson detour and can be corrected at large text',
    (tester) async {
      await _pump(
        tester,
        LessonView(challenge: _lesson, block: _block(_lesson)),
        dark: true,
        width: 320,
        scale: 1.6,
      );
      await _startLesson(tester);
      await _tap(tester, _text('href'));
      await _tap(tester, _button('Check answer'));
      expect(find.text('Not quite'), findsOneWidget);
      expect(
        tester.widget<FilledButton>(_button('Pick another answer')).onPressed,
        isNull,
      );
      await _tap(tester, _button('Lesson'));
      await _tap(tester, _button('Continue to questions'));
      expect(find.text('Question 1 of 2'), findsOneWidget);
      expect(_text('Which attribute sets an image source?'), findsOneWidget);
      await _tap(tester, _text('src'));
      await _tap(tester, _button('Check answer'));
      await _tap(tester, _button('Next question'));
      await _tap(tester, _text('id'));
      await _tap(tester, _button('Check answer'));
      await _tap(tester, _button('Lesson'));
      await _tap(tester, _button('Continue to questions'));
      expect(find.text('Question 2 of 2'), findsOneWidget);
      await _tap(tester, _text('alt'));
      await _tap(tester, _button('Check answer'));
      expect(_button('Continue'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'quiz paging retains answers and submission returns to the first unanswered question',
    (tester) async {
      final quiz = _quiz(count: 3);
      await _pump(
        tester,
        QuizView(challenge: quiz, block: _block(quiz)),
        dark: true,
        width: 320,
        scale: 1.6,
      );
      expect(tester.widget<FilledButton>(_button('Prev')).onPressed, isNull);
      await _tap(tester, _button('Next question'));
      await _tap(tester, _text('Correct choice 2'));
      await _tap(tester, _button('Prev'));
      expect(find.text('Question 1 of 3 · 1 answered'), findsOneWidget);
      await _tap(tester, find.byTooltip('All questions'));
      await _tap(tester, find.widgetWithText(OutlinedButton, '3'));
      expect(find.text('Question 3 of 3 · 1 answered'), findsOneWidget);
      await _tap(tester, _button('Submit quiz'));
      expect(
        find.text('Answer every question before submitting.'),
        findsOneWidget,
      );
      expect(find.text('Question 1 of 3 · 1 answered'), findsOneWidget);
      expect(find.text('Quiz results'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'quiz needs 90 percent, reviews wrong answers and retries without retaining selections',
    (tester) async {
      final quiz = _quiz();
      await _pump(tester, QuizView(challenge: quiz, block: _block(quiz)));
      expect(find.text('Pass with 9 of 10 correct'), findsOneWidget);
      await _answerQuiz(tester, correct: 8);
      expect(find.text('Keep going!'), findsOneWidget);
      expect(find.text('8 of 10 correct'), findsOneWidget);
      expect(_button('Continue'), findsNothing);
      await tester.scrollUntilVisible(find.text('Question 9'), 400);
      expect(_text('Other choice 9'), findsOneWidget);
      expect(_text('Correct choice 9'), findsOneWidget);
      expect(find.text('Correct answer'), findsWidgets);
      await _tap(tester, _button('Try again'));
      expect(find.text('Question 1 of 10 · 0 answered'), findsOneWidget);
      expect(find.text('Quiz results'), findsNothing);
      await _answerQuiz(tester, correct: 9);
      expect(find.text('You passed!'), findsOneWidget);
      expect(find.text('9 of 10 correct'), findsOneWidget);
      expect(
        tester.widget<FilledButton>(_button('Continue')).onPressed,
        isNotNull,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'English feedback clears when a previously correct blank is edited',
    (tester) async {
      await _pump(
        tester,
        EnglishView(challenge: _english, block: _block(_english)),
        width: 320,
        scale: 1.6,
      );
      expect(
        tester.widget<FilledButton>(_button('Check answer')).onPressed,
        isNull,
      );
      await tester.enterText(find.byType(TextField).at(0), 'your');
      await tester.enterText(find.byType(TextField).at(1), 'Tom');
      await tester.pumpAndSettle();
      await _tap(tester, _button('Check answer'));
      expect(find.text('Not quite'), findsOneWidget);
      expect(_text('Use the possessive word for yourself.'), findsOneWidget);
      await tester.enterText(find.byType(TextField).at(0), ' MY ');
      await tester.pumpAndSettle();
      expect(find.text('Not quite'), findsNothing);
      await _tap(tester, _button('Check answer'));
      expect(find.text('Correct!'), findsOneWidget);
      expect(_button('Continue'), findsOneWidget);
      await tester.enterText(find.byType(TextField).at(1), 'wrong');
      await tester.pumpAndSettle();
      expect(find.text('Correct!'), findsNothing);
      expect(_button('Continue'), findsNothing);
      expect(_button('Check answer'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'project link validation resets on edits before allowing submission',
    (tester) async {
      await _pump(
        tester,
        PythonProjectView(challenge: _project, block: _block(_project)),
        dark: true,
        width: 320,
        scale: 1.6,
      );
      expect(
        tester.widget<FilledButton>(_button('Check link')).onPressed,
        isNull,
      );
      await tester.enterText(find.byType(TextField), 'not a URL');
      await tester.pumpAndSettle();
      await _tap(tester, _button('Check link'));
      expect(find.text('Please enter a valid HTTPS link.'), findsOneWidget);
      await tester.enterText(
        find.byType(TextField),
        'https://example.com/my-project',
      );
      await tester.pumpAndSettle();
      expect(find.text('Please enter a valid HTTPS link.'), findsNothing);
      await _tap(tester, _button('Check link'));
      expect(find.text('Your link is ready to submit.'), findsOneWidget);
      expect(_button('Submit project'), findsOneWidget);
      await tester.enterText(
        find.byType(TextField),
        'http://example.com/my-project',
      );
      await tester.pumpAndSettle();
      expect(find.text('Your link is ready to submit.'), findsNothing);
      expect(_button('Submit project'), findsNothing);
      await _tap(tester, _button('Check link'));
      expect(find.text('Please use a secure (https) URL.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('review uses its actual assignment as the completion gate', (
    tester,
  ) async {
    final review = _lesson.copyWith(
      challengeType: 31,
      questions: [],
      assignments: ['<p>Review the examples and concepts.</p>'],
    );
    await _pump(tester, LessonView(challenge: review, block: _block(review)));
    expect(find.byType(CheckboxListTile), findsOneWidget);
    expect(tester.widget<FilledButton>(_button('Continue')).onPressed, isNull);
    await _tap(tester, find.byType(CheckboxListTile));
    expect(
      tester.widget<FilledButton>(_button('Continue')).onPressed,
      isNotNull,
    );
  });

  testWidgets('project rejects malformed, private and non-web solution links', (
    tester,
  ) async {
    await _pump(
      tester,
      PythonProjectView(challenge: _project, block: _block(_project)),
    );
    for (final link in [
      'mailto:camper@example.com',
      'javascript:alert(1)',
      'https:foo',
      'https://localhost:8000',
      'https://127.0.0.1',
      'https://github.com/freeCodeCamp/mobile',
    ]) {
      await tester.enterText(find.byType(TextField), link);
      await tester.pumpAndSettle();
      await _tap(tester, _button('Check link'));
      expect(_button('Submit project'), findsNothing, reason: link);
      expect(
        tester.widget<TextField>(find.byType(TextField)).decoration!.errorText,
        isNotNull,
        reason: link,
      );
    }
  });

  for (final dark in [false, true]) {
    final mode = dark ? 'dark' : 'light';
    testWidgets('lesson and question preview $mode', (tester) async {
      await _pump(
        tester,
        LessonView(challenge: _lesson, block: _block(_lesson)),
        dark: dark,
      );
      await _screenshot(tester, 'learn-lesson-$mode');
      await _startLesson(tester);
      await _tap(tester, _text('src'));
      await _screenshot(tester, 'learn-question-$mode');
      expect(tester.takeException(), isNull);
    });
    testWidgets('quiz and results preview $mode', (tester) async {
      final quiz = _quiz();
      await _pump(
        tester,
        QuizView(challenge: quiz, block: _block(quiz)),
        dark: dark,
      );
      await _screenshot(tester, 'learn-quiz-$mode');
      await _answerQuiz(tester, correct: 9);
      await _screenshot(tester, 'learn-quiz-results-$mode');
      expect(tester.takeException(), isNull);
    });
    testWidgets('English preview $mode', (tester) async {
      await _pump(
        tester,
        EnglishView(challenge: _english, block: _block(_english)),
        dark: dark,
      );
      await tester.enterText(find.byType(TextField).at(0), 'my');
      await tester.enterText(find.byType(TextField).at(1), 'Tom');
      await tester.pumpAndSettle();
      await _tap(tester, _button('Check answer'));
      await _screenshot(tester, 'learn-english-$mode');
      expect(tester.takeException(), isNull);
    });
    testWidgets('project preview $mode', (tester) async {
      await _pump(
        tester,
        PythonProjectView(challenge: _project, block: _block(_project)),
        dark: dark,
      );
      await tester.enterText(
        find.byType(TextField),
        'https://example.com/my-project',
      );
      await tester.pumpAndSettle();
      await _tap(tester, _button('Check link'));
      await _screenshot(tester, 'learn-project-$mode');
      expect(tester.takeException(), isNull);
    });
  }
}
