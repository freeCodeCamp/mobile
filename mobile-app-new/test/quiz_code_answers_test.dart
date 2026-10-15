import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/questions.dart';
import 'package:mobile_app_new/widgets/html_handler/code_block.dart';
import 'package:phone_ide/highlighting/textmate_highlighter_registry.dart';

final _codes = [
  for (final tag in ['figure', 'section', 'div', 'footer'])
    '<$tag>\n'
        '  <img src="https://example.com/photos/a-sunny-landscape-in-the-mountains.jpg" alt="A sunny landscape">\n'
        '  <figcaption>A sunny day in the mountains.</figcaption>\n'
        '</$tag>',
];

final QuestionItem _question = (
  text: '<p>Which example correctly groups an image with its caption?</p>',
  answers: [
    for (final code in _codes)
      Answer(
        answer:
            '<pre><code class="language-html">'
            '${const HtmlEscape().convert(code)}</code></pre>',
      ),
    const Answer(answer: '<p>Use <code>figcaption</code> for the caption.</p>'),
    const Answer(
      answer: '<p><a href="https://example.com/">Plain linked answer</a></p>',
    ),
  ],
  solution: 0,
  audioData: null,
);

final _capture = GlobalKey();

Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.runAsync(() => Future<void>.delayed(Duration.zero));
  await tester.pumpAndSettle();
  await tester.runAsync(() => Future<void>.delayed(Duration.zero));
  await tester.pumpAndSettle();
}

Future<void> _pump(
  WidgetTester tester, {
  required bool dark,
  required double scale,
  required List<(int, int)> changes,
  bool enabled = true,
  ValueNotifier<bool>? enabledChanges,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(scale == 1 ? 390 : 320, 844);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  var selected = 3;
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
        child: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: StatefulBuilder(
              builder: (_, setState) {
                Widget questions(bool enabled) => Questions(
                  questions: [_question],
                  selected: [selected],
                  validated: false,
                  enabled: enabled,
                  plainCodeBlocks: true,
                  onChanged: (question, answer) {
                    changes.add((question, answer));
                    setState(() => selected = answer);
                  },
                );
                return enabledChanges == null
                    ? questions(enabled)
                    : ValueListenableBuilder<bool>(
                        valueListenable: enabledChanges,
                        builder: (_, value, _) => questions(value),
                      );
              },
            ),
          ),
        ),
      ),
    ),
  );
  await _settle(tester);
}

Finder _block(int index) => find.byWidgetPredicate(
  (widget) => widget is FccCodeBlock && widget.code == _codes[index],
);

Finder _codeText(int index) => find.descendant(
  of: _block(index),
  matching: find.byWidgetPredicate(
    (widget) =>
        widget is RichText && widget.text.toPlainText() == _codes[index],
  ),
);

Finder _horizontal(int index) => find.descendant(
  of: _block(index),
  matching: find.byWidgetPredicate(
    (widget) =>
        widget is Scrollable &&
        axisDirectionToAxis(widget.axisDirection) == Axis.horizontal,
  ),
);

// Use the middle of the second line, where actual HTML characters fill the
// visible viewport, rather than the scrollbar or the padding below the text.
Offset _codePoint(WidgetTester tester, int index) {
  final viewport = tester.getRect(_horizontal(index));
  final text = tester.getRect(_codeText(index));
  return Offset(viewport.right - 20, text.top + text.height / 4 * 1.5);
}

