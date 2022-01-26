import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freecodecamp/models/code-radio/code_radio_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

class CodeRadioViewModel extends BaseViewModel with WidgetsBindingObserver {
  final _player = AudioPlayer();

  AudioPlayer get player => _player;

  Future<CodeRadio> initRadio() async {
    final http.Response response = await http.get(Uri.parse(
        'https://coderadio-admin.freecodecamp.org/api/live/nowplaying/coderadio'));

    if (response.statusCode == 200) {
      CodeRadio radio = CodeRadio.fromJson(jsonDecode(response.body));
      dev.log('cakked');
      toggleRadio(radio);
      return radio;
    } else {
      throw Exception(response.body);
    }
  }

  void pauseUnpauseRadio(CodeRadio radio) {
    if (!player.playing) {
      player.play();
    } else {
      player.pause();
    }
  }

  void disposePlayer() {
    _player.dispose();
  }

  Future<void> toggleRadio(CodeRadio radio) async {
    await player.setUrl(radio.listenUrl, preload: true);

    player.play();
    player.seek(Duration(seconds: radio.elapsed));
  }

  Future<void> getNextSong() async {
    await initRadio();
    notifyListeners();
  }

  desyncListener(int highestSec, int elapsed) {
    if (highestSec != 0 && highestSec < elapsed) {
      player.seek(Duration(seconds: elapsed));
    } else {
      elapsed = highestSec;
    }
  }
}
