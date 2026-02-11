import 'dart:async';
import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/service/learn/learn_offline_service.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:html/parser.dart';
import 'package:stacked/stacked.dart';

class EnglishViewModel extends BaseViewModel {
  final LearnOfflineService learnOfflineService =
      locator<LearnOfflineService>();

  final LearnService learnService = locator<LearnService>();

  Map<String, String> _currentBlankValues = {};
  Map<String, String> get currentBlankValues => _currentBlankValues;

  Map<String, bool> _inputValuesCorrect = {};
  Map<String, bool> get inputValuesCorrect => _inputValuesCorrect;

  String _feedback = '';
  String get feedback => _feedback;

  bool _allInputsCorrect = false;
  bool get allInputsCorrect => _allInputsCorrect;

  final StreamController<Map<String, String>> fills =
      StreamController<Map<String, String>>.broadcast();

  set setCurrentBlankValues(Map<String, String> value) {
    _currentBlankValues = value;
    notifyListeners();
  }

  set setInptuValuesCorrect(Map<String, bool> value) {
    _inputValuesCorrect = value;
    notifyListeners();
  }

  set setAllInputsCorrect(bool value) {
    _allInputsCorrect = value;
    notifyListeners();
  }

  set setFeedback(String value) {
    _feedback = value;
    notifyListeners();
  }

  void initBlankInputStreamListener() {
    fills.stream.listen((Map<String, String> event) {
      setCurrentBlankValues = event;
    });
  }

  double calculateTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text.replaceAll('BLANK', ''), style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.size.width;
  }

  void checkAnswers(Challenge challenge) {
    List<String> inputKeys = currentBlankValues.keys.toList();
    List<String> inputValues = currentBlankValues.values.toList();

    Map<String, bool> correctIncorrect = {};

    for (int i = 0; i < inputKeys.length; i++) {
      if (challenge.fillInTheBlank == null) break;
      inputValues[i] = inputValues[i].trim();

      bool value = inputValues[i].toLowerCase() == challenge.fillInTheBlank!.blanks[i].answer.toLowerCase();
      correctIncorrect['blank_correct_$i'] = value;
    }

    setInptuValuesCorrect = correctIncorrect;

    setAllInputsCorrect = correctIncorrect.values.every(
      (value) => value == true,
    );

    if (!allInputsCorrect) {
      int firstIncorrectIndex = correctIncorrect.values.toList().indexOf(false);

      if (firstIncorrectIndex != -1) {
        Blank blank = challenge.fillInTheBlank!.blanks[firstIncorrectIndex];
        setFeedback = blank.feedback;
      }
    } else {
      setFeedback = '';
    }
  }

  OutlineInputBorder handleInputBorderColor(int inputIndex) {
    if (inputValuesCorrect.isEmpty) {
      return const OutlineInputBorder(
        borderSide: BorderSide(color: FccColors.blue50),
      );
    }

    if (inputValuesCorrect['blank_correct_$inputIndex'] == true) {
      return const OutlineInputBorder(
        borderSide: BorderSide(
          width: 2,
          color: Colors.green,
        ),
      );
    } else {
      return const OutlineInputBorder(
        borderSide: BorderSide(
          width: 2,
          color: Colors.red,
        ),
      );
    }
  }

  List<Widget> getFillInBlankWidgets(
    Challenge challenge,
    BuildContext context,
  ) {
    List<Widget> widgets = [];

    List<String> sentences = challenge.fillInTheBlank!.sentence.split('\n');

    int blankIndex = 0;
    for (String sentence in sentences) {
      List<Widget> children = [];

      List<String> words = sentence.split(' ');
      for (String word in words) {
        if (word.contains('BLANK')) {
          String uniqueId = 'blank_$blankIndex';

          if (currentBlankValues[uniqueId] == null) {
            currentBlankValues.addAll({uniqueId: ''});
          }

          // The blank word is sometimes concatenated with the previous or next word
          List splitWord = word.split('BLANK');

          if (splitWord.isNotEmpty) {
            children.add(
              Text(
                parseFragment(splitWord[0]).text ?? '',
                textAlign: TextAlign.start,
                style: const TextStyle(fontSize: 20, letterSpacing: 0),
              ),
            );
          }

          children.add(
            Container(
              margin: const EdgeInsets.only(
                left: 5,
                right: 5,
              ),
              width: calculateTextWidth(
                    challenge.fillInTheBlank!.blanks[blankIndex].answer,
                    const TextStyle(fontSize: 20),
                  ) +
                  20,
              child: TextFormField(
                initialValue: currentBlankValues[uniqueId],
                cursorHeight: 19,
                onChanged: (value) {
                  Map<String, String> local = currentBlankValues;
                  local[uniqueId] = value;
                  fills.add(local);
                },
                smartQuotesType: SmartQuotesType.disabled,
                spellCheckConfiguration:
                    const SpellCheckConfiguration.disabled(),
                autocorrect: false,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  focusedBorder: handleInputBorderColor(blankIndex),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  isDense: true,
                  enabledBorder: handleInputBorderColor(blankIndex),
                ),
                style: const TextStyle(
                  fontSize: 19,
                  letterSpacing: 0,
                ),
              ),
            ),
          );

          if (splitWord.length > 1) {
            children.add(
              Text(
                parseFragment(splitWord[1]).text ?? '',
                style: const TextStyle(fontSize: 20, letterSpacing: 0),
              ),
            );
          }

          blankIndex++;
        } else {
          children.add(
            Text(
              parseFragment(word).text ?? '',
              style: const TextStyle(fontSize: 20, letterSpacing: 0),
            ),
          );
        }
      }

      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Align(
            alignment: Alignment.topLeft,
            child: Wrap(spacing: 3, runSpacing: 3, children: children),
          ),
        ),
      );
    }

    return widgets;
  }
}
