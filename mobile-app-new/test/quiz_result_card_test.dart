import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/quiz_result_card.dart';

final _capture = GlobalKey();
Future<void> _pump(
  WidgetTester tester, {
  bool dark = false,
  bool passed = true,
  bool reducedMotion = false,
  double scale = 1,
  Size size = const Size(390, 844),
  VoidCallback? onTap,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MaterialApp(
      theme: dark ? FccTheme.themeDark : FccTheme.themeLight,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          disableAnimations: reducedMotion,
          textScaler: TextScaler.linear(scale),
        ),
        child: child!,
      ),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.topCenter,
            child: RepaintBoundary(
              key: _capture,
              child: GestureDetector(
                onTap: onTap,
                child: QuizResultCard(
                  passed: passed,
                  correct: passed ? 19 : 17,
                  total: 20,
                  requiredCorrect: 18,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

Future<(Uint8List, int, int)> _confettiPixels(WidgetTester tester) async {
  final painter = tester.renderObject<RenderCustomPaint>(
    find.byWidgetPredicate((w) => w is CustomPaint && w.painter != null),
  );
  final boundary = painter.parent! as RenderRepaintBoundary;
  return (await tester.runAsync(() async {
    final image = await boundary.toImage();
    final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    final result = (data!.buffer.asUint8List(), image.width, image.height);
    image.dispose();
    return result;
  }))!;
}

double _yellowCenter((Uint8List, int, int) image) {
  var count = 0;
  var yTotal = 0.0;
  for (var y = 0; y < image.$3; y++) {
    for (var x = 0; x < image.$2; x++) {
      final p = (y * image.$2 + x) * 4;
      final r = image.$1[p];
      final g = image.$1[p + 1];
      final b = image.$1[p + 2];
      final a = image.$1[p + 3];
      if (a > 50 && r > g * 1.1 && b < g * .6) {
        count++;
        yTotal += y;
      }
    }
  }
  expect(
    count,
    greaterThan(0),
    reason: 'A falling yellow confetti piece should be visible.',
  );
  return yTotal / count;
}

Future<void> _screenshot(WidgetTester tester, String name) async {
  const directory = String.fromEnvironment('RESULT_CARD_SCREENSHOT_DIR');
  if (directory.isEmpty) {
    return;
  }
  await tester.runAsync(() async {
    final image =
        await (_capture.currentContext!.findRenderObject()!
                as RenderRepaintBoundary)
            .toImage(pixelRatio: 2);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File('$directory/$name.png');
    await file.parent.create(recursive: true);
    await file.writeAsBytes(data!.buffer.asUint8List());
    image.dispose();
  });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final fonts = FontLoader('Lato');
    for (final weight in ['Regular', 'Bold', 'ExtraBold', 'Black']) {
      fonts.addFont(rootBundle.load('assets/fonts/Lato-$weight.ttf'));
    }
    await fonts.load();
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
  });
  for (final dark in [false, true]) {
    final mode = dark ? 'dark' : 'light';
    testWidgets('passed hero matches gradient badge and typography $mode', (
      tester,
    ) async {
      await _pump(tester, dark: dark);
      expect(find.text('You needed 18. Nice work.'), findsOneWidget);
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline), findsNothing);
      final title = tester.widget<Text>(find.text('You passed!'));
      expect(title.style!.fontSize, 32);
      expect(title.style!.fontWeight, FontWeight.w800);
      final score = tester.widget<Text>(find.text('19 of 20 correct'));
      expect(
        score.style!.color,
        (dark ? FccTheme.themeDark : FccTheme.themeLight)
            .colorScheme
            .onSurfaceVariant,
      );
      final decoration =
          tester
                  .widget<DecoratedBox>(
                    find
                        .descendant(
                          of: find.byType(QuizResultCard),
                          matching: find.byType(DecoratedBox),
                        )
                        .first,
                  )
                  .decoration
              as BoxDecoration;
      expect(decoration.gradient, isA<LinearGradient>());
      expect((decoration.gradient! as LinearGradient).colors.last.a, 0);
      expect(tester.getSize(find.byType(QuizResultCard)).height, lessThan(205));
      await tester.pump(const Duration(milliseconds: 1000));
      await _screenshot(tester, 'quiz-hero-$mode');
      expect(tester.takeException(), isNull);
    });
    for (final size in [const Size(320, 568), const Size(844, 390)]) {
      testWidgets('result text stays readable at 200 percent $mode $size', (
        tester,
      ) async {
        await _pump(tester, dark: dark, size: size, scale: 2);
        await tester.pump(const Duration(milliseconds: 1000));
        await _screenshot(
          tester,
          'quiz-hero-$mode-${size.width.toInt()}-text200',
        );
        expect(find.text('You needed 18. Nice work.'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
    testWidgets('failed hero gives retry guidance without confetti $mode', (
      tester,
    ) async {
      await _pump(tester, passed: false, dark: dark);
      expect(find.text('Keep going!'), findsOneWidget);
      expect(find.text('17 of 20 correct'), findsOneWidget);
      expect(
        find.text(
          'You need 18 correct to pass. Review your answers and try again.',
        ),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate((w) => w is CustomPaint && w.painter != null),
        findsNothing,
      );
      expect(tester.binding.hasScheduledFrame, isFalse);
    });
  }
  testWidgets(
    'confetti visibly falls then disappears and stops scheduling frames',
    (tester) async {
      var taps = 0;
      await _pump(tester, onTap: () => taps++);
      await tester.pump(const Duration(milliseconds: 300));
      final early = await _confettiPixels(tester);
      await tester.pump(const Duration(milliseconds: 300));
      final later = await _confettiPixels(tester);
      expect(_yellowCenter(later), greaterThan(_yellowCenter(early) + 5));
      await tester.tapAt(
        tester.getTopLeft(find.byType(QuizResultCard)) + const Offset(12, 50),
      );
      expect(
        taps,
        1,
        reason: 'Decorative confetti must not intercept pointer input.',
      );
      await tester.pump(const Duration(seconds: 8));
      await tester.pump();
      final finished = await _confettiPixels(tester);
      expect([
        for (var i = 3; i < finished.$1.length; i += 4) finished.$1[i],
      ], everyElement(0));
      expect(tester.binding.hasScheduledFrame, isFalse);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'reduced motion suppresses celebration and can be enabled while falling',
    (tester) async {
      await _pump(tester, reducedMotion: true);
      expect(
        find.byWidgetPredicate((w) => w is CustomPaint && w.painter != null),
        findsNothing,
      );
      expect(tester.binding.hasScheduledFrame, isFalse);
      await _pump(tester);
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.binding.hasScheduledFrame, isTrue);
      await _pump(tester, reducedMotion: true);
      expect(
        find.byWidgetPredicate((w) => w is CustomPaint && w.painter != null),
        findsNothing,
      );
      expect(tester.binding.hasScheduledFrame, isFalse);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('removing a celebrating card disposes its ticker', (
    tester,
  ) async {
    await _pump(tester);
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 10));
    expect(tester.binding.hasScheduledFrame, isFalse);
    expect(tester.takeException(), isNull);
  });
}
