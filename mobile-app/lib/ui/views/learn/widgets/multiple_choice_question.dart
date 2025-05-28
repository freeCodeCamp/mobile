import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:freecodecamp/ui/views/learn/widgets/challenge_card.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';

class MultipleChoiceQuestion extends StatelessWidget {
  const MultipleChoiceQuestion({
    super.key,
    required this.challenge,
    required this.selectedAnswer,
    required this.isCorrect,
    required this.onChanged,
  });

  final Challenge challenge;
  final int selectedAnswer;
  final bool? isCorrect;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    HTMLParser parser = HTMLParser(context: context);

    return ChallengeCard(
      title: 'Question',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...parser.parse(challenge.instructions),
          ...parser.parse(
            challenge.question!.text,
          ),
          const SizedBox(height: 8),
          for (var answerObj in challenge.question!.answers.asMap().entries)
            Option(
                answerObj: answerObj,
                selectedAnswer: selectedAnswer,
                isCorrect: isCorrect,
                onChanged: (value) {
                  onChanged(value);
                }),
        ],
      ),
    );
  }
}

class Option extends StatelessWidget {
  const Option({
    super.key,
    required this.answerObj,
    required this.selectedAnswer,
    required this.isCorrect,
    required this.onChanged,
  });

  final MapEntry<int, Answer> answerObj;
  final int selectedAnswer;
  final bool? isCorrect;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    HTMLParser parser = HTMLParser(context: context);

    final isSelected = answerObj.key == selectedAnswer;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        child: RadioListTile<int>(
          key: ValueKey(selectedAnswer),
          selected: isSelected,
          tileColor: const Color(0xFF0a0a23),
          selectedTileColor: const Color(0xFF0a0a23),
          value: answerObj.key,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
            side: BorderSide(
              color: const Color(0xFFAAAAAA),
              width: 2,
            ),
          ),
          groupValue: selectedAnswer,
          onChanged: (value) {
            onChanged(value ?? -1);
          },
          title: Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: parser.parse(
                  answerObj.value.answer,
                  isSelectable: false,
                  removeParagraphMargin: true,
                ),
              ),
            ),
          ),
          subtitle: isSelected
              ? Padding(
                  padding: EdgeInsets.only(
                      left: 12, bottom: isCorrect == true ? 32 : 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isCorrect != null)
                        ValidationStatus(isCorrect: isCorrect),
                      if (answerObj.value.feedback != null)
                        Feedback(
                            isCorrect: isCorrect,
                            feedback: answerObj.value.feedback),
                    ],
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

class Feedback extends StatelessWidget {
  const Feedback({super.key, required this.isCorrect, required this.feedback});

  final bool? isCorrect;
  final String? feedback;

  @override
  Widget build(BuildContext context) {
    if (isCorrect == null || feedback == null || feedback!.isEmpty) {
      return const SizedBox.shrink();
    }

    HTMLParser parser = HTMLParser(context: context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...parser.parse(
          feedback ?? '',
          removeParagraphMargin: true,
          fontColor: isCorrect == true ? FccColors.green40 : FccColors.red15,
        ),
      ],
    );
  }
}

class ValidationStatus extends StatelessWidget {
  const ValidationStatus({
    super.key,
    required this.isCorrect,
  });

  final bool? isCorrect;

  @override
  Widget build(BuildContext context) {
    if (isCorrect == true) {
      return Text(
        'Correct!',
        style: TextStyle(
          color: FccColors.green40,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      );
    } else if (isCorrect == false) {
      return Text(
        'Incorrect!',
        style: TextStyle(
          color: FccColors.red15,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
