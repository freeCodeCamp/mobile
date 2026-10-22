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
  LearnTestRunnerServiceProvider get _runner =>
      learnTestRunnerServiceProvider(workerTypeOf(challenge.challengeType));

  @override
  EditorChallengeState build(Challenge challenge) {
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

    state = state.copyWith(
      testsRunning: true,
      testConsole: ['<p>// running tests</p>'],
      userConsole: [],
      testResults: null,
    );
    final logs = runner.consoleMessages.listen((message) {
      if (!ref.mounted) return;
      state = state.copyWith(
        userConsole: [...state.userConsole, '<p>$message</p>'],
      );
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

      if (runner.workerType == 'javascript') {
        final error = await runner.evaluate(userCode);
        if (!ref.mounted) return;
        if (error != null) {
          state = state.copyWith(
            userConsole: [...state.userConsole, '<p>$error</p>'],
          );
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
        testConsole: [
          ...state.testConsole,
          if (failures.isNotEmpty)
            '<ol>${failures.map((f) => '<li>$f</li>').join()}</ol>',
          '<p>// tests completed</p>',
        ],
      );
    } catch (e, stack) {
      log('Editor: tests failed to run', error: e, stackTrace: stack);
      if (!ref.mounted) return;
      state = state.copyWith(
        testConsole: [
          ...state.testConsole,
          '<p>The tests could not run: ${const HtmlEscape().convert('$e')}</p>',
          '<p>// tests completed</p>',
        ],
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
