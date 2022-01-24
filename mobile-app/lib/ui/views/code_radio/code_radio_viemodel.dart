import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freecodecamp/models/code-radio/code_radio_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class CodeRadioViewModel extends BaseViewModel with WidgetsBindingObserver {
  final _player = AudioPlayer();

  AudioPlayer get player => _player;

  Future<CodeRadio> initRadio() async {
    final http.Response response = await http.get(Uri.parse(
        'https://coderadio-admin.freecodecamp.org/api/live/nowplaying/coderadio'));

    if (response.statusCode == 200) {
      CodeRadio radio = CodeRadio.fromJson(jsonDecode(response.body));

      toggleRadio(radio);

      return radio;
    } else {
      throw Exception(response.body);
    }
  }

  void pauseUnpauseRadio() {
    if (!_player.playing) {
      initRadio();
    } else {
      _player.pause();
    }
  }

  Future<void> toggleRadio(CodeRadio radio) async {
    await _player
        .setAudioSource(AudioSource.uri(Uri.parse(radio.listenUrl)),
            preload: true, initialPosition: Duration(seconds: radio.elapsed))
        .then((value) => {_player.play()});
  }
}
