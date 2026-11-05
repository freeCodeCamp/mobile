import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/ui/widgets/exam_card.dart';

void main() {
  testWidgets('should render only the title without an eyebrow label', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: FccTheme.themeLight,
        home: Scaffold(
          body: ExamCard(
            title: 'Certification Exam',
            locked: false,
            onOpen: () {},
          ),
        ),
      ),
    );

    expect(find.text('Certification Exam'), findsOneWidget);
    expect(find.textContaining('Chapter'), findsNothing);
    expect(find.text('Exam'), findsNothing);
  });
}
