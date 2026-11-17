import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/learn/models/challenge_file_model.dart';
import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/learn/repositories/prefs_repository.dart';
import 'package:freecodecamp/learn/services/test_runner_service.dart';
import 'package:freecodecamp/learn/ui/editor_challenge/editor_challenge_viewmodel.dart';

class _FakePrefs implements LearnPrefsRepository {
  final store = <String, String>{};

  @override
  Future<String?> read(String key) async => store[key];

  @override
  Future<void> write(String key, String value) async => store[key] = value;

  @override
  Future<void> remove(String key) async => store.remove(key);
}

class _FakeRunner extends LearnTestRunnerService {
  _FakeRunner(super.workerType);

  final messages = StreamController<String>.broadcast();
  var evaluateCalls = 0;
  var runCalls = 0;
  Object? transpileError;
  Future<String?> Function(String code) onEvaluate = (_) async => null;
  var pythonCalls = 0;
  Future<PythonConsoleResult> Function(String code) onPython = (_) async =>
      (logs: <String>[], error: null);

  @override
  Stream<String> get consoleMessages => messages.stream;

  @override
  Future<String> transpile(String code, {required String challengeId}) async {
    if (transpileError case final error?) {
      throw error;
    }
    return code;
  }

  @override
  Future<String?> evaluate(String code) {
    evaluateCalls++;
    return onEvaluate(code);
  }

  @override
  Future<PythonConsoleResult> runPythonConsole(String code) {
    pythonCalls++;
    return onPython(code);
  }

  @override
  Future<List<TestResult>> run({
    required String userCode,
    required String combinedCode,
    required String editableContents,
    required Hooks hooks,
    required List<ChallengeTest> tests,
    bool evaluateUserCode = false,
    void Function(String)? onConsole,
  }) async {
    runCalls++;
    if (evaluateUserCode && workerType == 'javascript') {
      final error = await evaluate(userCode);
      if (error != null) onConsole?.call(error);
    }
    return [];
  }
}

const _pyFile = ChallengeFile(
  ext: Ext.py,
  name: 'main',
  contents: '',
  fileKey: 'mainpy',
);

const _file = ChallengeFile(
  ext: Ext.js,
  name: 'script',
  contents: '',
  fileKey: 'scriptjs',
);

Challenge _challenge({int challengeType = 1}) => Challenge(
  id: 'challenge-id',
  block: 'block',
  superBlock: 'super-block',
  title: 'title',
  dashedName: 'dashed-name',
  challengeType: challengeType,
  challengeFiles: [challengeType == 27 ? _pyFile : _file],
);

class _Harness {
  _Harness({int challengeType = 1})
    : challenge = _challenge(challengeType: challengeType),
      runner = _FakeRunner(workerTypeOf(challengeType)) {
    container = ProviderContainer(
      overrides: [
        learnPrefsRepositoryProvider.overrideWithValue(_FakePrefs()),
        learnTestRunnerServiceProvider(
          runner.workerType,
        ).overrideWith((ref) async => runner),
      ],
    );
    container
      ..listen(editorChallengeProvider(challenge), (_, _) {})
      ..listen(learnTestRunnerServiceProvider(runner.workerType), (_, _) {});
  }

  final Challenge challenge;
  final _FakeRunner runner;
  late final ProviderContainer container;

  EditorChallengeNotifier get notifier =>
      container.read(editorChallengeProvider(challenge).notifier);

  EditorChallengeState get state =>
      container.read(editorChallengeProvider(challenge));

  void type(String text) =>
      unawaited(notifier.codeChanged(challenge.challengeFiles.first, text));

  void dispose() {
    container.dispose();
    unawaited(runner.messages.close());
  }
}

void _withHarness(
  void Function(_Harness harness, FakeAsync async) body, {
  int challengeType = 1,
  bool settleInitialRun = true,
}) {
  fakeAsync((async) {
    final harness = _Harness(challengeType: challengeType);
    if (settleInitialRun) {
      harness.state;
      async.elapse(const Duration(seconds: 1));
      harness.runner.evaluateCalls = 0;
    }
    body(harness, async);
    harness.dispose();
  });
}

