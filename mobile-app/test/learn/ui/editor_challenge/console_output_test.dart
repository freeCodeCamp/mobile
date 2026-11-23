import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/learn/ui/editor_challenge/editor_body.dart';

void main() {
  final theme = ThemeData();

  Future<Color?> colorOf(WidgetTester tester, String message) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: Scaffold(body: ConsoleOutput(userConsole: [message])),
      ),
    );
    return tester.widget<Text>(find.text(message)).style?.color;
  }

  group('ConsoleOutput', () {
    testWidgets('should color a JavaScript error red', (tester) async {
      expect(
        await colorOf(tester, 'SyntaxError: Unexpected token (1:17)'),
        theme.colorScheme.error,
      );
    });

    testWidgets('should color a Python traceback red', (tester) async {
      expect(
        await colorOf(
          tester,
          'File "<exec>", line 3\n    print(\'foo\n          ^\n'
          'SyntaxError: unterminated string literal (detected at line 3)',
        ),
        theme.colorScheme.error,
      );
    });

    testWidgets('should keep regular output in the default color', (
      tester,
    ) async {
      expect(await colorOf(tester, 'Alice'), theme.colorScheme.onSurface);
    });
  });
}
