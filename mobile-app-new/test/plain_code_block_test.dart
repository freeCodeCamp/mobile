import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/parsed_html.dart';
import 'package:mobile_app_new/widgets/html_handler/code_block.dart';
import 'package:phone_ide/highlighting/textmate_highlighter_registry.dart';

const _code =
    'const message = "Hello, this intentionally long sentence extends beyond the narrow phone viewport.";\n'
    '// A helpful comment\n'
    'console.log(message, 42);';
const _html = '<pre><code class="language-js">$_code</code></pre>';

Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.runAsync(() => Future<void>.delayed(Duration.zero));
  await tester.pumpAndSettle();
  await tester.runAsync(() => Future<void>.delayed(Duration.zero));
  await tester.pumpAndSettle();
}

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  bool dark = false,
  double scale = 1,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(320, 640);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
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
          child: child,
        ),
      ),
    ),
  );
  await _settle(tester);
}

SelectableText _codeText(WidgetTester tester, Finder block) =>
    tester.widget<SelectableText>(
      find.descendant(of: block, matching: find.byType(SelectableText)),
    );

List<Color?> _tokenColors(SelectableText widget, String token) {
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

  final span = widget.textSpan!;
  visit(span, widget.style?.color);
  final start = span.toPlainText().indexOf(token);
  expect(start, isNonNegative);
  return colors.sublist(start, start + token.length);
}

void _expectPalette(SelectableText code, ThemeData theme) {
  final design = theme.extension<FccDesignColors>()!;
  expect(code.textSpan!.toPlainText(), _code);
  expect(_tokenColors(code, 'const'), everyElement(design.accentText));
  expect(_tokenColors(code, 'Hello'), everyElement(design.success));
  expect(
    _tokenColors(code, 'A helpful comment'),
    everyElement(theme.colorScheme.onSurfaceVariant),
  );
  expect(
    _tokenColors(code, '42'),
    everyElement(
      theme.brightness == Brightness.dark
          ? const Color(0xFFFFAF85)
          : const Color(0xFFB93D0A),
    ),
  );
}

Finder _cardDecoration(Finder block) => find.descendant(
  of: block,
  matching: find.byWidgetPredicate(
    (widget) =>
        widget is DecoratedBox &&
        widget.decoration is BoxDecoration &&
        (widget.decoration as BoxDecoration).border != null,
  ),
);

