import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/news/bookmarked_tutorial_model.dart';
import 'package:freecodecamp/models/news/tutorial_model.dart';
import 'package:freecodecamp/service/news/bookmark_service.dart';
import 'package:path/path.dart' as path;

import '../../helpers/test_helpers.dart';

final Tutorial testTutorial = Tutorial(
  id: '61fad67af2ed6b06db5ab66f',
  slug: 'hello-world',
  featureImage:
      'https://www.freecodecamp.org/news/content/images/2022/01/python-game.png',
  title:
      'Python Game Development - How to Make a Turtle Racing Game with PyCharm',
  profileImage:
      'https://www.freecodecamp.org/news/content/images/2022/02/profile.jpg',
  authorId: '',
  authorName: 'Shahan Chowdhury',
  authorSlug: 'shahan',
  text:
      '<h1>This is heading 1</h1><h2>This is heading 2</h2><h3>This is heading 3</h3>',
);

final BookmarkedTutorial testBookmarkTutorial = BookmarkedTutorial(
  id: '61fad67af2ed6b06db5ab66f',
  tutorialTitle:
      'Python Game Development - How to Make a Turtle Racing Game with PyCharm',
  tutorialText:
      '<h1>This is heading 1</h1><h2>This is heading 2</h2><h3>This is heading 3</h3>',
  authorName: 'Shahan Chowdhury',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Directory? tempDir;

  group('News Bookmark Service Test -', () {
    setUp(() {
      registerServices();
      tempDir = Directory.systemTemp.createTempSync('fcc_bookmarks_test_');
      if (locator.isRegistered<BookmarksDatabaseService>()) {
        locator.unregister<BookmarksDatabaseService>();
      }
      locator.registerSingleton<BookmarksDatabaseService>(
        BookmarksDatabaseService(storageDirectoryOverride: tempDir),
      );
    });

    tearDown(() {
      locator.reset();
      try {
        tempDir?.deleteSync(recursive: true);
      } catch (_) {}
    });

    test('init service', () async {
      final service = locator<BookmarksDatabaseService>();
      await service.initialise();
      expect(service, isA<BookmarksDatabaseService>());

      final file = File(
        path.join(tempDir!.path, 'storage', 'bookmarked-articles.json'),
      );
      expect(await file.exists(), true);
    });

    test('get all bookmarks', () async {
      final service = locator<BookmarksDatabaseService>();
      await service.initialise();
      final bookmarks = await service.getBookmarks();
      expect(bookmarks, isA<List<BookmarkedTutorial>>());
      expect(bookmarks.length, 0);
    });

    test('add bookmark', () async {
      final service = locator<BookmarksDatabaseService>();
      await service.initialise();
      await service.addBookmark(testTutorial);
      final bookmarks = await service.getBookmarks();
      expect(bookmarks, isA<List<BookmarkedTutorial>>());
      expect(bookmarks.length, 1);
      expect(bookmarks[0].id, testBookmarkTutorial.id);
      expect(bookmarks[0].tutorialTitle, testBookmarkTutorial.tutorialTitle);
      expect(bookmarks[0].authorName, testBookmarkTutorial.authorName);
      expect(bookmarks[0].tutorialText, testBookmarkTutorial.tutorialText);
    });

    test('check if bookmark exists', () async {
      final service = locator<BookmarksDatabaseService>();
      await service.initialise();
      await service.addBookmark(testTutorial);
      expect(await service.isBookmarked(testBookmarkTutorial), true);
    });

    test('delete bookmark', () async {
      final service = locator<BookmarksDatabaseService>();
      await service.initialise();
      await service.addBookmark(testTutorial);
      await service.removeBookmark(testBookmarkTutorial);
      final bookmarks = await service.getBookmarks();
      expect(bookmarks, isA<List<BookmarkedTutorial>>());
      expect(bookmarks.length, 0);
    });
  });
}
