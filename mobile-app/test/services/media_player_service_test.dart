import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/services/audio_service.dart';
import 'package:freecodecamp/services/media_player_service.dart';

class _Audio extends BaseAudioHandler implements AudioPlayerHandler {
  @override
  PublishedSource? get published => null;
  @override
  Duration? get duration => null;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late _Audio audio;
  late ProviderContainer container;
  late List<MediaPlayerState> updates;

  setUp(() {
    audio = _Audio();
    audio.mediaItem.add(const MediaItem(id: 'episode', title: 'Episode'));
    audio.playbackState.add(
      PlaybackState(playing: true, processingState: AudioProcessingState.ready),
    );
    container = ProviderContainer(
      overrides: [audioHandlerProvider.overrideWithValue(audio)],
    );
    addTearDown(container.dispose);
    updates = [];
    container.listen(mediaPlayerProvider, (_, next) => updates.add(next));
  });

  test('ignores playback events that only move the buffer', () async {
    audio.playbackState.add(
      audio.playbackState.value.copyWith(
        bufferedPosition: const Duration(seconds: 30),
      ),
    );
    await pumpEventQueue();
    expect(updates, isEmpty);
  });

  test('notifies when playback pauses', () async {
    audio.playbackState.add(audio.playbackState.value.copyWith(playing: false));
    await pumpEventQueue();
    expect(updates.single.isPlaying, isFalse);
  });

  test('reports buffering as busy', () async {
    audio.playbackState.add(
      audio.playbackState.value.copyWith(
        processingState: AudioProcessingState.buffering,
      ),
    );
    await pumpEventQueue();
    expect(updates.single.isBusy, isTrue);
  });
}
