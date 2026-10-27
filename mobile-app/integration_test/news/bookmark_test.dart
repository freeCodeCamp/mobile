import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/main.dart' as app;
import 'package:freecodecamp/news/ui/bookmark_feed/bookmark_feed_view.dart';
import 'package:freecodecamp/news/ui/post/post_view.dart';
import 'package:freecodecamp/news/ui/widgets/bookmark_button.dart';
import 'package:freecodecamp/news/ui/widgets/post_tile.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding();
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpUntilFound(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 60),
  }) async {
    final deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      await tester
          .pump(const Duration(milliseconds: 250))
          .timeout(const Duration(seconds: 10));
      if (binding.sendFramesToEngine &&
          binding.firstFrameRasterized &&
          finder.evaluate().isNotEmpty) {
        return;
      }
    }
    fail('Timed out waiting for: $finder');
  }

  testWidgets('NEWS - should bookmark a post', (WidgetTester tester) async {
    tester.printToConsole('Test starting');
    await app.main();

    final articlesDestination = find.byWidgetPredicate(
      (widget) =>
          widget is NavigationDestination && widget.label == 'Articles',
    );
    await pumpUntilFound(tester, articlesDestination.hitTestable());
    await binding
        .convertFlutterSurfaceToImage()
        .timeout(const Duration(seconds: 10));
    await tester.pump().timeout(const Duration(seconds: 10));
    await tester.tap(articlesDestination);

    // News Feed
    await pumpUntilFound(tester, find.byType(PostTile));
    await binding.takeScreenshot('news/news-feed');

    final firstTile = find.byType(PostTile).first;
    expect(firstTile, findsOneWidget);

    final postId = tester.widget<PostTile>(firstTile).post.id;

    await tester.tap(firstTile);

    // Post detail - wait for the reader body.
    await pumpUntilFound(tester, find.byType(NewsPostHeader));
    await binding.takeScreenshot('news/news-post');

    final header = find.byType(NewsPostHeader);
    expect(header, findsOneWidget);

    final post = tester.widget<NewsPostHeader>(header).post;
    final title = post.title;
    final author = post.author.name;

    // Bookmark the post
    final bookmarkButton = find.byType(BookmarkButton);
    expect(bookmarkButton, findsOneWidget);
    await pumpUntilFound(tester, bookmarkButton.hitTestable());
    await tester.tap(bookmarkButton);
    await pumpUntilFound(
      tester,
      find.descendant(
        of: bookmarkButton,
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is IconButton &&
              widget.tooltip == 'Remove saved article' &&
              widget.onPressed != null,
        ),
      ),
    );

    // Back to the feed, then open Saved articles
    await tester.tap(find.byType(BackButton));
    final viewBookmarks = find.ancestor(
      of: find.text('View bookmarks'),
      matching: find.byWidgetPredicate((widget) => widget is OutlinedButton),
    );
    await pumpUntilFound(tester, viewBookmarks.hitTestable());
    await tester.tap(viewBookmarks);

    final savedFeed = find.byType(NewsBookmarkFeedView);
    final savedPost = find.descendant(
      of: savedFeed,
      matching: find.byKey(ValueKey(postId)),
    );
    await pumpUntilFound(
      tester,
      find.descendant(of: savedPost, matching: find.text(title)),
    );
    await binding.takeScreenshot('news/news-bookmark-feed');

    expect(
      find.descendant(of: savedFeed, matching: find.text(title)),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: savedPost,
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Text &&
              (widget.data == author ||
                  widget.data?.startsWith('$author · ') == true),
        ),
      ),
      findsOneWidget,
    );
    expect(find.text('Saved articles can be read offline'), findsOneWidget);

    // Check that the post is stored in the bookmarks JSON file
    final docsDir = await getApplicationDocumentsDirectory();
    final jsonFile = File(
      path.join(docsDir.path, 'storage', 'bookmarked-articles.json'),
    );
    expect(await jsonFile.exists(), isTrue);

    final decoded = jsonDecode(await jsonFile.readAsString()) as Map;
    final stored = (decoded['bookmarks'] as List)
        .cast<Map<String, dynamic>>()
        .firstWhere(
          (e) => e['articleId'] == postId,
          orElse: () => <String, dynamic>{},
        );

    expect(stored, isNotEmpty, reason: 'no entry for $postId');
    expect(stored['articleTitle'], title);
    expect(stored['authorName'], author);
    expect(stored['articleText'], isNotEmpty);
  });
}
