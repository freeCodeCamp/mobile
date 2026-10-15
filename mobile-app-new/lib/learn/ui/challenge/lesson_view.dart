import 'package:flutter/material.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/models/curriculum_model.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/challenge_card.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/challenge_layout.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/html_card.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/parsed_html.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/challenge_button.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/complete_button.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/assignment_tile.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/example_editor.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/challenge_video.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/help_dialog.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/questions.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/review_content.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/scene/scene_view.dart';

class LessonView extends StatefulWidget {
  const LessonView({super.key, required this.challenge, required this.block});
  final Challenge challenge;
  final Block block;
  @override
  State<LessonView> createState() => _LessonViewState();
}

class _LessonViewState extends State<LessonView> {
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
    final colors = Theme.of(context).colorScheme;
    final current = _current;
    final review = challenge.challengeType == 31;
    final shortViewport = MediaQuery.sizeOf(context).height < 600;
    final index = widget.block.challenges.indexWhere(
      (c) => c.id == challenge.id,
    );
    final lectureColor = Color(
      Theme.of(context).brightness == Brightness.dark ? 0xFF8EC5FF : 0xFF1F6FD1,
    );
    return Scaffold(
      appBar: challengeAppBar(
        context,
        title: widget.block.name,
        subtitle: current == null && review && _review.topicCount > 0
            ? 'Topic ${_review.selected + 1} of ${_review.topicCount}'
            : current == null
            ? '${review
                  ? 'Review'
                  : widget.block.label == BlockLabel.lecture
                  ? 'Lecture'
                  : 'Lesson'} ${index + 1} of ${widget.block.challenges.length}'
            : 'Question ${current + 1} of ${_questions.length}',
        actions: [
          if (![24, 31].contains(challenge.challengeType))
            IconButton(
              tooltip: 'Ask for help',
              icon: const Icon(Icons.help_outline),
              onPressed: () => showHelpDialog(context, challenge, widget.block),
            ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            if (current != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: QuestionProgress(
                  total: _questions.length,
                  current: current,
                  answered: _checked,
                ),
              )
            else
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
                padding: const EdgeInsets.all(16),
                children: [
                  if (current == null) ...[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Chip(
                          label: Text(
                            review
                                ? 'REVIEW'
                                : challenge.videoId != null
                                ? 'VIDEO'
                                : 'LECTURE',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: lectureColor,
                            ),
                          ),
                          backgroundColor: lectureColor.withValues(alpha: .1),
                          side: BorderSide.none,
                        ),
                        if (_questions.isNotEmpty)
                          Chip(
                            label: Text(
                              '${_questions.length} questions at the end',
                              style: const TextStyle(fontSize: 12),
                            ),
                            backgroundColor: colors.surfaceContainer,
                            side: BorderSide.none,
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      challenge.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    if (challenge.videoId case final videoId?) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: ChallengeVideo(videoId: videoId),
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (challenge.description.isNotEmpty)
                      ParsedHtml(challenge.description),
                    if (challenge.nodules.isNotEmpty)
                      review
                          ? ReviewContent(
                              nodules: challenge.nodules,
                              controller: _review,
                            )
                          : ExampleEditor(nodules: challenge.nodules),
                    if (challenge.transcript.isNotEmpty)
                      HtmlCard(
                        title: 'Transcript',
                        html: challenge.transcript,
                        collapsible: true,
                      ),
                    if (challenge.scene case final scene?)
                      SceneView(scene: scene, title: challenge.title),
                    if (challenge.instructions.isNotEmpty)
                      ParsedHtml(challenge.instructions),
                    if (challenge.assignments.isNotEmpty && !review)
                      ChallengeCard(
                        title: 'Before you continue',
                        child: Column(
                          children: [
                            for (final (i, assignment)
                                in challenge.assignments.indexed)
                              AssignmentTile(
                                label: assignment,
                                value: _assignments[i],
                                onToggle: () => setState(
                                  () => _assignments[i] = !_assignments[i],
                                ),
                              ),
                          ],
                        ),
                      ),
                    if (challenge.explanation.isNotEmpty)
                      HtmlCard(
                        title: 'Explanation',
                        html: challenge.explanation,
                        collapsible: true,
                      ),
                    if (review && shortViewport) ..._reviewConfirmations(),
                  ] else
                    Questions(
                      questions: _questions,
                      selected: _selected,
                      currentIndex: current,
                      validated: _checked[current],
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (current == null && review && !shortViewport)
              ..._reviewConfirmations(),
            if (current == null && _questions.isNotEmpty)
              ChallengeButton(
                label: 'Continue to questions',
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
                enabled:
                    _assignmentsDone &&
                    (!review || challenge.assignments.isNotEmpty || _reviewed),
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ChallengeButton(
                      label: 'Lesson',
                      secondary: true,
                      onPressed: () => _show(null),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: _passed
                        ? CompleteButton(
                            challenge: challenge,
                            block: widget.block,
                            label: 'Continue',
                            enabled: _assignmentsDone,
                          )
                        : ChallengeButton(
                            label:
                                _checked[current] &&
                                    _selected[current] ==
                                        _questions[current].solution
                                ? 'Next question'
                                : _checked[current]
                                ? 'Pick another answer'
                                : 'Check answer',
                            onPressed:
                                _selected[current] == null ||
                                    (_checked[current] &&
                                        _selected[current] !=
                                            _questions[current].solution)
                                ? null
                                : () {
                                    if (_checked[current]) {
                                      final next =
                                          List.generate(
                                            _questions.length,
                                            (i) =>
                                                (current + i + 1) %
                                                _questions.length,
                                          ).firstWhere(
                                            (i) =>
                                                !_checked[i] ||
                                                _selected[i] !=
                                                    _questions[i].solution,
                                          );
                                      _show(next);
                                    } else {
                                      setState(() => _checked[current] = true);
                                    }
                                  },
                          ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
