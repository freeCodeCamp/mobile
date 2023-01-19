import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ChallengeDownload {
  const ChallengeDownload({
    required this.id,
    required this.date,
    required this.block,
  });

  final String id;
  final String date;
  final String block;

  factory ChallengeDownload.fromObject(Map<String, dynamic> challengeObject) {
    return ChallengeDownload(
      id: challengeObject['id'],
      date: challengeObject['date'],
      block: challengeObject['block'],
    );
  }

  static toObject(ChallengeDownload challengeDownload) {
    return {
      'id': challengeDownload.id,
      'date': challengeDownload.date,
      'block': challengeDownload.block,
    };
  }
}

class LearnOfflineService {
  StreamController<double> downloadStream = StreamController.broadcast();
  StreamSubscription? batchSub;
  StreamSubscription? downloadSub;

  Timer? timer;

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

  Future<void> getChallengeBatch(Block block, List<String> urls) async {
    int index = 0;
    Duration duration = const Duration(milliseconds: 2000);

    await cacheBlockInfo(block);

    timer = Timer.periodic(duration, (timer) async {
      await storeDownloadedChallenge(await getChallenge(urls[index]));

      index += 1;

      if (!downloadStream.isClosed) {
        downloadStream.sink.add(
          index == 0 ? 1 / urls.length * 100 : index / urls.length * 100,
        );
      }

      if (urls.length == index) {
        timer.cancel();
      }
    });

    batchSub = downloadStream.stream.listen(
      (event) {
        log('percentage completed: $event');
      },
    );
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
          'block': challenge.block
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

  Future<void> cancelChallengeDownload(String block) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<ChallengeDownload?> downloads = await checkStoredChallenges();
    List<ChallengeDownload?> filteredDownloads = [];

    List<Map<String, dynamic>> challengeObjects = [];

    await removeCachedBlock(block);

    if (downloads.isNotEmpty) {
      for (int i = 0; i < downloads.length; i++) {
        if (downloads[i]!.block != block) {
          filteredDownloads.add(downloads[i]);
        }
      }

      for (int i = 0; i < filteredDownloads.length; i++) {
        challengeObjects.add(
          ChallengeDownload.toObject(
            filteredDownloads[i]!,
          ),
        );
      }

      prefs.setStringList(
        'storedChallenges',
        challengeObjects.map((e) => jsonEncode(e)).toList(),
      );
    }
  }

  Future<bool> hasInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      print('not connected');

      return false;
    }

    return false;
  }

  Future<void> cacheBlockInfo(Block block) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> blockToJson = Block.toCachedObject(block);
    List<String>? storedBlocks = prefs.getStringList('storedBlocks');

    if (storedBlocks == null) {
      prefs.setStringList('storedBlocks', [
        jsonEncode(blockToJson),
      ]);
    } else {
      List<String> newInfo = storedBlocks;

      newInfo.add(jsonEncode(newInfo));

      prefs.setStringList(
        'storedBlocks',
        newInfo,
      );
    }
  }

  Future<void> removeCachedBlock(String dashedBlockName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? storedBlocks = prefs.getStringList('storedBlocks');

    try {
      if (storedBlocks != null) {
        for (int i = 0; i < storedBlocks.length; i++) {
          Map<String, dynamic> data = json.decode(storedBlocks[i]);

          Block block = Block.fromJson(
            data,
            data['description'],
            data['dashedName'],
            data['superBlock']['dashedName'],
            data['superBlock']['name'],
          );

          if (dashedBlockName == block.dashedName) {
            storedBlocks.removeAt(i);

            if (storedBlocks.isEmpty) {
              prefs.setStringList('storedBlocks', []);
            } else {
              prefs.setStringList('storedBlocks', storedBlocks);
            }

            break;
          }

          print('stored blocks ${prefs.getStringList("storedBlocks")}');
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Block>?> getCachedBlocks(
    String superBlockDashedName,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? blocks = prefs.getStringList('storedBlocks');

    List<Block> convertedBlocks = [];

    if (blocks != null) {
      if (blocks.isEmpty) return [];

      for (int i = 0; i < blocks.length; i++) {
        Map<String, dynamic> data = jsonDecode(blocks[i]);

        Block block = Block.fromJson(
          data,
          data['description'],
          data['dashedName'],
          data['superBlock']['dashedName'],
          data['superBlock']['name'],
        );

        if (block.superBlock.dashedName == superBlockDashedName) {
          convertedBlocks.add(block);
        }
      }

      return convertedBlocks;
    }

    return [];
  }

  Future<List<SuperBlockButton>> getCachedSuperblocks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? blocks = prefs.getStringList('storedBlocks');

    List<List<String>> superBlockNames = [];

    List<SuperBlockButton> buttons = [];

    if (blocks != null) {
      for (int i = 0; i < blocks.length; i++) {
        Map<String, dynamic> data = jsonDecode(blocks[i]);

        if (!superBlockNames.contains(data['superBlock']['dashedName'])) {
          superBlockNames.add([
            data['superBlock']['dashedName'],
            data['superBlock']['name'],
          ]);
        }
      }
    }

    for (int i = 0; i < superBlockNames.length; i++) {
      buttons.add(
        SuperBlockButton(
          path: superBlockNames[i][0],
          name: superBlockNames[i][1],
          public: true,
        ),
      );
    }

    return buttons;
  }
}
