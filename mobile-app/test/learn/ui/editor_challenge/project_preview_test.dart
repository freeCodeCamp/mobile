import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/learn/ui/editor_challenge/editor_body.dart';
import 'package:freecodecamp/widgets/error_retry.dart';

void main() {
  testWidgets('failed previews can be retried without leaving the preview', (
    tester,
  ) async {
    final first = Completer<String>();
    final second = Completer<String>();
    var attempts = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProjectPreview(
            load: () => ++attempts == 1 ? first.future : second.future,
          ),
        ),
      ),
    );
    first.completeError(StateError('Preview failed'));
    await tester.pumpAndSettle();
    expect(find.byType(ErrorRetry), findsOneWidget);
    expect(attempts, 1);

    await tester.tap(find.byType(FilledButton));
    await tester.pump();
    expect(attempts, 2);
    expect(find.byType(ErrorRetry), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    second.completeError(StateError('Preview still unavailable'));
    await tester.pumpAndSettle();
    expect(find.byType(ErrorRetry), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
