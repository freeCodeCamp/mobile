import 'package:audio_service/audio_service.dart';
import 'package:mobile_app_new/services/audio_service.dart';
import 'package:mobile_app_new/podcasts/models/podcast_model.dart';
import 'package:mobile_app_new/podcasts/models/episode_model.dart';

/// Silent fixture that does not initialize a platform audio player.
class FakeAudioHandler extends BaseAudioHandler implements AudioPlayerHandler {
  @override
  String? get codeRadioSongId => null;
  @override
  String? get episodeId => null;
  @override
  (Podcast, Episode)? get currentPodcastEpisode => null;
  @override
  bool get isPlayingCodeRadio => false;
  @override
  Duration? get duration => null;
  @override
  Stream<Duration> get positionStream => Stream.value(Duration.zero);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
