import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/news/ui/widgets/article_reader.dart';
import 'package:mobile_app_new/widgets/html_handler/code_block.dart';
import 'package:mobile_app_new/widgets/html_handler/html_handler.dart';
import 'package:phone_ide/highlighting/textmate_highlighter_registry.dart';

const _javascript = '''const message = "Hello";
// A helpful comment
console.log(message, 42);''';

Future<void> _settleHighlight(WidgetTester tester) async {
  // The package caches its asset-loading future outside the widget fake clock.
  await tester.runAsync(() => Future<void>.delayed(Duration.zero));
  await tester.pumpAndSettle();
}

SelectableText _selectableText(WidgetTester tester, Finder block) =>
    tester.widget<SelectableText>(
      find.descendant(of: block, matching: find.byType(SelectableText)),
    );

List<TextStyle> _stylesFor(SelectableText widget, String text) {
  final matches = <TextStyle>[];
  void visit(InlineSpan span, TextStyle inherited) {
    final style = inherited.merge(span.style);
    if (span is TextSpan) {
      if (span.text?.contains(text) ?? false) matches.add(style);
      for (final child in span.children ?? <InlineSpan>[]) {
        visit(child, style);
      }
    }
  }

  if (widget.textSpan case final span?) {
    visit(span, widget.style ?? const TextStyle());
  }
  return matches;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await TextMateHighlighterRegistry.instance.initialize();
    expect(TextMateHighlighterRegistry.instance.isInitialized, isTrue);
  });

  testWidgets('syntax and plain text follow a running app theme change', (
    tester,
  ) async {
    final dark = ValueNotifier(false);
    addTearDown(dark.dispose);
    await tester.pumpWidget(
      ValueListenableBuilder<bool>(
        valueListenable: dark,
        builder: (_, isDark, _) => MaterialApp(
          theme: FccTheme.themeLight,
          darkTheme: FccTheme.themeDark,
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: const Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  FccCodeBlock(code: _javascript, language: 'javascript'),
                  FccCodeBlock(code: 'Unclassified plain text', language: ''),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await _settleHighlight(tester);

    void checkPalette(ThemeData theme) {
      final highlighted = _selectableText(
        tester,
        find.byType(FccCodeBlock).first,
      );
      final plain = _selectableText(tester, find.byType(FccCodeBlock).last);
      final colors = theme.colorScheme;
      expect(_stylesFor(highlighted, 'const').single.color, colors.primary);
      expect(
        _stylesFor(highlighted, 'Hello').single.color,
        theme.extension<FccDesignColors>()!.success,
      );
      expect(
        _stylesFor(highlighted, '42').single.color,
        theme.brightness == Brightness.dark
            ? const Color(0xFFFFAF85)
            : const Color(0xFFB93D0A),
      );
      expect(
        _stylesFor(highlighted, 'A helpful comment').single.color,
        colors.onSurfaceVariant,
      );
      expect(
        _stylesFor(plain, 'Unclassified plain text').single.color,
        colors.onSurface,
      );
      expect(highlighted.textSpan!.toPlainText(), _javascript);
    }

    checkPalette(FccTheme.themeLight);
    dark.value = true;
    await _settleHighlight(tester);
    checkPalette(FccTheme.themeDark);
    expect(tester.takeException(), isNull);
  });

  testWidgets('long lines stay selectable and scroll on a narrow phone', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final code =
        '${List.filled(40, 'long_identifier').join('_')};\nsecond line';
    await tester.pumpWidget(
      MaterialApp(
        theme: FccTheme.themeLight,
        home: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: FccCodeBlock(code: code, language: 'text'),
            ),
          ),
        ),
      ),
    );
    await _settleHighlight(tester);
    final text = _selectableText(tester, find.byType(FccCodeBlock));
    expect(text.textSpan!.toPlainText(), code);
    expect(text.enableInteractiveSelection, isNot(false));
    final horizontal = find.descendant(
      of: find.byType(FccCodeBlock),
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Scrollable &&
            axisDirectionToAxis(widget.axisDirection) == Axis.horizontal,
      ),
    );
    expect(horizontal, findsOneWidget);
    final position = tester.state<ScrollableState>(horizontal).position;
    expect(position.maxScrollExtent, greaterThan(0));
    await tester.dragFrom(
      tester.getBottomLeft(horizontal) + const Offset(220, -5),
      const Offset(-180, 0),
    );
    await _settleHighlight(tester);
    expect(position.pixels, greaterThan(0));
    expect(tester.takeException(), isNull);
  });

  testWidgets('HTML language markers retain code and tolerate unknown values', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: FccTheme.themeLight,
        home: Scaffold(
          body: Builder(
            builder: (context) => SingleChildScrollView(
              child: Column(
                children: HTMLParser(context: context).parse(
                  '<pre><code class="language">Plain &lt;text&gt;</code></pre>'
                  '<pre><code class="language-rust">let count = 1;</code></pre>'
                  '<pre class="language-js"><code>const count = 2;</code></pre>'
                  '<pre><code class="lang-css">body { color: red; }</code></pre>',
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await _settleHighlight(tester);
    final blocks = find.byType(FccCodeBlock);
    expect(blocks, findsNWidgets(4));
    expect(
      _selectableText(tester, blocks.at(0)).textSpan!.toPlainText(),
      'Plain <text>',
    );
    expect(
      _selectableText(tester, blocks.at(1)).textSpan!.toPlainText(),
      'let count = 1;',
    );
    expect(
      _stylesFor(_selectableText(tester, blocks.at(2)), 'const').single.color,
      FccTheme.themeLight.colorScheme.primary,
    );
    expect(
      _selectableText(tester, blocks.at(3)).textSpan!.toPlainText(),
      'body { color: red; }',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('copy code preserves whitespace and symbols', (tester) async {
    const code = '  if (count < 2) {\n    print("hello");\n  }';
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
    await tester.pumpWidget(
      MaterialApp(
        theme: FccTheme.themeLight,
        home: const Scaffold(
          body: FccCodeBlock(code: code, language: 'javascript'),
        ),
      ),
    );
    await _settleHighlight(tester);
    await tester.tap(find.byTooltip('Copy code'));
    await _settleHighlight(tester);
    expect(copied, code);
    expect(tester.takeException(), isNull);
  });

  testWidgets('reader text size updates the rendered code block', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: FccTheme.themeLight,
        home: const ArticleReader(
          html: '<pre><code class="language-js">const count = 2;</code></pre>',
          header: Text('Tutorial'),
          bookmarkButton: SizedBox.shrink(),
        ),
      ),
    );
    await _settleHighlight(tester);
    final before = _stylesFor(
      _selectableText(tester, find.byType(FccCodeBlock)),
      'const',
    ).single.fontSize;
    expect(before, 16);
    await tester.tap(find.byTooltip('Text size'));
    await _settleHighlight(tester);
    await tester.tap(
      find.byWidgetPredicate(
        (widget) =>
            widget is CheckedPopupMenuItem<double> && widget.value == 22,
      ),
    );
    await _settleHighlight(tester);
    final after = _stylesFor(
      _selectableText(tester, find.byType(FccCodeBlock)),
      'const',
    ).single.fontSize;
    expect(after, 20);
    expect(tester.takeException(), isNull);
  });
}
