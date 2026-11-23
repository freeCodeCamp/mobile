import 'dart:async';
import 'dart:developer';

import 'package:freecodecamp/learn/models/challenge_file_model.dart';
import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/learn/services/code_service.dart';
import 'package:freecodecamp/learn/services/quote_service.dart';
import 'package:freecodecamp/learn/services/test_runner_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'editor_challenge_viewmodel.freezed.dart';
part 'editor_challenge_viewmodel.g.dart';

const _consoleDebounce = Duration(milliseconds: 700);
// NOTE: A timed-out evaluate leaves the runner webview hung, so the runner is discarded.
const _consoleTimeout = Duration(seconds: 5);
// NOTE: The webview reports console output asynchronously, so wait briefly after evaluate returns.
const _consoleSettle = Duration(milliseconds: 100);
// NOTE: The Python worker enforces its own 5s test timeout, so this only guards a runner that never answers.
const _pythonConsoleTimeout = Duration(seconds: 30);

enum EditorPanel { instruction, pass }

enum EditorBody { editor, tests, preview, console }

@freezed
abstract class EditorChallengeState with _$EditorChallengeState {
  const factory EditorChallengeState({
    required ChallengeFile file,
    @Default(EditorPanel.instruction) EditorPanel panel,
    @Default(EditorBody.editor) EditorBody body,
    @Default(false) bool testsRunning,
    @Default(false) bool passed,
    @Default([]) List<String> userConsole,
    // NOTE: Null until a run reaches the tests.
    List<bool>? testResults,
    // NOTE: Bumped on reset so the view rebuilds its editor from the original code.
    @Default(0) int resetCount,
  }) = _EditorChallengeState;
}

@riverpod
Future<MotivationalQuote> passQuote(Ref ref) =>
    ref.watch(learnQuoteServiceProvider).getRandomQuote();

@riverpod
class EditorChallengeNotifier extends _$EditorChallengeNotifier {
  int _codeRevision = 0;
  bool _running = false;
  bool _resetting = false;

  LearnTestRunnerServiceProvider get _runner =>
      learnTestRunnerServiceProvider(workerTypeOf(challenge.challengeType));

  Timer? _consoleTimer;
  int _consoleRun = 0;

  @override
  EditorChallengeState build(Challenge challenge) {
    _codeRevision++;
    ref
        .watch(learnTestRunnerSessionProvider(challenge.id))
        .retain(workerTypeOf(challenge.challengeType));
    ref.onDispose(() => _consoleTimer?.cancel());
    _scheduleConsole(delay: Duration.zero, showErrors: false);
    final files = challenge.challengeFiles;
    return EditorChallengeState(
      file:
          files
              .where((f) => f.editableRegionBoundaries.isNotEmpty)
              .firstOrNull ??
          files.first,
    );
  }

  void selectFile(ChallengeFile file) =>
      state = state.copyWith(file: file, body: EditorBody.editor);

  void showBody(EditorBody body) => state = state.copyWith(
    body: state.body == body ? EditorBody.editor : body,
  );

  void showPanel(EditorPanel panel) => state = state.copyWith(panel: panel);

  Future<void> codeChanged(ChallengeFile file, String text) async {
    _invalidateResults();
    await ref.read(learnCodeServiceProvider).save(challenge, file, text);
    if (!ref.mounted) return;
    _scheduleConsole();
  }

  void _scheduleConsole({
    Duration delay = _consoleDebounce,
    bool showErrors = true,
  }) {
    if (workerTypeOf(challenge.challengeType) == 'dom') return;
    _consoleTimer?.cancel();
    _consoleTimer = Timer(delay, () => runConsole(showErrors: showErrors));
  }

  bool _isCurrentConsoleRun(int run) =>
      ref.mounted && run == _consoleRun && !state.testsRunning;

  // NOTE: The seed code runs without errors, since it is often incomplete on purpose.
  Future<void> runConsole({bool showErrors = true}) async {
    final run = ++_consoleRun;
    if (state.testsRunning) return;

    try {
      final runner = await ref.read(_runner.future);
      if (runner.workerType == 'python') {
        await _runPythonConsole(runner, run, showErrors);
        return;
      }
      final String userCode;
      try {
        userCode = await ref
            .read(learnCodeServiceProvider)
            .userCode(
              challenge,
              (js) => runner.transpile(js, challengeId: challenge.id),
            );
      } on BabelException catch (e) {
        if (showErrors && _isCurrentConsoleRun(run)) {
          state = state.copyWith(userConsole: [syntaxErrorMessage(e)]);
        }
        return;
      }
      if (!_isCurrentConsoleRun(run)) return;

      final output = <String>[];
      final logs = runner.consoleMessages.listen(output.add);
      try {
        final error = await runner.evaluate(userCode).timeout(_consoleTimeout);
        await Future<void>.delayed(_consoleSettle);
        if (showErrors && error != null) output.add(error);
      } on TimeoutException {
        if (showErrors) output.add(consoleTimeoutMessage);
        ref.invalidate(_runner);
      } finally {
        unawaited(logs.cancel());
      }

      if (!_isCurrentConsoleRun(run)) return;
      state = state.copyWith(userConsole: output);
    } catch (e, stack) {
      log('Editor: console failed to run', error: e, stackTrace: stack);
    }
  }

