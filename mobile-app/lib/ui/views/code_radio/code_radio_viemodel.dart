import 'dart:async';
import 'package:freecodecamp/models/code-radio/code_radio_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:stacked/stacked.dart';

import 'package:web_socket_channel/web_socket_channel.dart';

class CodeRadioViewModel extends BaseViewModel {
  final _player = AudioPlayer();

  AudioPlayer get player => _player;

  bool _stoppedManually = false;
  bool get stoppedManually => _stoppedManually;

  final _channel = WebSocketChannel.connect(Uri.parse(
      'wss://coderadio-admin.freecodecamp.org/api/live/nowplaying/coderadio'));

  WebSocketChannel get channel => _channel;

  int _counter = 0;
  int get counter => _counter;

  final _controller = StreamController<int>();
  StreamController<int> get controller => _controller;

  Timer? _timer;
  Timer? get timer => _timer;

  void startProgressBar(int timeElapsed, int duration) {
    _counter = timeElapsed;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _counter++;
      _controller.sink.add(_counter);

      if (_counter == duration) {
        timer.cancel();
      }
    });
  }

  void pauseUnpauseRadio() {
    if (!player.playing) {
      _stoppedManually = false;
      player.play();
    } else {
      _stoppedManually = true;
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
}
