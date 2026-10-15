import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/parsed_html.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/questions.dart';

const QuestionItem _question = (
  text: '<p><strong>Which answer describes a void element?</strong></p>',
  answers: [
    Answer(answer: '<p>A short answer.</p>'),
    Answer(
      answer:
          '<div><p>An element that does not have any content and only has '
          'a start tag, without an end tag.</p></div>',
    ),
    Answer(answer: '<p>Use <code>const value = 1;</code> in JavaScript.</p>'),
  ],
  solution: 1,
  audioData: null,
);

Finder _html(String html) => find.byWidgetPredicate(
  (widget) => widget is ParsedHtml && widget.html == html,
);

Finder _badge(int index) => find
    .ancestor(
      of: find.text(String.fromCharCode(65 + index)),
      matching: find.byType(Container),
    )
    .first;

Finder _card(int index) => find
    .ancestor(
      of: _html(_question.answers[index].answer),
      matching: find.byType(Material),
    )
    .first;

List<TextStyle> _stylesFor(WidgetTester tester, String text) {
  final styles = <TextStyle>[];
  void visit(InlineSpan span, TextStyle inherited) {
    final style = inherited.merge(span.style);
    if (span is TextSpan) {
      if (span.text?.contains(text) ?? false) {
        styles.add(style);
      }
      for (final child in span.children ?? <InlineSpan>[]) {
        visit(child, style);
      }
    }
  }

  for (final widget in tester.widgetList<RichText>(find.byType(RichText))) {
    visit(widget.text, const TextStyle());
  }
  return styles;
}

Future<void> _pump(
  WidgetTester tester, {
  bool dark = false,
  double scale = 1,
  double width = 390,
  bool enabled = true,
  required void Function(int question, int answer) onChanged,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 844);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  var selected = 1;
  await tester.pumpWidget(
    MaterialApp(
      theme: dark ? FccTheme.themeDark : FccTheme.themeLight,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(scale)),
        child: child!,
      ),
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: StatefulBuilder(
            builder: (context, setState) => Questions(
              questions: const [_question],
              selected: [selected],
              validated: false,
              enabled: enabled,
              onChanged: (question, answer) {
                onChanged(question, answer);
                setState(() => selected = answer);
              },
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await (FontLoader('Lato')
          ..addFont(rootBundle.load('assets/fonts/Lato-Regular.ttf'))
          ..addFont(rootBundle.load('assets/fonts/Lato-ExtraBold.ttf')))
        .load();
    await (FontLoader(
      'monospace',
    )..addFont(rootBundle.load('assets/fonts/Hack-Regular.ttf'))).load();
  });

  for (final dark in [false, true]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets(
        'question cards align text and badges in ${dark ? 'dark' : 'light'} '
        'theme at ${scale}x text',
        (tester) async {
          final changes = <(int, int)>[];
          await _pump(
            tester,
            dark: dark,
            scale: scale,
            width: scale == 1 ? 390 : 320,
            onChanged: (question, answer) => changes.add((question, answer)),
          );

          final questionStyles = _stylesFor(
            tester,
            'Which answer describes a void element?',
          );
          expect(questionStyles, isNotEmpty);
          for (final style in questionStyles) {
            expect(style.fontWeight, FontWeight.w800);
            expect(style.fontSize, 24);
          }

          for (var i = 0; i < _question.answers.length; i++) {
            final answer = _html(_question.answers[i].answer);
            await tester.ensureVisible(answer);
            await tester.pumpAndSettle();
            expect(
              tester.getCenter(_badge(i)).dy,
              closeTo(tester.getCenter(answer).dy, .1),
            );
            final letter = tester.widget<Text>(
              find.text(String.fromCharCode(65 + i)),
            );
            expect(letter.style?.fontWeight, FontWeight.w800);
            expect(letter.style?.fontSize, 16);
            expect(
              tester.getSize(_badge(i)).height,
              greaterThanOrEqualTo(16 * scale * 1.2),
            );
            final shape =
                tester.widget<Material>(_card(i)).shape!
                    as RoundedRectangleBorder;
            expect(shape.side.width, i == 1 ? 2 : 1);

            // Plain and multiline paragraph content has no invisible block
            // padding to shift its visible text away from the centered badge.
            if (i < 2) {
              final richText = find.descendant(
                of: answer,
                matching: find.byWidgetPredicate(
                  (widget) =>
                      widget is RichText &&
                      widget.text.toPlainText().contains(
                        i == 0 ? 'A short answer.' : 'An element that does not',
                      ),
                ),
              );
              expect(richText, findsOneWidget);
              expect(
                tester.getCenter(richText).dy,
                // HTML line boxes retain a small font-metric rounding offset.
                closeTo(tester.getCenter(_badge(i)).dy, scale),
              );
            }
          }

          final code = find.text('const value = 1;');
          await tester.ensureVisible(code);
          await tester.tapAt(tester.getCenter(code));
          await tester.pumpAndSettle();
          expect(changes, [(0, 2)]);
          final selectedShape =
              tester.widget<Material>(_card(2)).shape!
                  as RoundedRectangleBorder;
          expect(selectedShape.side.width, 2);
          expect(find.byType(SnackBar), findsNothing);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  testWidgets('disabled code answers cannot change the selected answer', (
    tester,
  ) async {
    final changes = <(int, int)>[];
    await _pump(
      tester,
      enabled: false,
      onChanged: (question, answer) => changes.add((question, answer)),
    );
    await tester.ensureVisible(find.text('const value = 1;'));
    await tester.tapAt(tester.getCenter(find.text('const value = 1;')));
    await tester.pumpAndSettle();
    expect(changes, isEmpty);
    expect(tester.takeException(), isNull);
  });
}
