import 'dart:async';
import 'package:freecodecamp/models/code-radio/code_radio_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:stacked/stacked.dart';

import 'package:web_socket_channel/web_socket_channel.dart';

class CodeRadioViewModel extends BaseViewModel {
  final _player = AudioPlayer();

  AudioPlayer get player => _player;

  bool recentlyCalledRadio = false;

  final _channel = WebSocketChannel.connect(Uri.parse(
      'wss://coderadio-admin.freecodecamp.org/api/live/nowplaying/coderadio'));

  WebSocketChannel get channel => _channel;

  void pauseUnpauseRadio() {
    if (!player.playing) {
    } else {
      player.pause();
    }
  }

  Future<void> toggleRadio(CodeRadio radio) async {
    AudioSource audio = AudioSource.uri(
      Uri.parse(radio.listenUrl),
      tag: MediaItem(
        id: radio.nowPlaying.id,
        album: radio.nowPlaying.album,
        title: radio.nowPlaying.title,
        artUri: Uri.parse(radio.nowPlaying.artUrl),
      ),
    );

    await player.setAudioSource(audio, preload: true);
    player.play();
    player.seek(Duration(seconds: radio.elapsed));
  }

  void desyncListener(int highestSec, int elapsed) {
    if (highestSec != 0 && highestSec < elapsed) {
      player.seek(Duration(seconds: elapsed));
    } else {
      elapsed = highestSec;
    }
  }
}
