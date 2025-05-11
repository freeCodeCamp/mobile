import 'dart:io';

void main(List<String> args) {
  exitCode = 0;

  bool isMacOS = false;

  int errorCount = 0;
  final testResults = [];

  late String bootedDeviceId;

  if (args.contains('--ios')) {
    isMacOS = true;

    final result = Process.runSync('which', ['applesimutils']);
    if (result.exitCode != 0) {
      print('''
------------------------------------------
WARNING: applesimutils is not installed
------------------------------------------
You can install it using homebrew:

brew tap wix/brew
brew install applesimutils
------------------------------------------''');
      exit(1);
    }

    final deviceIdResult = Process.runSync(
      'bash',
      [
        '-c',
        "xcrun simctl list devices | grep Booted | awk -F '[()]' '{print \$2}'"
      ],
      runInShell: true,
    );
    if (deviceIdResult.exitCode != 0) {
      print('ERROR: Failed to fetch booted iOS simulator device ID.');
      print(deviceIdResult.stderr);
      exit(1);
    }

    bootedDeviceId = deviceIdResult.stdout.trim();
    if (bootedDeviceId.isEmpty) {
      print('ERROR: No booted iOS simulator found.');
      exit(1);
    }
  }

  final testFilePaths = Directory('integration_test')
      .listSync(recursive: true)
      .whereType<File>()
      .map((file) => file.path)
      .where((testFilePath) =>
          !testFilePath.contains('test_runner') &&
          !testFilePath.contains('DS_Store'))
      .toList();

  for (final testFile in testFilePaths) {
    if (isMacOS) {
      final result = Process.runSync(
        'applesimutils',
        [
          '--byId',
          bootedDeviceId,
          '--bundle',
          'org.freecodecamp.ios',
          '--setPermissions',
          'notifications=YES'
        ],
        runInShell: true,
      );
      if (result.exitCode != 0) {
        print('ERROR: $testFile');
        print(result.stdout);
        print(result.stderr);
        exit(1);
      }
    }

    print('Testing: $testFile');

    final result = Process.runSync(
      'flutter',
      [
        'drive',
        '--no-pub',
        '--driver=test_driver/integration_test.dart',
        '--target=$testFile',
      ],
      runInShell: true,
    );

    print(result.stdout);

    if (result.exitCode != 0) {
      print('Test failed: $testFile\n');
      testResults.add('$testFile\n\n${result.stdout}');
      errorCount++;
      exitCode = 1;
    }
  }

  if (errorCount > 0) {
    final errorFile = File('screenshots/errors.txt');
    errorFile.createSync(recursive: true);
    errorFile.writeAsStringSync(testResults.join('\n\n'));
  }

  print('------------------------------------------');
  print('Test summary:');
  print('------------------------------------------');
  print('Total: ${testFilePaths.length}');
  print('Passed: ${testFilePaths.length - errorCount}');
  print('Failed: $errorCount\n');
  print('Failed tests output is in screenshots/errors.txt');
  print('------------------------------------------');
  exit(exitCode);
}
