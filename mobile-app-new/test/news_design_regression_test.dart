import 'dart:async';
import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/news/controllers/bookmarks_controller.dart';
import 'package:mobile_app_new/news/controllers/feed_controller.dart';
import 'package:mobile_app_new/news/models/author_model.dart';
import 'package:mobile_app_new/news/models/bookmarked_post_model.dart';
import 'package:mobile_app_new/news/models/post_model.dart';
import 'package:mobile_app_new/news/models/post_summary_model.dart';
import 'package:mobile_app_new/news/repositories/bookmark_repository.dart';
import 'package:mobile_app_new/news/services/bookmark_service.dart';
import 'package:mobile_app_new/news/ui/author_feed/author_feed_view.dart';
import 'package:mobile_app_new/news/ui/bookmark_feed/bookmark_feed_view.dart';
import 'package:mobile_app_new/news/ui/image/image_view.dart';
import 'package:mobile_app_new/news/ui/widgets/author_post_tile.dart';
import 'package:mobile_app_new/news/ui/widgets/news_image.dart';
import 'package:mobile_app_new/news/ui/widgets/news_load_error.dart';
import 'package:mobile_app_new/news/ui/widgets/post_feed_list.dart';
import 'package:mobile_app_new/routing/news.dart' as news;
import 'package:mobile_app_new/services/audio_service.dart';
import 'package:photo_view/photo_view.dart';

const _author = Author(id: 'author', username: 'camper', name: 'A Camper');
const _post = Post(
  id: 'new',
  slug: 'new',
  title: 'A saved tutorial',
  url: 'https://www.freecodecamp.org/news/new/',
  author: _author,
  readTimeInMinutes: 5,
  content: Content(html: '<p>Offline content</p>'),
  publishedAt: '2026-10-10',
  coverImage: CoverImage(url: 'https://example.com/cover.png'),
);

class _MemoryBookmarks extends NewsBookmarkRepository {
  List<BookmarkEntry> entries = [];
  int generation = 0;
  @override
  int get resetGeneration => generation;
  @override
  Future<List<BookmarkEntry>> readBookmarks() async => entries;
  @override
  Future<void> updateBookmarks(
    List<BookmarkEntry> Function(List<BookmarkEntry>) updater,
  ) async {
    entries = updater(entries);
  }

  @override
  Future<void> clearForReset() async {
    generation++;
    entries = [];
  }
}

