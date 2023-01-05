import 'dart:async';
import 'dart:developer';

import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_migration_service/sqflite_migration_service.dart';

const String podcastsTableName = 'podcasts';
const String episodesTableName = 'episodes';

class PodcastsDatabaseService {
  final _migrationService = locator<DatabaseMigrationService>();
  late Database _db;

  Future initialise() async {
    _db = await openDatabase('podcasts.db', version: 1);
    log(_db.path);
    // Uncomment below line to reset migrations
    // _migrationService.resetVersion();

    await _migrationService.runMigration(
      _db,
      migrationFiles: [
        '1_create_db_schema.sql',
        '2_delete_all_values.sql',
        '3_reset_episodes_schema.sql',
        '4_delete_all_values.sql',
      ],
      verbose: true,
    );
    log('FINISHED LOADING MIGRATIONS');
  }

  // PODCAST QUERIES
  Future<List<Podcasts>> getPodcasts() async {
    List<Map<String, dynamic>> podcastsResults =
        await _db.query(podcastsTableName);
    return podcastsResults
        .map((podcast) => Podcasts.fromDBJson(podcast))
        .toList();
  }

  Future addPodcast(Podcasts podcast) async {
    try {
      await _db.insert(
        podcastsTableName,
        podcast.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      log('Added Podcast: ${podcast.title}');
    } catch (e) {
      log('Could not insert the podcast: $e');
    }
  }

  Future removePodcast(Podcasts podcast) async {
    try {
      final res = await _db.rawQuery(
        'SELECT COUNT(*) FROM episodes GROUP BY podcastId HAVING podcastId = ?',
        [podcast.id],
      );
      final count = Sqflite.firstIntValue(res);
      if (count == 0 || count == null) {
        await _db.delete(
          podcastsTableName,
          where: 'id = ?',
          whereArgs: [podcast.id],
        );
        log('Removed Podcast: ${podcast.title}');
      } else {
        log('Did not remove podcast: ${podcast.title} because it has $count episodes');
      }
    } catch (e) {
      log('Could not remove the podcast: $e');
    }
  }

  // EPISODE QUERIES
  Future<List<Episodes>> getEpisodes(Podcasts podcast) async {
    List<Map<String, dynamic>> epsResults = await _db.query(
      episodesTableName,
      where: 'podcastId = ?',
      whereArgs: [podcast.id],
    );
    return epsResults.map((episode) => Episodes.fromDBJson(episode)).toList();
  }

  Future<Episodes> getEpisode(String podcastId, String guid) async {
    List<Map<String, dynamic>> epResult = await _db.query(
      episodesTableName,
      where: 'podcastId = ? AND guid = ?',
      whereArgs: [podcastId, guid],
    );
    return Episodes.fromDBJson(epResult.first);
  }

  Future addEpisode(Episodes episode) async {
    try {
      await _db.insert(
        episodesTableName,
        episode.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      log('Added Episode: ${episode.title}');
    } catch (e) {
      log('Could not insert the episode: $e');
    }
  }

  Future removeEpisode(Episodes episode) async {
    try {
      await _db.delete(
        episodesTableName,
        where: 'podcastId = ? AND id = ?',
        whereArgs: [episode.podcastId, episode.id],
      );
      log('Removed Episode: ${episode.title}');
    } catch (e) {
      log('Could not remove the episode: $e');
    }
  }

  Future<bool> episodeExists(Episodes episode) async {
    List<Map<String, dynamic>> epResult = await _db.query(
      episodesTableName,
      where: 'podcastId = ? AND id = ?',
      whereArgs: [episode.podcastId, episode.id],
    );
    return epResult.isNotEmpty;
  }
}
