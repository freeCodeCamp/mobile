import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/code_radio/models/code_radio_model.dart';
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
import 'package:freecodecamp/news/ui/feed/feed_viewmodel.dart';
import 'package:freecodecamp/news/ui/post/post_view.dart';
import 'package:freecodecamp/news/ui/post/post_viewmodel.dart';
import 'package:freecodecamp/news/ui/widgets/image.dart';
import 'package:freecodecamp/news/ui/widgets/load_error.dart';
import 'package:freecodecamp/news/ui/widgets/post_feed_list.dart';
import 'package:freecodecamp/news/ui/widgets/post_tile.dart';
import 'package:freecodecamp/news/ui/widgets/search_results.dart';
import 'package:freecodecamp/news/ui/widgets/tag_button.dart';
import 'package:freecodecamp/podcasts/controllers/downloads_controller.dart';
import 'package:freecodecamp/podcasts/controllers/library_controller.dart';
import 'package:freecodecamp/podcasts/controllers/player_controller.dart';
import 'package:freecodecamp/podcasts/models/episode_model.dart';
import 'package:freecodecamp/podcasts/models/podcast_model.dart';
import 'package:freecodecamp/podcasts/repositories/download_repository.dart';
import 'package:freecodecamp/podcasts/services/library_service.dart';
import 'package:freecodecamp/podcasts/ui/episode_list/episode_list_view.dart';
import 'package:freecodecamp/podcasts/ui/episode_list/episode_list_viewmodel.dart';
import 'package:freecodecamp/podcasts/ui/podcast_list/podcast_list_viewmodel.dart';
import 'package:freecodecamp/podcasts/ui/widgets/episode_play_button.dart';
import 'package:freecodecamp/podcasts/ui/widgets/podcast_artwork.dart';
import 'package:freecodecamp/podcasts/ui/widgets/podcast_format.dart';
import 'package:freecodecamp/routing/code_radio.dart' as radio_routes;
import 'package:freecodecamp/routing/news.dart' as news_routes;
import 'package:freecodecamp/routing/podcasts.dart' as podcast_routes;
import 'package:freecodecamp/services/audio_service.dart';
import 'package:freecodecamp/widgets/error_retry.dart';
import 'package:freecodecamp/widgets/listen_tabs.dart';
import 'package:freecodecamp/widgets/mini_player.dart';
import 'package:go_router/go_router.dart';

const _author = Author(username: 'learner', id: 'author', name: 'A Learner');
const _tag = Tag(id: 'tag', name: 'JavaScript', slug: 'javascript');
const _post = Post(
  id: 'article',
  slug: 'article',
  title: 'A useful article',
  url: '',
  author: _author,
  tags: [_tag],
  readTimeInMinutes: 5,
  content: Content(html: '<p>Body text.</p>'),
  publishedAt: '2026-10-30T12:00:00Z',
);
const _summary = PostSummary(
  id: 'article',
  slug: 'article',
  title: 'A useful article',
  author: _author,
  tags: [_tag],
  readTimeInMinutes: 5,
  publishedAt: '2026-10-30T12:00:00Z',
);
const _podcast = Podcast(
  id: 'podcast',
  feedUrl: '',
  podcastLink: '',
  title: 'A developer podcast',
  imageLink: '',
  numOfEps: 1051,
);
final _episode = Episode(
  id: 'episode',
  podcastId: 'podcast',
  title: 'A useful conversation',
  audioUrl: '',
  description: '<p>Useful show notes for this conversation.</p>',
  duration: const Duration(hours: 1, minutes: 19),
  publicationDate: DateTime(2026, 5, 19),
);
const _song = Song(
  id: 'song',
  title: 'A good song',
  artist: 'An artist',
  album: '',
  art: '',
);
const _radio = CodeRadio(
  station: Station(listenUrl: ''),
  listeners: Listeners(total: 123),
  nowPlaying: NowPlaying(duration: 120, elapsed: 30, song: _song),
  playingNext: PlayingNext(song: _song),
);

