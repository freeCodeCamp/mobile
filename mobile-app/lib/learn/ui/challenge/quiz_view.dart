import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/learn/models/curriculum_model.dart';
import 'package:freecodecamp/learn/ui/challenge/quiz_viewmodel.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/challenge_button.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/challenge_layout.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/complete_button.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/parsed_html.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/questions.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/quiz_leave_dialog.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/quiz_result_card.dart';
import 'package:freecodecamp/learn/ui/widgets/learn_presentation.dart';
import 'package:freecodecamp/services/auth_service.dart';

class QuizView extends ConsumerStatefulWidget {
  const QuizView({super.key, required this.challenge, required this.block});

  final Challenge challenge;
  final Block block;

  @override
  ConsumerState<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends ConsumerState<QuizView> {
  final _scroll = ScrollController(keepScrollOffset: false);
  bool _leaveDialogOpen = false;
  bool _allowLeave = false;

  QuizNotifierProvider get _provider => quizProvider(widget.challenge);

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
    ref.read(_provider.notifier).show(index);
    _top();
  }

  void _check() {
    final submitted = ref.read(_provider.notifier).submit();
    _top();
    if (!submitted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Answer every question before submitting.'),
        ),
      );
    }
  }

  void _reset() {
    ref.read(_provider.notifier).reset();
    _top();
  }

  Future<void> _leave() async {
    if (_leaveDialogOpen) return;
    _leaveDialogOpen = true;
    final quiz = ref.read(_provider);
    final leave = await showQuizLeaveDialog(
      context,
      answered: quiz.answered,
      total: quiz.questions.length,
    );
    _leaveDialogOpen = false;
    if (!leave || !mounted) return;
    setState(() => _allowLeave = true);
    await WidgetsBinding.instance.endOfFrame;
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _jump() async {
    final quiz = ref.read(_provider);
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
                      for (var i = 0; i < quiz.questions.length; i++)
                        SizedBox(
                          width: 52,
                          height: 48,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () => Navigator.of(context).pop(i),
                            child: Semantics(
                              selected: i == quiz.current,
                              label:
                                  'Question ${i + 1}${quiz.selected[i] != null ? ', answered' : ''}',
                              excludeSemantics: true,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (quiz.selected[i] != null) ...[
                                    const Icon(Icons.check, size: 14),
                                    const SizedBox(width: 4),
                                  ],
                                  Text('${i + 1}'),
                                ],
                              ),
                            ),
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
    final quiz = ref.watch(_provider);
    final colors = Theme.of(context).colorScheme;
    final completed = ref.watch(
      authProvider.select(
        (auth) =>
            auth.value?.completedChallenges.any((c) => c.id == challenge.id) ??
            false,
      ),
    );
    return PopScope(
      canPop: _allowLeave,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _leave();
      },
      child: Scaffold(
        appBar: challengeAppBar(
          context,
          title: challenge.title,
          subtitle: quiz.validated
              ? 'Results'
              : quiz.questions.isEmpty
              ? 'Quiz'
              : 'Question ${quiz.current + 1} of ${quiz.questions.length} · ${quiz.answered} answered',
          leading: IconButton(
            tooltip: 'Leave quiz',
            icon: const Icon(Icons.close),
            onPressed: _leave,
          ),
          actions: [
            if (completed)
              const Padding(
                padding: EdgeInsets.all(12),
                child: Tooltip(
                  message: 'Quiz completed',
                  child: SizedBox.square(
                    dimension: 20,
                    child: FittedBox(child: LearnStatus(complete: true)),
                  ),
                ),
              ),
            if (!quiz.validated && quiz.questions.isNotEmpty)
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
              if (!quiz.validated && quiz.questions.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: QuestionProgress(
                    total: quiz.questions.length,
                    height: 6,
                    spacing: 3,
                    currentColor: colors.secondary,
                    answeredColor: colors.primary,
                    current: quiz.current,
                    answered: quiz.selected.map((a) => a != null).toList(),
                  ),
                ),
              Expanded(
                child: ListView(
                  key: ValueKey((quiz.validated, quiz.current)),
                  controller: _scroll,
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (quiz.questions.isEmpty)
                      const Text(
                        'This quiz has no questions available. Please return to the course and try again later.',
                      )
                    else if (quiz.validated)
                      ..._results(context, quiz)
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
                            'Pass with ${quiz.requiredCorrect} of ${quiz.questions.length} correct',
                            style: TextStyle(
                              fontSize: 14,
                              color: colors.onSurfaceVariant,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ),
                      if (quiz.current == 0 &&
                          challenge.instructions.isNotEmpty)
                        ParsedHtml(challenge.instructions),
                      const SizedBox(height: 12),
                      Questions(
                        questions: quiz.questions,
                        plainCodeBlocks: true,
                        selected: quiz.selected,
                        currentIndex: quiz.current,
                        validated: false,
                        onChanged: ref.read(_provider.notifier).select,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: quiz.questions.isEmpty
            ? null
            : ChallengeFooter(
                padding: const EdgeInsets.all(12),
                child: quiz.validated
                    ? quiz.passed
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
                    : _navigation(context, quiz),
              ),
      ),
    );
  }

  List<Widget> _results(BuildContext context, QuizState quiz) {
    final colors = Theme.of(context).colorScheme;
    final success = FccDesignColors.of(context).success;
    return [
      QuizResultCard(
        passed: quiz.passed,
        correct: quiz.correct,
        total: quiz.questions.length,
        requiredCorrect: quiz.requiredCorrect,
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
            for (final (i, q) in quiz.questions.indexed) ...[
              if (i > 0) const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      label: quiz.results[i]
                          ? 'Correct answer'
                          : 'Incorrect answer',
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: quiz.results[i]
                            ? success
                            : colors.error,
                        child: Icon(
                          quiz.results[i] ? Icons.check : Icons.close,
                          color: colors.surface,
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
                              fontSize: 13,
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          _resultHtml(q.text),
                          if (!quiz.results[i]) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Your answer:',
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.4,
                                color: colors.error,
                              ),
                            ),
                            const SizedBox(height: 4),
                            _resultHtml(
                              q.answers[quiz.selected[i]!].answer,
                              color: colors.error,
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
        textStyle: TextStyle(
          fontFamily: 'Lato',
          fontSize: 17,
          fontWeight: secondary ? FontWeight.w700 : FontWeight.w900,
        ),
      );

  Widget _navigation(BuildContext context, QuizState quiz) => LayoutBuilder(
    builder: (context, constraints) {
      final previous = ChallengeButton(
        label: 'Previous',
        secondary: true,
        style: _buttonStyle(context, secondary: true),
        onPressed: quiz.current == 0 ? null : () => _show(quiz.current - 1),
      );
      final next = ChallengeButton(
        label: quiz.current == quiz.questions.length - 1
            ? 'Submit quiz'
            : 'Next question',
        style: _buttonStyle(context),
        trailingIcon: quiz.current == quiz.questions.length - 1
            ? null
            : Icons.arrow_forward,
        onPressed: quiz.current == quiz.questions.length - 1
            ? _check
            : () => _show(quiz.current + 1),
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

  Widget _resultHtml(String html, {Color? color, FontWeight? weight}) =>
      ParsedHtml(
        html,
        plainCodeBlocks: true,
        customStyles: {
          '*': Style(
            color: color,
            fontSize: FontSize(16),
            fontWeight: weight,
            lineHeight: const LineHeight(1.4),
          ),
          'p': Style(margin: Margins.zero),
          'div': Style(margin: Margins.zero),
        },
      );
}
