import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:freecodecamp/models/code-radio/code_radio_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

class CodeRadioViewModel extends BaseViewModel {
  final _player = AudioPlayer();

  AudioPlayer get player => _player;

  bool recentlyCalledRadio = false;

  var randomId = Random();

  Future<CodeRadio> initRadio() async {
    final http.Response response = await http.get(Uri.parse(
        'https://coderadio-admin.freecodecamp.org/api/live/nowplaying/coderadio'));

    if (response.statusCode == 200) {
      CodeRadio radio = CodeRadio.fromJson(jsonDecode(response.body));
      dev.log('WARNING CODERADIO IS CALLED!');

      toggleRadio(radio);

      return radio;
    } else {
      throw Exception(response.body);
    }
  }

  void pauseUnpauseRadio(CodeRadio radio) {
    if (!player.playing) {
      getNextSong();
    } else {
      player.pause();
    }
  }

  void disposePlayer() {
    _player.dispose();
  }

  Future<void> toggleRadio(CodeRadio radio) async {
    await player.setAudioSource(
        AudioSource.uri(
          Uri.parse(radio.listenUrl),
          tag: MediaItem(
            // Specify a unique ID for each media item:
            id: randomId.nextInt(100).toString(),
            // Metadata to display in the notification:
            album: radio.nowPlaying.album,
            title: radio.nowPlaying.title,
            artUri: Uri.parse(radio.nowPlaying.artUrl),
          ),
        ),
        preload: true);

    player.play();
    player.seek(Duration(seconds: radio.elapsed));
  }

  Future<void> getNextSong() async {
    if (!recentlyCalledRadio) {
      await initRadio();
      initRequestDelay();
      notifyListeners();
    }

    recentlyCalledRadio = true;
  }

  void desyncListener(int highestSec, int elapsed) {
    if (highestSec != 0 && highestSec < elapsed) {
      player.seek(Duration(seconds: elapsed));
    } else {
      elapsed = highestSec;
    }
  }

  void initRequestDelay() {
    Timer(const Duration(seconds: 5), () {
      recentlyCalledRadio = false;
    });
  }
}
