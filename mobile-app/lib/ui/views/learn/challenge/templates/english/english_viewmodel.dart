import 'dart:async';
import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/service/learn/learn_offline_service.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:freecodecamp/ui/views/learn/superblock/superblock_view.dart';
import 'package:just_audio/just_audio.dart';
import 'package:stacked/stacked.dart';

class EnglishViewModel extends BaseViewModel {
  final LearnOfflineService learnOfflineService =
      locator<LearnOfflineService>();

  final LearnService learnService = locator<LearnService>();

  final AudioPlayer player = AudioPlayer();

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  Map<String, String> _currentBlankValues = {};
  Map<String, String> get currentBlankValues => _currentBlankValues;

  Map<String, bool> _inputValuesCorrect = {};
  Map<String, bool> get inputValuesCorrect => _inputValuesCorrect;

  bool _allInputsCorrect = false;
  bool get allInputsCorrect => _allInputsCorrect;

  final StreamController<Map<String, String>> fills =
      StreamController<Map<String, String>>.broadcast();

  set setIsPlaying(bool value) {
    _isPlaying = value;
    notifyListeners();
  }

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

  void setAudio(String url) {
    player.setUrl(
      'https://cdn.freecodecamp.org/curriculum/english/animation-assets/sounds/$url',
    );
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

      bool value = inputValues[i] == challenge.fillInTheBlank!.blanks[i].answer;
      correctIncorrect['blank_correct_$i'] = value;
    }

    setInptuValuesCorrect = correctIncorrect;

    setAllInputsCorrect = correctIncorrect.values.every(
      (value) => value == true,
    );
  }

  OutlineInputBorder handleInputBorderColor(int inputIndex) {
    if (inputValuesCorrect.isEmpty) {
      return const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
        ),
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
      Challenge challenge, BuildContext context) {
    List<Widget> widgets = [];
    List<String> words = challenge.fillInTheBlank!.sentence.split(' ');

    int blankIndex = 0;

    for (String word in words) {
      if (word.contains('BLANK')) {
        String uniqueId = 'blank_$blankIndex';

        if (currentBlankValues[uniqueId] == null) {
          currentBlankValues.addAll({uniqueId: ''});
        }

        List splitWord = word.split('BLANK');

        if (splitWord.isNotEmpty) {
          widgets.add(
            Text(
              splitWord[0].replaceAll('<p>', ''),
              style: const TextStyle(fontSize: 20, letterSpacing: 0),
            ),
          );
        }

        widgets.add(
          Container(
            margin: EdgeInsets.only(
              left: uniqueId == 'blank_0' ? 0 : 5,
              right: 5,
            ),
            width: calculateTextWidth(
                  challenge.fillInTheBlank!.blanks[blankIndex].answer,
                  const TextStyle(fontSize: 20),
                ) +
                20,
            child: TextField(
              onChanged: (value) {
                Map<String, String> local = currentBlankValues;
                local[uniqueId] = value;
                fills.add(local);
              },
              smartQuotesType: SmartQuotesType.disabled,
              spellCheckConfiguration: const SpellCheckConfiguration.disabled(),
              autocorrect: false,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(3),
                focusedBorder: handleInputBorderColor(blankIndex),
                isDense: true,
                enabledBorder: handleInputBorderColor(blankIndex),
              ),
            ),
          ),
        );

        if (splitWord.length > 1) {
          widgets.add(
            Text(
              splitWord[1].replaceAll('</p>', ''),
              style: const TextStyle(fontSize: 20, letterSpacing: 0),
            ),
          );
        }

        blankIndex++;
      } else {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Text(
              word.replaceAll(RegExp('<p>|</p>'), ''),
              style: const TextStyle(fontSize: 20, letterSpacing: 0),
            ),
          ),
        );
      }
    }
    return widgets;
  }

  void playOrPauseAudio() {
    if (player.playing) {
      setIsPlaying = false;
      player.pause();
    } else {
      setIsPlaying = true;
      player.play();
    }
  }

  void updateProgressOnPop(BuildContext context, Block block) async {
    learnOfflineService.hasInternet().then(
          (value) => Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              transitionDuration: Duration.zero,
              pageBuilder: (
                context,
                animation1,
                animation2,
              ) =>
                  SuperBlockView(
                superBlockDashedName: block.superBlock.dashedName,
                superBlockName: block.superBlock.name,
                hasInternet: value,
              ),
            ),
          ),
        );
  }
}
