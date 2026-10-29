import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/learn/models/curriculum_model.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/assignment_tile.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/challenge_button.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/challenge_card.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/challenge_layout.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/challenge_video.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/complete_button.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/example_editor.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/html_card.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/parsed_html.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/questions.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/review_content.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/task_explanation.dart';
import 'package:freecodecamp/learn/ui/widgets/learn_presentation.dart';
import 'package:freecodecamp/learn/ui/widgets/scene/scene_view.dart';
import 'package:freecodecamp/services/auth_service.dart';

class LessonView extends ConsumerStatefulWidget {
  const LessonView({super.key, required this.challenge, required this.block});
  final Challenge challenge;
  final Block block;
  @override
  ConsumerState<LessonView> createState() => _LessonViewState();
}

class _LessonViewState extends ConsumerState<LessonView> {
  late final _questions = widget.challenge.questions.map(questionItem).toList();
  late final _selected = List<int?>.filled(_questions.length, null);
  late final _checked = List.filled(_questions.length, false);
  late final _assignments = List.filled(
    widget.challenge.assignments.length,
    false,
  );
  final _scroll = ScrollController(keepScrollOffset: false);
  late final _review = ReviewController(widget.challenge.nodules)
    ..addListener(_onTopicChanged);
  void _onTopicChanged() {
    if (mounted) setState(() {});
  }

