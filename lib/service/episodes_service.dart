import 'dart:async';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:developer';
import 'package:sqflite_migration_service/sqflite_migration_service.dart';

const String episodesTableName = 'episodes';

class EpisodesDatabaseService {
  final _migrationService = locator<DatabaseMigrationService>();
  late Database _db;

  Future initialise() async {
    _db = await openDatabase('podcasts.db', version: 1);
    // Uncomment below line to reset migrations
    // _migrationService.resetVersion();

    await _migrationService.runMigration(
      _db,
      migrationFiles: ['1_create_schema.sql'],
      verbose: true,
    );
  }

  Future<List<Episodes>> getEpisodes() async {
    List<Map<String, dynamic>> epsResults = await _db.query(episodesTableName);
    log(epsResults
        .map((episode) => Episodes.fromJson(episode))
        .where((episode) => episode.downloaded)
        .toList()
        .length
        .toString());
    return epsResults
        .map((episode) => Episodes.fromJson(episode))
        .where((episode) => episode.downloaded)
        .toList();
  }

  Future<List<Episodes>> getAllEpisodes() async {
    List<Map<String, dynamic>> epsResults = await _db.query(episodesTableName);
    return epsResults.map((episode) => Episodes.fromJson(episode)).toList();
  }

  Future<Episodes?> getEpisode(String guid) async {
    List<Map<String, dynamic>> epResult = await _db.query(
      episodesTableName,
      where: 'guid = ?',
      whereArgs: [guid],
    );
    if (epResult.isNotEmpty) {
      return Episodes.fromJson(epResult.first);
    }
    return null;
  }

  Future addEpisode(dynamic episode, String podcastId) async {
    try {
      await _db.insert(
          episodesTableName,
          Episodes(
            guid: episode.guid,
            podcastId: podcastId,
            title: episode.title,
            description: episode.description,
            link: episode.link,
            publicationDate: episode.publicationDate,
            contentUrl: episode.contentUrl,
            imageUrl: episode.imageUrl,
            duration: episode.duration,
            downloaded: false,
          ).toJson());
      log("Added Episode: ${episode.title}");
    } catch (e) {
      log('Could not insert the episode: $e');
    }
  }

  Future toggleDownloadEpisode(String guid, bool downloaded) async {
    try {
      await _db.update(
        episodesTableName,
        {
          'downloaded': downloaded ? 1 : 0,
        },
        where: 'guid = ?',
        whereArgs: [guid],
      );
    } catch (e) {
      log('Could not update the episode: $e');
    }
  }
}
