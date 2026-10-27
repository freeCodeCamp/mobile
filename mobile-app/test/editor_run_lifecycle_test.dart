import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/learn/models/challenge_file_model.dart';
import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/learn/repositories/prefs_repository.dart';
import 'package:freecodecamp/learn/services/code_service.dart';
import 'package:freecodecamp/learn/services/test_runner_service.dart';
import 'package:freecodecamp/learn/ui/editor_challenge/editor_challenge_viewmodel.dart';

const _file = ChallengeFile(
  ext: Ext.html,
  name: 'index',
  contents: '<h1>Original</h1>',
  fileKey: 'indexhtml',
);
const _challenge = Challenge(
  id: 'lifecycle-test',
  superBlock: 'responsive-web-design',
  block: 'test',
  title: 'Step 1',
  dashedName: 'step-1',
  challengeType: 0,
  challengeFiles: [_file],
  tests: [
    ChallengeTest(
      text: '<p>A heading is required.</p>',
      testString: 'hasHeading()',
    ),
  ],
);
final _provider = editorChallengeProvider(_challenge);

class _Prefs extends LearnPrefsRepository {
  final _values = <String, String>{};
  @override
  Future<String?> read(String key) async => _values[key];
  @override
  Future<void> write(String key, String value) async => _values[key] = value;
  @override
  Future<void> remove(String key) async => _values.remove(key);
}

class _Code extends LearnCodeService {
  _Code() : super(_Prefs());
  Completer<void>? resetPending;
  Completer<void>? codePending;
  bool userCodeRead = false;

  @override
  Future<String> userCode(Challenge challenge, Transpile transpile) async {
    userCodeRead = true;
    await codePending?.future;
    return super.userCode(challenge, transpile);
  }

  @override
  Future<void> reset(Challenge challenge) async {
    await resetPending?.future;
    await super.reset(challenge);
  }
}

class _Run {
  _Run(this.code);
  final String code;
  final result = Completer<List<TestResult>>();
}

