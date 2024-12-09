import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/service/learn/learn_offline_service.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:freecodecamp/ui/views/learn/superblock/superblock_view.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
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

    HTMLParser htmlParser = HTMLParser(context: context);
    Map<String, String> currentFills = {};
    log('REBUILDING WIDGETS');

    int blankIndex = 0;

    for (String word in words) {
      if (word.contains('BLANK')) {
        String uniqueId = 'blank_$blankIndex';
        currentFills[uniqueId] = '';

        widgets.add(
          Wrap(
            children: [
              Container(
                width: 40,
                margin: const EdgeInsets.only(right: 8),
                child: TextField(
                  onChanged: (value) {
                    currentFills[uniqueId] = value;
                    fills.add(currentFills);
                    log(currentFills.toString());
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              )
            ],
          ),
        );
        blankIndex++;
      } else {
        List<Widget> parsed = htmlParser.parse('<span>$word</span>');

        widgets.addAll(parsed);
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
