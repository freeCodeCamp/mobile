import 'dart:async';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:developer';
import 'package:sqflite_migration_service/sqflite_migration_service.dart';
// import 'package:uuid/uuid.dart';

const String podcastsTableName = 'podcasts';

class PodcastsDatabaseService {
  final _migrationService = locator<DatabaseMigrationService>();
  late Database _db;

  Future initialise() async {
    _db = await openDatabase('podcasts.db', version: 1);
    // Uncomment below line to reset migrations
    _migrationService.resetVersion();

    await _migrationService.runMigration(
      _db,
      migrationFiles: ['1_create_schema.sql'],
      verbose: true,
    );
  }

  Future<List<Podcasts>> getAllPodcasts() async {
    List<Map<String, dynamic>> epsResults = await _db.query(podcastsTableName);
    return epsResults
        .map((episode) => Podcasts.fromJson(episode))
        .toList();
  }

  // Future<Podcasts?> getEpisode(String guid) async {
  //   List<Map<String, dynamic>> epResult = await _db.query(
  //     episodesTablename,
  //     where: 'guid = ?',
  //     whereArgs: [guid],
  //   );
  //   if (epResult.isNotEmpty) {
  //     return Podcasts.fromJson(epResult.first);
  //   }
  //   return null;
  // }

  Future addPodcast(dynamic podcast, String podcastId) async {
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
          ).toJson());
      log("Added Podcast: ${podcast.title}");
    } catch (e) {
      log('Could not insert the podcast: $e');
    }
  }
}
