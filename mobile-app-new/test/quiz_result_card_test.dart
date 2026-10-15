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
  bool tickersEnabled = true,
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
                child: TickerMode(
                  enabled: tickersEnabled,
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

int _visiblePixels((Uint8List, int, int) image) {
  var count = 0;
  for (var p = 3; p < image.$1.length; p += 4) {
    if (image.$1[p] > 50) {
      count++;
    }
  }
  return count;
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
    'confetti keeps falling beyond eight seconds without replaying a batch',
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
      await tester.pump(const Duration(milliseconds: 7360));
      final beforeEight = await _confettiPixels(tester);
      await tester.pump(const Duration(milliseconds: 80));
      final afterEight = await _confettiPixels(tester);
      expect(_visiblePixels(beforeEight), greaterThan(120));
      expect(_visiblePixels(afterEight), greaterThan(120));
      await tester.pump(const Duration(seconds: 8));
      final afterSixteen = await _confettiPixels(tester);
      expect(_visiblePixels(afterSixteen), greaterThan(120));
      expect(afterSixteen.$1, isNot(orderedEquals(afterEight.$1)));
      expect(tester.binding.hasScheduledFrame, isTrue);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('falling pieces fade out near the bottom of the card', (
    tester,
  ) async {
    await _pump(tester);
    await tester.pump(const Duration(seconds: 6));
    var bottomAlpha = 0;
    var bottomPixels = 0;
    var middleAlpha = 0;
    var middlePixels = 0;
    for (var frame = 0; frame < 12; frame++) {
      await tester.pump(const Duration(milliseconds: 250));
      final pixels = await _confettiPixels(tester);
      for (var y = 0; y < pixels.$3; y++) {
        for (var x = 0; x < pixels.$2; x++) {
          final alpha = pixels.$1[(y * pixels.$2 + x) * 4 + 3];
          if (alpha == 0) {
            continue;
          }
          if (y >= pixels.$3 * .9) {
            bottomAlpha += alpha;
            bottomPixels++;
          } else if (y >= pixels.$3 * .3 && y < pixels.$3 * .7) {
            middleAlpha += alpha;
            middlePixels++;
          }
        }
      }
    }
    expect(bottomPixels, greaterThan(0));
    expect(middlePixels, greaterThan(0));
    expect(
      bottomAlpha / bottomPixels,
      lessThan(middleAlpha / middlePixels * .7),
      reason: 'Pieces should visibly fade before leaving the card.',
    );
  });
  testWidgets('offstage cards pause and safely resume after a long absence', (
    tester,
  ) async {
    await _pump(tester);
    await tester.pump(const Duration(seconds: 2));
    await _pump(tester, tickersEnabled: false);
    expect(tester.binding.hasScheduledFrame, isFalse);
    await tester.pump(const Duration(hours: 1));
    expect(tester.binding.hasScheduledFrame, isFalse);
    await _pump(tester);
    expect(tester.binding.hasScheduledFrame, isTrue);
    expect(_visiblePixels(await _confettiPixels(tester)), greaterThan(120));
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });
  testWidgets('a failed result stops the stream and passing restarts it', (
    tester,
  ) async {
    await _pump(tester);
    await tester.pump(const Duration(seconds: 2));
    await _pump(tester, passed: false);
    expect(tester.binding.hasScheduledFrame, isFalse);
    expect(
      find.byWidgetPredicate((w) => w is CustomPaint && w.painter != null),
      findsNothing,
    );
    await _pump(tester);
    await tester.pump(const Duration(milliseconds: 600));
    expect(_visiblePixels(await _confettiPixels(tester)), greaterThan(0));
    expect(tester.binding.hasScheduledFrame, isTrue);
    expect(tester.takeException(), isNull);
  });
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
