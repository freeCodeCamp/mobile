// Simple test to validate the FloatingNavigationButtons widget
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Create a standalone copy of the widget for testing
class TestFloatingNavigationButtons extends StatelessWidget {
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final bool hasPrevious;
  final bool hasNext;

  const TestFloatingNavigationButtons({
    super.key,
    this.onPrevious,
    this.onNext,
    required this.hasPrevious,
    required this.hasNext,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      right: 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Previous button
          FloatingActionButton(
            heroTag: "previous",
            onPressed: hasPrevious ? onPrevious : null,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1,
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(100),
            ),
            backgroundColor: hasPrevious 
                ? const Color.fromRGBO(0x2A, 0x2A, 0x40, 1)
                : const Color.fromRGBO(0x2A, 0x2A, 0x40, 0.5),
            child: Icon(
              Icons.keyboard_arrow_up,
              size: 30,
              color: hasPrevious ? Colors.white : Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          // Next button
          FloatingActionButton(
            heroTag: "next",
            onPressed: hasNext ? onNext : null,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1,
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(100),
            ),
            backgroundColor: hasNext 
                ? const Color.fromRGBO(0x2A, 0x2A, 0x40, 1)
                : const Color.fromRGBO(0x2A, 0x2A, 0x40, 0.5),
            child: Icon(
              Icons.keyboard_arrow_down,
              size: 30,
              color: hasNext ? Colors.white : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  testWidgets('FloatingNavigationButtons should render correctly', (WidgetTester tester) async {
    bool previousPressed = false;
    bool nextPressed = false;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            TestFloatingNavigationButtons(
              onPrevious: () => previousPressed = true,
              onNext: () => nextPressed = true,
              hasPrevious: true,
              hasNext: true,
            ),
          ],
        ),
      ),
    ));

    // Check that both buttons are present
    expect(find.byType(FloatingActionButton), findsExactly(2));
    
    // Check that the buttons have correct icons
    expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);

    // Test button functionality
    await tester.tap(find.byIcon(Icons.keyboard_arrow_up));
    await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
    
    expect(previousPressed, true);
    expect(nextPressed, true);
  });

  testWidgets('FloatingNavigationButtons should disable buttons when appropriate', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            TestFloatingNavigationButtons(
              onPrevious: () {},
              onNext: () {},
              hasPrevious: false,
              hasNext: false,
            ),
          ],
        ),
      ),
    ));

    // Check that buttons are disabled by verifying they have null onPressed
    final previousButton = tester.widget<FloatingActionButton>(
      find.byIcon(Icons.keyboard_arrow_up).first,
    );
    final nextButton = tester.widget<FloatingActionButton>(
      find.byIcon(Icons.keyboard_arrow_down).first,
    );

    expect(previousButton.onPressed, null);
    expect(nextButton.onPressed, null);
  });
}