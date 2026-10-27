import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/learn/models/curriculum_model.dart';
import 'package:freecodecamp/learn/ui/challenge/lesson_view.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/challenge_layout.dart';

const _lecture = Challenge(
  id: 'lecture-design',
  block: 'html-images',
  superBlock: 'responsive-web-design-v9',
  title: 'Working with images',
  dashedName: 'working-with-images',
  challengeType: 19,
  description:
      '<p>An image uses the <code>src</code> attribute to locate its file. '
      'Use <code>alt</code> to provide a text alternative.</p>',
  questions: [
    Question(
      text: '<p>Which attribute locates the image file?</p>',
      answers: [
        Answer(answer: '<p>src</p>'),
        Answer(answer: '<p>href</p>'),
      ],
      solution: 1,
    ),
    Question(
      text: '<p>Which attribute provides alternative text?</p>',
      answers: [
        Answer(answer: '<p>title</p>'),
        Answer(answer: '<p>alt</p>'),
      ],
      solution: 2,
    ),
  ],
);

final _block = Block(
  superBlock: _lecture.superBlock,
  dashedName: _lecture.block,
  name: 'HTML fundamentals',
  layout: BlockLayout.challengeList,
  label: BlockLabel.lecture,
  description: [],
  challenges: const [
    ChallengeOrder(id: 'lecture-design', title: 'Working with images'),
    ChallengeOrder(id: 'next-lecture', title: 'Working with links'),
  ],
);

final _capture = GlobalKey();

Finder _button(String label) => find.widgetWithText(FilledButton, label);
Finder _answer(String label) => find
    .ancestor(
      of: find.text(label, findRichText: true),
      matching: find.byType(InkWell),
    )
    .first;

TextStyle _labelStyle(WidgetTester tester, String label) {
  final text = find.text(label);
  return DefaultTextStyle.of(
    tester.element(text),
  ).style.merge(tester.widget<Text>(text).style);
}

List<Finder> _segments() {
  final segments = find.descendant(
    of: find.byType(QuestionProgress),
    matching: find.byType(DecoratedBox),
  );
  expect(segments, findsNWidgets(2));
  return [segments.at(0), segments.at(1)];
}

Color? _segmentColor(WidgetTester tester, Finder segment) =>
    (tester.widget<DecoratedBox>(segment).decoration as BoxDecoration).color;

