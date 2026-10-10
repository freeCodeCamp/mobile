import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/news/models/author_model.dart';
import 'package:mobile_app_new/news/models/post_model.dart';
import 'package:mobile_app_new/news/repositories/bookmark_repository.dart';
import 'package:mobile_app_new/news/services/api_service.dart';
import 'package:mobile_app_new/news/ui/widgets/article_reader.dart';
import 'package:mobile_app_new/news/ui/widgets/bookmark_button.dart';

const _post = Post(
  id: 'tutorial',
  slug: 'tutorial',
  title: 'A tutorial worth saving',
  url: 'https://www.freecodecamp.org/news/tutorial/',
  author: Author(id: 'author', username: 'author', name: 'A Camper'),
  readTimeInMinutes: 5,
  content: Content(
    html: '<p>Keep the complete tutorial available offline.</p>',
  ),
  publishedAt: '2026-10-10T00:00:00Z',
);

class _Bookmarks extends NewsBookmarkRepository {
  List<BookmarkEntry> entries = [];

  @override
  Future<List<BookmarkEntry>> readBookmarks() async => entries;

  @override
  Future<void> updateBookmarks(
    List<BookmarkEntry> Function(List<BookmarkEntry>) updater,
  ) async {
    entries = updater(entries);
  }
}

class _Api implements NewsApiService {
  _Api(this.load);

  final Future<Post> Function(String) load;

  @override
  Future<Post> getPostBySlug(String slug) => load(slug);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets(
    'saving from a summary fetches full HTML and removal needs no fetch',
    (tester) async {
      final bookmarks = _Bookmarks();
      var requests = 0;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            newsBookmarkRepositoryProvider.overrideWithValue(bookmarks),
            newsApiServiceProvider.overrideWithValue(
              _Api((_) async {
                requests++;
                return _post;
              }),
            ),
          ],
          child: MaterialApp(
            theme: FccTheme.themeLight,
            home: const Scaffold(
              body: BookmarkButton.forSummary(id: 'tutorial', slug: 'tutorial'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Save tutorial for offline reading'));
      await tester.pumpAndSettle();
      expect(requests, 1);
      expect(bookmarks.entries.single['articleText'], _post.content.html);
      expect(bookmarks.entries.single['articleId'], _post.id);
      expect(find.byTooltip('Remove saved tutorial'), findsOneWidget);

      await tester.tap(find.byTooltip('Remove saved tutorial'));
      await tester.pumpAndSettle();
      expect(bookmarks.entries, isEmpty);
      expect(requests, 1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('an in-flight save finishes after its summary tile is disposed', (
    tester,
  ) async {
    final bookmarks = _Bookmarks();
    final post = Completer<Post>();
    final visible = ValueNotifier(true);
    addTearDown(visible.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          newsBookmarkRepositoryProvider.overrideWithValue(bookmarks),
          newsApiServiceProvider.overrideWithValue(_Api((_) => post.future)),
        ],
        child: MaterialApp(
          theme: FccTheme.themeLight,
          home: Scaffold(
            body: ValueListenableBuilder<bool>(
              valueListenable: visible,
              builder: (_, show, _) => show
                  ? const BookmarkButton.forSummary(
                      id: 'tutorial',
                      slug: 'tutorial',
                    )
                  : const Text('Another part of the feed'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Save tutorial for offline reading'));
    await tester.pump();
    visible.value = false;
    await tester.pump();
    expect(find.byType(BookmarkButton), findsNothing);
    post.complete(_post);
    await tester.pumpAndSettle();
    expect(bookmarks.entries.single['articleText'], _post.content.html);
    visible.value = true;
    await tester.pumpAndSettle();
    expect(find.byTooltip('Remove saved tutorial'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('reader text size changes paragraph and nested quote typography', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: FccTheme.themeLight,
        home: const ArticleReader(
          html:
              '<p>Readable tutorial content.</p><blockquote><p>A readable quotation.</p></blockquote>',
          header: Text('Tutorial'),
          bookmarkButton: SizedBox.shrink(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    List<TextStyle> stylesFor(String text) {
      final matches = <TextStyle>[];
      void visit(InlineSpan span, TextStyle inherited) {
        final style = inherited.merge(span.style);
        if (span is TextSpan) {
          if (span.text?.contains(text) ?? false) matches.add(style);
          for (final child in span.children ?? <InlineSpan>[]) {
            visit(child, style);
          }
        }
      }

      for (final widget in tester.widgetList<RichText>(find.byType(RichText))) {
        visit(widget.text, const TextStyle());
      }
      return matches;
    }

    final before = stylesFor('Readable tutorial content.');
    expect(before, isNotEmpty);

    await tester.tap(find.byTooltip('Text size'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byWidgetPredicate(
        (widget) =>
            widget is CheckedPopupMenuItem<double> && widget.value == 22,
      ),
    );
    await tester.pumpAndSettle();
    final after = stylesFor('Readable tutorial content.');
    expect(after, isNotEmpty);
    expect(after.first.fontSize, greaterThan(before.first.fontSize!));
    expect(
      stylesFor('A readable quotation.').first.fontSize,
      after.first.fontSize,
    );
    expect(after.first.color, FccTheme.themeLight.colorScheme.onSurface);
    expect(tester.takeException(), isNull);
  });
}
