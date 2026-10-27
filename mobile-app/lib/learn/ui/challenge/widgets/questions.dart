import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/parsed_html.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/quiz_audio_player.dart';

typedef QuestionItem = ({
  String text,
  List<Answer> answers,
  int solution,
  QuizAudioData? audioData,
});
QuestionItem questionItem(Question q) => (
  text: q.text,
  answers: q.answers,
  solution: q.solution - 1,
  audioData: null,
);

class Questions extends StatelessWidget {
  const Questions({
    super.key,
    required this.questions,
    required this.selected,
    required this.validated,
    required this.onChanged,
    this.currentIndex,
    this.enabled = true,
    this.plainCodeBlocks = false,
    this.outlinedFeedbackCode = false,
  });
  final List<QuestionItem> questions;
  final List<int?> selected;
  final bool validated;
  final void Function(int question, int answer) onChanged;
  final int? currentIndex;
  final bool enabled;
  final bool plainCodeBlocks;
  final bool outlinedFeedbackCode;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (final (i, question) in questions.indexed)
        if (currentIndex == null || currentIndex == i) ...[
          ParsedHtml(
            question.text,
            plainCodeBlocks: plainCodeBlocks,
            customStyles: {
              '*': Style(
                fontSize: FontSize(24),
                fontWeight: FontWeight.w800,
                lineHeight: const LineHeight(1.35),
              ),
              for (final tag in ['body', 'div', 'p'])
                tag: Style(margin: Margins.zero, padding: HtmlPaddings.zero),
              'strong': Style(fontWeight: FontWeight.w800),
              'b': Style(fontWeight: FontWeight.w800),
            },
          ),
          if (question.audioData case final audio?) ...[
            const SizedBox(height: 16),
            QuizAudioPlayer(key: ValueKey(i), audioData: audio),
          ],
          const SizedBox(height: 20),
          for (final (j, answer) in question.answers.indexed)
            _option(context, i, j, answer),
          if (validated && selected[i] != null) _feedback(context, i),
        ],
    ],
  );

  Widget _option(BuildContext context, int question, int index, Answer answer) {
    final colors = Theme.of(context).colorScheme;
    final isSelected = selected[question] == index;
    final isCorrect = questions[question].solution == index;
    final checked = validated && isSelected;
    final accent = checked
        ? (isCorrect ? FccDesignColors.of(context).success : colors.error)
        : colors.primary;
    final background = isSelected
        ? (checked ? accent.withValues(alpha: .09) : colors.primaryContainer)
        : colors.surface;
    final badgeSize = (MediaQuery.textScalerOf(context).scale(16) * 1.2 + 12)
        .clamp(32.0, double.infinity);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Semantics(
        checked: isSelected,
        inMutuallyExclusiveGroup: true,
        button: true,
        child: Material(
          color: background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: isSelected ? accent : colors.outline,
              width: isSelected ? 2 : 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: enabled ? () => onChanged(question, index) : null,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: badgeSize,
                    height: badgeSize,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? accent : colors.surfaceContainer,
                    ),
                    child: checked
                        ? Icon(
                            isCorrect ? Icons.check : Icons.close,
                            size: 18,
                            color: colors.surface,
                          )
                        : Text(
                            String.fromCharCode(65 + index),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                              color: isSelected
                                  ? colors.onPrimary
                                  : colors.onSurfaceVariant,
                            ),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: IgnorePointer(
                      // Quiz code answers need their horizontal scroll gestures.
                      // Nested actions are disabled so taps reach this option.
                      ignoring: !plainCodeBlocks,
                      child: ParsedHtml(
                        answer.answer,
                        selectable: false,
                        plainCodeBlocks: plainCodeBlocks,
                        enableTapActions: false,
                        customStyles: {
                          '*': Style(lineHeight: const LineHeight(1.4)),
                          for (final tag in ['body', 'div', 'p'])
                            tag: Style(
                              margin: Margins.zero,
                              padding: HtmlPaddings.zero,
                            ),
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _feedback(BuildContext context, int question) {
    final index = selected[question]!;
    final correct = questions[question].solution == index;
    final color = correct
        ? FccDesignColors.of(context).success
        : Theme.of(context).colorScheme.error;
    final feedback = questions[question].answers[index].feedback;
    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: .3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            correct ? 'Correct!' : 'Not quite',
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (feedback != null && feedback.isNotEmpty)
            ParsedHtml(feedback, outlinedInlineCode: outlinedFeedbackCode)
          else if (!correct)
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text(
                'Try another answer. You can revisit the lesson for a hint.',
              ),
            ),
        ],
      ),
    );
  }
}
