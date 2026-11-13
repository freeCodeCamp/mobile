import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/parsed_html.dart';

void main() {
  testWidgets('should draw a keycap box around kbd text', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: FccTheme.themeDark,
        home: const Scaffold(
          body: SingleChildScrollView(
            child: ParsedHtml('<p>Press <kbd>Windows key</kbd> now.</p>'),
          ),
        ),
      ),
    );

    final keycap = find.ancestor(
      of: find.text('Windows key'),
      matching: find.byType(Container),
    );

    expect(keycap, findsWidgets);
    final decoration =
        tester.widget<Container>(keycap.first).decoration! as BoxDecoration;
    final border = decoration.border! as Border;
    expect(border.bottom.width, 2);
    expect(decoration.borderRadius, BorderRadius.circular(4));
  });
}
