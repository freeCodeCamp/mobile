// These fixtures override root providers; no nested app scope is created.
// ignore_for_file: riverpod_lint/scoped_providers_should_specify_dependencies

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/code_radio/ui/player/player_view.dart';
import 'package:freecodecamp/code_radio/ui/player/player_viewmodel.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/news/controllers/bookmarks_controller.dart';
import 'package:freecodecamp/news/controllers/feed_controller.dart';
import 'package:freecodecamp/news/models/author_model.dart';
import 'package:freecodecamp/news/models/bookmarked_post_model.dart';
import 'package:freecodecamp/news/models/post_model.dart';
import 'package:freecodecamp/news/models/post_summary_model.dart';
import 'package:freecodecamp/news/models/search_post_model.dart';
import 'package:freecodecamp/news/ui/bookmark_feed/bookmark_feed_view.dart';
import 'package:freecodecamp/news/ui/feed/feed_view.dart';
import 'package:freecodecamp/news/ui/post/post_view.dart';
import 'package:freecodecamp/news/ui/search/search_view.dart';
import 'package:freecodecamp/news/ui/search/search_viewmodel.dart';
import 'package:freecodecamp/news/ui/widgets/article_reader.dart';
import 'package:freecodecamp/news/ui/widgets/news_image.dart';
import 'package:freecodecamp/news/ui/widgets/offline_banner.dart';
import 'package:freecodecamp/news/ui/widgets/post_feed_skeleton.dart';
import 'package:freecodecamp/news/ui/widgets/post_tile.dart';
import 'package:freecodecamp/news/ui/widgets/search_result_tile.dart';
import 'package:freecodecamp/news/ui/widgets/tag_button.dart';
import 'package:freecodecamp/podcasts/controllers/downloads_controller.dart';
import 'package:freecodecamp/podcasts/controllers/library_controller.dart';
import 'package:freecodecamp/podcasts/controllers/player_controller.dart';
import 'package:freecodecamp/podcasts/models/episode_model.dart';
import 'package:freecodecamp/podcasts/models/podcast_model.dart';
import 'package:freecodecamp/podcasts/services/library_service.dart';
import 'package:freecodecamp/podcasts/ui/episode/episode_view.dart';
import 'package:freecodecamp/podcasts/ui/widgets/download_button.dart';
import 'package:freecodecamp/podcasts/ui/widgets/episode_play_button.dart';
import 'package:freecodecamp/podcasts/ui/widgets/episode_tile.dart';
import 'package:freecodecamp/podcasts/ui/widgets/podcast_artwork.dart';
import 'package:freecodecamp/podcasts/ui/widgets/podcast_grid_tile.dart';
import 'package:freecodecamp/widgets/listen_tabs.dart';
import 'package:go_router/go_router.dart';

const _author = Author(username: 'camper', id: 'author', name: 'A Camper');
const _tag = Tag(id: 'tag', name: 'JavaScript', slug: 'javascript');
const _post = Post(
  id: 'article',
  slug: 'article',
  title: 'A useful article',
  url: '',
  author: _author,
  tags: [_tag],
  readTimeInMinutes: 5,
  content: Content(html: '<h2>A heading</h2><p>Article body.</p>'),
  publishedAt: '2026-09-30T12:00:00Z',
);
const _summary = PostSummary(
  id: 'article',
  slug: 'article',
  title: 'A useful article',
  author: _author,
  tags: [_tag],
  readTimeInMinutes: 5,
  publishedAt: '2026-09-30T12:00:00Z',
);
const _saved = BookmarkedPost(
  id: 'article',
  title: 'A saved article',
  authorName: 'A Camper',
  text: '<p>Saved.</p>',
);
const _podcast = Podcast(
  id: 'podcast',
  feedUrl: '',
  podcastLink: '',
  title: 'A developer podcast',
  imageLink: '',
  numOfEps: 100,
);
final _episode = Episode(
  id: 'episode',
  podcastId: 'podcast',
  title: '#217 A useful conversation about programming',
  audioUrl: '',
  duration: const Duration(hours: 1, minutes: 19),
  publicationDate: DateTime(2026, 5, 19),
);

class _Search extends NewsSearchNotifier {
  final terms = <String>[];
  @override
  AsyncValue<List<SearchPost>> build() => const AsyncData([]);
  @override
  void search(String term) {
    terms.add(term);
    state = const AsyncData([]);
  }
}

class _Bookmarks extends NewsBookmarksNotifier {
  _Bookmarks(this.posts);
  final List<BookmarkedPost> posts;
  @override
  Future<List<BookmarkedPost>> build() async => posts;
}

