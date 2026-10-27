import 'dart:io';
import 'dart:ui' as ui;

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/news/controllers/bookmarks_controller.dart';
import 'package:freecodecamp/news/controllers/feed_controller.dart';
import 'package:freecodecamp/news/models/author_model.dart';
import 'package:freecodecamp/news/models/bookmarked_post_model.dart';
import 'package:freecodecamp/news/models/post_model.dart';
import 'package:freecodecamp/news/models/post_summary_model.dart';
import 'package:freecodecamp/news/ui/widgets/bookmark_button.dart';
import 'package:freecodecamp/news/ui/widgets/post_feed_list.dart';
import 'package:freecodecamp/news/ui/widgets/post_tile.dart';
import 'package:freecodecamp/news/ui/widgets/tag_button.dart';
import 'package:freecodecamp/podcasts/controllers/library_controller.dart';
import 'package:freecodecamp/podcasts/controllers/player_controller.dart';
import 'package:freecodecamp/podcasts/models/episode_model.dart';
import 'package:freecodecamp/podcasts/models/podcast_model.dart';
import 'package:freecodecamp/podcasts/services/library_service.dart';
import 'package:freecodecamp/podcasts/ui/episode_list/episode_list_viewmodel.dart';
import 'package:freecodecamp/podcasts/ui/podcast_list/podcast_list_viewmodel.dart';
import 'package:freecodecamp/routing/news.dart' as news;
import 'package:freecodecamp/routing/podcasts.dart' as podcasts;
import 'package:freecodecamp/services/audio_service.dart';
import 'package:go_router/go_router.dart';

const _author = Author(
  username: 'camper',
  id: 'author',
  name: 'Casmir Onyekani',
);
const _tag = Tag(id: 'hackathon', name: 'Hackathon', slug: 'hackathon');
const _posts = [
  PostSummary(
    id: 'portfolio',
    slug: 'portfolio',
    title:
        'How to Level Up Your Portfolio in the AI Era: From Technical Writer to Developer Educator',
    author: _author,
    tags: [_tag],
    readTimeInMinutes: 8,
    publishedAt: '2026-10-08T12:00:00Z',
  ),
  PostSummary(
    id: 'hackathon',
    slug: 'hackathon',
    title: 'Inside a Hong Kong Hackathon [Full freeCodeCamp Documentary]',
    author: Author(username: 'beau', id: 'beau', name: 'Beau Carnes'),
    tags: [_tag],
    readTimeInMinutes: 5,
    publishedAt: '2026-10-05T12:00:00Z',
  ),
  PostSummary(
    id: 'architecture',
    slug: 'architecture',
    title:
        'How Executable Operational Specifications Can Make Software Automation Verifiable',
    author: _author,
    tags: [
      Tag(
        id: 'architecture',
        name: 'Software architecture',
        slug: 'architecture',
      ),
    ],
    readTimeInMinutes: 10,
    publishedAt: '2026-10-05T12:00:00Z',
  ),
];
const _podcasts = [
  Podcast(
    id: 'fcc',
    feedUrl: 'https://freecodecamp.libsyn.com/rss',
    podcastLink: 'https://freecodecamp.org',
    title: 'The freeCodeCamp Podcast',
    imageLink: '',
    numOfEps: 100,
  ),
  Podcast(
    id: 'es',
    feedUrl: 'https://anchor.fm/s/ff0092f4/podcast/rss',
    podcastLink: 'https://freecodecamp.org/espanol',
    title: 'freeCodeCamp Podcast en Español',
    imageLink: '',
    numOfEps: 59,
  ),
  Podcast(
    id: 'syntax',
    feedUrl: 'https://syntax.fm/rss',
    podcastLink: 'https://syntax.fm',
    title: 'Syntax - Tasty Web Development Treats',
    imageLink: '',
    numOfEps: 1042,
  ),
  Podcast(
    id: 'changelog',
    feedUrl: 'https://changelog.com/rss',
    podcastLink: 'https://changelog.com',
    title: 'The Changelog: Software Development, Open Source',
    imageLink: '',
    numOfEps: 1014,
  ),
  Podcast(
    id: 'codenewbie',
    feedUrl: 'https://codenewbie.org/rss',
    podcastLink: 'https://codenewbie.org',
    title: 'CodeNewbie',
    imageLink: '',
    numOfEps: 366,
  ),
];
final _episodes = [
  Episode(
    id: '217',
    podcastId: 'fcc',
    title:
        '#217 Stanford’s youngest instructor on InfoSec, AI, catching cheaters - Rachel Fernandez',
    description:
        '<p>Today Quincy Larson interviews Rachel Ann Fernandez about teaching and learning to code.</p>',
    publicationDate: DateTime(2026, 5, 19),
    audioUrl: 'https://example.com/episode.mp3',
    duration: const Duration(hours: 1, minutes: 19),
  ),
  Episode(
    id: '216',
    podcastId: 'fcc',
    title:
        '#216 How to friction-max your learning with software engineer Jessica Rose',
    publicationDate: DateTime(2026, 4, 17),
    audioUrl: 'https://example.com/episode.mp3',
    duration: const Duration(minutes: 53),
  ),
  Episode(
    id: '215',
    podcastId: 'fcc',
    title: '#215 How to learn programming and CS in the AI hype era',
    publicationDate: DateTime(2026, 4, 10),
    audioUrl: 'https://example.com/episode.mp3',
    duration: const Duration(hours: 1, minutes: 16),
  ),
];

