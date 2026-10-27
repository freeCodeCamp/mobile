import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/review_content.dart';
import 'package:freecodecamp/widgets/html_handler/code_block.dart';

final _nodules = [
  const Nodule.paragraph(
    contents:
        '<p>Read every concept in this review.</p><h2>HTML <em>Basics</em></h2><p>HTML provides structure.</p>',
  ),
  for (var i = 0; i < 10; i++)
    Nodule.paragraph(
      contents:
          '<p>First topic paragraph $i. Review headings, links and images.</p>',
    ),
  const Nodule.interactiveEditor(
    files: [
      NoduleFile(
        name: 'example.txt',
        ext: 'text',
        contents: 'Example contents retained',
      ),
    ],
  ),
  const Nodule.paragraph(
    contents:
        '<h2>Common Elements</h2><p>Use elements to mark up your content.</p><h2>Links &amp; Images</h2><p>Use meaningful alternative text.</p>',
  ),
];

Future<ScrollController> _pump(
  WidgetTester tester,
  List<Nodule> nodules, {
  bool dark = false,
  double width = 390,
  double scale = 1,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 844);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  final scroll = ScrollController();
  addTearDown(scroll.dispose);
  await tester.pumpWidget(
    MaterialApp(
      theme: dark ? FccTheme.themeDark : FccTheme.themeLight,
      home: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(scale)),
        child: Scaffold(
          body: ListView(
            controller: scroll,
            padding: const EdgeInsets.all(16),
            children: [
              ReviewContent(nodules: nodules),
              const SizedBox(height: 600),
            ],
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return scroll;
}

void main() {
  for (final dark in [false, true]) {
    testWidgets(
      'Review topic chips scroll to actual content (${dark ? 'dark' : 'light'})',
      (tester) async {
        final scroll = await _pump(tester, _nodules, dark: dark);
        expect(find.byType(ChoiceChip), findsNWidgets(3));
        expect(find.widgetWithText(ChoiceChip, 'HTML Basics'), findsOneWidget);
        expect(
          find.widgetWithText(ChoiceChip, 'Links & Images'),
          findsOneWidget,
        );
        expect(find.byType(FccCodeBlock), findsOneWidget);
        expect(
          tester.widget<FccCodeBlock>(find.byType(FccCodeBlock)).code,
          'Example contents retained',
        );
        await tester.tap(find.widgetWithText(ChoiceChip, 'Common Elements'));
        await tester.pumpAndSettle();
        expect(scroll.offset, greaterThan(500));
        expect(
          tester
              .widget<ChoiceChip>(
                find.widgetWithText(ChoiceChip, 'Common Elements'),
              )
              .selected,
          isTrue,
        );
        expect(
          find.textContaining('Read every concept', findRichText: true),
          findsWidgets,
        );
        expect(
          find.textContaining('First topic paragraph 9', findRichText: true),
          findsWidgets,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('Review preserves content without headings', (tester) async {
    await _pump(tester, const [
      Nodule.paragraph(contents: '<p>Review this complete paragraph.</p>'),
    ]);
    expect(find.byType(ChoiceChip), findsNothing);
    expect(
      find.textContaining(
        'Review this complete paragraph.',
        findRichText: true,
      ),
      findsWidgets,
    );
  });

  testWidgets('Review topics support narrow screens and large text', (
    tester,
  ) async {
    await _pump(tester, _nodules, width: 320, scale: 1.6);
    final horizontal = find.byWidgetPredicate(
      (w) => w is SingleChildScrollView && w.scrollDirection == Axis.horizontal,
    );
    await tester.drag(horizontal.first, const Offset(-600, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Links & Images'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Links & Images'))
          .selected,
      isTrue,
    );
    expect(tester.takeException(), isNull);
  });
}