void _expectVisibleThumb(WidgetTester tester, Finder block) {
  final paintFinder = find.descendant(
    of: block,
    matching: find.byWidgetPredicate(
      (widget) =>
          widget is CustomPaint && widget.foregroundPainter is ScrollbarPainter,
    ),
  );
  expect(paintFinder, findsOneWidget);
  final painter =
      tester.widget<CustomPaint>(paintFinder).foregroundPainter!
          as ScrollbarPainter;
  expect(painter.fadeoutOpacityAnimation.value, greaterThan(0));
  expect(
    paintFinder,
    paints
      ..rect(color: painter.trackColor)
      ..rect(color: painter.color),
    reason: 'The overflow thumb is actually painted.',
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await TextMateHighlighterRegistry.instance.initialize();
    await (FontLoader(
      'monospace',
    )..addFont(rootBundle.load('assets/fonts/Hack-Regular.ttf'))).load();
  });

  for (final dark in [false, true]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets(
        'plain code scrolls without a card in ${dark ? 'dark' : 'light'} '
        'theme at ${scale}x text',
        (tester) async {
          await _pump(
            tester,
            const FccCodeBlock(
              code: _code,
              language: 'javascript',
              plain: true,
            ),
            dark: dark,
            scale: scale,
          );
          final block = find.byType(FccCodeBlock);
          final code = _codeText(tester, block);
          _expectPalette(code, dark ? FccTheme.themeDark : FccTheme.themeLight);
          expect(code.enableInteractiveSelection, isNot(false));
          expect(find.byTooltip('Copy code'), findsNothing);
          expect(find.text('Copy'), findsNothing);
          expect(find.text('JavaScript'), findsNothing);
          expect(_cardDecoration(block), findsNothing);

          final scrollbar = tester.widget<Scrollbar>(
            find.descendant(of: block, matching: find.byType(Scrollbar)),
          );
          expect(scrollbar.thumbVisibility, isTrue);
          expect(scrollbar.trackVisibility, isTrue);
          final horizontal = find.descendant(
            of: block,
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is Scrollable &&
                  axisDirectionToAxis(widget.axisDirection) == Axis.horizontal,
            ),
          );
          final position = tester.state<ScrollableState>(horizontal).position;
          expect(position.maxScrollExtent, greaterThan(0));
          _expectVisibleThumb(tester, block);
          await tester.dragFrom(
            tester.getBottomLeft(horizontal) + const Offset(220, -8),
            const Offset(-180, 0),
          );
          await _settle(tester);
          expect(position.pixels, greaterThan(0));
          await tester.pump(const Duration(seconds: 3));
          _expectVisibleThumb(tester, block);
          expect(tester.takeException(), isNull);
        },
      );
    }

    testWidgets(
      'plain block mode preserves inline code ${dark ? 'dark' : 'light'}',
      (tester) async {
        String? copied;
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          (call) async {
            if (call.method == 'Clipboard.setData') {
              copied = (call.arguments as Map)['text'] as String;
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
        await _pump(
          tester,
          const ParsedHtml(
            '<p>Use <code>index.html</code> to begin.</p>$_html',
            plainCodeBlocks: true,
          ),
          dark: dark,
        );
        final inline = find.text('index.html');
        expect(inline, findsOneWidget);
        final text = tester.widget<Text>(inline);
        final theme = dark ? FccTheme.themeDark : FccTheme.themeLight;
        expect(text.style!.fontFamily, 'monospace');
        expect(text.style!.fontSize, 16);
        expect(text.style!.color, theme.colorScheme.onSurface);
        final container = tester.widget<Container>(
          find.ancestor(of: inline, matching: find.byType(Container)).first,
        );
        final decoration = container.decoration! as BoxDecoration;
        expect(decoration.color, theme.colorScheme.surfaceContainer);
        expect(decoration.borderRadius, BorderRadius.circular(6));
        await tester.tap(inline);
        await _settle(tester);
        expect(copied, 'index.html');
        expect(find.text('Copied to clipboard: index.html'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('plain code follows a running theme change', (tester) async {
    final dark = ValueNotifier(false);
    addTearDown(dark.dispose);
    await tester.pumpWidget(
      ValueListenableBuilder<bool>(
        valueListenable: dark,
        builder: (_, isDark, _) => MaterialApp(
          theme: isDark ? FccTheme.themeDark : FccTheme.themeLight,
          home: const Scaffold(body: ParsedHtml(_html, plainCodeBlocks: true)),
        ),
      ),
    );
    await _settle(tester);
    _expectPalette(
      _codeText(tester, find.byType(FccCodeBlock)),
      FccTheme.themeLight,
    );
    dark.value = true;
    await _settle(tester);
    _expectPalette(
      _codeText(tester, find.byType(FccCodeBlock)),
      FccTheme.themeDark,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('ParsedHtml invalidates cached blocks when plain mode changes', (
    tester,
  ) async {
    final plain = ValueNotifier(false);
    addTearDown(plain.dispose);
    await _pump(
      tester,
      ValueListenableBuilder<bool>(
        valueListenable: plain,
        builder: (_, isPlain, _) => ParsedHtml(
          _html,
          key: const ValueKey('same parsed html'),
          plainCodeBlocks: isPlain,
        ),
      ),
    );
    final state = tester.state(find.byType(ParsedHtml));
    expect(find.byTooltip('Copy code'), findsOneWidget);
    expect(_cardDecoration(find.byType(FccCodeBlock)), findsOneWidget);
    plain.value = true;
    await _settle(tester);
    expect(tester.state(find.byType(ParsedHtml)), same(state));
    expect(
      tester.widget<FccCodeBlock>(find.byType(FccCodeBlock)).plain,
      isTrue,
    );
    expect(find.byTooltip('Copy code'), findsNothing);
    expect(_cardDecoration(find.byType(FccCodeBlock)), findsNothing);
    _expectVisibleThumb(tester, find.byType(FccCodeBlock));
    plain.value = false;
    await _settle(tester);
    expect(tester.state(find.byType(ParsedHtml)), same(state));
    expect(
      tester.widget<FccCodeBlock>(find.byType(FccCodeBlock)).plain,
      isFalse,
    );
    expect(find.byTooltip('Copy code'), findsOneWidget);
    expect(_cardDecoration(find.byType(FccCodeBlock)), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('nested blockquotes forward plain mode to their code blocks', (
    tester,
  ) async {
    await _pump(
      tester,
      const ParsedHtml(
        '<blockquote><p>An example:</p>$_html'
        '<blockquote>$_html</blockquote></blockquote>',
        plainCodeBlocks: true,
      ),
    );
    final blocks = find.byType(FccCodeBlock);
    expect(blocks, findsNWidgets(2));
    for (var i = 0; i < 2; i++) {
      expect(tester.widget<FccCodeBlock>(blocks.at(i)).plain, isTrue);
      expect(_cardDecoration(blocks.at(i)), findsNothing);
      _expectPalette(_codeText(tester, blocks.at(i)), FccTheme.themeLight);
    }
    expect(find.byTooltip('Copy code'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
