import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async {
  FlutterDriver driver = await FlutterDriver.connect();
  final vm = await driver.serviceClient.getVM();
  final platform = vm.operatingSystem;

  if (platform!.toLowerCase().contains('android')) {
    Process.runSync(
      'adb',
      [
        'shell',
        'pm',
        'grant',
        'org.freecodecamp',
        'android.permission.POST_NOTIFICATIONS'
      ],
    );
  }

  try {
    await integrationDriver(
      onScreenshot: (String screenshotName, List<int> screenshotBytes,
          [Map<String, Object?>? _]) async {
        final File image = await File('screenshots/$screenshotName.png')
            .create(recursive: true);
        image.writeAsBytesSync(screenshotBytes);
        return true;
      },
    );
  } catch (e) {
    print('Error occured: $e');
  }
}
