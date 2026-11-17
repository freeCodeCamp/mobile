import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/utils/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'test_runner_service.g.dart';

typedef TestResult = ({bool pass, Map<dynamic, dynamic>? err});
typedef PythonConsoleResult = ({List<String> logs, String? error});

const consoleTimeoutMessage =
    'Your code took too long to run. Check for an infinite loop.';

// NOTE: No auto-retry; the editor offers a manual retry instead.
// NOTE: keepAlive so the next challenge never races the previous one for port 8080.
@Riverpod(keepAlive: true, retry: noRetry)
Future<void> learnTestRunnerServer(Ref ref) async {
  final server = InAppLocalhostServer(documentRoot: 'assets/test_runner');
  ref.onDispose(server.close);
  await server.start();
}

@Riverpod(retry: noRetry)
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

@riverpod
LearnTestRunnerSession learnTestRunnerSession(Ref ref, String challengeId) =>
    LearnTestRunnerSession((workerType) {
      ref.listen(learnTestRunnerServiceProvider(workerType), (_, _) {});
    });

class LearnTestRunnerSession {
  LearnTestRunnerSession(this._retain);

  final void Function(String) _retain;
  final _workers = <String>{};

  void retain(String workerType) {
    if (_workers.add(workerType)) _retain(workerType);
  }
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
  Future<void> _pending = Future.value();
  Future<void>? _starting;
  bool _disposed = false;

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
    initialUserScripts: UnmodifiableListView([
      UserScript(
        source: _formatConsoleScript,
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
      ),
    ]),
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

  Future<void> start() => _starting ??= _start();

  Future<void> _start() async {
    await _babel.run();
    await _runner.run();
    // NOTE: A webview that never finishes loading would otherwise hang here silently.
    await (
      _babelReady.future,
      _runnerReady.future,
    ).wait.timeout(const Duration(seconds: 30));
  }

  Stream<String> get consoleMessages => _console.stream;

  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    try {
      await _starting;
    } catch (e) {
      log('Test runner: startup failed before disposal ($e)');
    }
    // NOTE: A timed-out evaluate never settles, so do not wait on it forever.
    await _pending.timeout(const Duration(seconds: 5), onTimeout: () {});
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

  Future<String?> evaluate(String code) => _enqueue(() => _evaluate(code));

  Future<String?> _evaluate(String code) async =>
      (await _runner.webViewController!.callAsyncJavaScript(
        functionBody: code,
      ))?.error;

  Future<PythonConsoleResult> runPythonConsole(String code) =>
      _enqueue(() => _runPythonConsole(code));

  // NOTE: The worker runs the source and returns its print output as logs once a test string evaluates to { test }.
  Future<PythonConsoleResult> _runPythonConsole(String code) async {
    final controller = _runner.webViewController!;
    await _createRunner(controller, userCode: code, combinedCode: code);
    final res = await controller.callAsyncJavaScript(
      functionBody: _testScript,
      arguments: {'testStr': '({ test: () => {} })'},
    );
    if (res == null) throw StateError('Test runner returned no result');

    final value = res.value as Map<dynamic, dynamic>?;
    final logs = value?['logs'] as List<dynamic>? ?? const [];
    final err = value?['err'] as Map<dynamic, dynamic>?;
    return (
      logs: [
        for (final log in logs) '${(log as Map<dynamic, dynamic>)['msg']}',
      ],
      error: err == null ? null : '${err['message']}',
    );
  }

  Future<List<TestResult>> run({
    required String userCode,
    required String combinedCode,
    required String editableContents,
    required Hooks hooks,
    required List<ChallengeTest> tests,
    bool evaluateUserCode = false,
    void Function(String)? onConsole,
  }) {
    return _enqueue(() async {
      final logs = onConsole == null ? null : _console.stream.listen(onConsole);
      try {
        if (evaluateUserCode && workerType == 'javascript') {
          final error = await _evaluate(userCode);
          if (error != null) onConsole?.call(error);
        }
        if (evaluateUserCode && workerType == 'python') {
          final result = await _runPythonConsole(userCode);
          result.logs.forEach(onConsole ?? (_) {});
          if (result.error case final error?) {
            onConsole?.call(pythonErrorHint(error));
          }
        }
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
      } finally {
        await logs?.cancel();
      }
    });
  }

  Future<T> _enqueue<T>(Future<T> Function() task) {
    final operation = _pending.then((_) {
      if (_disposed) throw StateError('Test runner has been disposed');
      return task();
    });
    // A failed attempt must not prevent the next queued attempt from running.
    _pending = operation.then<void>(
      (_) {},
      onError: (Object _, StackTrace _) {},
    );
    return operation;
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

// NOTE: Babel syntax errors are expected in these steps
const _skipBabelErrorChallengeIds = {
  // workshop-fcc-authors-page
  '69e16a610b33e847d85be16e', // step 27
  '69e1e83ac6424325f77331e8', // step 28
  // workshop-library-search
  '6a1c49231334592cc5a4c6b0', // step 5
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

// NOTE: Pyodide tracebacks open with its own frames, so keep only the part from the user's code onward.
String pythonErrorHint(String message) {
  if (message == 'Test timed out') return consoleTimeoutMessage;
  final lines = message.split('\n');
  final start = lines.indexWhere((line) => line.contains('File "<exec>"'));
  if (start == -1) return message.replaceFirst('PythonError: ', '').trim();
  return lines.sublist(start).join('\n').trim();
}

String workerTypeOf(int challengeType) => switch (challengeType) {
  1 || 26 || 28 => 'javascript',
  20 || 23 || 27 || 29 => 'python',
  _ => 'dom',
};

// NOTE: The webview stringifies console arguments with String(), which turns objects into "[object Object]".
const _formatConsoleScript = '''
(() => {
  const format = (value) => {
    if (typeof value === 'string') return value;
    if (value instanceof Error) return value.stack || String(value);
    if (typeof value === 'function' || typeof value === 'symbol' || typeof value === 'bigint' || value === undefined) return String(value);
    if (typeof value === 'object' && value !== null) {
      try {
        return JSON.stringify(value, (_, v) => typeof v === 'bigint' ? String(v) : v, 2);
      } catch (e) {
        return String(value);
      }
    }
    return String(value);
  };
  const log = console.log.bind(console);
  console.log = (...args) => log(args.map(format).join(' '));
})();
''';

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
