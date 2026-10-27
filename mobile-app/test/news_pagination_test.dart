import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/news/controllers/feed_controller.dart';
import 'package:freecodecamp/news/models/author_model.dart';
import 'package:freecodecamp/news/models/post_summary_model.dart';
import 'package:freecodecamp/news/services/api_service.dart';

final _provider = newsFeedProvider(const NewsFeedSource.all());
PostsPage _page(String id) => (
  posts: [
    PostSummary(
      id: id,
      slug: id,
      title: id,
      author: const Author(id: 'author', username: 'camper', name: 'A Camper'),
      readTimeInMinutes: 5,
      publishedAt: '2026-10-10',
    ),
  ],
  endCursor: id,
  hasNextPage: true,
);

class _Api implements NewsApiService {
  final requests = <Completer<PostsPage>>[];
  @override
  Future<PostsPage> getAllPosts({String afterCursor = ''}) {
    final result = Completer<PostsPage>();
    requests.add(result);
    return result.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  for (final failure in [false, true]) {
    test(
      'stale news append ${failure ? 'failure' : 'response'} cannot overwrite refreshed tutorials',
      () async {
        final api = _Api();
        final container = ProviderContainer(
          overrides: [newsApiServiceProvider.overrideWithValue(api)],
        );
        addTearDown(container.dispose);
        container.listen(_provider, (_, _) {});
        final initial = container.read(_provider.future);
        api.requests.single.complete(_page('old-first'));
        await initial;
        final append = container.read(_provider.notifier).fetchNextPage();
        final stale = api.requests.last;
        container.invalidate(_provider);
        final refresh = container.read(_provider.future);
        api.requests.last.complete(_page('fresh-first'));
        await refresh;
        if (failure) {
          stale.completeError(StateError('Old request failed'));
        } else {
          stale.complete(_page('old-second'));
        }
        await append;
        final current = container.read(_provider).requireValue;
        expect(current.posts.map((post) => post.id), ['fresh-first']);
        expect(current.loadMoreError, isNull);
        expect(current.isLoadingMore, isFalse);
      },
    );
    test(
      'news append ${failure ? 'failure' : 'response'} completes safely after disposal',
      () async {
        final api = _Api();
        final container = ProviderContainer(
          overrides: [newsApiServiceProvider.overrideWithValue(api)],
        );
        container.listen(_provider, (_, _) {});
        final initial = container.read(_provider.future);
        api.requests.single.complete(_page('first'));
        await initial;
        final append = container.read(_provider.notifier).fetchNextPage();
        final pending = api.requests.last;
        container.dispose();
        if (failure) {
          pending.completeError(StateError('Disposed'));
        } else {
          pending.complete(_page('second'));
        }
        await expectLater(append, completes);
      },
    );
  }
}
