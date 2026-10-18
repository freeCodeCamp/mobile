import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'test_runner_service.g.dart';

typedef TestResult = ({bool pass, Map<dynamic, dynamic>? err});

// NOTE: No auto-retry; the editor offers a manual retry instead.
Duration? _noRetry(int retryCount, Object error) => null;

// NOTE: keepAlive so the next challenge never races the previous one for port 8080.
@Riverpod(keepAlive: true, retry: _noRetry)
Future<void> learnTestRunnerServer(Ref ref) async {
  final server = InAppLocalhostServer(documentRoot: 'assets/test_runner');
  ref.onDispose(server.close);
  await server.start();
}

@Riverpod(retry: _noRetry)
Future<LearnTestRunnerService> learnTestRunnerService(
  Ref ref,
  String workerType,
) async {
  await ref.watch(learnTestRunnerServerProvider.future);

  final service = LearnTestRunnerService(workerType);
  ref.onDispose(service.dispose);
  await service.start();
  return service;
}

class BabelException implements Exception {
  BabelException(this.message);

  final String message;

  @override
  String toString() => message;
}

class LearnTestRunnerService {
  LearnTestRunnerService(this.workerType);

  final String workerType;

  final _babelReady = Completer<void>();
  final _runnerReady = Completer<void>();
  final _console = StreamController<String>.broadcast();

  late final _babel = HeadlessInAppWebView(
    initialData: InAppWebViewInitialData(
      data: '<html><head><title>Babel</title></head><body></body></html>',
      baseUrl: WebUri('http://localhost:8080/babel-transformer'),
    ),
    initialSettings: InAppWebViewSettings(isInspectable: kDebugMode),
    onConsoleMessage: (_, message) =>
        log('Babel console message: ${message.message}'),
    onLoadStop: (controller, _) async {
      final res = await controller.injectJavascriptFileFromAsset(
        assetFilePath: 'assets/test_runner/babel/babel.min.js',
      );
      log('Babel load: $res');
      if (!_babelReady.isCompleted) _babelReady.complete();
    },
  );

  late final _runner = HeadlessInAppWebView(
    initialData: InAppWebViewInitialData(
      data: '<html><head><title>Test Runner</title></head><body></body></html>',
      baseUrl: WebUri('http://localhost:8080/test-runner'),
    ),
    initialSettings: InAppWebViewSettings(
      isInspectable: kDebugMode,
      mediaPlaybackRequiresUserGesture: false,
    ),
    onConsoleMessage: (_, message) {
      if (message.messageLevel == ConsoleMessageLevel.LOG &&
          !_console.isClosed) {
        _console.add(message.message);
      }
    },
    onLoadStop: (controller, _) async {
      await _createRunner(controller);
      if (!_runnerReady.isCompleted) _runnerReady.complete();
    },
  );

  Stream<String> get consoleMessages => _console.stream;

  Future<void> start() async {
    await _babel.run();
    await _runner.run();
    // NOTE: A webview that never finishes loading would otherwise hang here silently.
    await (
      _babelReady.future,
      _runnerReady.future,
    ).wait.timeout(const Duration(seconds: 30));
  }

  Future<void> dispose() async {
    try {
      await _console.close();
      await _runner.dispose();
      await _babel.dispose();
    } catch (e) {
      log('Test runner: dispose failed ($e)');
    }
  }

  Future<String> transpile(String code, {required String challengeId}) async {
    try {
      return await _transpile(code);
    } on BabelException {
      if (_skipBabelErrorChallengeIds.contains(challengeId)) return code;
      rethrow;
    }
  }

  Future<String> _transpile(String code) async {
    final res = await _babel.webViewController!.callAsyncJavaScript(
      functionBody: _transpileScript,
      arguments: {'code': code},
    );
    if (res?.error case final error?) throw BabelException(error);

    final value = res?.value as Map<dynamic, dynamic>?;
    if (value?['success'] == false) throw BabelException('${value?['error']}');
    return value?['code'] as String? ?? code;
  }

  Future<String?> evaluate(String code) async =>
      (await _runner.webViewController!.callAsyncJavaScript(
        functionBody: code,
      ))?.error;

  Future<List<TestResult>> run({
    required String userCode,
    required String combinedCode,
    required String editableContents,
    required Hooks hooks,
    required List<ChallengeTest> tests,
  }) async {
    final controller = _runner.webViewController!;
    await _createRunner(
      controller,
      userCode: userCode,
      combinedCode: combinedCode,
      editableContents: editableContents,
      hooks: hooks,
    );

    return [
      for (final test in tests) await _runTest(controller, test.testString),
    ];
  }

  Future<TestResult> _runTest(
    InAppWebViewController controller,
    String testString,
  ) async {
    final res = await controller.callAsyncJavaScript(
      functionBody: _testScript,
      arguments: {'testStr': testString},
    );
    if (res == null) throw StateError('Test runner returned no result');

    final value = res.value as Map<dynamic, dynamic>?;
    return (
      pass: value?['pass'] != null,
      err: value?['err'] as Map<dynamic, dynamic>?,
    );
  }

  Future<void> _createRunner(
    InAppWebViewController controller, {
    String userCode = '',
    String combinedCode = '',
    String editableContents = '',
    Hooks hooks = const Hooks(),
  }) => controller.callAsyncJavaScript(
    functionBody: _runnerScript,
    arguments: {
      'userCode': userCode,
      'workerType': workerType,
      'combinedCode': combinedCode,
      'editableRegionContent': editableContents,
      'hooks': {
        'beforeAll': hooks.beforeAll,
        'beforeEach': hooks.beforeEach,
        'afterEach': hooks.afterEach,
      },
    },
  );
}

// NOTE: Babel syntax errors are expected in these steps (workshop-fcc-authors-page 27 and 28).
const _skipBabelErrorChallengeIds = {
  '69e16a610b33e847d85be16e',
  '69e1e83ac6424325f77331e8',
};

String syntaxErrorHint(BabelException error) {
  final match = RegExp(
    r'SyntaxError:.*?\((\d+):(\d+)\)',
  ).firstMatch(error.message);
  if (match == null) {
    return 'There is a syntax error in your code. Please check for missing brackets, quotes, or other syntax issues.';
  }

  final line = int.parse(match.group(1)!) - 1;
  return 'There is a syntax error on line $line. Please check for missing brackets, quotes, or other syntax issues.';
}

String workerTypeOf(int challengeType) => switch (challengeType) {
  1 || 26 || 28 => 'javascript',
  20 || 23 || 27 || 29 => 'python',
  _ => 'dom',
};

const _transpileScript = '''
try {
  return { success: true, code: Babel.transform(code, { presets: [["env", { "targets": "> 0.4%, not dead" }]] }).code };
} catch (e) {
  let errorMsg = e.message || e.toString();
  if (e.loc) {
    errorMsg = "SyntaxError: " + e.message + " (" + e.loc.line + ":" + e.loc.column + ")";
  }
  return { success: false, error: errorMsg };
}
''';

const _runnerScript = '''
await import("http://localhost:8080/dist/index.js");
window.TestRunner = await window.FCCTestRunner.createTestRunner({
  source: userCode,
  type: workerType,
  assetPath: "/dist",
  code: {
    contents: combinedCode,
    editableContents: editableRegionContent,
  },
  hooks
});
''';

const _testScript = '''
const testRes = await window.TestRunner.runTest(testStr);
return testRes;
''';
