import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
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

  set setIsPlaying(bool value) {
    _isPlaying = value;
    notifyListeners();
  }

  set setCurrentBlankValues(Map<String, String> value) {
    _currentBlankValues = value;
    notifyListeners();
  }

  void setAudio(String url) {
    player.setUrl(
      'https://cdn.freecodecamp.org/curriculum/english/animation-assets/sounds/$url',
    );
  }

  void initBlankInputStreamListener() {
    fills.stream.listen((Map<String, String> event) {
      print(event);
    });
  }

  final StreamController<Map<String, String>> fills =
      StreamController<Map<String, String>>.broadcast();

  List<Widget> getFillInBlankWidgets(String sentence, BuildContext context) {
    List<Widget> widgets = [];
    List<String> words = sentence.split(' ');

    Map<String, String> currentFills = {};
    log('REBUILDING WIDGETS');

    int blankIndex = 0;

    for (String word in words) {
      if (word.contains('BLANK')) {
        String uniqueId = 'blank_$blankIndex';
        currentFills[uniqueId] = '';

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
            width: 40,
            child: TextField(
              onChanged: (value) {
                currentFills[uniqueId] = value;
                fills.add(currentFills);
              },
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.zero,
                isDense: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
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
          Text(
            word.replaceAll(RegExp('<p>|</p>'), ''),
            style: const TextStyle(fontSize: 20, letterSpacing: 0),
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
