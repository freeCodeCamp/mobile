import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freecodecamp/models/code-radio/code_radio_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

class CodeRadioViewModel extends BaseViewModel with WidgetsBindingObserver {
  final _player = AudioPlayer();

  int _navIndex = 0;
  int get navIndex => _navIndex;

  Future<CodeRadio> initRadio() async {
    final http.Response response = await http.get(Uri.parse(
        'https://coderadio-admin.freecodecamp.org/api/live/nowplaying/coderadio'));

    if (response.statusCode == 200) {
      CodeRadio radio = CodeRadio.fromJson(jsonDecode(response.body));

      toggleRadio(radio.listenUrl);

      return radio;
    } else {
      throw Exception(response.body);
    }
  }

  pauseUnpauseRadio() {
    dev.log('getting executed');
    dev.log(_player.playing.toString());
    if (!_player.playing) {
      _player.play();
    } else {
      _player.pause();
    }
  }

  Future<void> toggleRadio(String url) async {
    await _player
        .setAudioSource(AudioSource.uri(Uri.parse(url)), preload: true)
        .then((value) => _player.play());
  }
}
