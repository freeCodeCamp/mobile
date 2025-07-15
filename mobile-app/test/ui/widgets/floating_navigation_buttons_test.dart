import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/ui/widgets/floating_navigation_buttons.dart';

void main() {
  testWidgets('FloatingNavigationButtons should render correctly', (WidgetTester tester) async {
    bool previousPressed = false;
    bool nextPressed = false;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingNavigationButtons(
          onPrevious: () => previousPressed = true,
          onNext: () => nextPressed = true,
          hasPrevious: true,
          hasNext: true,
        ),
      ),
    ));

    expect(find.byType(FloatingActionButton), findsExactly(2));
    
    expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);

    await tester.tap(find.byIcon(Icons.keyboard_arrow_up));
    await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
    
    expect(previousPressed, true);
    expect(nextPressed, true);
  });

  testWidgets('FloatingNavigationButtons should disable buttons when appropriate', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingNavigationButtons(
          onPrevious: () {},
          onNext: () {},
          hasPrevious: false,
          hasNext: false,
        ),
      ),
    ));

    final floatingActionButtons = tester.widgetList<FloatingActionButton>(
      find.byType(FloatingActionButton),
    ).toList();
    
    expect(floatingActionButtons.length, 2);
    expect(floatingActionButtons[0].onPressed, null);
    expect(floatingActionButtons[1].onPressed, null);
  });

  testWidgets('FloatingNavigationButtons should disable buttons when animating', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingNavigationButtons(
          onPrevious: () {},
          onNext: () {},
          hasPrevious: true,
          hasNext: true,
          isAnimating: true,
        ),
      ),
    ));

    final floatingActionButtons = tester.widgetList<FloatingActionButton>(
      find.byType(FloatingActionButton),
    ).toList();
    
    expect(floatingActionButtons.length, 2);
    expect(floatingActionButtons[0].onPressed, null);
    expect(floatingActionButtons[1].onPressed, null);
  });
}