import 'dart:async';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
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

  for (final (name, dimensions, ratio) in [
    ('portrait', 'width="120" height="240"', 0.5),
    ('landscape', 'width="800" height="400"', 2.0),
    ('unspecified', '', 16 / 9),
    ('invalid', 'width="0" height="NaN"', 16 / 9),
  ]) {
    testWidgets('$name images reserve finite space through loading', (
      tester,
    ) async {
      final url = 'https://example.com/$name.png';
      final pending = Completer<ImageInfo>();
      PaintingBinding.instance.imageCache.putIfAbsent(
        CachedNetworkImageProvider(url),
        () => OneFrameImageStreamCompleter(pending.future),
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: FccTheme.themeDark,
          home: Scaffold(
            body: SingleChildScrollView(
              child: ParsedHtml('<img src="$url" $dimensions><p>After</p>'),
            ),
          ),
        ),
      );

      final imageFinder = find.byType(CachedNetworkImage);
      final loadingBounds = tester.getRect(imageFinder);
      final afterImage = tester.getTopLeft(find.text('After'));
      expect(loadingBounds.width.isFinite, isTrue);
      expect(loadingBounds.height.isFinite, isTrue);
      expect(loadingBounds.height, greaterThan(0));
      expect(loadingBounds.width / loadingBounds.height, closeTo(ratio, .001));

      final decoded = await tester.runAsync(() async {
        final recorder = ui.PictureRecorder();
        ui.Canvas(recorder);
        return recorder.endRecording().toImage(4, 3);
      });
      pending.complete(ImageInfo(image: decoded!));
      await tester.pumpAndSettle();

      expect(tester.getRect(imageFinder), loadingBounds);
      expect(tester.getTopLeft(find.text('After')), afterImage);
      expect(
        tester.widget<CachedNetworkImage>(imageFinder).fit,
        BoxFit.contain,
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();
    });
  }
}
