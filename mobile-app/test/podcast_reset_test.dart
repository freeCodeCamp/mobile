import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/podcasts/controllers/downloads_controller.dart';
import 'package:freecodecamp/podcasts/controllers/library_controller.dart';
import 'package:freecodecamp/podcasts/models/episode_model.dart';
import 'package:freecodecamp/podcasts/models/podcast_model.dart';
import 'package:freecodecamp/podcasts/repositories/download_repository.dart';
import 'package:freecodecamp/podcasts/repositories/progress_repository.dart';
import 'package:freecodecamp/podcasts/repositories/storage_repository.dart';
import 'package:freecodecamp/podcasts/services/library_service.dart';
import 'package:freecodecamp/podcasts/services/playback_service.dart';
import 'support/fake_audio_handler.dart';

const _podcast = Podcast(
  id: 'show',
  feedUrl: '',
  podcastLink: '',
  title: 'Podcast',
  imageLink: '',
);
const _episode = Episode(
  id: 'episode',
  podcastId: 'show',
  title: 'Episode',
  audioUrl: 'https://example.com/episode.mp3',
);

class _PendingLibrary implements PodcastLibraryService {
  final transfers = <({Completer<void> done, CancelToken token})>[];
  @override
  Future<void> download(
    Podcast podcast,
    Episode episode, {
    CancelToken? cancelToken,
    void Function(double)? onProgress,
  }) {
    final done = Completer<void>();
    transfers.add((done: done, token: cancelToken!));
    return done.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Library extends PodcastLibraryNotifier {
  @override
  Future<PodcastLibrary> build() async => (
    podcasts: <Podcast>[],
    episodesByPodcastId: <String, List<Episode>>{},
    artworkByPodcastId: <String, File>{},
  );
  @override
  Future<void> refresh() async {}
}

class _PlayingAudio extends FakeAudioHandler {
  final positions = StreamController<Duration>.broadcast(sync: true);
  @override
  String? get episodeId => 'episode';
  @override
  Duration? get duration => const Duration(hours: 1);
  @override
  Stream<Duration> get positionStream => positions.stream;
}

class _Progress extends PodcastProgressRepository {
  final released = Completer<void>();
  final writes = <int>[];
  @override
  Future<void> writePosition(String episodeId, int seconds) async {
    writes.add(seconds);
    await released.future;
  }

  @override
  Future<List<String>> readRecentEpisodeIds() async => [];
  @override
  Future<void> writeRecentEpisodeIds(List<String> ids) async {}
}

class _Files implements PodcastDownloadRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test(
    'cancel hides progress but reset and restart wait for the transfer to settle',
    () async {
      final library = _PendingLibrary();
      final container = ProviderContainer(
        overrides: [
          podcastLibraryServiceProvider.overrideWithValue(library),
          podcastLibraryProvider.overrideWith(_Library.new),
        ],
      );
      addTearDown(container.dispose);
      container.listen(podcastDownloadsProvider, (_, _) {});
      final downloads = container.read(podcastDownloadsProvider.notifier);
      final first = downloads.start(_podcast, _episode);
      expect(library.transfers, hasLength(1));
      downloads.cancel(_episode.id);
      expect(library.transfers.first.token.isCancelled, isTrue);
      expect(container.read(podcastDownloadsProvider), isEmpty);
      expect(downloads.hasPendingTransfers(), isTrue);
      await downloads.start(_podcast, _episode);
      expect(library.transfers, hasLength(1));
      library.transfers.first.done.completeError(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.cancel,
        ),
      );
      await first;
      expect(downloads.hasPendingTransfers(), isFalse);
      final restarted = downloads.start(_podcast, _episode);
      expect(library.transfers, hasLength(2));
      expect(library.transfers.last.token.isCancelled, isFalse);
      expect(container.read(podcastDownloadsProvider), contains(_episode.id));
      library.transfers.last.done.complete();
      await restarted;
      expect(downloads.hasPendingTransfers(), isFalse);
    },
  );

  test(
    'reset waits for queued progress and prevents later position writes',
    () async {
      final audio = _PlayingAudio();
      final progress = _Progress();
      final service = PodcastPlaybackService(
        audio,
        progress,
        PodcastStorageRepository(),
        _Files(),
      );
      service.start();
      addTearDown(service.dispose);
      addTearDown(audio.positions.close);
      audio.positions.add(const Duration(seconds: 100));
      await Future<void>.delayed(Duration.zero);
      expect(progress.writes, [100]);
      var suspended = false;
      final drained = service.suspendForReset().then((_) => suspended = true);
      audio.positions.add(const Duration(seconds: 200));
      await Future<void>.delayed(Duration.zero);
      expect(suspended, isFalse);
      expect(progress.writes, [100]);
      progress.released.complete();
      await drained;
      expect(suspended, isTrue);
      audio.positions.add(const Duration(seconds: 300));
      await Future<void>.delayed(Duration.zero);
      expect(progress.writes, [100]);
    },
  );
}
