import 'dart:async';
import 'dart:convert';

import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/code-radio/code_radio_model.dart';
import 'package:freecodecamp/service/audio/audio_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CodeRadioViewModel extends BaseViewModel {
  final audioService = locator<AppAudioService>().audioHandler;
  bool stoppedManually = false;

  final _webSocketChannel = WebSocketChannel.connect(Uri.parse(
      'wss://coderadio-admin-v2.freecodecamp.org/api/live/nowplaying/websocket'));
  final _webSocketController = StreamController<dynamic>.broadcast();
  StreamController<dynamic> get webSocketController => _webSocketController;

  int _counter = 0;
  int get counter => _counter;

  final _audioStateController = StreamController<int>();
  StreamController<int> get audioStateController => _audioStateController;

  Timer? _timer;
  Timer? get timer => _timer;

  void init() async {
    _webSocketChannel.sink.add(jsonEncode({
      'subs': {'station:coderadio': {}}
    }));
    await _webSocketController.addStream(_webSocketChannel.stream);
  }

  void startProgressBar(int timeElapsed, int duration) {
    _counter = timeElapsed;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _counter++;
      _audioStateController.sink.add(_counter);

      if (_counter == duration) {
        timer.cancel();
      }
    });
  }

  void pauseUnpauseRadio() async {
    if (!audioService.isPlaying('coderadio')) {
      stoppedManually = false;

      await audioService.play();
      notifyListeners();
    } else {
      stoppedManually = true;
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
