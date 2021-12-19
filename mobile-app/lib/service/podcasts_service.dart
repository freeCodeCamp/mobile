import 'dart:async';
import 'dart:developer';

import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:podcast_search/podcast_search.dart';
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
      migrationFiles: ['1_create_db_schema.sql'],
      verbose: true,
    );
    log("FINISHED LOADING MIGRATIONS");
  }

  // PODCAST QUERIES
  Future<List<Podcasts>> getAllPodcasts() async {
    List<Map<String, dynamic>> podcastsResults =
        await _db.query(podcastsTableName);
    return podcastsResults
        .map((podcast) => Podcasts.fromJson(podcast))
        .toList();
  }

  Future<List<Podcasts>> getDownloadedPodcasts() async {
    List<Map<String, dynamic>> downloadedPodcastResults = await _db.rawQuery(
        'SELECT * from podcasts where id in (select podcastId from episodes where downloaded=1 group by podcastId)');
    return downloadedPodcastResults
        .map((podcast) => Podcasts.fromJson(podcast))
        .toList();
  }

  Future<Podcasts?> getPodcast(String podcastId) async {
    List<Map<String, dynamic>> podcastResult = await _db.query(
      podcastsTableName,
      where: 'id = ?',
      whereArgs: [podcastId],
    );
    if (podcastResult.isNotEmpty) {
      return Podcasts.fromJson(podcastResult.first);
    }
    return null;
  }

  Future addPodcast(Podcast podcast, String podcastId) async {
    try {
      await _db.insert(
          podcastsTableName,
          Podcasts(
            id: podcastId,
            url: podcast.url,
            link: podcast.link,
            title: podcast.title,
            description: podcast.description,
            image: podcast.image,
            copyright: podcast.copyright,
            numEps: podcast.episodes?.length,
          ).toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      log("Added Podcast: ${podcast.title}");
    } catch (e) {
      log('Could not insert the podcast: $e');
    }
  }

  // EPISODE QUERIES
  Future<List<Episodes>> getDownloadedEpisodes(String podcastId) async {
    List<Map<String, dynamic>> epsResults = await _db.query(
      episodesTableName,
      where: 'podcastId = ?',
      whereArgs: [podcastId],
    );
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

  Future<List<Episodes>> getEpisodes(String podcastId) async {
    List<Map<String, dynamic>> epsResults = await _db.query(
      episodesTableName,
      where: 'podcastId = ?',
      whereArgs: [podcastId],
    );
    return epsResults.map((episode) => Episodes.fromJson(episode)).toList();
  }

  Future<Episodes> getEpisode(String podcastId, String guid) async {
    List<Map<String, dynamic>> epResult = await _db.query(
      episodesTableName,
      where: 'podcastId = ? AND guid = ?',
      whereArgs: [podcastId, guid],
    );
    return Episodes.fromJson(epResult.first);
  }

  Future addEpisode(Episode episode, String podcastId) async {
    try {
      await _db.insert(
          episodesTableName,
          Episodes(
            guid: episode.guid,
            podcastId: podcastId,
            title: episode.title,
            description: episode.description,
            publicationDate: episode.publicationDate,
            contentUrl: episode.contentUrl,
            duration: episode.duration,
            downloaded: false,
          ).toJson(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
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
