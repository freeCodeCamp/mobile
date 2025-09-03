import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/news/bookmarked_tutorial_model.dart';
import 'package:freecodecamp/models/news/tutorial_model.dart';
import 'package:freecodecamp/service/news/bookmark_service.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

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
  bookmarkId: 1,
  id: '61fad67af2ed6b06db5ab66f',
  tutorialTitle:
      'Python Game Development - How to Make a Turtle Racing Game with PyCharm',
  tutorialText:
      '<h1>This is heading 1</h1><h2>This is heading 2</h2><h3>This is heading 3</h3>',
  authorName: 'Shahan Chowdhury',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  group('News Bookmark Service Test -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
    tearDownAll(() async {
      String dbPath = await getDatabasesPath();
      String dbPathTutorials = path.join(dbPath, 'bookmarked-article.db');
      File(dbPathTutorials).deleteSync();
    });

    test('init service', () async {
      final service = locator<BookmarksDatabaseService>();
      await service.initialise();
      String dbPath = await getDatabasesPath();
      String dbPathTutorials = path.join(dbPath, 'bookmarked-article.db');
      expect(service, isA<BookmarksDatabaseService>());
      expect(await databaseExists(dbPathTutorials), true);
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
      expect(bookmarks[0].authorName, testBookmarkTutorial.authorName);
      expect(bookmarks[0].bookmarkId, testBookmarkTutorial.bookmarkId);
      expect(bookmarks[0].id, testBookmarkTutorial.id);
      expect(bookmarks[0].tutorialText, testBookmarkTutorial.tutorialText);
      expect(bookmarks[0].tutorialTitle, testBookmarkTutorial.tutorialTitle);
    });

    test('check if bookmark exists', () async {
      final service = locator<BookmarksDatabaseService>();
      await service.initialise();
      expect(await service.isBookmarked(testBookmarkTutorial), true);
    });

    test('delete bookmark', () async {
      final service = locator<BookmarksDatabaseService>();
      await service.initialise();
      await service.removeBookmark(testBookmarkTutorial);
      final bookmarks = await service.getBookmarks();
      expect(bookmarks, isA<List<BookmarkedTutorial>>());
      expect(bookmarks.length, 0);
    });
  });
}