class _Feed extends NewsFeedNotifier {
  @override
  Future<NewsFeedState> build(NewsFeedSource source) async => NewsFeedState(
    posts: source is TagPosts
        ? _posts.where((p) => p.tags.any((t) => t.slug == source.slug)).toList()
        : _posts,
    hasNextPage: false,
  );
}

class _TopicFeed extends NewsFeedNotifier {
  @override
  Future<NewsFeedState> build(NewsFeedSource source) async => NewsFeedState(
    posts: [
      _posts[1],
      _posts[2].copyWith(tags: [_tag, ..._posts[2].tags]),
    ],
    hasNextPage: false,
  );
}

class _Bookmarks extends NewsBookmarksNotifier {
  @override
  Future<List<BookmarkedPost>> build() async => const [
    BookmarkedPost(
      id: 'portfolio',
      title: 'How to Level Up Your Portfolio in the AI Era',
      authorName: 'Casmir Onyekani',
      text: '<p>A saved tutorial.</p>',
    ),
  ];
}

class _Library extends PodcastLibraryNotifier {
  @override
  Future<PodcastLibrary> build() async => (
    podcasts: [_podcasts.first],
    episodesByPodcastId: {
      'fcc': [_episodes[1]],
    },
    artworkByPodcastId: <String, File>{},
  );
}

class _Episodes extends PodcastEpisodesNotifier {
  @override
  Future<PodcastEpisodesState> build(PodcastEpisodeSource source) async =>
      PodcastEpisodesState(podcast: _podcasts.first, episodes: _episodes);
}

class _Player extends PodcastPlayerNotifier {
  @override
  PodcastPlayerState build() => const PodcastPlayerState();
}

class _Audio extends BaseAudioHandler implements AudioPlayerHandler {
  @override
  (Podcast, Episode)? get currentPodcastEpisode => null;
  @override
  String? get episodeId => null;
  @override
  Stream<Duration> get positionStream => const Stream.empty();
  @override
  Duration? get duration => null;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final _capture = GlobalKey();

Future<GoRouter> _pump(
  WidgetTester tester,
  String location, {
  bool dark = false,
  double scale = 1,
  double width = 390,
  double height = 844,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, height);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final router = GoRouter(
    initialLocation: location,
    routes: [...news.$appRoutes, ...podcasts.$appRoutes],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        audioHandlerProvider.overrideWithValue(_Audio()),
        newsFeedProvider.overrideWith2((source) => _Feed()),
        newsBookmarksProvider.overrideWith(_Bookmarks.new),
        podcastListProvider.overrideWith((ref) async => _podcasts),
        podcastLibraryProvider.overrideWith(_Library.new),
        podcastEpisodesProvider.overrideWith2((source) => _Episodes()),
        podcastPlayerProvider.overrideWith(_Player.new),
      ],
      child: RepaintBoundary(
        key: _capture,
        child: MaterialApp.router(
          routerConfig: router,
          debugShowCheckedModeBanner: false,
          theme: dark ? FccTheme.themeDark : FccTheme.themeLight,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(scale)),
            child: child!,
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle(
    const Duration(milliseconds: 100),
    EnginePhase.sendSemanticsUpdate,
    const Duration(seconds: 5),
  );
  await tester.runAsync(() async {
    await Future.wait([
      precacheImage(
        const AssetImage('assets/images/freecodecamp-banner.png'),
        _capture.currentContext!,
      ),
      precacheImage(
        const AssetImage('assets/images/placeholder-profile-img.png'),
        _capture.currentContext!,
      ),
    ]);
  });
  await tester.pump();
  return router;
}

Future<void> _screenshot(WidgetTester tester, String name) async {
  const directory = String.fromEnvironment('UI_SCREENSHOT_DIR');
  if (directory.isEmpty) return;
  await tester.runAsync(() async {
    final boundary =
        _capture.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 2);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File('$directory/$name.png');
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes!.buffer.asUint8List());
    image.dispose();
  });
}

