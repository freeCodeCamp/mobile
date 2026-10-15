import 'package:mobile_app_new/code_radio/models/code_radio_model.dart';
import 'package:mobile_app_new/code_radio/services/code_radio_service.dart';
import 'package:mobile_app_new/services/audio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'player_viewmodel.g.dart';

Duration? _noRetry(int retryCount, Object error) => null;

@Riverpod(retry: _noRetry)
Stream<CodeRadio> codeRadioNowPlaying(Ref ref) {
  final service = ref.watch(codeRadioServiceProvider);

  service.start();

  return service.updates;
}

// The station only pushes on an event, so the seconds in between are counted
// locally. Every push resyncs the count to the server's elapsed.
@riverpod
Stream<int> codeRadioElapsed(Ref ref) async* {
  final radio = await ref.watch(codeRadioNowPlayingProvider.future);

  yield radio.nowPlaying.elapsed;

  yield* Stream.periodic(
    const Duration(seconds: 1),
    (tick) => radio.nowPlaying.elapsed + tick + 1,
  ).takeWhile((elapsed) => elapsed <= radio.nowPlaying.duration);
}

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
