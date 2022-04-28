import 'dart:async';
import 'package:freecodecamp/models/code-radio/code_radio_model.dart';
import 'package:freecodecamp/service/code_radio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:freecodecamp/app/app.locator.dart';

class CodeRadioViewModel extends BaseViewModel {
  final audioService = locator<CodeRadioService>();
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
    if (!audioService.player.playing) {
      _stoppedManually = false;
      audioService.player.play();
    } else {
      _stoppedManually = true;
      audioService.player.pause();
    }
  }

  Future<void> setAndGetLastId(CodeRadio radio) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString('lastSongId') == null) {
      prefs.setString('lastSongId', radio.nowPlaying.id);
    }

    if (radio.nowPlaying.id != prefs.getString('lastSongId')) {
      setBackgroundWidget(radio);
      audioService.player.play();
      prefs.setString('lastSongId', radio.nowPlaying.id);
    }
  }

  Future<void> toggleRadio(CodeRadio radio) async {
    setBackgroundWidget(radio);
    audioService.player.play();
    audioService.player.seek(Duration(seconds: radio.elapsed));
  }

  Future<void> setBackgroundWidget(CodeRadio radio) async {
    if (audioService.player.playing) {
      audioService.player.stop();
    }

    await audioService.player.setAudioSource(
        ConcatenatingAudioSource(children: [
          AudioSource.uri(
            Uri.parse(radio.listenUrl),
            tag: MediaItem(
              id: radio.nowPlaying.id,
              album: radio.nowPlaying.album,
              title: radio.nowPlaying.title,
              artUri: Uri.parse(radio.nowPlaying.artUrl),
            ),
          ),
          AudioSource.uri(
            Uri.parse(radio.listenUrl),
            tag: MediaItem(
              id: radio.nextPlaying.id,
              album: radio.nextPlaying.album,
              title: radio.nextPlaying.title,
              artUri: Uri.parse(radio.nextPlaying.artUrl),
            ),
          ),
        ]),
        preload: false);
  }
}
