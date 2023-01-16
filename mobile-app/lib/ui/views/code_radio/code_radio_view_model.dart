import 'dart:async';
import 'package:freecodecamp/models/code-radio/code_radio_model.dart';
import 'package:freecodecamp/service/audio/audio_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:freecodecamp/app/app.locator.dart';

class CodeRadioViewModel extends BaseViewModel {
  final audioService = locator<AppAudioService>().audioHandler;
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

  void pauseUnpauseRadio() async {
    if (!audioService.isPlaying('coderadio')) {
      _stoppedManually = false;

      await audioService.play();
      notifyListeners();
    } else {
      _stoppedManually = true;
      await audioService.pause();
      notifyListeners();
    }
  }

  Future<void> setAndGetLastId(CodeRadio radio) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString('lastSongId') == null) {
      prefs.setString('lastSongId', radio.nowPlaying.id);
    }

    if (radio.nowPlaying.id != prefs.getString('lastSongId')) {
      setBackgroundWidget(radio);
      if (!stoppedManually) {
        audioService.play();
      }
      prefs.setString('lastSongId', radio.nowPlaying.id);
    }
  }

  Future<void> toggleRadio(CodeRadio radio) async {
    setBackgroundWidget(radio);
    audioService.play();
    audioService.seek(Duration(seconds: radio.elapsed));
  }

  Future<void> setBackgroundWidget(CodeRadio radio) async {
    if (audioService.isPlaying('coderadio')) {
      audioService.stop();
    }

    await audioService.codeRadioMusic(radio);
  }
}
