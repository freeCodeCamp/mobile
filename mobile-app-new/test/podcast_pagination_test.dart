import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_new/podcasts/models/episode_model.dart';
import 'package:mobile_app_new/podcasts/models/podcast_model.dart';
import 'package:mobile_app_new/podcasts/services/api_service.dart';
import 'package:mobile_app_new/podcasts/ui/episode_list/episode_list_viewmodel.dart';

const _podcast = Podcast(
  id: 'show',
  feedUrl: '',
  podcastLink: '',
  title: 'A podcast',
  imageLink: '',
);
final _provider = podcastEpisodesProvider(
  const PodcastEpisodeSource.remote('show'),
);

EpisodesPage _page(String id, {bool hasMore = true}) => (
  podcast: _podcast,
  episodes: [
    Episode(
      id: id,
      podcastId: 'show',
      title: id,
      audioUrl: 'https://example.com/$id.mp3',
    ),
  ],
  hasMore: hasMore,
);

void main() {
  for (final fails in [false, true]) {
    test(
      'a stale append ${fails ? 'failure' : 'response'} cannot overwrite refreshed episodes',
      () async {
        final api = _QueuedApi();
        final container = ProviderContainer(
          overrides: [podcastApiServiceProvider.overrideWithValue(api)],
        );
        addTearDown(container.dispose);
        container.listen(_provider, (_, _) {});
        final firstLoad = container.read(_provider.future);
        api.requests.single.result.complete(_page('old-first'));
        await firstLoad;

        final append = container.read(_provider.notifier).fetchNextPage();
        final stale = api.requests.last;
        expect(stale.page, 1);
        expect(container.read(_provider).requireValue.isLoadingMore, isTrue);

        container.invalidate(_provider);
        final refresh = container.read(_provider.future);
        expect(api.requests.last.page, 0);
        api.requests.last.result.complete(_page('fresh-first'));
        await refresh;

        if (fails) {
          stale.result.completeError(StateError('Old request failed'));
        } else {
          stale.result.complete(_page('old-second', hasMore: false));
        }
        await append;

        final current = container.read(_provider).requireValue;
        expect(current.episodes.map((episode) => episode.id), ['fresh-first']);
        expect(current.page, 0);
        expect(current.hasNextPage, isTrue);
        expect(current.isLoadingMore, isFalse);
        expect(current.loadMoreError, isNull);
      },
    );

    test(
      'an append ${fails ? 'failure' : 'response'} after disposal completes safely',
      () async {
        final api = _QueuedApi();
        final container = ProviderContainer(
          overrides: [podcastApiServiceProvider.overrideWithValue(api)],
        );
        var disposed = false;
        addTearDown(() {
          if (!disposed) container.dispose();
        });
        container.listen(_provider, (_, _) {});
        final firstLoad = container.read(_provider.future);
        api.requests.single.result.complete(_page('first'));
        await firstLoad;

        final append = container.read(_provider.notifier).fetchNextPage();
        final pending = api.requests.last;
        container.dispose();
        disposed = true;

        if (fails) {
          pending.result.completeError(
            StateError('Request failed after leaving'),
          );
        } else {
          pending.result.complete(_page('second'));
        }
        await expectLater(append, completes);
      },
    );
  }

  test(
    'append failure preserves episodes and waits for an explicit retry',
    () async {
      final api = _QueuedApi();
      final container = ProviderContainer(
        overrides: [podcastApiServiceProvider.overrideWithValue(api)],
      );
      addTearDown(container.dispose);
      container.listen(_provider, (_, _) {});
      final firstLoad = container.read(_provider.future);
      api.requests.single.result.complete(_page('first'));
      await firstLoad;

      final notifier = container.read(_provider.notifier);
      final append = notifier.fetchNextPage();
      api.requests.last.result.completeError(StateError('Offline'));
      await append;
      expect(
        container.read(_provider).requireValue.episodes.single.id,
        'first',
      );
      expect(
        container.read(_provider).requireValue.loadMoreError,
        isA<StateError>(),
      );

      await notifier.fetchNextPage();
      expect(api.requests.length, 2);
      final retry = notifier.fetchNextPage(isRetry: true);
      expect(api.requests.last.page, 1);
      api.requests.last.result.complete(_page('second', hasMore: false));
      await retry;

      final current = container.read(_provider).requireValue;
      expect(current.episodes.map((episode) => episode.id), [
        'first',
        'second',
      ]);
      expect(current.page, 1);
      expect(current.loadMoreError, isNull);
      expect(current.hasNextPage, isFalse);
    },
  );
}

class _Request {
  _Request(this.page);
  final int page;
  final result = Completer<EpisodesPage>();
}

class _QueuedApi implements PodcastApiService {
  final requests = <_Request>[];

  @override
  Future<EpisodesPage> getEpisodes(String podcastId, {int page = 0}) {
    final request = _Request(page);
    requests.add(request);
    return request.result.future;
  }

  @override
  Future<List<Podcast>> getPodcasts() async => [_podcast];
}
