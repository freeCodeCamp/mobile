import 'dart:convert';

import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChallengeDownload {
  const ChallengeDownload({required this.id, required this.date});

  final String id;
  final DateTime date;

  factory ChallengeDownload.fromObject(Map<String, dynamic> challengeObject) {
    return ChallengeDownload(
      id: challengeObject['id'],
      date: challengeObject['date'],
    );
  }

  static toObject(ChallengeDownload challengeDownload) {
    return {
      'id': challengeDownload.id,
      'date': challengeDownload.date,
    };
  }
}

class LearnOfflineService {
  Future<List<ChallengeDownload?>> checkStoredChallenges() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? storedChallenges = prefs.getStringList('storedChallenges');

    bool hasStoredChallenges = storedChallenges != null;

    if (!hasStoredChallenges) {
      prefs.setStringList('storedChallenges', []);
    } else {
      List<ChallengeDownload> converted = [];

      for (int i = 0; i < storedChallenges.length; i++) {
        Map<String, dynamic> toObject = jsonDecode(storedChallenges[i]);

        converted.add(ChallengeDownload.fromObject(toObject));
      }

      return converted;
    }

    return [];
  }

  Future<Future<dynamic>> storeDownloadedChallenge(Challenge challenge) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> challengeObj = Challenge.toJson(challenge);

      List<ChallengeDownload?> downloads = await checkStoredChallenges();
      List<Map<String, dynamic>> downloadObjects = [];

      List<String> downloadIds = [];

      for (int i = 0; i < downloads.length; i++) {
        if (downloads[i] == null) continue;

        downloadObjects.add(ChallengeDownload.toObject(downloads[i]!));

        downloadIds.add(downloads[i]!.id);
      }

      if (!downloadIds.contains(challenge.id)) {
        downloadObjects.add({'id': challenge.id, 'date': DateTime.now()});

        prefs.setStringList(
          'storedChallenges',
          downloadObjects.map((e) => e.toString()).toList(),
        );
        prefs.setString(challenge.id, challengeObj.toString());
      }

      return Future<String>.value('download completed');
    } catch (e) {
      return Future.error(
        Exception('unable to download challenge: \n ${e.toString()}'),
      );
    }
  }
}
