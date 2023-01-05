import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ChallengeDownload {
  const ChallengeDownload({required this.id, required this.date});

  final String id;
  final String date;

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
  int downloadsCompleted = 0;

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

  Future<Challenge> getChallenge(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response res = await http.get(Uri.parse(url));

    if (prefs.getString(url) == null) {
      if (res.statusCode == 200) {
        Challenge challenge = Challenge.fromJson(
          jsonDecode(
            res.body,
          )['result']['data']['challengeNode']['challenge'],
        );

        prefs.setString(url, res.body);

        return challenge;
      }
    }

    Challenge challenge = Challenge.fromJson(
      jsonDecode(
        prefs.getString(url) as String,
      )['result']['data']['challengeNode']['challenge'],
    );

    return challenge;
  }

  Future<void> getChallengeBatch(List<String> urls) async {
    int index = 0;

    Timer.periodic(const Duration(seconds: 5), (timer) async {
      await storeDownloadedChallenge(await getChallenge(urls[index]));

      index += 1;

      log('timer $index');

      if (urls.length == index) {
        timer.cancel();
      }
    });
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
        downloadObjects.add({
          'id': challenge.id,
          'date': DateTime.now().toString(),
        });

        prefs.setStringList(
          'storedChallenges',
          downloadObjects.map((e) => jsonEncode(e)).toList(),
        );
        prefs.setString(challenge.id, challengeObj.toString());
      }

      return Future<String>.value('download completed');
    } catch (e) {
      return Future<String>.error(
        Exception('unable to store challenge: \n ${e.toString()}'),
      );
    }
  }
}
