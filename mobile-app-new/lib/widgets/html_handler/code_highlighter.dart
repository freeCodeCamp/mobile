import 'package:flutter/material.dart';
import 'package:highlight/highlight.dart' as syntax;
import 'package:phone_ide/highlighting/textmate_highlighter_registry.dart';

/// Uses PhoneIDE's JavaScript/CSS grammars and semantic article grammars for
/// HTML and other News languages (TypeScript, Python, SQL, etc.).
Future<TextSpan> highlightArticleCode(String code, String language) async {
  final normalized = switch (language.trim().toLowerCase()) {
    // PhoneIDE emits the same color for HTML attributes and numeric literals.
    // Keep their semantic roles distinct so attributes can match the design.
    'html' || 'htm' => 'xml',
    // The TypeScript grammar rejects JSX tags; the JSX grammar retains both
    // the surrounding code and embedded markup highlighting.
    'tsx' => 'jsx',
    'py3' || 'python3' => 'python',
    final name => name,
  };
  if (normalized.isEmpty) return TextSpan(text: code);

  if (TextMateHighlighterRegistry.canonicalizeLanguage(normalized) != null) {
    final registry = TextMateHighlighterRegistry.instance;
    await registry.initialize();
    final highlighted = registry.buildTextSpan(
      text: code,
      language: normalized,
    );
    // PhoneIDE's sanitized JavaScript grammar drops regexp literals. Restore
    // only those token ranges from the article parser, retaining PhoneIDE's
    // function-call highlighting and the complete source span structure.
    return TextMateHighlighterRegistry.canonicalizeLanguage(normalized) ==
            'javascript'
        ? _highlightRegExps(highlighted, code)
        : highlighted;
  }

  try {
    // Always use the article's declared language. Unknown languages remain
    // plain text; auto-detection is costly and can misclassify short snippets.
    final result = syntax.highlight.parse(code, language: normalized);
    return TextSpan(children: result.nodes?.map(_spanForNode).toList());
  } catch (error) {
    debugPrint('Article highlighting failed for "$normalized": $error');
    return TextSpan(text: code);
  }
}

TextSpan _highlightRegExps(TextSpan highlighted, String code) {
  final ranges = <({int start, int end})>[];
  var offset = 0;
  void findRegExps(syntax.Node node) {
    final start = offset;
    offset += node.value?.length ?? 0;
    node.children?.forEach(findRegExps);
    if (node.className == 'regexp') ranges.add((start: start, end: offset));
  }

  try {
    syntax.highlight
        .parse(code, language: 'javascript')
        .nodes
        ?.forEach(findRegExps);
  } catch (_) {
    return highlighted;
  }
  if (ranges.isEmpty) return highlighted;

  offset = 0;
  TextSpan apply(TextSpan span) {
    final children = <InlineSpan>[];
    if (span.text case final text?) {
      final start = offset;
      final end = start + text.length;
      var cursor = start;
      for (final range in ranges) {
        if (range.end <= cursor || range.start >= end) continue;
        final from = range.start.clamp(cursor, end);
        final to = range.end.clamp(from, end);
        if (from > cursor) {
          children.add(
            TextSpan(text: text.substring(cursor - start, from - start)),
          );
        }
        children.add(
          TextSpan(
            text: text.substring(from - start, to - start),
            style: _styleForToken('regexp'),
          ),
        );
        cursor = to;
      }
      if (cursor < end) {
        children.add(TextSpan(text: text.substring(cursor - start)));
      }
      offset = end;
    }
    for (final child in span.children ?? <InlineSpan>[]) {
      children.add(child is TextSpan ? apply(child) : child);
    }
    return TextSpan(style: span.style, children: children);
  }

  return apply(highlighted);
}

TextSpan _spanForNode(syntax.Node node, {String? parentToken}) => TextSpan(
  text: node.value,
  style: _styleForToken(
    parentToken == 'tag' && const {'<', '</', '>', '/>'}.contains(node.value)
        ? 'name'
        : node.className,
  ),
  children: node.children
      ?.map((child) => _spanForNode(child, parentToken: node.className))
      .toList(),
);

// Use PhoneIDE's reference colors so FccCodeBlock can apply the same app palette
// to either parser, including when the reader changes themes without reloading.
TextStyle? _styleForToken(String? token) => switch (token) {
  'comment' || 'quote' => const TextStyle(
    color: Color(0xFF5C6370),
    fontStyle: FontStyle.italic,
  ),
  'keyword' ||
  'name' ||
  'selector-tag' ||
  'doctag' ||
  'formula' ||
  'literal' => const TextStyle(color: Color(0xFFC678DD)),
  'string' ||
  'regexp' ||
  'addition' ||
  'attribute' ||
  'meta-string' => const TextStyle(color: Color(0xFF98C379)),
  'number' => const TextStyle(color: Color(0xFFD19A66)),
  'built_in' || 'type' || 'class' => const TextStyle(color: Color(0xFFE5C07B)),
  'title' ||
  'attr' ||
  'symbol' ||
  'bullet' ||
  'link' ||
  'meta' ||
  'selector-id' => const TextStyle(color: Color(0xFF61AFEF)),
  'section' ||
  'deletion' ||
  'variable' ||
  'template-variable' ||
  'selector-class' ||
  'selector-attr' ||
  'selector-pseudo' => const TextStyle(color: Color(0xFFE06C75)),
  'subst' => const TextStyle(color: Color(0xFFABB2BF)),
  'emphasis' => const TextStyle(fontStyle: FontStyle.italic),
  'strong' => const TextStyle(fontWeight: FontWeight.bold),
  _ => null,
};
