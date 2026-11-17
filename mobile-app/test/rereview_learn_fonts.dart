import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> loadLearningDesignFonts() async {
  for (final (family, assets) in [
    ('Lato', ['Lato-Regular.ttf', 'Lato-Bold.ttf', 'Lato-Black.ttf']),
    ('Hack', ['Hack-Regular.ttf']),
    ('monospace', ['Hack-Regular.ttf']),
    (
      'JetBrains Mono',
      [
        'JetBrainsMono/JetBrainsMono-Regular.ttf',
        'JetBrainsMono/JetBrainsMono-SemiBold.ttf',
        'JetBrainsMono/JetBrainsMono-Bold.ttf',
      ],
    ),
  ]) {
    final loader = FontLoader(family);
    for (final asset in assets) {
      loader.addFont(rootBundle.load('assets/fonts/$asset'));
    }
    await loader.load();
  }
  final icons = FontLoader('MaterialIcons')
    ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
  await icons.load();
}

Future<void> captureLearningDesign(WidgetTester tester, String name) async {
  final directory = Platform.environment['DESIGN_SCREENSHOT_DIR'];
  if (directory == null) return;
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(const ValueKey('rereview-capture')),
  );
  await tester.runAsync(() async {
    final image = await boundary.toImage();
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    await Directory(directory).create(recursive: true);
    await File(
      '$directory/$name.png',
    ).writeAsBytes(bytes!.buffer.asUint8List());
    image.dispose();
  });
}