class _Runner implements LearnTestRunnerService {
  final messages = StreamController<String>.broadcast(sync: true);
  final runs = <_Run>[];
  @override
  String get workerType => 'dom';
  @override
  Stream<String> get consoleMessages => messages.stream;
  @override
  Future<String> transpile(String code, {required String challengeId}) async =>
      code;
  @override
  Future<List<TestResult>> run({
    required String userCode,
    required String combinedCode,
    required String editableContents,
    required Hooks hooks,
    required List<ChallengeTest> tests,
  }) {
    final run = _Run(userCode);
    runs.add(run);
    return run.result.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Fixture {
  _Fixture({Future<LearnTestRunnerService> Function()? loadRunner}) {
    container = ProviderContainer(
      overrides: [
        learnCodeServiceProvider.overrideWithValue(code),
        learnTestRunnerServiceProvider.overrideWith(
          (ref, type) async => loadRunner == null ? runner : await loadRunner(),
        ),
      ],
    );
    subscription = container.listen(_provider, (_, _) {});
    notifier = container.read(_provider.notifier);
  }
  final runner = _Runner();
  final code = _Code();
  late final ProviderContainer container;
  late final ProviderSubscription<EditorChallengeState> subscription;
  late final EditorChallengeNotifier notifier;
  EditorChallengeState get state => container.read(_provider);
  bool disposed = false;
  void disposeContainer() {
    if (disposed) return;
    disposed = true;
    subscription.close();
    container.dispose();
  }

  Future<void> dispose() async {
    disposeContainer();
    await runner.messages.close();
  }
}

Future<void> _flush() => Future<void>.delayed(Duration.zero);
void _pass(_Run run) => run.result.complete([(pass: true, err: null)]);

void main() {
  test(
    'edited code discards pending results and late console messages',
    () async {
      final fixture = _Fixture();
      addTearDown(fixture.dispose);
      final pending = fixture.notifier.runTests();
      await _flush();
      expect(fixture.runner.runs, hasLength(1));
      fixture.runner.messages.add('before editing');
      expect(fixture.state.userConsole, ['<p>before editing</p>']);
      await fixture.notifier.codeChanged(_file, '<h2>Changed</h2>');
      fixture.runner.messages.add('stale result');
      _pass(fixture.runner.runs.single);
      await pending;
      expect(fixture.state.passed, isFalse);
      expect(fixture.state.testResults, isNull);
      expect(fixture.state.userConsole, isEmpty);
      expect(fixture.state.testConsole, isEmpty);
      expect(fixture.state.testsRunning, isFalse);
    },
  );

  test('reset drains the old native run before a new run can start', () async {
    final fixture = _Fixture();
    addTearDown(fixture.dispose);
    await fixture.notifier.codeChanged(_file, '<h2>Edited</h2>');
    final oldRun = fixture.notifier.runTests();
    await _flush();
    await fixture.notifier.reset();
    expect(fixture.state.resetCount, 1);
    expect(fixture.state.testsRunning, isTrue);
    await fixture.notifier.runTests();
    expect(fixture.runner.runs, hasLength(1));
    _pass(fixture.runner.runs.first);
    await oldRun;
    expect(fixture.state.passed, isFalse);
    expect(fixture.state.testResults, isNull);
    expect(fixture.state.testsRunning, isFalse);
    final newRun = fixture.notifier.runTests();
    await _flush();
    expect(fixture.runner.runs, hasLength(2));
    expect(fixture.state.testsRunning, isTrue);
    expect(fixture.runner.runs.last.code, contains(_file.contents));
    _pass(fixture.runner.runs.last);
    await newRun;
    expect(fixture.state.passed, isTrue);
    expect(fixture.state.testResults, [true]);
    expect(fixture.state.testsRunning, isFalse);
  });

  test(
    'runner startup is guarded before its first asynchronous result',
    () async {
      final ready = Completer<LearnTestRunnerService>();
      final fixture = _Fixture(loadRunner: () => ready.future);
      addTearDown(fixture.dispose);
      final pending = fixture.notifier.runTests();
      expect(fixture.state.testsRunning, isTrue);
      await fixture.notifier.runTests();
      ready.complete(fixture.runner);
      await _flush();
      expect(fixture.runner.runs, hasLength(1));
      _pass(fixture.runner.runs.single);
      await pending;
      expect(fixture.state.testsRunning, isFalse);
    },
  );

  test('an edit during code preparation avoids starting stale tests', () async {
    final fixture = _Fixture();
    addTearDown(fixture.dispose);
    fixture.code.codePending = Completer<void>();
    final pending = fixture.notifier.runTests();
    await _flush();
    expect(fixture.code.userCodeRead, isTrue);
    await fixture.notifier.codeChanged(_file, 'changed during preparation');
    fixture.code.codePending!.complete();
    await pending;
    expect(fixture.runner.runs, isEmpty);
    expect(fixture.state.testResults, isNull);
    expect(fixture.state.testsRunning, isFalse);
  });

  test('stale test failures do not overwrite reset state', () async {
    final fixture = _Fixture();
    addTearDown(fixture.dispose);
    final pending = fixture.notifier.runTests();
    await _flush();
    await fixture.notifier.reset();
    fixture.runner.runs.single.result.completeError(
      StateError('old run failed'),
    );
    await pending;
    expect(fixture.state.hint, isEmpty);
    expect(fixture.state.testConsole, isEmpty);
    expect(fixture.state.testResults, isNull);
    expect(fixture.state.testsRunning, isFalse);
  });

  test(
    'reset in progress prevents a run and clears earlier passing results',
    () async {
      final fixture = _Fixture();
      addTearDown(fixture.dispose);
      final first = fixture.notifier.runTests();
      await _flush();
      _pass(fixture.runner.runs.single);
      await first;
      expect(fixture.state.passed, isTrue);
      fixture.code.resetPending = Completer<void>();
      final reset = fixture.notifier.reset();
      expect(fixture.state.passed, isFalse);
      await fixture.notifier.runTests();
      expect(fixture.runner.runs, hasLength(1));
      fixture.code.resetPending!.complete();
      await reset;
      expect(fixture.state.testResults, isNull);
      expect(fixture.state.resetCount, 1);
    },
  );

  test('disposal during runner initialization never starts tests', () async {
    final ready = Completer<LearnTestRunnerService>();
    final fixture = _Fixture(loadRunner: () => ready.future);
    addTearDown(fixture.dispose);
    final pending = fixture.notifier.runTests();
    fixture.disposeContainer();
    ready.complete(fixture.runner);
    await pending;
    expect(fixture.runner.runs, isEmpty);
  });

  test('runner initialization failure releases the running guard', () async {
    final ready = Completer<LearnTestRunnerService>();
    final fixture = _Fixture(loadRunner: () => ready.future);
    addTearDown(fixture.dispose);
    final pending = fixture.notifier.runTests();
    final expectation = expectLater(pending, throwsStateError);
    ready.completeError(StateError('runner unavailable'));
    await expectation;
    expect(fixture.state.testsRunning, isFalse);
    expect(fixture.state.passed, isFalse);
  });
}
