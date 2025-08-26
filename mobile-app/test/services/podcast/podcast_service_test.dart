import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:freecodecamp/service/podcast/podcasts_service.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return Directory.systemTemp.createTempSync().path;
  }
}

void main() {
  group('PodcastsDatabaseService Tests', () {
    late PodcastsDatabaseService service;
    late MockPathProviderPlatform mockPathProvider;

    setUp(() async {
      mockPathProvider = MockPathProviderPlatform();
      PathProviderPlatform.instance = mockPathProvider;
      service = PodcastsDatabaseService();
      await service.initialise();
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
  });
}