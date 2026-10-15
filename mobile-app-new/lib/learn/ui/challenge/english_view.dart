import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/models/curriculum_model.dart';
import 'package:mobile_app_new/learn/ui/challenge/challenge_viewmodel.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/assignment_tile.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/challenge_button.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/challenge_card.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/complete_button.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/help_dialog.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/html_card.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/parsed_html.dart';
import 'package:mobile_app_new/learn/ui/widgets/scene/scene_view.dart';

const _wordStyle = TextStyle(fontSize: 20, letterSpacing: 0);

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
    final gray = {
      '*:not(h1):not(h2):not(h3):not(h4):not(h5):not(h6)': Style(
        color: FccColors.gray05,
      ),
    };
    final results = _results;
    final firstWrong = results?.indexOf(false) ?? -1;
    final feedback = firstWrong == -1 ? '' : _blanks[firstWrong].feedback;

    return Scaffold(
      backgroundColor: FccColors.gray90,
      appBar: AppBar(
        backgroundColor: FccColors.gray90,
        title: Text(challengeTitle(challenge, widget.block)),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ChallengeCard(
              title: challenge.title,
              child: Column(
                children: [
                  ParsedHtml(challenge.description, customStyles: gray),
                  ParsedHtml(challenge.instructions, customStyles: gray),
                ],
              ),
            ),
            if (challenge.scene case final scene?)
              ChallengeCard(
                title: 'Scene',
                child: SceneView(scene: scene, title: challenge.title),
              ),
            if (challenge.assignments.isNotEmpty)
              ChallengeCard(
                title: 'Assignments',
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
            if (challenge.fillInTheBlank case final fill?)
              ChallengeCard(
                title: 'Fill in the Blank',
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(children: _sentences(fill.sentence)),
                ),
              ),
            if (feedback.isNotEmpty)
              HtmlCard(title: 'Feedback', html: feedback),
            if (challenge.explanation.isNotEmpty)
              HtmlCard(
                title: 'Explanation',
                html: challenge.explanation,
                collapsible: true,
              ),
            if (_blanks.isEmpty || _allCorrect)
              CompleteButton(
                challenge: challenge,
                block: widget.block,
                label: 'Go to Next Challenge',
                enabled: _assignments.every((done) => done),
              )
            else
              ChallengeButton(label: 'Check Answers', onPressed: _check),
            ChallengeButton(
              label: 'Ask for Help',
              onPressed: () => showHelpDialog(context, challenge, widget.block),
            ),
          ],
        ),
      ),
    );
  }

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
    final result = _results?[index];
    final border = OutlineInputBorder(
      borderSide: switch (result) {
        null => const BorderSide(color: FccColors.blue50),
        true => const BorderSide(width: 2, color: Colors.green),
        false => const BorderSide(width: 2, color: Colors.red),
      },
    );
    final painter = TextPainter(
      // NOTE: Two extra characters of leeway, so a typo or the cursor isn't clipped.
      text: TextSpan(text: '${_blanks[index].answer}mm', style: _wordStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    final answerWidth = painter.width;
    painter.dispose();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: answerWidth,
      child: TextField(
        controller: _inputs[index],
        cursorHeight: 19,
        autocorrect: false,
        smartQuotesType: SmartQuotesType.disabled,
        spellCheckConfiguration: const SpellCheckConfiguration.disabled(),
        style: const TextStyle(fontSize: 19, letterSpacing: 0),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          enabledBorder: border,
          focusedBorder: border,
        ),
      ),
    );
  }
}
