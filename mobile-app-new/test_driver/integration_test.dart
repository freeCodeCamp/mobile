import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async {
  try {
    await integrationDriver(
      onScreenshot: (String name, List<int> bytes, [Map<String, Object?>? _]) async {
        final image = await File('screenshots/$name.png').create(recursive: true);
        image.writeAsBytesSync(bytes);
        return true;
      },
    );
  } catch (e) {
    stderr.writeln('Integration driver error: $e');
  }
}
