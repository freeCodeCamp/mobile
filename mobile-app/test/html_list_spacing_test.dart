import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/parsed_html.dart';

const _html = '''<ol>
<li>You should have a <code>!DOCTYPE html</code> declaration.</li>
<li>You should have an <code>html</code> element with <code>lang</code> set to <code>en</code>.</li>
<li>You should have a <code>head</code> element containing a <code>title</code> element with the name of your recipe, and a <code>meta</code> element with a <code>charset</code> attribute set to <code>UTF-8</code>.</li>
<li>You should have a <code>body</code> element.</li>
<li>You should have only one <code>h1</code> element.</li>
</ol>''';

// The curriculum HTML has a newline between <li> tags, and a renderer can treat
// that whitespace as text, which breaks the list layout. The fixture keeps
// those newlines, and the test checks that every item still has the same
// indent and the same gap before the next one.
void main() {
  testWidgets(
    'should lay out whitespace-separated list items with equal indent and gaps',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(700, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        MaterialApp(
          theme: FccTheme.themeDark,
          home: const Scaffold(
            body: SingleChildScrollView(
              child: ParsedHtml(_html, outlinedInlineCode: true),
            ),
          ),
        ),
      );

      final rects = find
          .byWidgetPredicate(
            (w) => w is RichText && w.text.toPlainText().startsWith('You '),
          )
          .evaluate()
          .map((e) => tester.getRect(find.byWidget(e.widget)))
          .toList();

      expect(rects, hasLength(5));
      expect(rects.map((r) => r.left).toSet(), hasLength(1));
      final gaps = {
        for (var i = 1; i < rects.length; i++)
          (rects[i].top - rects[i - 1].bottom).toStringAsFixed(1),
      };
      expect(gaps, hasLength(1));
    },
  );
}