  Future<void> _runPythonConsole(
    LearnTestRunnerService runner,
    int run,
    bool showErrors,
  ) async {
    final userCode = await ref
        .read(learnCodeServiceProvider)
        .userCode(challenge, (code) async => code);
    if (!_isCurrentConsoleRun(run)) return;

    final output = <String>[];
    try {
      final result = await runner
          .runPythonConsole(userCode)
          .timeout(_pythonConsoleTimeout);
      output.addAll(result.logs);
      if (showErrors && result.error != null) {
        output.add(pythonErrorHint(result.error!));
      }
    } on TimeoutException {
      if (showErrors) output.add(consoleTimeoutMessage);
      ref.invalidate(_runner);
    }

    if (!_isCurrentConsoleRun(run)) return;
    state = state.copyWith(userConsole: output);
  }

  Future<void> reset() async {
    if (_resetting) return;
    _resetting = true;
    _invalidateResults();
    try {
      await ref.read(learnCodeServiceProvider).reset(challenge);
      if (!ref.mounted) return;
      state = EditorChallengeState(
        file: state.file,
        testsRunning: _running,
        resetCount: state.resetCount + 1,
      );
    } finally {
      _resetting = false;
    }
  }

  void _invalidateResults() {
    _codeRevision++;
    state = state.copyWith(passed: false, testResults: null, userConsole: []);
  }

  Future<String> previewHtml() async {
    final runner = await ref.read(_runner.future);
    return ref
        .read(learnCodeServiceProvider)
        .previewHtml(
          challenge,
          (js) => runner.transpile(js, challengeId: challenge.id),
        );
  }

  Future<void> runTests() async {
    if (_running || _resetting) return;
    final link = ref.keepAlive();
    _running = true;
    final revision = _codeRevision;
    bool isCurrent() => ref.mounted && revision == _codeRevision;
    var runnerReady = false;

    _consoleTimer?.cancel();
    _consoleRun++;
    state = state.copyWith(
      testsRunning: true,
      passed: false,
      userConsole: [],
      testResults: null,
    );
    try {
      final runner = await ref.read(_runner.future);
      if (!isCurrent()) return;
      runnerReady = true;
      final code = ref.read(learnCodeServiceProvider);
      final String userCode;
      try {
        userCode = await code.userCode(
          challenge,
          (js) => runner.transpile(js, challengeId: challenge.id),
        );
      } on BabelException catch (e) {
        if (!isCurrent()) return;
        state = state.copyWith(userConsole: [syntaxErrorMessage(e)]);
        return;
      }
      if (!isCurrent()) return;

      final combinedCode = await code.combinedCode(challenge);
      if (!isCurrent()) return;
      final editableContents = await code.editableContents(challenge);
      if (!isCurrent()) return;
      final results = await runner.run(
        userCode: userCode,
        combinedCode: combinedCode,
        editableContents: editableContents,
        hooks: challenge.hooks,
        tests: challenge.tests,
        evaluateUserCode: true,
        onConsole: (message) {
          if (!isCurrent()) return;
          state = state.copyWith(userConsole: [...state.userConsole, message]);
        },
      );
      if (!isCurrent()) return;

      final passed = results.every((result) => result.pass);
      state = state.copyWith(
        testResults: [for (final result in results) result.pass],
        panel: passed ? EditorPanel.pass : EditorPanel.instruction,
        passed: passed,
      );
    } catch (e, stack) {
      log('Editor: tests failed to run', error: e, stackTrace: stack);
      if (!isCurrent()) return;
      if (!runnerReady) rethrow;
      state = state.copyWith(userConsole: ['The tests could not run: $e']);
    } finally {
      try {
        _running = false;
        if (ref.mounted) state = state.copyWith(testsRunning: false);
      } finally {
        link.close();
      }
    }
  }
}