class _Audio extends BaseAudioHandler implements AudioPlayerHandler {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Feed extends NewsFeedNotifier {
  @override
  Future<NewsFeedState> build(NewsFeedSource source) async =>
      const NewsFeedState(
        hasNextPage: false,
        posts: [
          PostSummary(
            id: 'new',
            slug: 'new',
            title: 'Build a useful application',
            author: _author,
            readTimeInMinutes: 5,
            publishedAt: '2026-10-10',
          ),
        ],
      );
}

void main() {
  test(
    'legacy bookmark storage survives reading and adding new metadata',
    () async {
      final repository = _MemoryBookmarks()
        ..entries = [
          {
            'articleId': 'legacy',
            'articleTitle': 'Old tutorial',
            'authorName': 'Old author',
            'articleText': '<p>Old HTML</p>',
          },
        ];
      final service = NewsBookmarkService(repository);
      final legacy = (await service.getBookmarks()).single;
      expect(legacy.coverImageUrl, isNull);
      expect(legacy.savedAt, isNull);
      expect(legacy.text, '<p>Old HTML</p>');
      await service.addBookmark(BookmarkedPost.fromPost(_post));
      final result = await service.getBookmarks();
      expect(result.map((post) => post.id), ['new', 'legacy']);
      expect(result.first.coverImageUrl, _post.coverImage!.url);
      expect(result.first.savedAt, isNotNull);
      expect(result.last, legacy);
      expect(BookmarkedPost.fromJson(legacy.toJson()), legacy);
      expect(BookmarkedPost.fromJson(result.first.toJson()), result.first);
      repository.entries.last['savedAt'] = 'unknown old date';
      expect((await service.getBookmarks()).first.savedAt, isNull);
    },
  );

  test(
    'a local reset prevents a pending article load from saving afterwards',
    () async {
      final repository = _MemoryBookmarks();
      final container = ProviderContainer(
        overrides: [
          newsBookmarkRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
      final subscription = container.listen(newsBookmarksProvider, (_, _) {});
      addTearDown(subscription.close);
      await container.read(newsBookmarksProvider.future);
      final loaded = Completer<BookmarkedPost>();
      final started = Completer<void>();
      final save = container.read(newsBookmarksProvider.notifier).toggleById(
        'new',
        () {
          started.complete();
          return loaded.future;
        },
      );
      await started.future;
      await repository.clearForReset();
      loaded.complete(BookmarkedPost.fromPost(_post));
      await save;
      expect(repository.entries, isEmpty);
    },
  );

  for (final dark in [false, true]) {
    testWidgets(
      'recovery actions and compact author layout in ${dark ? 'dark' : 'light'} large text',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(320, 844);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        var retries = 0;
        String? launchedUrl;
        const launcherChannel = MethodChannel(
          'plugins.flutter.io/url_launcher',
        );
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(launcherChannel, (call) async {
              launchedUrl = (call.arguments as Map)['url'] as String?;
              return true;
            });
        addTearDown(
          () => TestDefaultBinaryMessengerBinding
              .instance
              .defaultBinaryMessenger
              .setMockMethodCallHandler(launcherChannel, null),
        );
        final router = GoRouter(
          initialLocation: '/error',
          routes: [
            GoRoute(
              path: '/error',
              builder: (_, _) =>
                  Scaffold(body: NewsLoadError(onRetry: () => retries++)),
            ),
            GoRoute(
              path: '/news/bookmarks',
              builder: (_, _) =>
                  const Scaffold(body: Text('Saved destination')),
            ),
            GoRoute(
              path: '/author',
              builder: (_, _) =>
                  const NewsAuthorFeedView(username: 'camper', author: _author),
            ),
            GoRoute(
              path: '/news/new',
              builder: (_, _) =>
                  const Scaffold(body: Text('Tutorial destination')),
            ),
            GoRoute(
              path: '/news',
              builder: (_, _) =>
                  const Scaffold(body: Text('All tutorials destination')),
            ),
          ],
        );
        addTearDown(router.dispose);
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              audioHandlerProvider.overrideWithValue(_Audio()),
              newsFeedProvider.overrideWith2((_) => _Feed()),
            ],
            child: MaterialApp.router(
              routerConfig: router,
              theme: dark ? FccTheme.themeDark : FccTheme.themeLight,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(1.6)),
                child: child!,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Read articles online'), findsOneWidget);
        await tester.tap(find.text('Read articles online'));
        await tester.pumpAndSettle();
        expect(launchedUrl, 'https://www.freecodecamp.org/news/');
        await tester.tap(find.text('Try again'));
        expect(retries, 1);
        await tester.tap(find.text('Saved articles'));
        await tester.pumpAndSettle();
        expect(find.text('Saved destination'), findsOneWidget);
        router.go('/author');
        await tester.pumpAndSettle();
        expect(
          find.descendant(
            of: find.byType(PostFeedList),
            matching: find.text('Articles'),
          ),
          findsOneWidget,
        );
        expect(find.text('Articles by A Camper'), findsNothing);
        await tester.ensureVisible(find.byType(AuthorPostTile));
        expect(find.text('Build a useful application'), findsOneWidget);
        expect(find.byIcon(Icons.bookmark_border_rounded), findsNothing);
        final titleY = tester
            .getTopLeft(find.text('Build a useful application'))
            .dy;
        final footerY = tester.getTopLeft(find.text('See all articles')).dy;
        expect(footerY, greaterThan(titleY));
        await tester.tap(find.text('Build a useful application'));
        await tester.pumpAndSettle();
        expect(find.text('Tutorial destination'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'saved metadata and legacy fallback remain readable in ${dark ? 'dark' : 'light'}',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(320, 844);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final repository = _MemoryBookmarks();
        final service = NewsBookmarkService(repository);
        await service.addBookmark(BookmarkedPost.fromPost(_post));
        await service.addBookmark(
          const BookmarkedPost(
            id: 'legacy',
            title: 'Legacy tutorial',
            authorName: 'An author',
            text: '<p>Legacy</p>',
          ),
        );
        repository.entries.last.remove('savedAt');
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              newsBookmarkRepositoryProvider.overrideWithValue(repository),
            ],
            child: MaterialApp(
              theme: dark ? FccTheme.themeDark : FccTheme.themeLight,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(1.6)),
                child: child!,
              ),
              home: const Scaffold(body: NewsBookmarkFeedView()),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.textContaining('Saved today'), findsOneWidget);
        expect(find.text('Legacy tutorial'), findsOneWidget);
        expect(
          tester
              .widgetList<NewsImage>(find.byType(NewsImage))
              .any((image) => image.url == _post.coverImage!.url),
          isTrue,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('image metadata and swipe work while zoomed panning stays open', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final imageBytes = (await rootBundle.load(
      'assets/images/freecodecamp-banner.png',
    )).buffer.asUint8List();
    final imageUrl = 'data:image/png;base64,${base64Encode(imageBytes)}';
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          builder: (_, _) => const Scaffold(body: Text('Reader')),
        ),
        news.$newsImageRoute,
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(routerConfig: router, theme: FccTheme.themeDark),
    );
    await tester.pumpAndSettle();
    Future<void> open() async {
      news.NewsImageRoute(
        $extra: imageUrl,
        caption: 'A forest beside a river',
        alt: 'Trees and a river',
      ).push(tester.element(find.text('Reader')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      await tester.runAsync(
        () => precacheImage(
          tester.widget<PhotoView>(find.byType(PhotoView)).imageProvider!,
          tester.element(find.byType(PhotoView)),
        ),
      );
      await tester.pumpAndSettle();
    }

    await open();
    expect(find.text('A forest beside a river'), findsOneWidget);
    final semantics = tester.ensureSemantics();
    expect(find.bySemanticsLabel('Trees and a river'), findsOneWidget);
    semantics.dispose();
    final image = find.byType(PhotoView);
    final center = tester.getCenter(image);
    final initial = tester.widget<PhotoView>(image).controller!.scale!;
    await tester.tapAt(center);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tapAt(center);
    await tester.pumpAndSettle();
    expect(
      tester.widget<PhotoView>(image).controller!.scale,
      greaterThan(initial),
    );
    await tester.dragFrom(center, const Offset(0, 180));
    await tester.pumpAndSettle();
    expect(find.byType(NewsImageView), findsOneWidget);
    await tester.tap(find.byTooltip('Close image'));
    await tester.pumpAndSettle();
    await open();
    await tester.dragFrom(const Offset(160, 400), const Offset(0, 180));
    await tester.pumpAndSettle();
    expect(find.byType(NewsImageView), findsNothing);
    expect(find.text('Reader'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