class _Feed extends NewsFeedNotifier {
  _Feed({this.loading = false});
  final bool loading;
  @override
  FutureOr<NewsFeedState> build(NewsFeedSource source) => loading
      ? Completer<NewsFeedState>().future
      : const NewsFeedState(posts: [_summary], hasNextPage: false);
}

class _Library extends PodcastLibraryNotifier {
  bool _downloaded = false;
  int _removeCalls = 0;
  PodcastLibrary get _library => (
    podcasts: [_podcast],
    episodesByPodcastId: {
      'podcast': [if (_downloaded) _episode],
    },
    artworkByPodcastId: {},
  );
  @override
  Future<PodcastLibrary> build() async => _library;
  void save(bool value) {
    _downloaded = value;
    state = AsyncData(_library);
  }

  @override
  Future<void> remove(String podcastId, String episodeId) async {
    _removeCalls++;
    save(false);
  }
}

class _Downloads extends PodcastDownloadsNotifier {
  int _starts = 0;
  int _cancels = 0;
  @override
  Map<String, DownloadStatus> build() => {};
  @override
  Future<void> start(Podcast podcast, Episode episode) async {
    _starts++;
    state = {episode.id: const DownloadStatus.running(.5)};
  }

  @override
  void cancel(String episodeId) {
    _cancels++;
    state = {};
  }
}

class _Player extends PodcastPlayerNotifier {
  int _toggles = 0;
  @override
  PodcastPlayerState build() => const PodcastPlayerState();
  @override
  Future<void> toggle(Podcast podcast, Episode episode) async {
    _toggles++;
    state = state.copyWith(
      episodeId: episode.id,
      isPlaying: !state.isPlaying,
      duration: episode.duration,
    );
  }

  @override
  Future<void> rewind() async {}

  @override
  Future<void> fastForward() async {}

  @override
  Future<void> seek(Duration position) async {}

  @override
  Future<void> setSpeed(double speed) async {
    state = state.copyWith(speed: speed);
  }
}

Future<void> _pump(
  WidgetTester tester,
  Widget page,
  Brightness brightness,
) async {
  tester.view.physicalSize = const Size(360, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MaterialApp(
      theme: brightness == Brightness.dark
          ? FccTheme.themeDark
          : FccTheme.themeLight,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(1.3)),
        child: child!,
      ),
      home: page,
    ),
  );
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
}

TextStyle _textStyle(WidgetTester tester, String label) {
  final finder = find.text(label);
  return DefaultTextStyle.of(
    tester.element(finder),
  ).style.merge(tester.widget<Text>(finder).style);
}