List<Color?> _tokenColors(RichText widget, String token) {
  final colors = <Color?>[];
  void visit(InlineSpan span, Color? inherited) {
    final color = span.style?.color ?? inherited;
    if (span is TextSpan) {
      colors.addAll(List<Color?>.filled(span.text?.length ?? 0, color));
      for (final child in span.children ?? <InlineSpan>[]) {
        visit(child, color);
      }
    }
  }

  visit(widget.text, null);
  final start = widget.text.toPlainText().indexOf(token);
  expect(start, isNonNegative);
  return colors.sublist(start, start + token.length);
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
    await TextMateHighlighterRegistry.instance.initialize();
    final fonts = FontLoader('Lato');
    for (final weight in ['Regular', 'Bold', 'ExtraBold', 'Black']) {
      fonts.addFont(rootBundle.load('assets/fonts/Lato-$weight.ttf'));
    }
    await fonts.load();
    await (FontLoader(
      'monospace',
    )..addFont(rootBundle.load('assets/fonts/Hack-Regular.ttf'))).load();
  });

  for (final dark in [false, true]) {
    final mode = dark ? 'dark' : 'light';
    for (final scale in [1.0, 2.0]) {
      testWidgets(
        'quiz code answers scroll on text and select on taps $mode ${scale}x',
        (tester) async {
          final changes = <(int, int)>[];
          final copied = <String>[];
          tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
            SystemChannels.platform,
            (call) async {
              if (call.method == 'Clipboard.setData') {
                copied.add((call.arguments as Map)['text'] as String);
              }
              return null;
            },
          );
          addTearDown(
            () => tester.binding.defaultBinaryMessenger
                .setMockMethodCallHandler(SystemChannels.platform, null),
          );
          await _pump(tester, dark: dark, scale: scale, changes: changes);
          final theme = dark ? FccTheme.themeDark : FccTheme.themeLight;
          final design = theme.extension<FccDesignColors>()!;
          expect(find.byType(FccCodeBlock), findsNWidgets(4));
          expect(find.byTooltip('Copy code'), findsNothing);
          expect(find.text('Copy'), findsNothing);
          expect(find.text('HTML'), findsNothing);
          await _screenshot(
            tester,
            'quiz-code-answers-$mode-text${(scale * 100).toInt()}',
          );

          for (var i = 0; i < 4; i++) {
            final block = _block(i);
            expect(tester.widget<FccCodeBlock>(block).plain, isTrue);
            expect(
              find.descendant(of: block, matching: find.byType(SelectableText)),
              findsNothing,
            );
            expect(
              find.descendant(
                of: block,
                matching: find.byWidgetPredicate(
                  (widget) =>
                      widget is DecoratedBox &&
                      widget.decoration is BoxDecoration &&
                      (widget.decoration as BoxDecoration).border != null,
                ),
              ),
              findsNothing,
            );
            final text = tester.widget<RichText>(_codeText(i));
            expect(_tokenColors(text, 'img'), everyElement(design.accentText));
            expect(
              _tokenColors(text, 'alt'),
              everyElement(theme.colorScheme.tertiary),
            );
            expect(
              _tokenColors(text, 'A sunny landscape'),
              everyElement(design.success),
            );

            await tester.ensureVisible(block);
            await _settle(tester);
            final position = tester
                .state<ScrollableState>(_horizontal(i))
                .position;
            expect(position.maxScrollExtent, greaterThan(0));
            final countBeforeDrag = changes.length;
            final scrollBeforeDrag = position.pixels;
            await tester.dragFrom(_codePoint(tester, i), const Offset(-120, 0));
            await _settle(tester);
            expect(position.pixels, greaterThan(scrollBeforeDrag));
            expect(changes, hasLength(countBeforeDrag));

            await tester.tapAt(_codePoint(tester, i));
            await _settle(tester);
            expect(changes, hasLength(countBeforeDrag + 1));
            expect(changes.last, (0, i));
            final badge = find.text(String.fromCharCode(65 + i));
            await tester.tap(badge);
            await _settle(tester);
            expect(changes, hasLength(countBeforeDrag + 2));
            expect(changes.last, (0, i));
          }

          final inline = find.text('figcaption');
          await tester.ensureVisible(inline);
          await tester.tap(inline);
          await _settle(tester);
          expect(changes.last, (0, 4));
          final beforeLink = changes.length;
          final link = find.text('Plain linked answer', findRichText: true);
          await tester.ensureVisible(link);
          await tester.tap(link);
          await _settle(tester);
          expect(changes, hasLength(beforeLink + 1));
          expect(changes.last, (0, 5));
          expect(copied, isEmpty);
          expect(find.byType(SnackBar), findsNothing);
          expect(tester.takeException(), isNull);
        },
      );
    }

    testWidgets(
      'disabled quiz code answers still scroll without selection $mode',
      (tester) async {
        final changes = <(int, int)>[];
        final enabled = ValueNotifier(false);
        addTearDown(enabled.dispose);
        await _pump(
          tester,
          dark: dark,
          scale: 2,
          changes: changes,
          enabledChanges: enabled,
        );
        await tester.ensureVisible(_block(0));
        await _settle(tester);
        final position = tester.state<ScrollableState>(_horizontal(0)).position;
        await tester.dragFrom(_codePoint(tester, 0), const Offset(-120, 0));
        await _settle(tester);
        expect(position.pixels, greaterThan(0));
        await tester.tapAt(_codePoint(tester, 0));
        await tester.tap(find.text('A'));
        final inline = find.text('figcaption');
        await tester.ensureVisible(inline);
        await tester.tap(inline);
        final link = find.text('Plain linked answer', findRichText: true);
        await tester.ensureVisible(link);
        await tester.tap(link);
        await _settle(tester);
        expect(changes, isEmpty);
        expect(find.byType(SnackBar), findsNothing);
        enabled.value = true;
        await _settle(tester);
        await tester.tap(link);
        await _settle(tester);
        expect(changes, [(0, 5)]);
        await tester.ensureVisible(inline);
        await tester.tap(inline);
        await _settle(tester);
        expect(changes, [(0, 5), (0, 4)]);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
