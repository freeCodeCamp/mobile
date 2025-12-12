import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';

void printTestResults(int total, int failed, {String? extraInfo}) {
  print('''
------------------------------------------
Test summary:
------------------------------------------
Total: $total
Passed: ${total - failed}
Failed: $failed
------------------------------------------
''');

  if (extraInfo != null) {
    print('''$extraInfo
------------------------------------------
''');
  }
}

void main(List<String> args) async {
  exitCode = 0;

  bool isMacOS = false;
  bool isCurriculumTest = false;
  bool isDebug = false;

  int errorCount = 0;
  final testResults = [];

  late String bootedDeviceId;

  if (args.contains('--debug')) {
    isDebug = true;
  }

  if (args.contains('--curriculum')) {
    isCurriculumTest = true;
  }

  if (args.contains('--ios')) {
    isMacOS = true;

    if (!isCurriculumTest) {
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

  if (isCurriculumTest) {
    print('Running curriculum tests...');
    final testFilePath = 'integration_test/test_runner/curriculum_tests.dart';

    Directory mobileAppPath = Directory(Platform.script.path).parent;
    File curriculumFile = File(join(
      mobileAppPath.parent.parent.path,
      'freeCodeCamp',
      'shared-dist',
      'config',
      'curriculum.json',
    ));

    List<String> failedTests = [];
    int passedChallenges = 0;
    int failedChallenges = 0;

    if (!curriculumFile.existsSync()) {
      print('ERROR: Curriculum file not found: ${curriculumFile.path}');
      exit(1);
    }

    curriculumFile.copySync(
      join(
        mobileAppPath.path,
        'assets',
        'learn',
        'curriculum.json',
      ),
    );

    final process = await Process.start(
      'flutter',
      [
        'test',
        '--no-pub',
        '--reporter=expanded',
        '--timeout=1800s',
        if (isMacOS) ...[
          '-d',
          bootedDeviceId,
        ],
        testFilePath,
      ],
    );
    process.stdout.transform(utf8.decoder).forEach((line) {
      if (line.contains('Test(s) passed')) {
        passedChallenges++;
        if (!isDebug) {
          return;
        }
      }
      if (line.contains('Test(s) failed')) {
        failedChallenges++;
      }
      if (line.contains('TEST FAILED:')) {
        failedTests.add(line);
      }
      print(line);
    });
    stderr.addStream(process.stderr);

    int processExitCode = await process.exitCode;

    if (processExitCode != 0) {
      final file = await File(
        join(
          mobileAppPath.path,
          'integration_test',
          'test_runner',
          'test_runner_results.txt',
        ),
      ).create(
        recursive: true,
      );
      await file.writeAsString(
        'Failed tests:\n\n',
      );
      await file.writeAsString(
        failedTests.join('\n'),
        mode: FileMode.append,
      );
      exitCode = 1;
    }
    printTestResults(
      passedChallenges + failedChallenges,
      failedChallenges,
      extraInfo: processExitCode != 0
          ? 'Tests failed. See test_runner_results.txt for details.'
          : null,
    );
  } else {
    print('Running integration tests...');

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
          if (isMacOS) ...[
            '-d',
            bootedDeviceId,
          ],
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

    printTestResults(
      testFilePaths.length,
      errorCount,
      extraInfo: 'Failed tests output is in screenshots/errors.txt',
    );
  }
  exit(exitCode);
}
