import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/completed_challenge_model.dart';
import 'package:freecodecamp/models/learn/motivational_quote_model.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/ui/views/learn/challenge/challenge_viewmodel.dart';
import 'package:stacked/stacked.dart';

class PassWidgetModel extends BaseViewModel {
  final AuthenticationService auth = locator<AuthenticationService>();

  Future<int> numCompletedChallenges(
    ChallengeViewModel challengeModel,
    int challengesCompleted,
  ) async {
    FccUserModel? user = await auth.userModel;
    if (user != null) {
      List<CompletedChallenge> completedChallenges = user.completedChallenges;
      Challenge? currChallenge = challengeModel.challenge;
      if (currChallenge != null) {
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
}
