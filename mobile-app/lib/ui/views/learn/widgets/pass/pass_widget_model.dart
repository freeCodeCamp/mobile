import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/completed_challenge_model.dart';
import 'package:freecodecamp/models/learn/motivational_quote_model.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/service/authentication_service.dart';
import 'package:freecodecamp/service/learn_service.dart';
import 'package:freecodecamp/ui/views/learn/challenge_editor/challenge_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class PassWidgetModel extends BaseViewModel {
  final AuthenticationService auth = locator<AuthenticationService>();
  final LearnService _learnService = locator<LearnService>();

  late FccUserModel? _user;

  void init() async {
    _user = await auth.userModel;
    notifyListeners();
  }

  Future<int> numCompletedChallenges(
    ChallengeModel challengeModel,
    int challengesCompleted,
  ) async {
    if (_user != null) {
      List<CompletedChallenge>? completedChallenges =
          _user?.completedChallenges;
      Challenge? currChallenge = await challengeModel.challenge;
      if (currChallenge != null && completedChallenges != null) {
        if (completedChallenges
                .indexWhere((element) => element.id == currChallenge.id) !=
            -1) {
          return challengesCompleted;
        } else {
          return challengesCompleted + 1;
        }
      }
    }
    return 0;
  }

  Future<MotivationalQuote> retrieveNewQuote() async {
    String path = 'assets/learn/motivational-quotes.json';
    String file = await rootBundle.loadString(path);

    int quoteLength = jsonDecode(file)['motivationalQuotes'].length;

    Random random = Random();

    int randomValue = random.nextInt(quoteLength);

    dynamic json = jsonDecode(file)['motivationalQuotes'][randomValue];

    MotivationalQuote quote = MotivationalQuote.fromJson(json);

    return quote;
  }

  void passChallenge(ChallengeModel model) async {
    _learnService.init();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Challenge? challenge = await model.challenge;
    if (challenge != null) {
      List challengeFiles = challenge.files.map((file) {
        return {
          'contents': prefs.getString('${challenge.title}.${file.name}') ??
              file.contents,
          'ext': file.ext.name,
          'history': file.history,
          'key': file.fileKey,
          'name': file.name,
        };
      }).toList();
      await _learnService.postChallengeCompleted(challenge, challengeFiles);
    }
  }
}