void _expectBookmarksActionVisible(WidgetTester tester) {
  final button = find.widgetWithText(OutlinedButton, 'View bookmarks');
  expect(button.hitTestable(), findsOneWidget);
  final bounds = tester.getRect(button);
  final appBar = tester.getRect(find.byType(AppBar));
  expect(bounds.top, greaterThanOrEqualTo(appBar.top));
  expect(bounds.bottom, lessThanOrEqualTo(appBar.bottom));
  expect(bounds.left, greaterThanOrEqualTo(0));
  expect(bounds.right, lessThanOrEqualTo(tester.view.physicalSize.width));
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final lato = FontLoader('Lato');
    for (final weight in ['Regular', 'Bold', 'ExtraBold', 'Black']) {
      lato.addFont(rootBundle.load('assets/fonts/Lato-$weight.ttf'));
    }
    await lato.load();
    await (FontLoader(
      'monospace',
    )..addFont(rootBundle.load('assets/fonts/Hack-Regular.ttf'))).load();
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
  });
  for (final dark in [false, true]) {
    final mode = dark ? 'dark' : 'light';
    testWidgets('Articles browse, filter and saved navigation in $mode mode', (
      tester,
    ) async {
      await _pump(tester, '/news', dark: dark);
      expect(find.text('Search articles'), findsOneWidget);
      _expectBookmarksActionVisible(tester);
      expect(
        find.widgetWithText(OutlinedButton, 'View bookmarks'),
        findsOneWidget,
      );
      expect(find.byType(BookmarkButton), findsNothing);
      expect(find.text(_posts.first.title), findsOneWidget);
      final leadingTile = find.byType(PostTile).first;
      expect(
        find.descendant(of: leadingTile, matching: find.byType(IconButton)),
        findsNothing,
      );
      await _screenshot(tester, 'articles-$mode');
      await tester.ensureVisible(
        find.widgetWithText(ChoiceChip, 'Software architecture'),
      );
      await tester.tap(
        find.widgetWithText(ChoiceChip, 'Software architecture'),
      );
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 5),
      );
      expect(find.text(_posts.first.title), findsNothing);
      expect(find.text(_posts.last.title), findsOneWidget);
      expect(find.byType(BookmarkButton), findsNothing);
      await tester.tap(find.text('View bookmarks'));
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 5),
      );
      expect(find.text('Saved articles can be read offline'), findsOneWidget);
      await tester.tap(find.widgetWithText(NavigationDestination, 'Articles'));
      await tester.pumpAndSettle();
      expect(find.text('Search articles'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
    testWidgets('Podcasts browse, downloads and detail in $mode mode', (
      tester,
    ) async {
      final router = await _pump(tester, '/podcasts', dark: dark);
      expect(find.text('From freeCodeCamp'), findsOneWidget);
      expect(find.text('More developer podcasts'), findsOneWidget);
      expect(find.text('100 episodes'), findsNothing);
      await _screenshot(tester, 'podcasts-$mode');
      await tester.tap(find.text('Downloaded'));
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 5),
      );
      expect(find.text(_episodes[1].title), findsOneWidget);
      expect(find.text('53 min'), findsOneWidget);
      expect(find.textContaining('✓ Downloaded'), findsNothing);
      expect(find.textContaining('on this device'), findsNothing);
      await _screenshot(tester, 'downloads-$mode');
      await tester.tap(find.text('Manage'));
      await tester.pumpAndSettle();
      expect(find.byType(Checkbox), findsOneWidget);
      await tester.tap(find.text('Select all'));
      await tester.pumpAndSettle();
      expect(find.text('Remove (1)'), findsOneWidget);
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();
      router.go('/podcasts/fcc');
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 5),
      );
      expect(find.text('Play latest'), findsOneWidget);
      expect(find.text('freeCodeCamp · 100 episodes'), findsNothing);
      await _screenshot(tester, 'episodes-$mode');
      await tester.tap(find.text('Newest first'));
      await tester.pumpAndSettle();
      expect(find.text('Sort episodes'), findsOneWidget);
      await tester.tap(find.text('Oldest first'));
      await tester.pumpAndSettle();
      expect(
        tester.getTopLeft(find.text('#215')).dy,
        lessThan(tester.getTopLeft(find.text('#216')).dy),
      );
      router.push(
        '/podcasts/fcc/217',
        extra: (_podcasts.first, _episodes.first),
      );
      await tester.pumpAndSettle();
      expect(find.byTooltip('Close player'), findsOneWidget);
      expect(tester.widget<Slider>(find.byType(Slider)).onChanged, isNull);
      await _screenshot(tester, 'player-$mode');
      expect(tester.takeException(), isNull);
    });
    testWidgets(
      'topic feed omits its selected tag and keeps other topics in $mode',
      (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [newsFeedProvider.overrideWith2((_) => _TopicFeed())],
            child: MaterialApp(
              theme: dark ? FccTheme.themeDark : FccTheme.themeLight,
              home: const Scaffold(
                body: PostFeedList(source: NewsFeedSource.tag('hackathon')),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text(_posts[1].title), findsOneWidget);
        expect(find.text(_posts[2].title), findsOneWidget);
        expect(find.text('#Hackathon'), findsNothing);
        expect(find.text('#Software architecture'), findsOneWidget);
        expect(
          tester.widget<TagButton>(find.byType(TagButton)).tagSlug,
          'architecture',
        );
        expect(tester.takeException(), isNull);
      },
    );
  }
  for (final location in [
    '/news',
    '/podcasts',
    '/podcasts/fcc',
    '/podcasts/downloads',
    '/news/bookmarks',
  ]) {
    testWidgets('$location supports narrow screens and larger text', (
      tester,
    ) async {
      final router = await _pump(tester, location, scale: 1.6, width: 320);
      await tester.drag(find.byType(Scrollable).last, const Offset(0, -300));
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 5),
      );
      expect(tester.takeException(), isNull);
      if (location == '/podcasts/fcc') {
        router.push(
          '/podcasts/fcc/217',
          extra: (_podcasts.first, _episodes.first),
        );
        await tester.pumpAndSettle();
        await tester.drag(find.byType(Scrollable).last, const Offset(0, -700));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    });
  }
  for (final dark in [false, true]) {
    for (final scale in [1.0, 2.0]) {
      for (final featured in [false, true]) {
        testWidgets(
          'Article row reclaims bookmark space dark$dark text$scale featured$featured',
          (tester) async {
            tester.view.devicePixelRatio = 1;
            tester.view.physicalSize = const Size(320, 844);
            addTearDown(tester.view.resetDevicePixelRatio);
            addTearDown(tester.view.resetPhysicalSize);
            await tester.pumpWidget(
              RepaintBoundary(
                key: _capture,
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: dark ? FccTheme.themeDark : FccTheme.themeLight,
                  builder: (context, child) => MediaQuery(
                    data: MediaQuery.of(
                      context,
                    ).copyWith(textScaler: TextScaler.linear(scale)),
                    child: child!,
                  ),
                  home: Scaffold(
                    body: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: PostTile(post: _posts[1], featured: featured),
                    ),
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle();
            expect(find.byType(BookmarkButton), findsNothing);
            expect(find.byType(IconButton), findsNothing);
            expect(
              tester.getSize(find.text(_posts[1].title)).width,
              closeTo(featured ? 280 : 164, .01),
            );
            expect(
              tester.getRect(find.textContaining('Beau Carnes')).right,
              closeTo(300, .01),
            );
            await _screenshot(
              tester,
              'article-${featured ? 'lead' : 'compact'}-${dark ? 'dark' : 'light'}-text${(scale * 100).toInt()}',
            );
            expect(tester.takeException(), isNull);
          },
        );
      }
    }
    for (final size in [const Size(320, 844), const Size(844, 390)]) {
      testWidgets(
        'Articles scroll to readable content at 200 percent in $size dark$dark',
        (tester) async {
          await _pump(
            tester,
            '/news',
            width: size.width,
            height: size.height,
            scale: 2,
            dark: dark,
          );
          await _screenshot(
            tester,
            'articles-${dark ? 'dark' : 'light'}-${size.width.toInt()}-text200',
          );
          _expectBookmarksActionVisible(tester);
          expect(tester.takeException(), isNull);
          expect(
            find.widgetWithText(OutlinedButton, 'View bookmarks').hitTestable(),
            findsOneWidget,
          );
          await tester.ensureVisible(find.text(_posts.first.title));
          await tester.pumpAndSettle();
          expect(find.text(_posts.first.title).hitTestable(), findsOneWidget);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
