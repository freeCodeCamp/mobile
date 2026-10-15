import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/models/curriculum_model.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/challenge_button.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/challenge_layout.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/complete_button.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/parsed_html.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/questions.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/quiz_leave_dialog.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/quiz_result_card.dart';

// NOTE: The quiz picks one of its question sets at random and shuffles each question's answers.
List<QuestionItem> _pickQuestions(List<Quiz> quizzes) {
  if (quizzes.isEmpty) return const [];

  final random = Random();
  final quiz = quizzes[random.nextInt(quizzes.length)];

  return [
    for (final q in quiz.questions)
      () {
        final answers = [
          for (final text in [...q.distractors, q.answer]) Answer(answer: text),
        ]..shuffle(random);

        return (
          text: q.text,
          answers: answers,
          solution: answers.indexWhere((a) => a.answer == q.answer),
          audioData: q.audioData,
        );
      }(),
  ];
}

class QuizView extends StatefulWidget {
  const QuizView({super.key, required this.challenge, required this.block});

  final Challenge challenge;
  final Block block;

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  static const _passRate = .9;
  late final _questions = _pickQuestions(widget.challenge.quizzes);
  late List<int?> _selected = List.filled(_questions.length, null);
  final _scroll = ScrollController(keepScrollOffset: false);
  int _current = 0;
  bool _validated = false;
  bool _leaveDialogOpen = false;
  bool _allowLeave = false;
  int get _correct =>
      _questions.indexed.where((q) => _selected[q.$1] == q.$2.solution).length;
  int get _required => (_questions.length * _passRate).ceil();
  bool get _passed =>
      _validated && _questions.isNotEmpty && _correct >= _required;
  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _top() {
    // Changing questions or replacing the quiz with its results can change
    // sliver geometry. Reset after that layout so scroll correction cannot
    // leave the score or the next question above the viewport.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _scroll.hasClients) _scroll.jumpTo(0);
    });
  }

  void _show(int index) {
    setState(() => _current = index);
    _top();
  }

  void _check() {
    final unanswered = _selected.indexOf(null);
    if (unanswered != -1) {
      _show(unanswered);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Answer every question before submitting.'),
        ),
      );
      return;
    }
    setState(() => _validated = true);
    _top();
  }

  void _reset() {
    setState(() {
      _selected = List.filled(_questions.length, null);
      _validated = false;
      _current = 0;
    });
    _top();
  }

  Future<void> _leave() async {
    if (_leaveDialogOpen) return;
    _leaveDialogOpen = true;
    final leave = await showQuizLeaveDialog(
      context,
      answered: _selected.whereType<int>().length,
      total: _questions.length,
    );
    _leaveDialogOpen = false;
    if (!leave || !mounted) return;
    setState(() => _allowLeave = true);
    await WidgetsBinding.instance.endOfFrame;
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _jump() async {
    final colors = Theme.of(context).colorScheme;
    final index = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your questions',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text('Choose a question to review your answer.'),
              const SizedBox(height: 20),
              Flexible(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (var i = 0; i < _questions.length; i++)
                        SizedBox(
                          width: 52,
                          height: 48,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: _selected[i] != null
                                  ? colors.primaryContainer
                                  : colors.surface,
                              side: BorderSide(
                                color: i == _current
                                    ? colors.primary
                                    : colors.outlineVariant,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () => Navigator.of(context).pop(i),
                            child: Text('${i + 1}'),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (index != null && mounted) _show(index);
  }

  @override
  Widget build(BuildContext context) {
    final challenge = widget.challenge;
    final colors = Theme.of(context).colorScheme;
    return PopScope(
      canPop: _allowLeave,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _leave();
      },
      child: Scaffold(
        appBar: challengeAppBar(
          context,
          title: challenge.title,
          subtitle: _validated
              ? 'Results'
              : _questions.isEmpty
              ? 'Quiz'
              : 'Question ${_current + 1} of ${_questions.length} · ${_selected.whereType<int>().length} answered',
          leading: IconButton(
            tooltip: 'Leave quiz',
            icon: const Icon(Icons.close),
            onPressed: _leave,
          ),
          actions: [
            if (!_validated && _questions.isNotEmpty)
              IconButton(
                tooltip: 'All questions',
                icon: const Icon(Icons.grid_view_outlined),
                onPressed: _jump,
              ),
          ],
        ),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              if (!_validated && _questions.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: QuestionProgress(
                    total: _questions.length,
                    height: 6,
                    spacing: 3,
                    currentColor: colors.secondary,
                    answeredColor: colors.primary,
                    current: _current,
                    answered: _selected.map((a) => a != null).toList(),
                  ),
                ),
              Expanded(
                child: ListView(
                  key: ValueKey((_validated, _current)),
                  controller: _scroll,
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (_questions.isEmpty)
                      const Text(
                        'This quiz has no questions available. Please return to the course and try again later.',
                      )
                    else if (_validated)
                      ..._results(context)
                    else ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colors.surfaceContainer,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: colors.outlineVariant,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            'Pass with $_required of ${_questions.length} correct',
                            style: TextStyle(
                              fontSize: 14,
                              color: colors.onSurfaceVariant,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ),
                      if (_current == 0 && challenge.instructions.isNotEmpty)
                        ParsedHtml(challenge.instructions),
                      const SizedBox(height: 12),
                      Questions(
                        questions: _questions,
                        plainCodeBlocks: true,
                        selected: _selected,
                        currentIndex: _current,
                        validated: false,
                        onChanged: (q, a) => setState(() => _selected[q] = a),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'You’ll see which answers were right after you submit the whole quiz.',
                        style: TextStyle(
                          color: colors.onSurfaceVariant,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _questions.isEmpty
            ? null
            : ChallengeFooter(
                padding: const EdgeInsets.all(12),
                child: _validated
                    ? _passed
                          ? CompleteButton(
                              challenge: challenge,
                              block: widget.block,
                              label: 'Continue',
                              buttonStyle: _buttonStyle(context),
                            )
                          : ChallengeButton(
                              label: 'Try again',
                              style: _buttonStyle(context),
                              onPressed: _reset,
                            )
                    : _navigation(context),
              ),
      ),
    );
  }

  List<Widget> _results(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final success = FccDesignColors.of(context).success;
    return [
      QuizResultCard(
        passed: _passed,
        correct: _correct,
        total: _questions.length,
        requiredCorrect: _required,
      ),
      const SizedBox(height: 20),
      Text(
        'Review your answers',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 16),
      Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            for (final (i, q) in _questions.indexed) ...[
              if (i > 0) const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      label: _selected[i] == q.solution
                          ? 'Correct answer'
                          : 'Incorrect answer',
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: _selected[i] == q.solution
                            ? const Color(0xFF1E7F46)
                            : const Color(0xFFD6245A),
                        child: Icon(
                          _selected[i] == q.solution
                              ? Icons.check
                              : Icons.close,
                          color: const Color(0xFFFFF8EC),
                          size: 17,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Question ${i + 1}',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 12,
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          _resultHtml(q.text),
                          if (_selected[i] != q.solution) ...[
                            const SizedBox(height: 8),
                            _resultHtml(
                              '<span>Your answer: </span>${q.answers[_selected[i]!].answer}',
                              color: colors.error,
                              inline: true,
                            ),
                            const SizedBox(height: 4),
                            _resultHtml(
                              '<span>Correct answer: </span>${q.answers[q.solution].answer}',
                              color: success,
                              weight: FontWeight.w700,
                              inline: true,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    ];
  }

  ButtonStyle _buttonStyle(BuildContext context, {bool secondary = false}) =>
      FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        textStyle: const TextStyle(
          fontFamily: 'Lato',
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: secondary
            ? BorderSide(color: Theme.of(context).colorScheme.outlineVariant)
            : BorderSide.none,
      );

  Widget _navigation(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final previous = ChallengeButton(
        label: 'Previous',
        secondary: true,
        style: _buttonStyle(context, secondary: true),
        onPressed: _current == 0 ? null : () => _show(_current - 1),
      );
      final next = ChallengeButton(
        label: _current == _questions.length - 1
            ? 'Submit quiz'
            : 'Next question',
        style: _buttonStyle(context),
        trailingIcon: _current == _questions.length - 1
            ? null
            : Icons.arrow_forward,
        onPressed: _current == _questions.length - 1
            ? _check
            : () => _show(_current + 1),
      );
      // Keep full labels at enlarged text sizes without squeezing either action.
      if (constraints.maxWidth < 360 &&
          MediaQuery.textScalerOf(context).scale(16) > 20) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [previous, const SizedBox(height: 8), next],
        );
      }
      return Row(
        children: [
          Expanded(child: previous),
          const SizedBox(width: 8),
          Expanded(flex: 2, child: next),
        ],
      );
    },
  );

  Widget _resultHtml(
    String html, {
    Color? color,
    FontWeight? weight,
    bool inline = false,
  }) => ParsedHtml(
    html,
    plainCodeBlocks: true,
    customStyles: {
      '*': Style(
        color: color,
        fontSize: FontSize(16),
        fontWeight: weight,
        lineHeight: const LineHeight(1.4),
      ),
      'p': Style(
        margin: Margins.zero,
        display: inline ? Display.inline : Display.block,
      ),
      'div': Style(
        margin: Margins.zero,
        display: inline ? Display.inline : Display.block,
      ),
    },
  );
}
