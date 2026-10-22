import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/learn/constants/curriculum.dart';
import 'package:freecodecamp/learn/ui/landing/landing_view.dart';
import 'package:freecodecamp/learn/ui/landing/superblock_button.dart';
import 'package:freecodecamp/main.dart' as app;
import 'package:freecodecamp/services/auth_service.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding();
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpUntilFound(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 60),
  }) async {
    final deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      await tester.pump(const Duration(milliseconds: 250));
      if (finder.evaluate().isNotEmpty) return;
    }
    fail('Timed out waiting for: $finder');
  }

  testWidgets('LEARN - should list every superblock', (
    WidgetTester tester,
  ) async {
    tester.printToConsole('Test starting');
    await app.main();
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();

    final keyed = find.byWidgetPredicate(
      (widget) => widget is SuperBlockButton && widget.key is ValueKey<String>,
    );
    await pumpUntilFound(tester, keyed);
    await tester.pumpAndSettle();
    await binding.takeScreenshot('learn/learn-landing');

    final response = await Dio().get<Map<String, dynamic>>(
      '$curriculumDataUrl/available-superblocks.json',
    );
    final stages = response.data!['superblocks'] as Map<String, dynamic>;
    final expected = [
      for (final stage in stageTitles.keys)
        for (final superBlock in stages[stage] as List? ?? const [])
          if (!(superBlock['dashedName'] as String).contains('full-stack'))
            superBlock as Map<String, dynamic>,
    ];

    final container = ProviderScope.containerOf(
      tester.element(find.byType(LearnLandingView)),
    );

    expect(keyed, findsNWidgets(expected.length));
    for (final superBlock in expected) {
      final dashedName = superBlock['dashedName'] as String;
      final button = find.byKey(ValueKey(dashedName));
      expect(button, findsOneWidget, reason: dashedName);
      expect(
        tester.widget<SuperBlockButton>(button).isEnabled,
        superBlock['public'] == true,
        reason: dashedName,
      );
    }

    expect(await container.read(authProvider.future), isNull);
    expect(find.text('Sign in to save your progress'), findsOneWidget);
  });
}
