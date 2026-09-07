import 'package:mobile_app_new/code_radio/models/code_radio_model.dart';
import 'package:mobile_app_new/code_radio/services/code_radio_service.dart';
import 'package:mobile_app_new/services/audio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'player_viewmodel.g.dart';

@riverpod
Stream<CodeRadio> codeRadioNowPlaying(Ref ref) =>
    ref.watch(codeRadioServiceProvider).nowPlaying;

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
      if (ref.mounted) state = playbackState.playing;
    });
    ref.onDispose(subscription.cancel);

    ref.listen(codeRadioNowPlayingProvider, (_, next) {
      final radio = next.value;
      if (radio != null) _load(radio);
    }, fireImmediately: true);

    return _handler.isPlayingCodeRadio;
  }

  Future<void> _load(CodeRadio radio) async {
    if (_handler.codeRadioSongId == radio.nowPlaying.song.id) return;

    if (_handler.codeRadioSongId != null) {
      _handler.updateCodeRadioSong(radio.nowPlaying.song);
      return;
    }

    await _handler.loadCodeRadio(radio);
    await _handler.play();
  }

  Future<void> toggle() => state ? _handler.pause() : _handler.play();
}
