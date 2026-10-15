import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_new/widgets/html_handler/code_highlighter.dart';
import 'package:phone_ide/highlighting/textmate_highlighter_registry.dart';

List<({String text, Color? color})> _segments(TextSpan span) {
  final segments = <({String text, Color? color})>[];

  void visit(InlineSpan span, Color? inheritedColor) {
    final color = span.style?.color ?? inheritedColor;
    if (span is TextSpan) {
      if (span.text case final text?) {
        segments.add((text: text, color: color));
      }
      for (final child in span.children ?? <InlineSpan>[]) {
        visit(child, color);
      }
    }
  }

  visit(span, null);
  return segments;
}

List<Color?> _colorsByCodeUnit(TextSpan span) => [
  for (final segment in _segments(span))
    ...List<Color?>.filled(segment.text.length, segment.color),
];

List<Color?> _colorsIn(TextSpan span, String source, String token) {
  final start = source.indexOf(token);
  expect(start, isNonNegative, reason: 'Fixture must contain $token');
  return _colorsByCodeUnit(span).sublist(start, start + token.length);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final examples =
      <({List<String> languages, String code, List<String> tokens})>[
        (
          languages: ['typescript', 'ts'],
          code: '''import axios from 'axios';

const HMRC_BASE_URL = 'https://test-api.service.hmrc.gov.uk'; // sandbox
async function request(path: string, accessToken: string) {
  return axios.get(HMRC_BASE_URL + path, {
    headers: { Authorization: 'Bearer ' + accessToken },
    timeout: 2000,
  });
}''',
          tokens: ['import', 'async', 'sandbox', 'Bearer ', '2000'],
        ),
        (
          languages: ['python', 'py'],
          code: '''def greet(name: str) -> str:
    # Welcome the learner
    return "Hello, " + name
''',
          tokens: ['def', 'return', 'Welcome the learner', 'Hello, '],
        ),
        (
          languages: ['sql'],
          code: "SELECT name FROM learners WHERE course = 'Python' LIMIT 10;",
          tokens: ['SELECT', 'WHERE', 'Python', '10'],
        ),
        (
          languages: ['json'],
          code: '{"course": "Python", "count": 42, "active": true}',
          tokens: ['course', 'Python', '42', 'true'],
        ),
        (
          languages: ['bash', 'sh'],
          code: '''if [ -f app.dart ]; then
  echo "Ready to learn"
fi''',
          tokens: ['if', 'then', 'Ready to learn'],
        ),
        (
          languages: ['dart'],
          code: '''class Greeting {
  String greet() {
    return 'Hello';
  }
}''',
          tokens: ['class', 'return', 'Hello'],
        ),
        (
          languages: ['rust'],
          code: '''fn main() {
    let count = 42;
    println!("Hello");
}''',
          tokens: ['fn', 'let', '42', 'Hello'],
        ),
        (
          languages: ['cpp', 'c++'],
          code: '''int main() {
  const char* message = "Hello";
  return 42;
}''',
          tokens: ['const', 'return', 'Hello', '42'],
        ),
        (
          languages: ['cs', 'c#'],
          code: '''public class Greeting {
  public string Greet() {
    return "Hello";
  }
}''',
          tokens: ['public', 'return', 'Hello'],
        ),
        (
          languages: ['jsx'],
          code: '''const label = "Hello";
const element = <div className="greeting">{label}</div>;''',
          tokens: ['const', 'Hello', 'div', 'greeting'],
        ),
        (
          languages: ['tsx'],
          code: '''const label: string = "Hello";
const element = <div className="greeting">{label}</div>;''',
          tokens: ['const', 'Hello', 'div', 'greeting'],
        ),
      ];

  for (final example in examples) {
    for (final language in example.languages) {
      test(
        '$language highlights article tokens and preserves source',
        () async {
          final code = '\t\n${example.code}\n  \n';
          final span = await highlightArticleCode(code, language);
          final segments = _segments(span);

          expect(span.toPlainText(), code);
          for (final token in example.tokens) {
            expect(
              segments.any(
                (segment) =>
                    segment.text.contains(token) &&
                    segment.color != null &&
                    segment.color != const Color(0xFFABB2BF),
              ),
              isTrue,
              reason: '$language should highlight $token',
            );
          }
          expect(
            segments.map((segment) => segment.color).whereType<Color>().toSet(),
            hasLength(greaterThanOrEqualTo(2)),
            reason: 'Keywords and values should have distinct token styles',
          );
        },
      );
    }
  }

  test('language names tolerate surrounding whitespace and case', () async {
    const code = 'const message: string = "Hello";';
    final span = await highlightArticleCode(code, '  TypeScript  ');
    expect(span.toPlainText(), code);
    expect(
      _segments(
        span,
      ).any((segment) => segment.text == 'const' && segment.color != null),
      isTrue,
    );
  });

  test(
    'JavaScript regexp ranges preserve functions and Unicode offsets',
    () async {
      const code = r'''const label = "🚀 café";
const words = text.split(/\s+/);
const isWord = /^[a-z]+$/i.test(label);''';
      final span = await highlightArticleCode(code, 'javascript');
      final baseline = TextMateHighlighterRegistry.instance.buildTextSpan(
        text: code,
        language: 'javascript',
      );
      final stringColor = _colorsIn(baseline, code, 'café').first;

      expect(span.toPlainText(), code);
      expect(stringColor, isNotNull);
      for (final regexp in [r'/\s+/', r'/^[a-z]+$/i']) {
        expect(_colorsIn(span, code, regexp), everyElement(stringColor));
      }
      for (final unchanged in ['const', '🚀 café', 'split', 'test']) {
        expect(
          _colorsIn(span, code, unchanged),
          _colorsIn(baseline, code, unchanged),
          reason:
              'Regexp highlighting must retain the existing $unchanged style',
        );
      }
    },
  );

  test(
    'JavaScript division, comments and string slashes are not regexps',
    () async {
      const code = r'''const total = value / divisor / 2;
const url = "https://example.com/a/b";
// A comment with /not-a-regexp/
/* A block comment with /also-not/ */
const matched = /a\/b/g.test(url);''';
      final span = await highlightArticleCode(code, 'js');
      final baseline = TextMateHighlighterRegistry.instance.buildTextSpan(
        text: code,
        language: 'javascript',
      );
      final stringColor = _colorsIn(
        baseline,
        code,
        'https://example.com/a/b',
      ).first;

      expect(span.toPlainText(), code);
      expect(_colorsIn(span, code, r'/a\/b/g'), everyElement(stringColor));
      for (final unchanged in [
        'value / divisor / 2',
        'https://example.com/a/b',
        '// A comment with /not-a-regexp/',
        '/* A block comment with /also-not/ */',
      ]) {
        expect(
          _colorsIn(span, code, unchanged),
          _colorsIn(baseline, code, unchanged),
          reason: 'Slashes in $unchanged must retain their original styling',
        );
      }
    },
  );

  for (final code in [
    r'const pattern = /unterminated;',
    r'const pattern = /[unterminated/;',
    r'const pattern = /trailing\',
  ]) {
    test('incomplete JavaScript regexp preserves source: $code', () async {
      final span = await highlightArticleCode(code, 'javascript');
      expect(span.toPlainText(), code);
      expect(_colorsByCodeUnit(span), hasLength(code.length));
    });
  }

  for (final language in ['', 'text', 'plaintext', 'not-a-real-language']) {
    test('unclassified "$language" preserves plain text', () async {
      const code = '\tUnclassified <text> & symbols\n  🚀\n';
      final span = await highlightArticleCode(code, language);
      expect(span.toPlainText(), code);
      expect(_segments(span).every((segment) => segment.color == null), isTrue);
    });
  }
}
