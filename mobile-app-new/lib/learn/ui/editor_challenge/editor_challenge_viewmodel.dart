import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile_app_new/learn/models/challenge_file_model.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/services/code_service.dart';
import 'package:mobile_app_new/learn/services/quote_service.dart';
import 'package:mobile_app_new/learn/services/test_runner_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'editor_challenge_viewmodel.freezed.dart';
part 'editor_challenge_viewmodel.g.dart';

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
    @Default([]) List<String> testConsole,
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

  @override
  EditorChallengeState build(Challenge challenge) {
    _codeRevision++;
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
    state = state.copyWith(
      passed: false,
      testResults: null,
      hint: '',
      testConsole: [],
      userConsole: [],
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
    if (_running || _resetting) return;
    _running = true;
    final revision = _codeRevision;
    bool isCurrent() => ref.mounted && revision == _codeRevision;
    StreamSubscription<String>? logs;
    var runnerReady = false;

    state = state.copyWith(
      testsRunning: true,
      passed: false,
      testConsole: ['<p>// running tests</p>'],
      userConsole: [],
      testResults: null,
    );
    try {
      final runner = await ref.read(_runner.future);
      if (!isCurrent()) return;
      runnerReady = true;
      final code = ref.read(learnCodeServiceProvider);
      logs = runner.consoleMessages.listen((message) {
        if (!isCurrent()) return;
        state = state.copyWith(
          userConsole: [
            ...state.userConsole,
            '<p>${const HtmlEscape().convert(message)}</p>',
          ],
        );
      });
      final String userCode;
      try {
        userCode = await code.userCode(
          challenge,
          (js) => runner.transpile(js, challengeId: challenge.id),
        );
      } on BabelException catch (e) {
        if (!isCurrent()) return;
        final hint = syntaxErrorHint(e);
        state = state.copyWith(
          panel: EditorPanel.hint,
          hint: '<p>$hint</p>',
          testConsole: [
            ...state.testConsole,
            '<p>$hint</p>',
            '<p>// tests completed</p>',
          ],
        );
        return;
      }
      if (!isCurrent()) return;

      if (runner.workerType == 'javascript') {
        final error = await runner.evaluate(userCode);
        if (!isCurrent()) return;
        if (error != null) {
          state = state.copyWith(
            userConsole: [
              ...state.userConsole,
              '<p>${const HtmlEscape().convert(error)}</p>',
            ],
          );
        }
      }

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
      );
      if (!isCurrent()) return;

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
        testConsole: [
          ...state.testConsole,
          if (failures.isNotEmpty)
            '<ol>${failures.map((f) => '<li>$f</li>').join()}</ol>',
          '<p>// tests completed</p>',
        ],
      );
    } catch (e, stack) {
      log('Editor: tests failed to run', error: e, stackTrace: stack);
      if (!isCurrent()) return;
      if (!runnerReady) rethrow;
      state = state.copyWith(
        testConsole: [
          ...state.testConsole,
          '<p>The tests could not run: ${const HtmlEscape().convert('$e')}</p>',
          '<p>// tests completed</p>',
        ],
      );
    } finally {
      try {
        await logs?.cancel();
      } finally {
        // Reset invalidates results, but the shared native runner still has to
        // finish before a new run can safely replace its working context.
        _running = false;
        if (ref.mounted) state = state.copyWith(testsRunning: false);
      }
    }
  }

  String _fillPlaceholders(String text, Map<dynamic, dynamic>? err) => text
      .replaceAll(
        '--fcc-expected--',
        const HtmlEscape().convert('${err?['expected'] ?? ''}'),
      )
      .replaceAll(
        '--fcc-actual--',
        const HtmlEscape().convert('${err?['actual'] ?? ''}'),
      );
}
