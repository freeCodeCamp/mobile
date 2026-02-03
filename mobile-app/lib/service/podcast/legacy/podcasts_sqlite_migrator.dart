import 'dart:developer';

import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

const String _podcastsTableName = 'podcasts';
const String _episodesTableName = 'episodes';

class PodcastsSqliteMigrator {
  const PodcastsSqliteMigrator();

  Future<
      ({
        List<Map<String, dynamic>> podcasts,
        List<Map<String, dynamic>> episodes
      })> readPodcastsAndEpisodes() async {
    String dbFilePath;
    try {
      final dbPath = await getDatabasesPath();
      log('dbPath: $dbPath');
      dbFilePath = path.join(dbPath, 'podcasts.db');

      final exists = await databaseExists(dbFilePath);
      if (!exists) {
        return (
          podcasts: <Map<String, dynamic>>[],
          episodes: <Map<String, dynamic>>[],
        );
      }
    } catch (e) {
      // In some environments (e.g., unit tests without sqflite factory init),
      // any sqflite call can throw. Treat that as "no legacy DB".
      log('PodcastsSqliteMigrator unavailable: $e');
      return (
        podcasts: <Map<String, dynamic>>[],
        episodes: <Map<String, dynamic>>[],
      );
    }

    Database? db;
    try {
      db = await openDatabase(dbFilePath, version: 1);

      final podcasts = await db.query(_podcastsTableName);
      final episodes = await db.query(_episodesTableName);

      return (podcasts: podcasts, episodes: episodes);
    } catch (e) {
      log('PodcastsSqliteMigrator failed: $e');
      return (
        podcasts: <Map<String, dynamic>>[],
        episodes: <Map<String, dynamic>>[]
      );
    } finally {
      try {
        await db?.close();
      } catch (_) {}
    }
  }
}
