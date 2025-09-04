import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/completed_challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/models/learn/motivational_quote_model.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/ui/views/learn/challenge/challenge_viewmodel.dart';
import 'package:stacked/stacked.dart';

class PassWidgetModel extends BaseViewModel {
  final AuthenticationService auth = locator<AuthenticationService>();

  Future<MotivationalQuote>? quoteFuture;

  set setQuoteFuture(Future<MotivationalQuote> value) {
    quoteFuture = value;
    notifyListeners();
  }

  void initQuoute() {
    setQuoteFuture = retrieveNewQuote();
  }

  Future<int> numCompletedChallenges(ChallengeViewModel challengeModel) async {
    FccUserModel? user = await auth.userModel;
    if (user != null) {
      Challenge? currChallenge = challengeModel.challenge;
      List<CompletedChallenge> completedChallenges = user.completedChallenges;
      Set<String> completedChallengeIds =
          completedChallenges.map((completed) => completed.id).toSet();
      int completedCount = 0;
      List<ChallengeOrder> blockChallenges =
          challengeModel.block?.challenges ?? [];

      for (ChallengeOrder challenge in blockChallenges) {
        if (completedChallengeIds.contains(challenge.id)) {
          completedCount += 1;
        }
      }

      if (currChallenge != null &&
          !completedChallengeIds.contains(currChallenge.id)) {
        completedCount += 1;
      }

      return completedCount;
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
