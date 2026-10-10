import 'package:flutter/material.dart';
import 'package:highlight/highlight.dart' as syntax;
import 'package:phone_ide/highlighting/textmate_highlighter_registry.dart';

/// Keeps PhoneIDE's web grammars while retaining highlighting for the wider
/// range of languages used in News articles (TypeScript, Python, SQL, etc.).
Future<TextSpan> highlightArticleCode(String code, String language) async {
  final normalized = switch (language.trim().toLowerCase()) {
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
    return registry.buildTextSpan(text: code, language: normalized);
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

TextSpan _spanForNode(syntax.Node node) => TextSpan(
  text: node.value,
  style: _styleForToken(node.className),
  children: node.children?.map(_spanForNode).toList(),
);

// Use PhoneIDE's reference colors so FccCodeBlock can apply the same app palette
// to either parser, including when the reader changes themes without reloading.
TextStyle? _styleForToken(String? token) => switch (token) {
  'comment' || 'quote' => const TextStyle(
    color: Color(0xFF5C6370),
    fontStyle: FontStyle.italic,
  ),
  'keyword' ||
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
  'symbol' ||
  'bullet' ||
  'link' ||
  'meta' ||
  'selector-id' => const TextStyle(color: Color(0xFF61AFEF)),
  'name' ||
  'section' ||
  'selector-tag' ||
  'deletion' ||
  'attr' ||
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
