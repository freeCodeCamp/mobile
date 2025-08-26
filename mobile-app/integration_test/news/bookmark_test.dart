import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/main.dart' as app;
import 'package:freecodecamp/ui/views/news/news-tutorial/news_tutorial_view.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding();
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('NEWS - should bookmark tutorial', (WidgetTester tester) async {
    // Start app and navigate to news view
    tester.printToConsole('Test starting');
    await app.main(testing: true);
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();

    final Finder drawer = find.byIcon(Icons.menu);
    await tester.tap(drawer);
    await tester.pumpAndSettle();

    final Finder news = find.byKey(const Key('news'));
    await tester.tap(news);
    await tester.pumpAndSettle();

    await binding.takeScreenshot('news/news-feed');

    // Tap on the first tutorial
    final Finder firstTutorial = find
        .descendant(
          of: find.byKey(const Key('news-tutorial-0')),
          matching: find.byType(InkWell),
        )
        .first;
    final Finder firstTutorialImage = find
        .descendant(
          of: firstTutorial,
          matching: find.byType(AspectRatio),
        )
        .first;
    final ValueKey firstTutorialKey =
        tester.firstWidget<InkWell>(firstTutorial).key! as ValueKey;

    expect(firstTutorial, findsOneWidget);
    expect(firstTutorialImage, findsOneWidget);
    await tester.tap(firstTutorialImage);
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(const Duration(seconds: 3));
    await binding.takeScreenshot('news/news-tutorial');

    // Tap on the bookmark button and store tutorial title and author
    final Finder bookmarkButton = find.byKey(const Key('bookmark_btn'));
    final Finder tutorialTitle = find.byKey(const Key('title'));
    final Finder tutorialAuthor = find.descendant(
        of: find.byType(NewsTutorialHeader),
        matching: find.textContaining(RegExp(r'^Written by')));
    await tester.pumpAndSettle();
    expect(bookmarkButton, findsOneWidget);
    expect(tutorialTitle, findsOneWidget);
    expect(tutorialAuthor, findsOneWidget);
    Text title = tester.firstWidget(tutorialTitle);
    String author = tester.firstWidget<Text>(tutorialAuthor).data!;
    await tester.tap(bookmarkButton);
    await tester.pumpAndSettle();

    // Go to news bookmark view
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Bookmarks'));
    await tester.pumpAndSettle();
    await binding.takeScreenshot('news/news-bookmark-feed');

    // Check if tutorial is in bookmark view and it has same title and author
    final Finder bookmarkTutorial =
        find.byKey(const Key('bookmark_tutorial_0'));
    final Finder bookmarkTutorialText = find.descendant(
      of: bookmarkTutorial,
      matching: find.byType(Text),
    );
    expect(
      tester.firstWidget<Text>(bookmarkTutorialText.first).data!,
      title.data,
    );
    expect(
      (tester.firstWidget<Text>(bookmarkTutorialText.last).data!)
          .split('Written by: ')[1],
      author.split('Written by ')[1],
    );

    // Check JSON file if record exists
    final directory = await getApplicationDocumentsDirectory();
    final articlesFile = File(path.join(directory.path, 'articles.json'));
    
    expect(await articlesFile.exists(), true);
    
    final contents = await articlesFile.readAsString();
    final List<dynamic> bookmarks = json.decode(contents);
    
    expect(bookmarks.length, 1);
    expect(bookmarks[0]['id'], firstTutorialKey.value);
    expect(bookmarks[0]['tutorialTitle'], title.data);
    expect(bookmarks[0]['authorName'], author.split('Written by ')[1]);
  });
}