void main() {
  group('EditorChallengeNotifier initial console run', () {
    test('should show console output of the seed code on open', () {
      _withHarness(settleInitialRun: false, (harness, async) {
        harness.runner.onEvaluate = (_) async {
          harness.runner.messages.add('seed');
          return null;
        };

        harness.state;
        async.elapse(const Duration(seconds: 2));

        expect(harness.state.userConsole, ['seed']);
      });
    });

    test('should hide a syntax error in the seed code', () {
      _withHarness(settleInitialRun: false, (harness, async) {
        harness.runner.transpileError = BabelException(
          'SyntaxError: Unexpected token (3:5)',
        );

        harness.state;
        async.elapse(const Duration(seconds: 2));

        expect(harness.state.userConsole, isEmpty);
        expect(harness.runner.evaluateCalls, 0);
      });
    });

    test('should keep seed output and hide its runtime error', () {
      _withHarness(settleInitialRun: false, (harness, async) {
        harness.runner.onEvaluate = (_) async {
          harness.runner.messages.add('before');
          return 'ReferenceError: x';
        };

        harness.state;
        async.elapse(const Duration(seconds: 2));

        expect(harness.state.userConsole, ['before']);
      });
    });

    test('should hide the timeout message for the seed code', () {
      _withHarness(settleInitialRun: false, (harness, async) {
        harness.runner.onEvaluate = (_) => Future.error(TimeoutException(null));

        harness.state;
        async.elapse(const Duration(seconds: 2));

        expect(harness.state.userConsole, isEmpty);
      });
    });

    test('should show errors again after the first edit', () {
      _withHarness(settleInitialRun: false, (harness, async) {
        harness.runner.onEvaluate = (_) async => 'ReferenceError: x';

        harness.state;
        async.elapse(const Duration(seconds: 2));
        harness.type('x');
        async.elapse(const Duration(seconds: 2));

        expect(harness.state.userConsole, ['ReferenceError: x']);
      });
    });
  });

  group('EditorChallengeNotifier console run', () {
    test('should not evaluate until typing pauses', () {
      _withHarness((harness, async) {
        harness.type('console.log(1)');
        async.elapse(const Duration(milliseconds: 600));
        expect(harness.runner.evaluateCalls, 0);

        async.elapse(const Duration(milliseconds: 200));
        expect(harness.runner.evaluateCalls, 1);
      });
    });

    test('should evaluate once for a burst of edits', () {
      _withHarness((harness, async) {
        harness.type('c');
        async.elapse(const Duration(milliseconds: 300));
        harness.type('co');
        async.elapse(const Duration(milliseconds: 300));
        harness.type('con');
        async.elapse(const Duration(seconds: 2));

        expect(harness.runner.evaluateCalls, 1);
      });
    });

    test('should keep whitespace in console output', () {
      _withHarness((harness, async) {
        harness.runner.onEvaluate = (_) async {
          harness.runner.messages.add('  padded <b>  ');
          return null;
        };

        harness.type('console.log("  padded <b>  ")');
        async.elapse(const Duration(seconds: 2));

        expect(harness.state.userConsole, ['  padded <b>  ']);
      });
    });

    test('should show console output without running tests', () {
      _withHarness((harness, async) {
        harness.runner.onEvaluate = (_) async {
          harness.runner.messages.add('foo');
          return null;
        };

        harness.type("console.log('foo')");
        async.elapse(const Duration(seconds: 2));

        expect(harness.state.userConsole, ['foo']);
        expect(harness.state.testResults, isNull);
        expect(harness.runner.runCalls, 0);
      });
    });

    test('should show a runtime error in the console', () {
      _withHarness((harness, async) {
        harness.runner.onEvaluate = (_) async => 'ReferenceError: x';

        harness.type('x');
        async.elapse(const Duration(seconds: 2));

        expect(harness.state.userConsole, ['ReferenceError: x']);
      });
    });

    test('should show the syntax error hint in the console', () {
      _withHarness((harness, async) {
        final error = BabelException('SyntaxError: Unexpected token (3:5)');
        harness.runner.transpileError = error;

        harness.type("console.log('foo'");
        async.elapse(const Duration(seconds: 2));

        expect(harness.state.userConsole, [syntaxErrorHint(error)]);
        expect(harness.runner.evaluateCalls, 0);
      });
    });

    test('should show a timeout message when the code never returns', () {
      _withHarness((harness, async) {
        harness.runner.onEvaluate = (_) => Future.error(TimeoutException(null));

        harness.type('while (true) {}');
        async.elapse(const Duration(seconds: 2));

        expect(harness.state.userConsole.single, contains('infinite loop'));
      });
    });

    test('should replace output from the previous run', () {
      _withHarness((harness, async) {
        harness.runner.onEvaluate = (code) async {
          harness.runner.messages.add(code);
          return null;
        };

        harness.type('first');
        async.elapse(const Duration(seconds: 2));
        harness.type('second');
        async.elapse(const Duration(seconds: 2));

        expect(harness.state.userConsole, ['second']);
      });
    });

    test('should not evaluate for non-JavaScript challenges', () {
      _withHarness(challengeType: 20, (harness, async) {
        harness.type('print(1)');
        async.elapse(const Duration(seconds: 2));

        expect(harness.runner.evaluateCalls, 0);
      });
    });

    test('should cancel a pending console run when the tests start', () {
      _withHarness((harness, async) {
        harness.type('console.log(1)');
        async.elapse(const Duration(milliseconds: 300));
        unawaited(harness.notifier.runTests());
        async.elapse(const Duration(seconds: 2));

        expect(harness.runner.runCalls, 1);
        expect(harness.runner.evaluateCalls, 1);
      });
    });
  });

  group('EditorChallengeNotifier python console', () {
    void withPython(void Function(_Harness harness, FakeAsync async) body) =>
        _withHarness(challengeType: 27, (harness, async) {
          harness.runner.pythonCalls = 0;
          body(harness, async);
        });

    test('should show print output after an edit', () {
      withPython((harness, async) {
        harness.runner.onPython = (_) async => (logs: ['a 1'], error: null);

        harness.type('print("a", 1)');
        async.elapse(const Duration(seconds: 1));

        expect(harness.state.userConsole, ['a 1']);
        expect(harness.runner.evaluateCalls, 0);
      });
    });

    test('should trim a traceback to the user frame', () {
      withPython((harness, async) {
        harness.runner.onPython = (_) async => (
          logs: ['before'],
          error:
              'Traceback (most recent call last):\n'
              '  File "/lib/_pyodide/_base.py", line 1, in eval_code\n'
              '  File "<exec>", line 3, in <module>\n'
              "NameError: name 'x' is not defined",
        );

        harness.type('x');
        async.elapse(const Duration(seconds: 1));

        expect(harness.state.userConsole, [
          'before',
          'File "<exec>", line 3, in <module>\n'
              "NameError: name 'x' is not defined",
        ]);
      });
    });

    test('should show the timeout message for a timed out worker', () {
      withPython((harness, async) {
        harness.runner.onPython = (_) async =>
            (logs: <String>[], error: 'Test timed out');

        harness.type('while True: pass');
        async.elapse(const Duration(seconds: 1));

        expect(harness.state.userConsole, [consoleTimeoutMessage]);
      });
    });

    test('should hide the error of the seed code', () {
      _withHarness(challengeType: 27, settleInitialRun: false, (
        harness,
        async,
      ) {
        harness.runner.onPython = (_) async =>
            (logs: ['seed'], error: 'NameError');

        harness.state;
        async.elapse(const Duration(seconds: 2));

        expect(harness.state.userConsole, ['seed']);
      });
    });
  });
}
