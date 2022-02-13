import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';

class CodeRadioService with WidgetsBindingObserver {
  final _player = AudioPlayer();
  AudioPlayer get player => _player;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    final didTerminateApp = state == AppLifecycleState.detached;

    if (didTerminateApp) {
      player.dispose();
    }
  }

  void initAppStateObserver() {
    WidgetsBinding.instance!.addObserver(this);
  }

  void removeAppStateObserver() {
    WidgetsBinding.instance!.removeObserver(this);
  }
}
