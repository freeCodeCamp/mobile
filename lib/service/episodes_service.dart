import 'dart:async';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/downloaded_episodes.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:developer';
import 'package:sqflite_migration_service/sqflite_migration_service.dart';

const String episodesTablename = 'episodes';

class EpisodeDatabaseService {
  final _migrationService = locator<DatabaseMigrationService>();
  late Database _db;

  Future initialise() async {
    _db = await openDatabase('episodes.db', version: 1);
    // _migrationService.resetVersion();

    await _migrationService.runMigration(
      _db,
      migrationFiles: ['1_create_episode_schema.sql'],
      verbose: true,
    );
  }

  Future<List<DownloadedEpisodes>> getDownloadedEpisodes() async {
    List<Map<String, dynamic>> epsResults = await _db.query(episodesTablename);
    log(epsResults
        .map((episode) => DownloadedEpisodes.fromJson(episode))
        .where((episode) => episode.downloaded)
        .toList()
        .length
        .toString());
    return epsResults
        .map((episode) => DownloadedEpisodes.fromJson(episode))
        .where((episode) => episode.downloaded)
        .toList();
  }

  Future<List<DownloadedEpisodes>> getAllEpisodes() async {
    List<Map<String, dynamic>> epsResults = await _db.query(episodesTablename);
    return epsResults
        .map((episode) => DownloadedEpisodes.fromJson(episode))
        .toList();
  }

  Future<DownloadedEpisodes?> getEpisode(String guid) async {
    List<Map<String, dynamic>> epResult = await _db.query(
      episodesTablename,
      where: 'guid = ?',
      whereArgs: [guid],
    );
    if (epResult.isNotEmpty) {
      return DownloadedEpisodes.fromJson(epResult.first);
    }
    return null;
  }

  Future addEpisode(dynamic episode) async {
    try {
      await _db.insert(
          episodesTablename,
          DownloadedEpisodes(
            guid: episode.guid,
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
        episodesTablename,
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