void main() {
  for (final brightness in Brightness.values) {
    testWidgets(
      'search suggestions replace query and suppress zero count ($brightness)',
      (tester) async {
        final search = _Search();
        await _pump(
          tester,
          ProviderScope(
            overrides: [newsSearchProvider.overrideWith(() => search)],
            child: const Scaffold(body: NewsSearchView()),
          ),
          brightness,
        );
        await tester.enterText(find.byType(TextField), 'no matching articles');
        await tester.pumpAndSettle();
        expect(find.byType(NewsSearchEmptyState), findsOneWidget);
        expect(find.textContaining('0 results for'), findsNothing);
        expect(_textStyle(tester, 'No articles found').fontSize, 20);
        expect(
          _textStyle(tester, 'No articles found').fontWeight,
          FontWeight.w900,
        );
        await tester.ensureVisible(find.widgetWithText(ActionChip, 'Python'));
        await tester.tap(find.widgetWithText(ActionChip, 'Python'));
        await tester.pumpAndSettle();
        expect(search.terms.last, 'Python');
        expect(
          tester.widget<TextField>(find.byType(TextField)).controller!.text,
          'Python',
        );
        final decoration = tester
            .widget<TextField>(find.byType(TextField))
            .decoration!;
        final focused = decoration.focusedBorder! as OutlineInputBorder;
        expect(focused.borderRadius, BorderRadius.circular(12));
        expect(focused.borderSide.width, 2);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'saved empty state browses articles; banner requires saved items ($brightness)',
      (tester) async {
        final router = GoRouter(
          initialLocation: '/saved',
          routes: [
            GoRoute(
              path: '/saved',
              builder: (_, _) => const Scaffold(body: NewsBookmarkFeedView()),
            ),
            GoRoute(
              path: '/news',
              builder: (_, _) =>
                  const Scaffold(body: Text('Article destination')),
            ),
          ],
        );
        addTearDown(router.dispose);
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              newsBookmarksProvider.overrideWith(() => _Bookmarks([])),
            ],
            child: MaterialApp.router(
              theme: brightness == Brightness.dark
                  ? FccTheme.themeDark
                  : FccTheme.themeLight,
              routerConfig: router,
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(OfflineBanner), findsNothing);
        expect(
          find.text('Tap the bookmark on an article to save it.'),
          findsOneWidget,
        );
        await tester.tap(find.widgetWithText(FilledButton, 'Browse articles'));
        await tester.pumpAndSettle();
        expect(find.text('Article destination'), findsOneWidget);
        await _pump(
          tester,
          ProviderScope(
            overrides: [
              newsBookmarksProvider.overrideWith(() => _Bookmarks([_saved])),
            ],
            child: const Scaffold(body: NewsBookmarkFeedView()),
          ),
          brightness,
        );
        expect(find.byType(OfflineBanner), findsOneWidget);
        expect(_textStyle(tester, 'A saved article').fontSize, 15);
        final image = tester.widget<NewsImage>(find.byType(NewsImage));
        expect((image.width, image.height, image.radius), (64, 64, 10));
        final banner = tester.widget<Container>(
          find.descendant(
            of: find.byType(OfflineBanner),
            matching: find.byType(Container),
          ),
        );
        final colors = FccDesignColors.of(
          tester.element(find.byType(OfflineBanner)),
        );
        expect(
          (banner.decoration! as BoxDecoration).color,
          colors.successContainer,
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'feed skeleton retains search and tag typography is contextual ($brightness)',
      (tester) async {
        await _pump(
          tester,
          ProviderScope(
            overrides: [
              newsFeedProvider(
                const NewsFeedSource.all(),
              ).overrideWith(() => _Feed(loading: true)),
            ],
            child: const Scaffold(body: NewsFeedView()),
          ),
          brightness,
        );
        expect(find.byType(PostFeedSkeleton), findsOneWidget);
        expect(find.text('Search articles'), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNothing);
        await _pump(
          tester,
          const Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  TagButton(
                    tagName: 'List',
                    tagSlug: 'list',
                    variant: TagButtonVariant.listEyebrow,
                  ),
                  TagButton(
                    tagName: 'Header',
                    tagSlug: 'header',
                    variant: TagButtonVariant.articleEyebrow,
                  ),
                  TagButton(tagName: 'Footer', tagSlug: 'footer'),
                  PostTile(post: _summary),
                ],
              ),
            ),
          ),
          brightness,
        );
        expect(_textStyle(tester, '#List').fontFamily, 'JetBrains Mono');
        expect(_textStyle(tester, '#List').fontSize, 12);
        expect(_textStyle(tester, '#Header').fontSize, 14);
        expect(
          _textStyle(tester, '#Footer').decoration,
          TextDecoration.underline,
        );
        expect(_textStyle(tester, '#Footer').fontSize, 15);
        expect(_textStyle(tester, 'A useful article').fontSize, 15);
        final image = tester.widget<NewsImage>(find.byType(NewsImage));
        expect((image.width, image.height, image.radius), (104, 70, 8));
      },
    );

    testWidgets('article dates and header use audited metrics ($brightness)', (
      tester,
    ) async {
      await _pump(
        tester,
        const Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                NewsPostHeader(post: _post),
                SearchResultTile(
                  post: SearchPost(
                    objectID: 'result',
                    title: 'Search result',
                    url: 'https://example.invalid/result',
                    author: SearchAuthor(name: 'A Camper'),
                    publishedAt: '2026-09-30T12:00:00Z',
                  ),
                ),
              ],
            ),
          ),
        ),
        brightness,
      );
      expect(find.text('Sep 30, 2026 · 5 min read'), findsOneWidget);
      expect(find.text('A Camper · Sep 30, 2026'), findsOneWidget);
      expect(_textStyle(tester, 'A useful article').fontSize, 26);
      expect(
        _textStyle(tester, 'A useful article').fontWeight,
        FontWeight.w900,
      );
      expect(_textStyle(tester, 'Search result').fontSize, 15);
      await _pump(
        tester,
        const ArticleReader(
          html: '<h2>Section title</h2><p>Body text.</p>',
          header: SizedBox.shrink(),
          bookmarkButton: SizedBox.shrink(),
        ),
        brightness,
      );
      expect(
        tester
            .widget<LinearProgressIndicator>(
              find.byType(LinearProgressIndicator),
            )
            .minHeight,
        4,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'podcast rows and play pill preserve playback action ($brightness)',
      (tester) async {
        final player = _Player();
        final library = _Library();
        await _pump(
          tester,
          ProviderScope(
            overrides: [
              podcastPlayerProvider.overrideWith(() => player),
              podcastLibraryProvider.overrideWith(() => library),
              podcastDownloadsProvider.overrideWith(_Downloads.new),
              podcastPlaybackPositionProvider.overrideWith(
                (ref) => Stream.value(Duration.zero),
              ),
            ],
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const ListenTabs(isRadio: false),
                    PodcastGridTile(podcast: _podcast, onTap: () {}),
                    PodcastEpisodeTile(podcast: _podcast, episode: _episode),
                  ],
                ),
              ),
            ),
          ),
          brightness,
        );
        expect(find.text('100 episodes'), findsOneWidget);
        expect(_textStyle(tester, 'A developer podcast').fontSize, 15);
        final art = tester.widget<PodcastArtwork>(find.byType(PodcastArtwork));
        expect((art.size, art.radius), (52, 8));
        final pillFinder = find.descendant(
          of: find.byType(EpisodePlayButton),
          matching: find.byType(OutlinedButton),
        );
        final pill = tester.widget<OutlinedButton>(pillFinder);
        expect(pill.style!.fixedSize!.resolve({})!.height, 36);
        expect(tester.getSize(pillFinder).height, greaterThanOrEqualTo(44));
        expect(_textStyle(tester, '1 hr 19 min').fontSize, 13);
        expect(_textStyle(tester, '#217').fontSize, 14);
        expect(_textStyle(tester, '#217').fontWeight, FontWeight.w900);
        await tester.tap(pillFinder);
        await tester.pumpAndSettle();
        expect(player._toggles, 1);
        expect(find.byTooltip('Pause episode'), findsOneWidget);
        await tester.tap(pillFinder);
        await tester.pumpAndSettle();
        expect(player._toggles, 2);
        expect(find.byTooltip('Play episode'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'download metadata and actions use library completion ($brightness)',
      (tester) async {
        final library = _Library();
        final downloads = _Downloads();
        await _pump(
          tester,
          ProviderScope(
            overrides: [
              podcastLibraryProvider.overrideWith(() => library),
              podcastDownloadsProvider.overrideWith(() => downloads),
            ],
            child: Scaffold(
              body: Column(
                children: [
                  PodcastEpisodeMetadata(episode: _episode),
                  PodcastDownloadButton(
                    podcast: _podcast,
                    episode: _episode,
                    outlined: true,
                  ),
                ],
              ),
            ),
          ),
          brightness,
        );
        expect(find.text('May 19, 2026 · 1 hr 19 min'), findsOneWidget);
        await tester.tap(find.byTooltip('Download episode'));
        await tester.pump();
        expect(downloads._starts, 1);
        expect(find.textContaining('Downloaded'), findsNothing);
        await tester.tap(find.byTooltip('Cancel download'));
        await tester.pumpAndSettle();
        expect(downloads._cancels, 1);
        library.save(true);
        await tester.pumpAndSettle();
        expect(
          find.text('May 19, 2026 · 1 hr 19 min · Downloaded'),
          findsOneWidget,
        );
        await tester.tap(find.byTooltip('Remove download'));
        await tester.pumpAndSettle();
        expect(library._removeCalls, 1);
        expect(find.textContaining('Downloaded'), findsNothing);
      },
    );

    testWidgets(
      'skip controls and radio timestamps are accessible ($brightness)',
      (tester) async {
        var rewind = 0;
        var forward = 0;
        await _pump(
          tester,
          ProviderScope(
            overrides: [
              codeRadioElapsedProvider.overrideWith((ref) => Stream.value(30)),
            ],
            child: Scaffold(
              body: Column(
                children: [
                  Row(
                    children: [
                      PodcastSkipButton(
                        seconds: 10,
                        forward: false,
                        onPressed: () => rewind++,
                      ),
                      PodcastSkipButton(
                        seconds: 30,
                        forward: true,
                        onPressed: () => forward++,
                      ),
                    ],
                  ),
                  const CodeRadioProgressBar(duration: 120),
                  const Expanded(
                    child: SingleChildScrollView(child: CodeRadioSkeleton()),
                  ),
                ],
              ),
            ),
          ),
          brightness,
        );
        expect(find.byIcon(Icons.replay_10_rounded), findsNothing);
        expect(find.byIcon(Icons.forward_30_rounded), findsNothing);
        await tester.tap(find.byTooltip('Rewind 10 seconds'));
        await tester.tap(find.byTooltip('Forward 30 seconds'));
        expect((rewind, forward), (1, 1));
        expect(_textStyle(tester, '0:30').fontFamily, 'JetBrains Mono');
        expect(_textStyle(tester, '0:30').fontSize, 12);
        expect(_textStyle(tester, '-1:30').fontWeight, FontWeight.w700);
        expect(
          const PodcastSeekThumb().getPreferredSize(true, false),
          const Size(18, 18),
        );
        expect(tester.takeException(), isNull);
      },
    );
  }
}
