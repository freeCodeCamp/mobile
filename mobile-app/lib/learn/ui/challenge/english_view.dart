import 'package:flutter/material.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/learn/models/curriculum_model.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/answer_feedback.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/assignment_tile.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/challenge_button.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/challenge_card.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/challenge_layout.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/complete_button.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/html_card.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/parsed_html.dart';
import 'package:freecodecamp/learn/ui/widgets/scene/scene_view.dart';
import 'package:html/parser.dart';

const _wordStyle = TextStyle(fontSize: 20, height: 1.8, letterSpacing: 0);

String _plain(String html) => parseFragment(html).text ?? '';

class EnglishView extends StatefulWidget {
  const EnglishView({super.key, required this.challenge, required this.block});

  final Challenge challenge;
  final Block block;

  @override
  State<EnglishView> createState() => _EnglishViewState();
}

class _EnglishViewState extends State<EnglishView> {
  late final _blanks = widget.challenge.fillInTheBlank?.blanks ?? const [];
  late final _inputs = [for (final _ in _blanks) TextEditingController()];
  late final _assignments = List.filled(
    widget.challenge.assignments.length,
    false,
  );
  List<bool>? _results;

  bool get _allCorrect => _results?.every((r) => r) ?? false;

  @override
  void dispose() {
    for (final input in _inputs) {
      input.dispose();
    }
    super.dispose();
  }

  void _check() => setState(() {
    _results = [
      for (final (i, blank) in _blanks.indexed)
        _inputs[i].text.trim().toLowerCase() == blank.answer.toLowerCase(),
    ];
  });

  @override
  Widget build(BuildContext context) {
    final challenge = widget.challenge;
    final firstWrong = _results?.indexOf(false) ?? -1;
    final feedback = firstWrong == -1 ? '' : _blanks[firstWrong].feedback;
    final dialogue = challenge.challengeType == 21;
    // Fill-in-the-blank tasks carry their teaching note in description, while
    // some curriculum versions also provide a separate explanation.
    final explanation = {
      if (!dialogue) challenge.description.trim(),
      challenge.explanation.trim(),
    }.where((html) => html.isNotEmpty).join('\n');
    return Scaffold(
      appBar: challengeAppBar(
        context,
        title: challenge.title,
        subtitle: widget.block.name,
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            if (challenge.scene case final scene?)
              SceneView(scene: scene, title: challenge.title, edgeToEdge: true),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (dialogue && challenge.description.isNotEmpty)
                    ParsedHtml(challenge.description),
                  if (challenge.instructions.isNotEmpty)
                    ParsedHtml(challenge.instructions),
                  if (challenge.assignments.isNotEmpty)
                    ChallengeCard(
                      title: 'Assignments',
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
                  if (challenge.fillInTheBlank case final fill?) ...[
                    if (challenge.instructions.isNotEmpty)
                      const SizedBox(height: 12),
                    Text(
                      'Fill in the blank',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: FccDesignColors.of(context).accentText,
                      ),
                    ),
                    ..._sentences(fill.sentence),
                    const SizedBox(height: 24),
                  ],
                  if (_results != null)
                    AnswerFeedback(
                      correct: _allCorrect,
                      html: [_allCorrect ? explanation : feedback],
                      fallback: _allCorrect
                          ? null
                          : 'Check the highlighted words and try again.',
                      outlinedInlineCode: true,
                    ),
                  if (challenge.transcript.isNotEmpty)
                    HtmlCard(
                      title: 'Transcript',
                      html: challenge.transcript,
                      collapsible: !dialogue,
                    )
                  else if (dialogue && challenge.scene != null)
                    ChallengeCard(
                      title: 'Transcript',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final command in challenge.scene!.commands)
                            if (command.dialogue case final line?)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      command.character,
                                      style: TextStyle(
                                        color: FccDesignColors.of(
                                          context,
                                        ).accentText,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    ParsedHtml(line.text),
                                  ],
                                ),
                              ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ChallengeFooter(
        padding: const EdgeInsets.all(12),
        child: _blanks.isEmpty || _allCorrect
            ? CompleteButton(
                challenge: challenge,
                block: widget.block,
                label: dialogue
                    ? 'Start tasks'
                    : _blanks.isEmpty
                    ? 'Continue'
                    : 'Next lesson',
                buttonStyle: _buttonStyle,
                enabled: _assignments.every((done) => done),
              )
            : ChallengeButton(
                label: _results == null ? 'Check answer' : 'Check again',
                style: _buttonStyle,
                onPressed:
                    _inputs.every((input) => input.text.trim().isNotEmpty)
                    ? _check
                    : null,
              ),
      ),
    );
  }

  ButtonStyle get _buttonStyle => FilledButton.styleFrom(
    minimumSize: const Size(double.infinity, 50),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    textStyle: const TextStyle(
      fontFamily: 'Lato',
      fontSize: 17,
      fontWeight: FontWeight.w900,
    ),
  );

  // NOTE: A blank can be glued to the words around it ("BLANK," or "(BLANK)"), so each word splits on it.
  List<Widget> _sentences(String sentence) {
    var blank = 0;

    return [
      for (final line in sentence.split('\n'))
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Align(
            alignment: Alignment.topLeft,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 3,
              runSpacing: 3,
              children: [
                for (final word in line.split(' '))
                  if (word.contains('BLANK')) ...[
                    for (final (i, part) in word.split('BLANK').indexed) ...[
                      if (i > 0) _input(blank++),
                      if (part.isNotEmpty)
                        Text(_plain(part), style: _wordStyle),
                    ],
                  ] else
                    Text(_plain(word), style: _wordStyle),
              ],
            ),
          ),
        ),
    ];
  }

  Widget _input(int index) {
    if (index >= _inputs.length) return const Text('____', style: _wordStyle);
    final result = _results?[index];
    final design = FccDesignColors.of(context);
    final fill = switch (result) {
      null => null,
      true => design.successContainer,
      false => design.dangerContainer,
    };
    final border = UnderlineInputBorder(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      borderSide: switch (result) {
        null => BorderSide(
          width: 3,
          color: Theme.of(context).colorScheme.primary,
        ),
        true => BorderSide(
          width: 3,
          color: FccDesignColors.of(context).success,
        ),
        false => BorderSide(
          width: 3,
          color: Theme.of(context).colorScheme.error,
        ),
      },
    );
    final painter = TextPainter(
      text: TextSpan(text: '${_blanks[index].answer}mm', style: _wordStyle),
      textDirection: TextDirection.ltr,
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    final answerWidth = painter.width;
    painter.dispose();

    return Semantics(
      label: 'Blank ${index + 1}',
      child: Container(
        height: 44,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        width: (answerWidth + 24).clamp(
          64,
          MediaQuery.sizeOf(context).width - 48,
        ),
        child: TextField(
          controller: _inputs[index],
          onChanged: (_) => setState(() => _results = null),
          textInputAction: index == _inputs.length - 1
              ? TextInputAction.done
              : TextInputAction.next,
          cursorHeight: 22,
          autocorrect: false,
          smartQuotesType: SmartQuotesType.disabled,
          spellCheckConfiguration: const SpellCheckConfiguration.disabled(),
          style: _wordStyle.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            isDense: true,
            filled: fill != null,
            fillColor: fill,
            hintText: '…',
            isCollapsed: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            enabledBorder: border,
            focusedBorder: border,
          ),
        ),
      ),
    );
  }
}
