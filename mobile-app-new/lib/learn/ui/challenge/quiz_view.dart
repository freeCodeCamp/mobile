import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/models/curriculum_model.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/challenge_button.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/challenge_card.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/html_card.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/challenge_layout.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/complete_button.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/parsed_html.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/questions.dart';
import 'package:mobile_app_new/widgets/dialog/confirm_dialog.dart';

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
  final _scroll = ScrollController();
  int _current = 0;
  bool _validated = false;
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
    if (_scroll.hasClients) _scroll.jumpTo(0);
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
    final leave = await showConfirmDialog(
      context,
      title: 'Leave this quiz?',
      description:
          'Your answers will be lost. You can start the quiz again from the course.',
      confirmLabel: 'Leave',
      destructive: true,
    );
    if (leave && mounted) Navigator.of(context).pop();
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
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _leave();
      },
      child: Scaffold(
        appBar: challengeAppBar(
          context,
          title: challenge.title,
          subtitle: _validated
              ? 'Quiz results'
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
                icon: const Icon(Icons.grid_view_rounded),
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
                    current: _current,
                    answered: _selected.map((a) => a != null).toList(),
                  ),
                ),
              Expanded(
                child: ListView(
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
                        child: Chip(
                          backgroundColor: colors.surfaceContainer,
                          side: BorderSide.none,
                          label: Text(
                            'Pass with $_required of ${_questions.length} correct',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      if (_current == 0 && challenge.description.isNotEmpty)
                        HtmlCard(
                          title: 'About this quiz',
                          html: challenge.description,
                          collapsible: true,
                        ),
                      if (_current == 0 && challenge.instructions.isNotEmpty)
                        ParsedHtml(challenge.instructions),
                      const SizedBox(height: 12),
                      Questions(
                        questions: _questions,
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
                child: _validated
                    ? _passed
                          ? CompleteButton(
                              challenge: challenge,
                              block: widget.block,
                              label: 'Continue',
                            )
                          : ChallengeButton(
                              label: 'Try again',
                              onPressed: _reset,
                            )
                    : Row(
                        children: [
                          Expanded(
                            child: ChallengeButton(
                              label: 'Prev',
                              secondary: true,
                              onPressed: _current == 0
                                  ? null
                                  : () => _show(_current - 1),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ChallengeButton(
                              label: _current == _questions.length - 1
                                  ? 'Submit quiz'
                                  : 'Next question',
                              onPressed: _current == _questions.length - 1
                                  ? _check
                                  : () => _show(_current + 1),
                            ),
                          ),
                        ],
                      ),
              ),
      ),
    );
  }

  List<Widget> _results(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final success = FccDesignColors.of(context).success;
    final resultColor = _passed ? success : colors.error;
    return [
      Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: resultColor.withValues(alpha: .1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: resultColor.withValues(alpha: .3)),
        ),
        child: Column(
          children: [
            Icon(
              _passed ? Icons.check_circle_outline : Icons.refresh,
              color: resultColor,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              _passed ? 'You passed!' : 'Keep going!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '$_correct of ${_questions.length} correct',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: resultColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _passed
                  ? 'Well done. You’re ready for the next challenge.'
                  : 'You need $_required correct to pass. Review your answers and try again.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      Text(
        'Review your answers',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      const SizedBox(height: 16),
      for (final (i, q) in _questions.indexed)
        ChallengeCard(
          title: '',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _selected[i] == q.solution
                        ? Icons.check_circle_outline
                        : Icons.cancel_outlined,
                    color: _selected[i] == q.solution ? success : colors.error,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Question ${i + 1}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ParsedHtml(q.text),
              Text(
                'Your answer',
                style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12),
              ),
              ParsedHtml(q.answers[_selected[i]!].answer),
              if (_selected[i] != q.solution) ...[
                Text(
                  'Correct answer',
                  style: TextStyle(
                    color: success,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                ParsedHtml(q.answers[q.solution].answer),
              ],
            ],
          ),
        ),
    ];
  }
}