class _Audio extends BaseAudioHandler implements AudioPlayerHandler {
  @override
  String? get codeRadioSongId => null;
  @override
  bool get isPlayingCodeRadio => false;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Feed extends NewsFeedNotifier {
  _Feed({this.withRows = false});
  final bool withRows;
  @override
  FutureOr<NewsFeedState> build(NewsFeedSource source) => NewsFeedState(
    posts: [
      _summary,
      if (withRows) _summary.copyWith(id: 'two', title: 'Second story'),
      if (withRows) _summary.copyWith(id: 'three', title: 'Third story'),
    ],
    hasNextPage: false,
  );
}

class _FeedError extends _Feed {
  @override
  Future<NewsFeedState> build(NewsFeedSource source) async =>
      throw StateError('Offline');
}

class _Bookmarks extends NewsBookmarksNotifier {
  @override
  Future<List<BookmarkedPost>> build() async => [];
}

class _Search extends NewsSearchNotifier {
  @override
  AsyncValue<List<SearchPost>> build() => const AsyncData([]);
  @override
  void search(String term) => state = const AsyncData([]);
}

class _SearchError extends _Search {
  @override
  void search(String term) =>
      state = AsyncError(StateError('Offline'), StackTrace.empty);
}

class _Library extends PodcastLibraryNotifier {
  _Library({this.downloaded = false});
  final bool downloaded;
  @override
  Future<PodcastLibrary> build() async => (
    podcasts: [_podcast],
    episodesByPodcastId: {
      'podcast': [if (downloaded) _episode],
    },
    artworkByPodcastId: <String, File>{},
  );
}

class _Downloads extends PodcastDownloadsNotifier {
  @override
  Map<String, DownloadStatus> build() => {};
}

class _Player extends PodcastPlayerNotifier {
  @override
  PodcastPlayerState build() => const PodcastPlayerState();
  @override
  Future<void> toggle(Podcast podcast, Episode episode) async {
    state = state.copyWith(
      episodeId: episode.id,
      isPlaying: !state.isPlaying,
      duration: episode.duration,
    );
  }
}

class _Episodes extends PodcastEpisodesNotifier {
  @override
  FutureOr<PodcastEpisodesState> build(PodcastEpisodeSource source) =>
      PodcastEpisodesState(podcast: _podcast, episodes: [_episode]);
}

Future<GoRouter> _pumpRoutes(
  WidgetTester tester, {
  String path = '/news',
  double scale = 1,
  bool searchError = false,
  bool feedError = false,
  bool withRows = false,
  bool downloaded = false,
  int? downloadedBytes,
  AudioPlayerHandler? audio,
  Brightness brightness = Brightness.dark,
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final router = GoRouter(
    initialLocation: path,
    routes: [
      ...news_routes.$appRoutes,
      ...podcast_routes.$appRoutes,
      ...radio_routes.$appRoutes,
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        audioHandlerProvider.overrideWithValue(audio ?? _Audio()),
        newsFeedProvider(const NewsFeedSource.all()).overrideWith(
          () => feedError ? _FeedError() : _Feed(withRows: withRows),
        ),
        newsBookmarksProvider.overrideWith(_Bookmarks.new),
        newsSearchProvider.overrideWith(
          () => searchError ? _SearchError() : _Search(),
        ),
        newsPostProvider('article').overrideWith((ref) async => _post),
        podcastListProvider.overrideWith((ref) async => [_podcast]),
        podcastLibraryProvider.overrideWith(
          () => _Library(downloaded: downloaded),
        ),
        podcastDownloadedSizeProvider(
          _episode.podcastId,
          _episode.id,
        ).overrideWith((ref) async => downloadedBytes),
        podcastPlayerProvider.overrideWith(_Player.new),
        podcastDownloadsProvider.overrideWith(_Downloads.new),
        podcastEpisodesProvider(
          const PodcastEpisodeSource.remote('podcast'),
        ).overrideWith(_Episodes.new),
        podcastPlaybackPositionProvider.overrideWith(
          (ref) => Stream.value(Duration.zero),
        ),
        codeRadioNowPlayingProvider.overrideWith((ref) => Stream.value(_radio)),
        codeRadioElapsedProvider.overrideWith((ref) => Stream.value(30)),
      ],
      child: MaterialApp.router(
        theme: brightness == Brightness.dark
            ? FccTheme.themeDark
            : FccTheme.themeLight,
        routerConfig: router,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
  return router;
}

TextStyle _rendered(WidgetTester tester, String label) {
  final text = find.text(label).first;
  final rich = find.descendant(of: text, matching: find.byType(RichText)).first;
  return tester.widget<RichText>(rich).text.style!;
}

Finder _materialInside(Finder finder) =>
    find.descendant(of: finder, matching: find.byType(Material)).first;

void main() {
  for (final entry in ['View bookmarks', 'Search articles']) {
    testWidgets(
      entry == 'View bookmarks'
          ? 'SAVE-N1 real $entry entry supports system back'
          : 'SAVE-N1 inline search preserves Articles navigation',
      (tester) async {
        final router = await _pumpRoutes(tester);
        final feed = tester.element(find.byType(NewsPostFeedList));
        await tester.tap(
          entry == 'View bookmarks' ? find.text(entry) : find.byType(TextField),
        );
        await tester.pumpAndSettle();
        if (entry == 'View bookmarks') {
          expect(router.canPop(), isTrue);
          expect(find.byType(NewsBookmarkFeedView), findsOneWidget);
          expect(find.widgetWithText(AppBar, 'Saved articles'), findsOneWidget);
          await tester.binding.handlePopRoute();
          await tester.pumpAndSettle();
        } else {
          expect(router.canPop(), isFalse);
          expect(router.routeInformationProvider.value.uri.path, '/news');
          expect(
            tester
                .widget<TextField>(find.byType(TextField))
                .focusNode!
                .hasFocus,
            isTrue,
          );
          expect(find.byType(NewsPostTile), findsOneWidget);
          await tester.enterText(find.byType(TextField), 'HTML');
          await tester.pumpAndSettle();
          expect(find.byType(NewsSearchResults), findsOneWidget);
          expect(router.routeInformationProvider.value.uri.path, '/news');
          expect(
            tester.element(find.byType(NewsPostFeedList, skipOffstage: false)),
            same(feed),
          );
          await tester.tap(find.byTooltip('Clear search'));
          await tester.pumpAndSettle();
          expect(find.byType(NewsSearchResults), findsNothing);
          expect(find.byType(NewsPostTile), findsOneWidget);
          expect(tester.element(find.byType(NewsPostFeedList)), same(feed));
          await tester.tap(find.byTooltip('Dismiss keyboard'));
          await tester.pumpAndSettle();
          expect(
            tester
                .widget<TextField>(find.byType(TextField))
                .focusNode!
                .hasFocus,
            isFalse,
          );
        }
        expect(router.routeInformationProvider.value.uri.path, '/news');
        expect(find.byType(NewsFeedView), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
  testWidgets('SAVE-N1 Saved articles error entry supports system back', (
    tester,
  ) async {
    final router = await _pumpRoutes(tester, feedError: true);
    expect(find.byType(NewsLoadError), findsOneWidget);
    await tester.tap(find.text('Saved articles'));
    await tester.pumpAndSettle();
    expect(router.canPop(), isTrue);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/news');
  });
  for (final path in ['/news/bookmarks', '/news/search']) {
    testWidgets(
      path == '/news/bookmarks'
          ? 'SAVE-N1 $path deep link arrow returns to Articles'
          : 'SAVE-N1 $path deep link redirects to inline Articles',
      (tester) async {
        final router = await _pumpRoutes(tester, path: path);
        if (path == '/news/bookmarks') {
          await tester.tap(find.byType(BackButton));
          await tester.pumpAndSettle();
        } else {
          expect(find.byType(BackButton), findsNothing);
          expect(router.canPop(), isFalse);
          expect(
            tester
                .widget<TextField>(find.byType(TextField))
                .focusNode!
                .hasFocus,
            isFalse,
          );
        }
        expect(router.routeInformationProvider.value.uri.path, '/news');
        expect(find.byType(NewsFeedView), findsOneWidget);
      },
    );
    testWidgets(
      path == '/news/bookmarks'
          ? 'SAVE-N1 $path deep link system back returns to Articles'
          : 'SAVE-N1 $path deep link search clears to Articles',
      (tester) async {
        final router = await _pumpRoutes(tester, path: path);
        if (path == '/news/bookmarks') {
          await tester.binding.handlePopRoute();
          await tester.pumpAndSettle();
        } else {
          await tester.enterText(find.byType(TextField), 'HTML');
          await tester.pumpAndSettle();
          expect(find.byType(NewsSearchResults), findsOneWidget);
          await tester.tap(find.byTooltip('Clear search'));
          await tester.pumpAndSettle();
          await tester.tap(find.byTooltip('Dismiss keyboard'));
          await tester.pumpAndSettle();
          expect(find.byType(NewsSearchResults), findsNothing);
          expect(find.byType(NewsPostTile), findsOneWidget);
        }
        expect(router.routeInformationProvider.value.uri.path, '/news');
      },
    );
  }
  testWidgets(
    'LIST-N1 same rendered header bounds on both actual Listen routes',
    (tester) async {
      await _pumpRoutes(tester, path: '/podcasts');
      expect(find.text('1,051 episodes'), findsOneWidget);
      final before = tester.getRect(find.byType(ListenTabs));
      final titleBefore = tester.getRect(find.text('Listen').first);
      expect(before.left, 16);
      expect(before.width, 358);
      expect(_rendered(tester, 'Podcasts').fontFamily, 'Lato');
      await tester.tap(find.text('Code Radio'));
      await tester.pumpAndSettle();
      expect(find.byType(CodeRadioPlayerView), findsOneWidget);
      expect(tester.getRect(find.byType(ListenTabs)), before);
      expect(tester.getRect(find.text('Listen').first), titleBefore);
      expect(_rendered(tester, 'Code Radio').fontFamily, 'Lato');
      expect(_rendered(tester, '0:30').fontFamily, 'JetBrains Mono');
      expect(_rendered(tester, '0:30').fontWeight, FontWeight.w400);
      final art = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(CodeRadioAlbumArt),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(
        tester.getSize(find.byType(CodeRadioAlbumArt)),
        const Size(220, 220),
      );
      final decoration = art.decoration! as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(20));
      expect((decoration.border! as Border).top.color, const Color(0xff3e329c));
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('P1 P2 PODC-N1 PODC-N2 real podcast labels and share sizing', (
    tester,
  ) async {
    await _pumpRoutes(tester, path: '/podcasts/podcast');
    expect(find.byType(PodcastEpisodeListView), findsOneWidget);
    for (final label in ['Play latest', '1 hr 19 min']) {
      expect(_rendered(tester, label).fontFamily, 'Lato');
      expect(_rendered(tester, label).letterSpacing, 0);
    }
    expect(_rendered(tester, '1 hr 19 min').fontSize, 14);
    expect(_rendered(tester, 'Play latest').fontWeight, FontWeight.w900);
    expect(_rendered(tester, 'Episodes').fontSize, 20);
    expect(_rendered(tester, 'Episodes').fontWeight, FontWeight.w900);
    expect(_rendered(tester, 'Newest first').fontSize, 14);
    final share = find.widgetWithIcon(IconButton, Icons.ios_share_rounded);
    expect(tester.getSize(share), const Size(48, 48));
    expect(
      tester.widget<Material>(_materialInside(share)).color,
      Colors.transparent,
    );
  });
  testWidgets('A2 G15 rendered search edge and filter chip height', (
    tester,
  ) async {
    await _pumpRoutes(tester);
    final decoration = tester
        .widget<TextField>(find.byType(TextField))
        .decoration!;
    final border = decoration.enabledBorder! as OutlineInputBorder;
    expect(decoration.fillColor, const Color(0xff2b2140));
    expect(
      border.borderSide,
      const BorderSide(color: Color(0xff4c4066), width: 1.5),
    );
    for (final chip in find.byType(ChoiceChip).evaluate()) {
      expect(
        tester.getSize(find.byWidget(chip.widget)).height,
        greaterThanOrEqualTo(44),
      );
    }
  });
  testWidgets(
    'FEED-N1 AN1 tag/title gaps are 4 and top aligned without top padding',
    (tester) async {
      await _pumpRoutes(tester);
      await tester.pumpWidget(
        MaterialApp(
          theme: FccTheme.themeDark,
          home: const Scaffold(body: NewsPostTile(post: _summary)),
        ),
      );
      await tester.pumpAndSettle();
      final tag = tester.getRect(find.byType(NewsTagButton));
      final title = tester.getRect(find.text(_summary.title));
      final image = tester.getRect(find.byType(NewsImage));
      expect(tag.top, image.top);
      expect(tag.top, tester.getRect(find.byType(NewsPostTile)).top);
      expect(title.top - tag.bottom, closeTo(4, .001));
      expect(_rendered(tester, '#JavaScript').fontWeight, FontWeight.w400);
      expect(_rendered(tester, '#JavaScript').fontFamily, 'JetBrains Mono');
      expect(tag.height, lessThan(24));
    },
  );
  testWidgets('FEED-N1 eyebrow accepts tap48target outside painted text', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    final router = GoRouter(
      initialLocation: '/news',
      routes: [
        GoRoute(
          path: '/news',
          builder: (_, _) => const Scaffold(body: NewsPostTile(post: _summary)),
        ),
        GoRoute(
          path: '/news/tag/javascript',
          builder: (_, _) => const Scaffold(body: Text('Selected tag')),
        ),
        GoRoute(
          path: '/news/article',
          builder: (_, _) => const Scaffold(body: Text('Selected article')),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(theme: FccTheme.themeDark, routerConfig: router),
    );
    await tester.pumpAndSettle();
    final node = tester.getSemantics(find.byType(NewsTagButton));
    expect(node.rect.height, greaterThanOrEqualTo(48));
    final tag = tester.getRect(find.byType(NewsTagButton));
    await tester.tapAt(Offset(tag.left + 8, tag.top + 40));
    await tester.pumpAndSettle();
    expect(find.text('Selected tag'), findsOneWidget);
    semantics.dispose();
  });
  testWidgets('USER-news-tags shortandlong eyebrows start at the title edge', (
    tester,
  ) async {
    await _pumpRoutes(tester);
    for (final name in ['js', 'mcp', 'JavaScript']) {
      final post = _summary.copyWith(
        tags: [Tag(id: name, name: name, slug: name)],
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: FccTheme.themeDark,
          home: Scaffold(body: NewsPostTile(post: post)),
        ),
      );
      await tester.pumpAndSettle();
      final rich = find.descendant(
        of: find.text('#$name'),
        matching: find.byType(RichText),
      );
      expect(
        tester.getRect(rich).left,
        tester.getRect(find.text(post.title)).left,
      );
      expect(tester.takeException(), isNull);
    }
  });
  testWidgets(
    'USER-news-divider leaves14dp above and below every feed separator',
    (tester) async {
      await _pumpRoutes(tester, withRows: true);
      final second = find.byWidgetPredicate(
        (widget) => widget is NewsPostTile && widget.post.id == 'two',
      );
      await tester.ensureVisible(second);
      await tester.pumpAndSettle();
      final tiles = find
          .byType(NewsPostTile)
          .evaluate()
          .map((e) => tester.getRect(find.byWidget(e.widget)))
          .toList();
      final dividers = find
          .byType(Divider)
          .evaluate()
          .where((e) => (e.widget as Divider).height == 29);
      expect(dividers.length, 2);
      for (var index = 0; index < dividers.length; index++) {
        final rect = tester.getRect(
          find.byWidget(dividers.elementAt(index).widget),
        );
        final lineTop = rect.center.dy - .5;
        expect(lineTop - tiles[index].bottom, closeTo(14, .001));
        expect(tiles[index + 1].top - lineTop - 1, closeTo(14, .001));
      }
    },
  );
  testWidgets('ARTI-N1 header aligns at16 and eyebrow/title has4gap', (
    tester,
  ) async {
    await _pumpRoutes(tester, path: '/news/article');
    final header = tester.getRect(find.byType(NewsPostHeader));
    final tag = tester.getRect(find.byType(NewsTagButton).first);
    final title = tester.getRect(find.text(_post.title));
    expect(tag.left, 16);
    expect(title.left, 16);
    expect(tag.top - header.top, 16);
    expect(title.top - tag.bottom, closeTo(4, .001));
    final avatar = find.byWidgetPredicate(
      (widget) => widget is NewsImage && widget.isAvatar,
    );
    expect(
      tester
              .getRect(
                find.ancestor(of: avatar, matching: find.byType(Row)).first,
              )
              .top -
          title.bottom,
      closeTo(4, .001),
    );
  });
  testWidgets('SV1 SAVE-N2 empty glyph padding body and saved title match', (
    tester,
  ) async {
    await _pumpRoutes(tester, path: '/news/bookmarks');
    expect(_rendered(tester, 'Saved articles').fontSize, 16);
    expect(_rendered(tester, 'Saved articles').fontWeight, FontWeight.w700);
    expect(
      _rendered(tester, 'Tap the bookmark on an article to save it.').fontSize,
      15,
    );
    final icon = tester.widget<Icon>(
      find.byIcon(Icons.bookmark_border_rounded),
    );
    expect(icon.size, 28);
    final container = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(NewsSavedEmptyState),
            matching: find.byType(Container),
          )
          .first,
    );
    expect(
      container.padding,
      const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
    );
  });
  testWidgets('S3 actual search failure has body and width at1.3 scale', (
    tester,
  ) async {
    final router = await _pumpRoutes(
      tester,
      path: '/news/search',
      searchError: true,
      scale: 1.3,
    );
    await tester.enterText(find.byType(TextField), 'HTML');
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/news');
    expect(find.byType(NewsFeedView), findsOneWidget);
    expect(find.byType(ErrorRetry), findsOneWidget);
    expect(find.textContaining('Your progress is safe.'), findsOneWidget);
    final card = tester.getRect(find.byType(Card));
    expect(card.left, 16);
    expect(card.width, 358);
    expect(tester.takeException(), isNull);
  });
  for (final brightness in Brightness.values) {
    for (final path in [
      '/news',
      '/news/bookmarks',
      '/news/search',
      '/news/article',
      '/podcasts',
      '/podcasts/podcast',
      '/code-radio',
    ]) {
      testWidgets('media text1.3 screen smoke $path $brightness', (
        tester,
      ) async {
        await _pumpRoutes(
          tester,
          path: path,
          scale: 1.3,
          brightness: brightness,
        );
        expect(tester.takeException(), isNull);
      });
    }
  }
  for (final brightness in Brightness.values) {
    for (final scale in [1.0, 1.3]) {
      testWidgets(
        'EPIS-N1 EP2 EPN1 EPIS-N2 player metrics and scaling $brightness $scale',
        (tester) async {
          final router = await _pumpRoutes(
            tester,
            path: '/podcasts',
            brightness: brightness,
            scale: scale,
          );
          unawaited(
            router.push(
              '/podcasts/podcast/episode',
              extra: (_podcast, _episode),
            ),
          );
          await tester.pumpAndSettle();
          final artwork = tester.widget<PodcastArtwork>(
            find.byType(PodcastArtwork),
          );
          expect(artwork.size, 250);
          expect(artwork.radius, 20);
          expect(
            artwork.borderColor,
            FccDesignColors.of(
              tester.element(find.byType(PodcastArtwork)),
            ).artworkBorder,
          );
          expect(
            tester.getSize(find.byType(EpisodePlayButton)),
            const Size.square(72),
          );
          final skip = find.widgetWithText(TextButton, '10');
          expect(tester.widget<TextButton>(skip).onPressed, isNull);
          expect(
            tester.widget<Material>(_materialInside(skip)).color,
            Colors.transparent,
          );
          expect(
            tester.widget<Icon>(find.byIcon(Icons.replay_rounded).first).size,
            24,
          );
          expect(
            find.text('Press play to use speed and skip controls.'),
            findsOneWidget,
          );
          expect(_rendered(tester, '0:00').fontWeight, FontWeight.w400);
          final speed = find.widgetWithText(OutlinedButton, '1×');
          expect(tester.getSize(_materialInside(speed)), const Size(52, 44));
          expect(
            tester.widget<Material>(_materialInside(speed)).color,
            Colors.transparent,
          );
          final download = find.widgetWithIcon(
            IconButton,
            Icons.download_rounded,
          );
          expect(tester.getSize(_materialInside(download)), const Size(52, 44));
          final shape =
              tester.widget<Material>(_materialInside(speed)).shape!
                  as RoundedRectangleBorder;
          expect(shape.borderRadius, BorderRadius.circular(999));
          await tester.ensureVisible(find.text('Show notes'));
          expect(_rendered(tester, 'Show notes').fontSize, 15);
          expect(_rendered(tester, 'Show notes').fontWeight, FontWeight.w900);
          expect(_rendered(tester, 'Read all').fontSize, 14);
          expect(
            _rendered(tester, 'Read all').decoration,
            TextDecoration.underline,
          );
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
  testWidgets('EP3 downloaded metadata shows actual size and completion', (
    tester,
  ) async {
    final router = await _pumpRoutes(
      tester,
      path: '/podcasts',
      downloaded: true,
      downloadedBytes: 54000000,
    );
    unawaited(
      router.push('/podcasts/podcast/episode', extra: (_podcast, _episode)),
    );
    await tester.pumpAndSettle();
    expect(
      find.text('May 19, 2026 · 1 hr 19 min · 54 MB · Downloaded'),
      findsOneWidget,
    );
  });
  testWidgets(
    'USER-player dismiss stops and clears persistent player across tabs; explicit playback can reopen',
    (tester) async {
      final audio = _PlaybackAudio()..start();
      final router = await _pumpRoutes(tester, audio: audio, scale: 1.3);
      expect(find.byTooltip('Dismiss player'), findsOneWidget);
      expect(
        tester.getSize(find.byTooltip('Dismiss player')).shortestSide,
        greaterThanOrEqualTo(48),
      );
      router.go('/podcasts');
      await tester.pumpAndSettle();
      expect(find.byTooltip('Dismiss player'), findsOneWidget);
      await tester.tap(find.byTooltip('Dismiss player'));
      await tester.pumpAndSettle();
      expect(audio.stops, 1);
      expect(audio.playbackState.value.playing, isFalse);
      expect(audio.mediaItem.value, isNull);
      expect(find.byTooltip('Dismiss player'), findsNothing);
      router.go('/news');
      await tester.pumpAndSettle();
      expect(find.byTooltip('Dismiss player'), findsNothing);
      expect(audio.plays, 0);
      audio.start(playing: false);
      await tester.pumpAndSettle();
      expect(find.byType(MiniPlayer), findsOneWidget);
      await tester.tap(find.byTooltip('Resume audio'));
      await tester.pumpAndSettle();
      expect(audio.plays, 1);
      expect(find.byTooltip('Pause audio'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  test('EP3 size labels use locale, one decimal under10MB', () {
    expect(podcastFileSize(54000000, 'en_US'), '54 MB');
    expect(podcastFileSize(1500000, 'en_US'), '1.5 MB');
    expect(podcastFileSize(1500000, 'nl_NL'), '1,5 MB');
    expect(podcastFileSize(1234000000, 'en_US'), '1,234 MB');
  });
  test('EP3 local size is real and missing files omit metadata', () async {
    final dir = await Directory.systemTemp.createTemp('episode-size-test');
    addTearDown(() => dir.delete(recursive: true));
    final file = File('${dir.path}/episode.mp3');
    final repository = _LocalDownloads(file);
    expect(await repository.episodeSize('podcast', 'episode'), isNull);
    await file.writeAsBytes(List.filled(1234, 0));
    expect(await repository.episodeSize('podcast', 'episode'), 1234);
  });
}

class _LocalDownloads extends PodcastDownloadRepository {
  _LocalDownloads(this.file) : super(Dio());
  final File file;
  @override
  Future<File> episodeFile(String podcastId, String episodeId) async => file;
}

class _PlaybackAudio extends _Audio {
  bool loaded = false;
  int stops = 0;
  int plays = 0;
  @override
  String? get episodeId => loaded ? _episode.id : null;
  @override
  Duration? get duration => _episode.duration;
  @override
  Stream<Duration> get positionStream =>
      Stream.value(const Duration(minutes: 2));
  @override
  (Podcast, Episode)? get currentPodcastEpisode =>
      loaded ? (_podcast, _episode) : null;
  void start({bool playing = true}) {
    loaded = true;
    mediaItem.add(
      MediaItem(
        id: _episode.id,
        title: _episode.title,
        duration: _episode.duration,
      ),
    );
    playbackState.add(
      PlaybackState(
        playing: playing,
        processingState: AudioProcessingState.ready,
      ),
    );
  }

  @override
  Future<void> stop() async {
    stops++;
    loaded = false;
    playbackState.add(PlaybackState());
    mediaItem.add(null);
  }

  @override
  Future<void> play() async {
    if (!loaded) return;
    plays++;
    playbackState.add(playbackState.value.copyWith(playing: true));
  }
}
