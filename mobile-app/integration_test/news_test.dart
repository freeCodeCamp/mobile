import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/main.dart' as app;
import 'package:freecodecamp/ui/views/news/news-article/news_article_header.dart';
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_lazyloading.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding();
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('News Component', () {
    testWidgets('should bookmark article', (WidgetTester tester) async {
      // Start app
      tester.printToConsole('Test starting');
      await app.main();
      await binding.convertFlutterSurfaceToImage();
      await tester.pumpAndSettle();
      await binding.takeScreenshot('news-feed');

      // Tap on the first article
      final Finder firstArticle = find.byType(NewsFeedLazyLoading).first;
      final Finder firstArticleImage = find
          .descendant(
            of: firstArticle,
            matching: find.byType(Image),
          )
          .first;
      final ValueKey firstArticleKey = tester
          .firstWidget<NewsFeedLazyLoading>(firstArticle)
          .key! as ValueKey;
      expect(firstArticle, findsOneWidget);
      expect(firstArticleImage, findsOneWidget);
      await tester.tap(firstArticleImage);
      await tester.pumpAndSettle();
      await binding.takeScreenshot('news-article');
      await tester.pump(const Duration(milliseconds: 3000));
      // Tap on the bookmark button and store article title and author
      final Finder bookmarkButton = find.byKey(const Key('bookmark_btn'));
      final Finder articleTitle = find.byKey(const Key('title'));
      final Finder articleAuthor = find.descendant(
          of: find.byType(NewsArticleHeader),
          matching: find.textContaining(RegExp(r'^Written by')));
      await tester.pumpAndSettle();
      expect(bookmarkButton, findsOneWidget);
      expect(articleTitle, findsOneWidget);
      expect(articleAuthor, findsOneWidget);
      Text title = tester.firstWidget(articleTitle);
      String author = tester.firstWidget<Text>(articleAuthor).data!;
      await tester.tap(bookmarkButton);
      await tester.pumpAndSettle();

      // Go to news bookmark view
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Bookmarks'));
      await tester.pumpAndSettle();
      await binding.takeScreenshot('news-bookmark-feed');

      // Check if article is in bookmark view and it has same title and author
      final Finder bookmarkArticle =
          find.byKey(const Key('bookmark_article_0'));
      final Finder bookmarkArticleText = find.descendant(
        of: bookmarkArticle,
        matching: find.byType(Text),
      );
      expect(
        tester.firstWidget<Text>(bookmarkArticleText.first).data!,
        title.data,
      );
      expect(
        (tester.firstWidget<Text>(bookmarkArticleText.last).data!)
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
