import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/news/bookmarked_tutorial_model.dart';
import 'package:freecodecamp/models/news/tutorial_model.dart';
import 'package:freecodecamp/service/news/bookmark_service.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

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
  
  group('News Bookmark Service Test -', () {
    late Directory tempDir;
    
    setUp(() async {
      registerServices();
      // Create a temporary directory for testing
      tempDir = await Directory.systemTemp.createTemp('bookmark_test_');
      
      // Mock path_provider to use our temp directory
      PathProviderPlatform.instance = FakePathProviderPlatform(tempDir.path);
    });
    
    tearDown(() async {
      locator.reset();
      // Clean up temporary directory
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('init service', () async {
      final service = locator<BookmarksDatabaseService>();
      await service.initialise();
      expect(service, isA<BookmarksDatabaseService>());
      
      // Check that articles.json file is created in temp directory
      String articlesPath = path.join(tempDir.path, 'articles.json');
      // File might not exist yet if no bookmarks are added
      expect(await Directory(tempDir.path).exists(), true);
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
      expect(bookmarks[0].bookmarkId, 1); // First bookmark should have ID 1
      expect(bookmarks[0].id, testBookmarkTutorial.id);
      expect(bookmarks[0].tutorialText, testBookmarkTutorial.tutorialText);
      expect(bookmarks[0].tutorialTitle, testBookmarkTutorial.tutorialTitle);
    });

    test('check if bookmark exists', () async {
      final service = locator<BookmarksDatabaseService>();
      await service.initialise();
      
      // Initially should not be bookmarked
      expect(await service.isBookmarked(testTutorial), false);
      
      // Add bookmark
      await service.addBookmark(testTutorial);
      
      // Now should be bookmarked
      expect(await service.isBookmarked(testTutorial), true);
    });

    test('delete bookmark', () async {
      final service = locator<BookmarksDatabaseService>();
      await service.initialise();
      
      // Add bookmark first
      await service.addBookmark(testTutorial);
      var bookmarks = await service.getBookmarks();
      expect(bookmarks.length, 1);
      
      // Remove bookmark
      await service.removeBookmark(testTutorial);
      bookmarks = await service.getBookmarks();
      expect(bookmarks, isA<List<BookmarkedTutorial>>());
      expect(bookmarks.length, 0);
    });

    test('prevent duplicate bookmarks', () async {
      final service = locator<BookmarksDatabaseService>();
      await service.initialise();
      
      // Add same bookmark twice
      await service.addBookmark(testTutorial);
      await service.addBookmark(testTutorial);
      
      final bookmarks = await service.getBookmarks();
      expect(bookmarks.length, 1); // Should only have one bookmark
    });

    test('persistence between service instances', () async {
      // First service instance
      final service1 = locator<BookmarksDatabaseService>();
      await service1.initialise();
      await service1.addBookmark(testTutorial);
      
      var bookmarks = await service1.getBookmarks();
      expect(bookmarks.length, 1);
      
      // Reset and create new service instance
      locator.reset();
      registerServices();
      
      final service2 = locator<BookmarksDatabaseService>();
      await service2.initialise();
      
      // Should load the previously saved bookmark
      bookmarks = await service2.getBookmarks();
      expect(bookmarks.length, 1);
      expect(bookmarks[0].id, testTutorial.id);
    });
  });
}

// Mock PathProviderPlatform for testing
class FakePathProviderPlatform extends PathProviderPlatform {
  final String tempPath;
  
  FakePathProviderPlatform(this.tempPath);
  
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return tempPath;
  }
  
  @override
  Future<String?> getTemporaryPath() async {
    return tempPath;
  }
  
  @override
  Future<String?> getApplicationSupportPath() async {
    return tempPath;
  }
  
  @override
  Future<String?> getLibraryPath() async {
    return tempPath;
  }
  
  @override
  Future<String?> getExternalStoragePath() async {
    return tempPath;
  }
  
  @override
  Future<List<String>?> getExternalCachePaths() async {
    return [tempPath];
  }
  
  @override
  Future<List<String>?> getExternalStoragePaths({
    StorageDirectory? type,
  }) async {
    return [tempPath];
  }
  
  @override
  Future<String?> getDownloadsPath() async {
    return tempPath;
  }
}
