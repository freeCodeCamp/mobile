import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mobile_app_new/main.dart' as app;
import 'package:mobile_app_new/ui/views/news/news-bookmark-feed/news_bookmark_feed_view.dart';
import 'package:mobile_app_new/ui/views/news/news-post/news_post_view.dart';
import 'package:mobile_app_new/ui/views/news/widgets/bookmark_button.dart';
import 'package:mobile_app_new/ui/views/news/widgets/post_tile.dart';
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
      await tester.pump(const Duration(milliseconds: 250));
      if (finder.evaluate().isNotEmpty) return;
    }
    fail('Timed out waiting for: $finder');
  }

  testWidgets('NEWS - should bookmark a post', (WidgetTester tester) async {
    tester.printToConsole('Test starting');
    await app.main();
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();

    // Drawer -> Tutorials
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tutorials'));
    await tester.pumpAndSettle();

    // News Feed
    await pumpUntilFound(tester, find.byType(PostTile));
    await binding.takeScreenshot('news/news-feed');

    final firstTile = find.byType(PostTile).first;
    expect(firstTile, findsOneWidget);

    final postId = (tester.widget<PostTile>(firstTile).key! as ValueKey).value;

    await tester.tap(firstTile);
    await tester.pumpAndSettle();

    // Post detail - wait for the body, then for the bottom bar to slide in.
    await pumpUntilFound(tester, find.byType(NewsPostHeader));
    await tester.pumpAndSettle(const Duration(seconds: 3));
    await binding.takeScreenshot('news/news-post');

    final header = find.byType(NewsPostHeader);
    expect(header, findsOneWidget);

    final post = tester.widget<NewsPostHeader>(header).post;
    final title = post.title;
    final author = post.author.name;

    // Bookmark the post
    final bookmarkButton = find.byType(BookmarkButton);
    expect(bookmarkButton, findsOneWidget);
    await tester.tap(bookmarkButton);
    await tester.pumpAndSettle();

    // Back to the feed, then over to the Bookmarks tab
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Bookmarks'));
    await tester.pumpAndSettle();

    await pumpUntilFound(
      tester,
      find.descendant(
        of: find.byType(NewsBookmarkFeedView),
        matching: find.byType(ListTile),
      ),
    );
    await binding.takeScreenshot('news/news-bookmark-feed');

    // Verify that the first row in the bookmarks feed matches the post we bookmarked
    final firstRow = find
        .descendant(
          of: find.byType(NewsBookmarkFeedView),
          matching: find.byType(ListTile),
        )
        .first;
    expect(firstRow, findsOneWidget);

    final rowText = find.descendant(of: firstRow, matching: find.byType(Text));
    expect(tester.widget<Text>(rowText.first).data, title);
    expect(
      tester.widget<Text>(rowText.last).data!.replaceFirst('Written by: ', ''),
      author,
    );

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
