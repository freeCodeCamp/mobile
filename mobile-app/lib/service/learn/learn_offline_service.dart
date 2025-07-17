import 'package:freecodecamp/models/learn/daily_challenge_model.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/models/learn/daily_challenge_model.dart';
import 'package:freecodecamp/service/dio_service.dart';
import 'package:freecodecamp/service/learn/daily_challenges_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final _dio = DioService.dio;

  // Lazy initialization of the daily challenges service
  DailyChallengesService? _dailyChallengesService;
  DailyChallengesService get dailyChallengesService {
    _dailyChallengesService ??= locator<DailyChallengesService>();
    return _dailyChallengesService!;
  }

  /*
   This function will return an instance of every challenge download that has
   previously occured when downloading.

   // TODO: check if it is neccessary to request all challenges and not just the block
  */

  Future<List<ChallengeDownload?>> checkStoredChallenges() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? storedChallenges = prefs.getStringList('storedChallenges');

    bool hasStoredChallenges = storedChallenges != null;

    if (!hasStoredChallenges) {
      // prefs.setStringList('storedChallenges', []);
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

  /*
  This function will request the given url and return an instance of a challenge.s
  */

  Future<Challenge> getChallenge(String url, [String challengeId = '']) async {
    Challenge challenge;

    Response res = await _dio.get(url);
    if (res.statusCode == 200) {
      challenge = Challenge.fromJson(res.data);
      return challenge;
    } else {
      throw Exception('Please check your internet connection.');
    }

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (await hasInternet()) {
    //   Response res = await _dio.get(url);

    //   if (prefs.getString(url) == null) {
    //     if (res.statusCode == 200) {
    //       challenge = Challenge.fromJson(res.data);

    //       prefs.setString(url, jsonEncode(res.data));

    //       return challenge;
    //     }
    //   }

    //   challenge = Challenge.fromJson(
    //     jsonDecode(prefs.getString(url) as String),
    //   );
    // } else {
    //   String? challengeStr = prefs.getString(challengeId);
    //   if (challengeStr == null) {
    //     throw Exception('No internet connection and no stored challenge');
    //   } else {
    //     challenge = Challenge.fromJson(jsonDecode(challengeStr));
    //   }
    // }
    // return challenge;
  }

  /*
    This function fetches a daily challenge by date and map it to Challenge.
  */

  Future<Challenge> getDailyChallenge(String date, Block block) async {
    try {
      DailyChallenge dailyChallenge =
          await dailyChallengesService.fetchChallengeByDate(date);

      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? selectedLangStr =
          prefs.getString('selectedDailyChallengeLanguage');
      DailyChallengeLanguage selectedLangEnum;

      if (selectedLangStr == null || selectedLangStr.isEmpty) {
        selectedLangEnum = DailyChallengeLanguage.javascript;
      } else {
        selectedLangEnum = DailyChallengeLanguage.values.firstWhere(
          (e) => e.name == selectedLangStr,
          orElse: () => DailyChallengeLanguage.javascript,
        );
      }

      // Map enum to challenge data and help category
      dynamic challengeData;
      HelpCategory helpCategory;
      switch (selectedLangEnum) {
        case DailyChallengeLanguage.python:
          challengeData = dailyChallenge.python;
          helpCategory = HelpCategory.python;
          break;
        default:
          challengeData = dailyChallenge.javascript;
          helpCategory = HelpCategory.javascript;
      }

      return Challenge(
        id: dailyChallenge.id,
        block: block.dashedName,
        title: dailyChallenge.title,
        description: dailyChallenge.description,
        instructions: '',
        dashedName: '',
        superBlock: block.superBlock.dashedName,
        videoId: null,
        challengeType: 28,
        tests: challengeData.tests,
        files: challengeData.challengeFiles,
        helpCategory: helpCategory,
        explanation: '',
        transcript: '',
        hooks: Hooks.fromJson({'beforeAll': ''}),
        fillInTheBlank: null,
        audio: null,
        scene: null,
        questions: null,
        assignments: null,
        quizzes: null,
      );
    } catch (e) {
      throw Exception('Failed to fetch daily challenge: $e');
    }
  }

  /*
    This function will download every challenges in a given amount of time in a
    certain block. It will request these urls and update the respective stream
    which is listen to on the front-end.
  */

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

  /*
    This function will store a downloaded challenge, it will return a future.
    If an error occurs an instance of a Future.error is throw which should stop
    the downloading.

    // TODO: check if downloading stops if an error occurs
  */

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

        await prefs.setStringList(
          'storedChallenges',
          downloadObjects.map((e) => jsonEncode(e)).toList(),
        );
        await prefs.setString(challenge.id, jsonEncode(challengeObj));
      }

      return Future<String>.value('download completed');
    } catch (e) {
      return Future<String>.error(
        Exception('unable to store challenge: \n ${e.toString()}'),
      );
    }
  }

  /*
  This function wil cancel the download of challenges, it will delete challenges
  that are already downloaded. It will also remove the correlated block.
  */

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

      await prefs.setStringList(
        'storedChallenges',
        challengeObjects.map((e) => jsonEncode(e)).toList(),
      );
    }
  }

  /*
    This function checks if the user has internet, it makes a request to a given
    URL, which will return an error if the request did not go through.
  */

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

  /*
    This function will cache the given block.
  */

  Future<void> cacheBlockInfo(Block block) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      Map<String, dynamic> blockToJson = {};
      List<String>? storedBlocks = prefs.getStringList('storedBlocks');

      if (storedBlocks == null) {
        await prefs.setStringList('storedBlocks', [
          jsonEncode(blockToJson),
        ]);

        log('it is empty');
      } else {
        List<String> newInfo = storedBlocks;

        newInfo.add(jsonEncode(blockToJson));

        await prefs.setStringList(
          'storedBlocks',
          newInfo,
        );
      }
    } catch (e) {
      return Future.error('Could not download block info');
    }
  }

  /*
    This function will remove the cached block according to the given dashed name
    of the block in question. If there is an error removing the block an error
    will be thrown.
  */

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
              await prefs.setStringList('storedBlocks', []);
            } else {
              await prefs.setStringList('storedBlocks', [...storedBlocks]);
            }

            break;
          }
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /*
  This function retrieves the cached blocks according to their correlated
  superblock by giving the superblock's dashed name. If there are no cached
  blocks on the gives superblock, it wil return an empty list.
  */

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

  /*
  This function retrieves a list of superblock buttons which are used to build
  the landing page. It firstly checks if there are any cached blocks, if so
  get the superblock names correlated to the block in question. This will start
  a for loop which will return the superblock buttons in a list.
  */

  Future<List<SuperBlockButtonData>> getCachedSuperblocks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? blocks = prefs.getStringList('storedBlocks');

    List<List<String>> superBlockNames = [];

    List<SuperBlockButtonData> buttons = [];

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
        SuperBlockButtonData(
          path: superBlockNames[i][0],
          name: superBlockNames[i][1],
          public: true,
        ),
      );
    }

    return buttons;
  }
}
