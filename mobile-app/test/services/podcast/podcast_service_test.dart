import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:freecodecamp/service/podcast/podcasts_service.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('PodcastsDatabaseService Tests', () {
    late PodcastsDatabaseService service;
    late Directory tempDir;

    setUp(() async {
      // Create a temporary directory for testing
      tempDir = await Directory.systemTemp.createTemp('podcast_test_');
      
      // Mock path_provider to use our temp directory
      PathProviderPlatform.instance = FakePathProviderPlatform(tempDir.path);
      
      service = PodcastsDatabaseService();
      await service.initialise();
    });

    tearDown(() async {
      // Clean up temporary directory
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('should initialize with empty lists', () async {
      final podcasts = await service.getPodcasts();
      expect(podcasts, isEmpty);
    });

    test('should add and retrieve podcasts', () async {
      final podcast = Podcasts(
        id: 'test-id',
        url: 'https://example.com/feed.xml',
        title: 'Test Podcast',
        description: 'A test podcast',
      );

      await service.addPodcast(podcast);
      final podcasts = await service.getPodcasts();
      
      expect(podcasts.length, 1);
      expect(podcasts.first.id, 'test-id');
      expect(podcasts.first.title, 'Test Podcast');
    });

    test('should not add duplicate podcasts', () async {
      final podcast = Podcasts(
        id: 'test-id',
        url: 'https://example.com/feed.xml',
        title: 'Test Podcast',
      );

      await service.addPodcast(podcast);
      await service.addPodcast(podcast);
      final podcasts = await service.getPodcasts();
      
      expect(podcasts.length, 1);
    });

    test('should add and retrieve episodes', () async {
      final podcast = Podcasts(
        id: 'podcast-id',
        url: 'https://example.com/feed.xml',
        title: 'Test Podcast',
      );

      final episode = Episodes(
        id: 'episode-id',
        podcastId: 'podcast-id',
        title: 'Test Episode',
        description: 'A test episode',
      );

      await service.addPodcast(podcast);
      await service.addEpisode(episode);
      
      final episodes = await service.getEpisodes(podcast);
      expect(episodes.length, 1);
      expect(episodes.first.id, 'episode-id');
      expect(episodes.first.title, 'Test Episode');
    });

    test('should check if episode exists', () async {
      final episode = Episodes(
        id: 'episode-id',
        podcastId: 'podcast-id',
        title: 'Test Episode',
      );

      expect(await service.episodeExists(episode), false);
      
      await service.addEpisode(episode);
      expect(await service.episodeExists(episode), true);
    });

    test('should remove episodes', () async {
      final episode = Episodes(
        id: 'episode-id',
        podcastId: 'podcast-id',
        title: 'Test Episode',
      );

      await service.addEpisode(episode);
      expect(await service.episodeExists(episode), true);
      
      await service.removeEpisode(episode);
      expect(await service.episodeExists(episode), false);
    });

    test('should remove podcast only if no episodes exist', () async {
      final podcast = Podcasts(
        id: 'podcast-id',
        url: 'https://example.com/feed.xml',
        title: 'Test Podcast',
      );

      final episode = Episodes(
        id: 'episode-id',
        podcastId: 'podcast-id',
        title: 'Test Episode',
      );

      await service.addPodcast(podcast);
      await service.addEpisode(episode);
      
      // Should not remove podcast because it has episodes
      await service.removePodcast(podcast);
      final podcasts = await service.getPodcasts();
      expect(podcasts.length, 1);
      
      // Remove episode first
      await service.removeEpisode(episode);
      await service.removePodcast(podcast);
      final podcastsAfterRemoval = await service.getPodcasts();
      expect(podcastsAfterRemoval.length, 0);
    });

    test('should persist data between service instances', () async {
      final podcast = Podcasts(
        id: 'test-id',
        url: 'https://example.com/feed.xml',
        title: 'Test Podcast',
      );

      // Add podcast with first service instance
      await service.addPodcast(podcast);
      var podcasts = await service.getPodcasts();
      expect(podcasts.length, 1);

      // Create new service instance
      final newService = PodcastsDatabaseService();
      await newService.initialise();
      
      // Should load the previously saved podcast
      podcasts = await newService.getPodcasts();
      expect(podcasts.length, 1);
      expect(podcasts.first.id, 'test-id');
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