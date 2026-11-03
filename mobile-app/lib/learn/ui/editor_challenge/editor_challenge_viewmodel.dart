import 'dart:async';
import 'dart:convert';
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
const _timeoutMessage =
    'Your code took too long to run. Check for an infinite loop.';

enum EditorPanel { instruction, hint, pass }

enum EditorBody { editor, tests, preview, console }

@freezed
abstract class EditorChallengeState with _$EditorChallengeState {
  const factory EditorChallengeState({
    required ChallengeFile file,
    @Default(EditorPanel.instruction) EditorPanel panel,
    @Default(EditorBody.editor) EditorBody body,
    @Default(false) bool testsRunning,
    @Default(false) bool passed,
    @Default('') String hint,
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
  LearnTestRunnerServiceProvider get _runner =>
      learnTestRunnerServiceProvider(workerTypeOf(challenge.challengeType));

  Timer? _consoleTimer;
  int _consoleRun = 0;

  @override
  EditorChallengeState build(Challenge challenge) {
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
    if (state.passed) state = state.copyWith(passed: false);
    await ref.read(learnCodeServiceProvider).save(challenge, file, text);
    if (!ref.mounted) return;
    _scheduleConsole();
  }

  void _scheduleConsole({
    Duration delay = _consoleDebounce,
    bool showErrors = true,
  }) {
    if (workerTypeOf(challenge.challengeType) != 'javascript') return;
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
          state = state.copyWith(userConsole: [syntaxErrorHint(e)]);
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
        if (showErrors) output.add(_timeoutMessage);
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

  Future<void> reset() async {
    await ref.read(learnCodeServiceProvider).reset(challenge);
    if (!ref.mounted) return;
    state = EditorChallengeState(
      file: state.file,
      resetCount: state.resetCount + 1,
    );
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
    final runner = await ref.read(_runner.future);
    final code = ref.read(learnCodeServiceProvider);

    _consoleTimer?.cancel();
    _consoleRun++;
    state = state.copyWith(
      testsRunning: true,
      userConsole: [],
      testResults: null,
    );
    final logs = runner.consoleMessages.listen((message) {
      if (!ref.mounted) return;
      state = state.copyWith(userConsole: [...state.userConsole, message]);
    });

    try {
      final String userCode;
      try {
        userCode = await code.userCode(
          challenge,
          (js) => runner.transpile(js, challengeId: challenge.id),
        );
      } on BabelException catch (e) {
        if (!ref.mounted) return;
        final hint = syntaxErrorHint(e);
        state = state.copyWith(panel: EditorPanel.hint, hint: '<p>$hint</p>');
        return;
      }

      if (runner.workerType == 'javascript') {
        final error = await runner.evaluate(userCode);
        if (!ref.mounted) return;
        if (error != null) {
          state = state.copyWith(userConsole: [...state.userConsole, error]);
        }
      }

      final results = await runner.run(
        userCode: userCode,
        combinedCode: await code.combinedCode(challenge),
        editableContents: await code.editableContents(challenge),
        hooks: challenge.hooks,
        tests: challenge.tests,
      );
      if (!ref.mounted) return;

      final failures = [
        for (final (i, result) in results.indexed)
          if (!result.pass)
            _fillPlaceholders(challenge.tests[i].text, result.err),
      ];

      state = state.copyWith(
        testResults: [for (final result in results) result.pass],
        panel: failures.isEmpty ? EditorPanel.pass : EditorPanel.hint,
        passed: failures.isEmpty,
        hint: failures.firstOrNull ?? state.hint,
      );
    } catch (e, stack) {
      log('Editor: tests failed to run', error: e, stackTrace: stack);
      if (!ref.mounted) return;
      state = state.copyWith(
        panel: EditorPanel.hint,
        hint:
            '<p>The tests could not run: ${const HtmlEscape().convert('$e')}</p>',
      );
    } finally {
      await logs.cancel();
      if (ref.mounted) state = state.copyWith(testsRunning: false);
    }
  }

  String _fillPlaceholders(String text, Map<dynamic, dynamic>? err) => text
      .replaceAll('--fcc-expected--', '${err?['expected'] ?? ''}')
      .replaceAll('--fcc-actual--', '${err?['actual'] ?? ''}');
}
