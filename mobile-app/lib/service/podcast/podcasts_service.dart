import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

const String podcastsFileName = 'podcasts.json';
const String episodesFileName = 'episodes.json';

class PodcastsDatabaseService {
  List<Podcasts> _podcasts = [];
  List<Episodes> _episodes = [];
  File? _podcastsFile;
  File? _episodesFile;

  Future initialise() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      _podcastsFile = File(path.join(directory.path, podcastsFileName));
      _episodesFile = File(path.join(directory.path, episodesFileName));
      
      await _loadPodcastsFromFile();
      await _loadEpisodesFromFile();
      
      log('Podcast service initialized with ${_podcasts.length} podcasts and ${_episodes.length} episodes');
    } catch (e) {
      log('Error initializing podcast service: $e');
      _podcasts = [];
      _episodes = [];
    }
  }

  Future _loadPodcastsFromFile() async {
    try {
      if (_podcastsFile == null || !await _podcastsFile!.exists()) {
        log('Podcasts file does not exist, starting with empty podcasts');
        _podcasts = [];
        return;
      }

      String contents = await _podcastsFile!.readAsString();
      if (contents.trim().isEmpty) {
        log('Podcasts file is empty, starting with empty podcasts');
        _podcasts = [];
        return;
      }

      List<dynamic> jsonList = json.decode(contents);
      _podcasts = jsonList.map((json) => Podcasts.fromDBJson(json)).toList();
      
      log('Loaded ${_podcasts.length} podcasts from file');
    } catch (e) {
      log('Error loading podcasts from file: $e');
      _podcasts = [];
    }
  }

  Future _loadEpisodesFromFile() async {
    try {
      if (_episodesFile == null || !await _episodesFile!.exists()) {
        log('Episodes file does not exist, starting with empty episodes');
        _episodes = [];
        return;
      }

      String contents = await _episodesFile!.readAsString();
      if (contents.trim().isEmpty) {
        log('Episodes file is empty, starting with empty episodes');
        _episodes = [];
        return;
      }

      List<dynamic> jsonList = json.decode(contents);
      _episodes = jsonList.map((json) => Episodes.fromDBJson(json)).toList();
      
      log('Loaded ${_episodes.length} episodes from file');
    } catch (e) {
      log('Error loading episodes from file: $e');
      _episodes = [];
    }
  }

  Future _savePodcastsToFile() async {
    try {
      if (_podcastsFile == null) {
        log('Podcasts file not initialized');
        return;
      }

      await _podcastsFile!.parent.create(recursive: true);
      
      List<Map<String, dynamic>> jsonList = _podcasts.map((p) => p.toJson()).toList();
      String jsonString = json.encode(jsonList);
      
      await _podcastsFile!.writeAsString(jsonString);
      log('Saved ${_podcasts.length} podcasts to file');
    } catch (e) {
      log('Error saving podcasts to file: $e');
    }
  }

  Future _saveEpisodesToFile() async {
    try {
      if (_episodesFile == null) {
        log('Episodes file not initialized');
        return;
      }

      await _episodesFile!.parent.create(recursive: true);
      
      List<Map<String, dynamic>> jsonList = _episodes.map((e) => e.toJson()).toList();
      String jsonString = json.encode(jsonList);
      
      await _episodesFile!.writeAsString(jsonString);
      log('Saved ${_episodes.length} episodes to file');
    } catch (e) {
      log('Error saving episodes to file: $e');
    }
  }

  // PODCAST QUERIES
  Future<List<Podcasts>> getPodcasts() async {
    return List.from(_podcasts);
  }

  Future addPodcast(Podcasts podcast) async {
    try {
      // Check if podcast already exists
      bool exists = _podcasts.any((p) => p.id == podcast.id);
      if (exists) {
        log('Podcast already exists: ${podcast.title}');
        return;
      }

      _podcasts.add(podcast);
      await _savePodcastsToFile();
      log('Added Podcast: ${podcast.title}');
    } catch (e) {
      log('Could not insert the podcast: $e');
    }
  }

  Future removePodcast(Podcasts podcast) async {
    try {
      // Check if podcast has episodes
      int episodeCount = _episodes.where((e) => e.podcastId == podcast.id).length;
      
      if (episodeCount == 0) {
        _podcasts.removeWhere((p) => p.id == podcast.id);
        await _savePodcastsToFile();
        log('Removed Podcast: ${podcast.title}');
      } else {
        log('Did not remove podcast: ${podcast.title} because it has $episodeCount episodes');
      }
    } catch (e) {
      log('Could not remove the podcast: $e');
    }
  }

  // EPISODE QUERIES
  Future<List<Episodes>> getEpisodes(Podcasts podcast) async {
    return _episodes.where((e) => e.podcastId == podcast.id).toList();
  }

  Future<Episodes?> getEpisode(String podcastId, String guid) async {
    try {
      return _episodes.firstWhere(
        (e) => e.podcastId == podcastId && e.id == guid,
      );
    } catch (e) {
      log('Episode not found: podcastId=$podcastId, guid=$guid');
      return null;
    }
  }

  Future addEpisode(Episodes episode) async {
    try {
      // Check if episode already exists
      bool exists = _episodes.any((e) => e.podcastId == episode.podcastId && e.id == episode.id);
      if (exists) {
        log('Episode already exists: ${episode.title}');
        return;
      }

      _episodes.add(episode);
      await _saveEpisodesToFile();
      log('Added Episode: ${episode.title}');
    } catch (e) {
      log('Could not insert the episode: $e');
    }
  }

  Future removeEpisode(Episodes episode) async {
    try {
      _episodes.removeWhere((e) => e.podcastId == episode.podcastId && e.id == episode.id);
      await _saveEpisodesToFile();
      log('Removed Episode: ${episode.title}');
    } catch (e) {
      log('Could not remove the episode: $e');
    }
  }

  Future<bool> episodeExists(Episodes episode) async {
    return _episodes.any((e) => e.podcastId == episode.podcastId && e.id == episode.id);
  }
}
