import 'dart:convert';

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

  // Future<bool> storeDownloadedChallenge(Challenge challenge) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   if(prefs.)
  // }
}
