import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/main.dart' as app;
import 'package:freecodecamp/ui/views/news/news-article-post/news_article_post_header.dart';
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_lazyloading.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('News Component', () {
    testWidgets('should bookmark article', (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      // Tap on the first article
      final Finder firstArticle = find.byType(NewsFeedLazyLoading).first;
      final ValueKey firstArticleKey =
          tester.firstWidget<NewsFeedLazyLoading>(firstArticle).key! as ValueKey;
      expect(firstArticle, findsOneWidget);
      await tester.tap(firstArticle);
      await tester.pumpAndSettle();

      // Tap on the bookmark button and store article title and author
      final Finder bookmarkButton = find.byKey(const Key('bookmark_btn'));
      final Finder articleTitle = find.byKey(const Key('title'));
      final Finder articleAuthor = find.descendant(
          of: find.byType(NewsArticlePostHeader),
          matching: find.textContaining(RegExp(r'^Written by')));
      expect(bookmarkButton, findsOneWidget);
      expect(articleTitle, findsOneWidget);
      expect(articleAuthor, findsOneWidget);
      Text title = tester.firstWidget(articleTitle);
      String author = tester.firstWidget<Text>(articleAuthor).data ?? '';
      await tester.tap(bookmarkButton);
      await tester.pumpAndSettle();

      // Go to news bookmark view
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Bookmarks'));
      await tester.pumpAndSettle();

      // Check if article is in bookmark view and it has same title and author
      final Finder bookmarkArticle =
          find.byKey(const Key('bookmark_article_0'));
      final Finder bookmarkArticleText = find.descendant(
        of: bookmarkArticle,
        matching: find.byType(Text),
      );
      expect(
        tester.firstWidget<Text>(bookmarkArticleText.first).data ?? '',
        title.data,
      );
      expect(
        (tester.firstWidget<Text>(bookmarkArticleText.last).data ?? '')
            .split('Written by: ')[1],
        author.split('Written by ')[1],
      );

      // Check database if record exists
      final db = await openDatabase(
          path.join(await getDatabasesPath(), 'bookmarked-article.db'));
      final List<Map<String, dynamic>> result = await db.query(
        'bookmarks',
        where: 'articleId = ?',
        whereArgs: [firstArticleKey.value],
      );
      expect(result.length, 1);
      expect(result[0]['articleId'], firstArticleKey.value);
      expect(result[0]['articleTitle'], title.data);
      expect(result[0]['authorName'], author.split('Written by ')[1]);
    });
  });
}
