import 'package:freecodecamp/code_radio/controllers/player_controller.dart';
import 'package:freecodecamp/services/audio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'player_viewmodel.g.dart';

@riverpod
class CodeRadioPlayerNotifier extends _$CodeRadioPlayerNotifier {
  AudioPlayerHandler get _handler => ref.read(audioHandlerProvider);

  @override
  bool build() {
    final subscription = _handler.playbackState.listen((playbackState) {
      if (ref.mounted) state = _handler.isPlayingCodeRadio;
    });
    ref.onDispose(subscription.cancel);

    return _handler.isPlayingCodeRadio;
  }

  Future<void> toggle() async {
    final handler = _handler;
    if (handler.isPlayingCodeRadio) {
      await handler.pause();
      return;
    }
    if (handler.codeRadioSongId == null) {
      final radio = await ref.read(codeRadioNowPlayingProvider.future);
      await handler.loadCodeRadio(radio);
    }
    await handler.play();
  }
}