Future<void> _expectPaintedLabel(
  WidgetTester tester,
  String label,
  Color color,
) async {
  final finder = find.text(label);
  final labelRect = tester.getRect(finder);
  final buttonRect = tester.getRect(_button(label));
  expect(buttonRect.contains(labelRect.topLeft), isTrue);
  expect(buttonRect.contains(labelRect.bottomRight), isTrue);
  expect(_labelStyle(tester, label).color, color);
  final captureOffset = tester.getTopLeft(find.byKey(_capture));
  final local = labelRect.shift(-captureOffset);
  final coloredPixels = await tester.runAsync(() async {
    final boundary =
        _capture.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final data = (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!;
    final pixels = data.buffer.asUint8List();
    final argb = color.toARGB32();
    var count = 0;
    for (var y = local.top.ceil(); y < local.bottom.floor(); y++) {
      for (var x = local.left.ceil(); x < local.right.floor(); x++) {
        final offset = (y * image.width + x) * 4;
        if (pixels[offset] == (argb >> 16 & 255) &&
            pixels[offset + 1] == (argb >> 8 & 255) &&
            pixels[offset + 2] == (argb & 255) &&
            pixels[offset + 3] == 255) {
          count++;
        }
      }
    }
    image.dispose();
    return count;
  });
  expect(
    coloredPixels,
    greaterThan(10),
    reason: '$label must paint visible text over its button background.',
  );
}

Future<void> _tap(WidgetTester tester, Finder target) async {
  await tester.ensureVisible(target);
  await tester.tap(target);
  await tester.pumpAndSettle();
}

Future<void> _pump(
  WidgetTester tester, {
  required bool dark,
  required double scale,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(scale == 1 ? 390 : 320, 844);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: dark ? FccTheme.themeDark : FccTheme.themeLight,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(scale)),
        child: child!,
      ),
      home: RepaintBoundary(
        key: _capture,
        child: LessonView(challenge: _lecture, block: _block),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _screenshot(WidgetTester tester, String name) async {
  const directory = String.fromEnvironment('UI_SCREENSHOT_DIR');
  if (directory.isEmpty) {
    return;
  }
  await tester.runAsync(() async {
    final boundary =
        _capture.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 2);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File('$directory/$name.png');
    await file.parent.create(recursive: true);
    await file.writeAsBytes(data!.buffer.asUint8List());
    image.dispose();
  });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final fonts = FontLoader('Lato');
    for (final weight in ['Regular', 'Bold', 'ExtraBold', 'Black']) {
      fonts.addFont(rootBundle.load('assets/fonts/Lato-$weight.ttf'));
    }
    await fonts.load();
    for (final font in {
      'monospace': 'assets/fonts/Hack-Regular.ttf',
      'MaterialIcons': 'fonts/MaterialIcons-Regular.otf',
      'packages/cupertino_icons/CupertinoIcons':
          'packages/cupertino_icons/assets/CupertinoIcons.ttf',
    }.entries) {
      await (FontLoader(font.key)..addFont(rootBundle.load(font.value))).load();
    }
  });

  for (final dark in [false, true]) {
    for (final scale in [1.0, 2.0]) {
      final mode = '${dark ? 'dark' : 'light'}-text${(scale * 100).toInt()}';
      testWidgets(
        'lecture controls match the design and retain answers $mode',
        (tester) async {
          await _pump(tester, dark: dark, scale: scale);
          final theme = dark ? FccTheme.themeDark : FccTheme.themeLight;
          final colors = theme.colorScheme;
          expect(find.byTooltip('Ask for help'), findsNothing);
          expect(find.byIcon(Icons.help_outline), findsNothing);
          expect(find.byType(Chip), findsNothing);
          expect(find.text('2 questions at the end'), findsNothing);
          final continueStyle = _labelStyle(tester, 'Continue to questions');
          expect(continueStyle.fontSize, 16);
          expect(continueStyle.fontWeight, FontWeight.w800);
          expect(
            tester.getSize(_button('Continue to questions')).height,
            greaterThanOrEqualTo(50),
          );
          final continueButton = tester.widget<FilledButton>(
            _button('Continue to questions'),
          );
          expect(
            continueButton.style!.backgroundColor!.resolve({}),
            colors.secondary,
          );
          expect(
            (continueButton.style!.shape!.resolve({})!
                    as RoundedRectangleBorder)
                .borderRadius,
            BorderRadius.circular(10),
          );
          await _screenshot(tester, 'lecture-$mode');

          await _tap(tester, _button('Continue to questions'));
          expect(find.byTooltip('Ask for help'), findsNothing);
          expect(find.byIcon(Icons.help_outline), findsNothing);
          expect(find.text('Question 1 of 2'), findsOneWidget);
          final segments = _segments();
          final first = tester.getRect(segments[0]);
          final second = tester.getRect(segments[1]);
          expect(first.size, const Size(28, 6));
          expect(second.size, const Size(28, 6));
          expect(first.left, 16);
          expect(second.left - first.right, 6);
          expect(_segmentColor(tester, segments[0]), colors.secondary);
          expect(_segmentColor(tester, segments[1]), colors.outlineVariant);

          final lesson = _button('Lesson');
          final lessonButton = tester.widget<FilledButton>(lesson);
          expect(
            lessonButton.style!.backgroundColor!.resolve({}),
            colors.primaryContainer,
          );
          final accent = theme.extension<FccDesignColors>()!.accentText;
          final lessonStyle = _labelStyle(tester, 'Lesson');
          expect(lessonStyle.fontSize, 16);
          expect(lessonStyle.fontWeight, FontWeight.w800);
          expect(lessonStyle.color, accent);
          final icon = find.descendant(
            of: lesson,
            matching: find.byIcon(CupertinoIcons.book),
          );
          expect(icon, findsOneWidget);
          expect(
            tester.getCenter(icon).dx,
            lessThan(tester.getCenter(find.text('Lesson')).dx),
          );
          expect(
            tester.widget<Icon>(icon).color ??
                IconTheme.of(tester.element(icon)).color,
            accent,
          );
          final lessonRect = tester.getRect(lesson);
          final checkRect = tester.getRect(_button('Check answer'));
          if (scale == 2) {
            expect(lessonRect.left, checkRect.left);
            expect(lessonRect.width, checkRect.width);
            expect(checkRect.top - lessonRect.bottom, 8);
          } else {
            expect(lessonRect.top, checkRect.top);
            expect(checkRect.left, greaterThan(lessonRect.right));
            expect(checkRect.width, closeTo(lessonRect.width * 2, .1));
          }

          await _tap(tester, _answer('src'));
          await _expectPaintedLabel(tester, 'Check answer', colors.onSecondary);
          await _screenshot(tester, 'lecture-question-$mode');
          await _tap(tester, _button('Check answer'));
          expect(_segmentColor(tester, _segments()[0]), colors.secondary);
          await _tap(tester, _button('Next question'));
          expect(_segmentColor(tester, _segments()[0]), colors.primary);
          expect(_segmentColor(tester, _segments()[1]), colors.secondary);
          await _tap(tester, _answer('title'));
          await _tap(tester, _button('Check answer'));
          expect(find.text('Not quite'), findsOneWidget);
          expect(_segmentColor(tester, _segments()[1]), colors.secondary);
          await _tap(tester, _button('Lesson'));
          await _tap(tester, _button('Continue to questions'));
          expect(find.text('Question 2 of 2'), findsOneWidget);
          expect(find.text('Not quite'), findsOneWidget);
          expect(
            tester
                .widget<FilledButton>(_button('Pick another answer'))
                .onPressed,
            isNull,
          );
          expect(_segmentColor(tester, _segments()[0]), colors.primary);
          expect(_segmentColor(tester, _segments()[1]), colors.secondary);
          expect(tester.takeException(), isNull);
        },
      );
    }

    testWidgets('question back returns to reading before leaving the lecture '
        '${dark ? 'dark' : 'light'}', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(390, 844);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      await tester.pumpWidget(
        MaterialApp(
          theme: dark ? FccTheme.themeDark : FccTheme.themeLight,
          home: Scaffold(
            body: Builder(
              builder: (context) => Column(
                children: [
                  const Text('Parent course'),
                  FilledButton(
                    onPressed: () => Navigator.of(context).push<void>(
                      MaterialPageRoute(
                        builder: (_) =>
                            LessonView(challenge: _lecture, block: _block),
                      ),
                    ),
                    child: const Text('Open lecture'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await _tap(tester, _button('Open lecture'));
      expect(find.byType(BackButton), findsOneWidget);
      expect(find.text('Parent course'), findsNothing);
      await _tap(tester, _button('Continue to questions'));
      expect(find.byType(BackButton), findsOneWidget);
      expect(find.byTooltip('Back'), findsOneWidget);
      expect(find.byTooltip('Ask for help'), findsNothing);
      await _tap(tester, _answer('href'));
      await _tap(tester, _button('Check answer'));
      expect(find.text('Not quite'), findsOneWidget);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Working with images'), findsOneWidget);
      expect(find.byType(QuestionProgress), findsNothing);
      expect(find.text('Parent course'), findsNothing);
      expect(find.byType(BackButton), findsOneWidget);
      await _tap(tester, _button('Continue to questions'));
      expect(find.text('Question 1 of 2'), findsOneWidget);
      expect(find.text('Not quite'), findsOneWidget);
      expect(
        tester.widget<FilledButton>(_button('Pick another answer')).onPressed,
        isNull,
      );
      expect(find.byType(BackButton), findsOneWidget);

      // The question's app-bar Back action has the same destination as the
      // Android system Back action, without popping the lecture route.
      await _tap(tester, find.byType(BackButton));
      expect(find.text('Working with images'), findsOneWidget);
      expect(find.text('Parent course'), findsNothing);
      await _tap(tester, _button('Continue to questions'));
      expect(find.text('Not quite'), findsOneWidget);
      expect(find.byType(BackButton), findsOneWidget);

      // The explicit Lesson action preserves the same checked selection.
      await _tap(tester, _button('Lesson'));
      expect(find.text('Working with images'), findsOneWidget);
      expect(find.text('Parent course'), findsNothing);
      await _tap(tester, _button('Continue to questions'));
      expect(find.text('Not quite'), findsOneWidget);
      expect(find.byType(BackButton), findsOneWidget);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      await _tap(tester, find.byType(BackButton));
      expect(find.text('Parent course'), findsOneWidget);
      expect(find.byType(LessonView), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
}
