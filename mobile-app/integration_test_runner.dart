// ignore_for_file: avoid_print

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

String bootedSimulatorId() {
  final result = Process.runSync('bash', [
    '-c',
    "xcrun simctl list devices | grep Booted | awk -F '[()]' '{print \$2}'",
  ], runInShell: true);
  if (result.exitCode != 0) {
    print('ERROR: Failed to fetch booted iOS simulator device ID.');
    print(result.stderr);
    exit(1);
  }

  final id = (result.stdout as String).trim();
  if (id.isEmpty) {
    print('ERROR: No booted iOS simulator found.');
    exit(1);
  }
  return id;
}

Future<void> runCurriculumTests(
  String appPath,
  String? deviceId,
  bool debug,
) async {
  print('Running curriculum tests...');

  final source = File(
    join(
      dirname(appPath),
      '..',
      'freeCodeCamp',
      'curriculum',
      'generated',
      'curriculum.json',
    ),
  );
  if (!source.existsSync()) {
    print('ERROR: Curriculum file not found: ${source.path}');
    exit(1);
  }

  // NOTE: Deleted afterwards, otherwise every later build bundles the 100MB+ file.
  final curriculum = source.copySync(
    join(appPath, 'assets', 'learn', 'curriculum.json'),
  );

  // NOTE: Results come from reportData, not stdout, which loses lines on long device runs.
  final response = File(
    join(appPath, 'build', 'integration_response_data.json'),
  );
  if (response.existsSync()) response.deleteSync();

  final process = await Process.start('flutter', [
    'drive',
    '--no-pub',
    '--driver=test_driver/integration_test.dart',
    '--target=integration_test/test_runner/curriculum_test.dart',
    if (deviceId != null) ...['-d', deviceId],
  ], workingDirectory: appPath);
  final output = process.stdout
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .forEach((line) {
        // NOTE: Android's WebView mirrors every JS console call into logcat.
        if (line.contains('[INFO:CONSOLE')) return;
        if (debug || !line.contains('Test(s) passed')) print(line);
      });
  final errors = stderr.addStream(process.stderr);

  final processExitCode = await process.exitCode;
  await (output, errors).wait;
  curriculum.deleteSync();

  final data = response.existsSync()
      ? (jsonDecode(response.readAsStringSync()) as Map)['curriculum'] as Map?
      : null;
  if (data == null) {
    print(
      'ERROR: The test sent back no results (flutter drive exit code $processExitCode).',
    );
    exit(1);
  }

  final total = data['total'] as int;
  final failedChallenges = (data['failedChallenges'] as List).cast<String>();
  final failures = (data['failures'] as List).cast<String>();

  if (failedChallenges.isNotEmpty || processExitCode != 0) {
    final results = File(
      join(
        appPath,
        'integration_test',
        'test_runner',
        'test_runner_results.txt',
      ),
    );
    await results.create(recursive: true);
    await results.writeAsString('Failed tests:\n\n${failures.join('\n\n')}\n');
    exitCode = 1;
  }

  printTestResults(
    total,
    failedChallenges.length,
    extraInfo: exitCode != 0
        ? 'Tests failed. See test_runner_results.txt for details.'
        : null,
  );
}

void runIntegrationTests(String? deviceId) {
  print('Running integration tests...');

  final testFiles = Directory('integration_test')
      .listSync(recursive: true)
      .whereType<File>()
      .map((file) => file.path)
      .where(
        (path) => !path.contains('test_runner') && !path.contains('DS_Store'),
      )
      .toList();

  final failures = <String>[];
  for (final testFile in testFiles) {
    if (deviceId != null) {
      final result = Process.runSync('applesimutils', [
        '--byId',
        deviceId,
        '--bundle',
        'org.freecodecamp.ios',
        '--setPermissions',
        'notifications=YES',
      ], runInShell: true);
      if (result.exitCode != 0) {
        print('ERROR: $testFile');
        print(result.stdout);
        print(result.stderr);
        exit(1);
      }
    }

    print('Testing: $testFile');

    final result = Process.runSync('flutter', [
      'drive',
      '--no-pub',
      '--driver=test_driver/integration_test.dart',
      if (deviceId != null) ...['-d', deviceId],
      '--target=$testFile',
    ], runInShell: true);

    print(result.stdout);

    if (result.exitCode != 0) {
      print('Test failed: $testFile\n');
      failures.add('$testFile\n\n${result.stdout}');
      exitCode = 1;
    }
  }

  if (failures.isNotEmpty) {
    File('screenshots/errors.txt')
      ..createSync(recursive: true)
      ..writeAsStringSync(failures.join('\n\n'));
  }

  printTestResults(
    testFiles.length,
    failures.length,
    extraInfo: 'Failed tests output is in screenshots/errors.txt',
  );
}

Future<void> main(List<String> args) async {
  exitCode = 0;

  final debug = args.contains('--debug');
  final curriculum = args.contains('--curriculum');
  final ios = args.contains('--ios');

  if (ios &&
      !curriculum &&
      Process.runSync('which', ['applesimutils']).exitCode != 0) {
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

  final deviceId = ios ? bootedSimulatorId() : null;
  final appPath = File(Platform.script.toFilePath()).parent.path;

  if (curriculum) {
    await runCurriculumTests(appPath, deviceId, debug);
  } else {
    runIntegrationTests(deviceId);
  }
  exit(exitCode);
}