  int? _current;
  bool _reviewed = false;
  bool get _assignmentsDone => _assignments.every((done) => done);
  bool get _passed => _questions.indexed.every(
    (q) => _checked[q.$1] && _selected[q.$1] == q.$2.solution,
  );
  @override
  void dispose() {
    _review.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _show(int? index) {
    setState(() => _current = index);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _scroll.hasClients) _scroll.jumpTo(0);
    });
  }

  List<Widget> _reviewConfirmations() => [
    if (widget.challenge.assignments.isNotEmpty)
      for (final (i, assignment) in widget.challenge.assignments.indexed)
        AssignmentTile(
          label: assignment,
          value: _assignments[i],
          onToggle: () => setState(() => _assignments[i] = !_assignments[i]),
        )
    else
      CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text('I have reviewed these concepts'),
        value: _reviewed,
        onChanged: (value) => setState(() => _reviewed = value ?? false),
      ),
  ];

  @override
  Widget build(BuildContext context) {
    final challenge = widget.challenge;
    final completed = ref.watch(
      authProvider.select(
        (auth) =>
            auth.value?.completedChallenges.any((c) => c.id == challenge.id) ??
            false,
      ),
    );
    final colors = Theme.of(context).colorScheme;
    final current = _current;
    final review = challenge.challengeType == 31;
    final englishTask =
        challenge.challengeType == 19 &&
        widget.block.layout == BlockLayout.challengeDialogue;
    final taskExplanation = {
      challenge.description.trim(),
      challenge.explanation.trim(),
    }.where((html) => html.isNotEmpty).join('\n');
    final shortViewport = MediaQuery.sizeOf(context).height < 600;
    final index = widget.block.challenges.indexWhere(
      (c) => c.id == challenge.id,
    );
    final lectureColor = Color(
      Theme.of(context).brightness == Brightness.dark ? 0xFF8EC5FF : 0xFF1F6FD1,
    );
    final readingContent = <Widget>[
      if (!englishTask) ...[
        Text(
          challenge.title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
      ],
      if (challenge.videoId case final videoId?) ...[
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: ChallengeVideo(videoId: videoId),
        ),
        const SizedBox(height: 16),
      ],
      if (!englishTask && challenge.description.isNotEmpty)
        ParsedHtml(challenge.description),
      if (challenge.nodules.isNotEmpty)
        review
            ? ReviewContent(nodules: challenge.nodules, controller: _review)
            : ExampleEditor(nodules: challenge.nodules),
      if (challenge.transcript.isNotEmpty)
        HtmlCard(
          title: 'Transcript',
          html: challenge.transcript,
          collapsible: true,
        ),
      if (!englishTask && challenge.scene != null)
        SceneView(scene: challenge.scene!, title: challenge.title),
      if (challenge.instructions.isNotEmpty) ParsedHtml(challenge.instructions),
      if (challenge.assignments.isNotEmpty && !review)
        ChallengeCard(
          title: 'Before you continue',
          child: Column(
            children: [
              for (final (i, assignment) in challenge.assignments.indexed)
                AssignmentTile(
                  label: assignment,
                  value: _assignments[i],
                  onToggle: () =>
                      setState(() => _assignments[i] = !_assignments[i]),
                ),
            ],
          ),
        ),
      if (englishTask && taskExplanation.isNotEmpty)
        TaskExplanation(html: taskExplanation)
      else if (!englishTask && challenge.explanation.isNotEmpty)
        HtmlCard(
          title: 'Explanation',
          html: challenge.explanation,
          collapsible: true,
        ),
      if (review && shortViewport) ..._reviewConfirmations(),
    ];
    final scaffold = Scaffold(
      appBar: challengeAppBar(
        context,
        actions: [
          if (completed)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Tooltip(
                message: 'Lesson completed',
                child: LearnStatus(complete: true),
              ),
            ),
        ],
        leading: current == null
            ? null
            : BackButton(onPressed: () => _show(null)),
        title: englishTask ? challenge.title : widget.block.name,
        subtitle: current == null && englishTask
            ? widget.block.name
            : current == null && review && _review.topicCount > 0
            ? 'Topic ${_review.selected + 1} of ${_review.topicCount}'
            : current == null
            ? '${review
                  ? 'Review'
                  : widget.block.label == BlockLabel.lecture
                  ? 'Lecture'
                  : 'Lesson'} ${index + 1} of ${widget.block.challenges.length}'
            : 'Question ${current + 1} of ${_questions.length}',
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            if (current != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    // Keep short lectures compact; parent constraints shrink
                    // the row safely if a lesson has many questions.
                    width: _questions.length * 28 + (_questions.length - 1) * 6,
                    child: QuestionProgress(
                      total: _questions.length,
                      current: current,
                      answered: _checked,
                      height: 6,
                      spacing: 6,
                      currentColor: colors.secondary,
                      answeredColor: colors.primary,
                    ),
                  ),
                ),
              )
            else if (!englishTask)
              LinearProgressIndicator(
                value: widget.block.challenges.isEmpty
                    ? 0
                    : (index + 1) / widget.block.challenges.length,
                color: lectureColor,
                minHeight: 3,
              ),
            if (current == null && review && _review.topicCount > 0)
              ReviewTopics(controller: _review),
            Expanded(
              child: ListView(
                key: ValueKey(current),
                controller: _scroll,
                padding: englishTask && current == null
                    ? EdgeInsets.zero
                    : const EdgeInsets.all(16),
                children: [
                  if (current == null) ...[
                    if (englishTask && challenge.scene != null)
                      SceneView(
                        scene: challenge.scene!,
                        title: challenge.title,
                        edgeToEdge: true,
                      ),
                    if (englishTask)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: readingContent,
                        ),
                      )
                    else
                      ...readingContent,
                  ] else
                    Questions(
                      questions: _questions,
                      selected: _selected,
                      currentIndex: current,
                      validated: _checked[current],
                      outlinedFeedbackCode: englishTask,
                      onChanged: (question, answer) => setState(() {
                        _selected[question] = answer;
                        _checked[question] = false;
                      }),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ChallengeFooter(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (current != null && _questions.length > 1) ...[
              _questionNavigation(context, current),
              const SizedBox(height: 8),
            ],
            if (current == null && review && !shortViewport)
              ..._reviewConfirmations(),
            if (current == null && _questions.isNotEmpty)
              ChallengeButton(
                label: 'Continue to questions',
                style: _buttonStyle(context),
                onPressed: _assignmentsDone
                    ? () => _show(
                        _questions.indexed
                                .where(
                                  (q) =>
                                      !_checked[q.$1] ||
                                      _selected[q.$1] != q.$2.solution,
                                )
                                .firstOrNull
                                ?.$1 ??
                            0,
                      )
                    : null,
              )
            else if (current == null)
              CompleteButton(
                challenge: challenge,
                block: widget.block,
                label: 'Continue',
                buttonStyle: _buttonStyle(context),
                enabled:
                    _assignmentsDone &&
                    (!review || challenge.assignments.isNotEmpty || _reviewed),
              )
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  final lesson = ChallengeButton(
                    label: 'Lesson',
                    leadingIcon: CupertinoIcons.book,
                    style: _buttonStyle(context, secondary: true).merge(
                      FccTheme.surfaceButtonStyle(
                        context,
                        fill: colors.primaryContainer,
                        pressed: colors.surfaceContainer,
                        foreground: FccDesignColors.of(context).accentText,
                      ),
                    ),
                    onPressed: () => _show(null),
                  );
                  final checkAnswer = _passed
                      ? CompleteButton(
                          challenge: challenge,
                          block: widget.block,
                          label: 'Continue',
                          buttonStyle: _buttonStyle(context),
                          enabled: _assignmentsDone,
                        )
                      : ChallengeButton(
                          style: _buttonStyle(context),
                          label:
                              _checked[current] &&
                                  _selected[current] ==
                                      _questions[current].solution
                              ? 'Answer checked'
                              : _checked[current]
                              ? 'Pick another answer'
                              : 'Check answer',
                          onPressed:
                              _selected[current] == null || _checked[current]
                              ? null
                              : () => setState(() => _checked[current] = true),
                        );
                  if (constraints.maxWidth < 360 &&
                      MediaQuery.textScalerOf(context).scale(16) > 20) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        lesson,
                        const SizedBox(height: 8),
                        checkAnswer,
                      ],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: lesson),
                      const SizedBox(width: 8),
                      Expanded(flex: 2, child: checkAnswer),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
    return PopScope(
      canPop: current == null,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _current != null) _show(null);
      },
      child: scaffold,
    );
  }

  Widget _questionNavigation(BuildContext context, int current) =>
      LayoutBuilder(
        builder: (context, constraints) {
          final previous = ChallengeButton(
            label: 'Previous',
            secondary: true,
            style: _buttonStyle(context, secondary: true),
            onPressed: current == 0 ? null : () => _show(current - 1),
          );
          final next = ChallengeButton(
            label: 'Next question',
            secondary: true,
            style: _buttonStyle(context, secondary: true),
            trailingIcon: Icons.arrow_forward,
            onPressed: current == _questions.length - 1
                ? null
                : () => _show(current + 1),
          );
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

  ButtonStyle _buttonStyle(BuildContext context, {bool secondary = false}) =>
      FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        textStyle: TextStyle(
          fontFamily: 'Lato',
          fontSize: 17,
          fontWeight: secondary ? FontWeight.w700 : FontWeight.w900,
        ),
      );
}
