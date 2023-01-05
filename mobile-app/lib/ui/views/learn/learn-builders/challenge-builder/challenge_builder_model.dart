import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/completed_challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/learn/learn_offline_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ChallengeBuilderModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthenticationService _auth = locator<AuthenticationService>();

  FccUserModel? user;

  bool _isOpen = false;
  bool get isOpen => _isOpen;

  int _challengesCompleted = 0;
  int get challengesCompleted => _challengesCompleted;

  final learnOfflineService = locator<LearnOfflineService>();

  set setIsOpen(bool widgetIsOpened) {
    _isOpen = widgetIsOpened;
    notifyListeners();
  }

  void initBlockState(String blockName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(blockName)) {
      prefs.setBool(blockName, true);
    }

    setBlockOpenState(blockName, prefs.getBool(blockName) ?? false);
  }

  void setBlockOpenState(String blockName, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(blockName, !value);
    _isOpen = !value;
    notifyListeners();
  }

  void routeToChallengeView(String url, Block block) {
    _navigationService.navigateTo(
      Routes.challengeView,
      arguments: ChallengeViewArguments(
        url: url,
        block: block,
        challengesCompleted: _challengesCompleted,
      ),
    );
  }

  void init(List<ChallengeListTile> challengeBatch) async {
    user = await _auth.userModel;
    setNumberOfCompletedChallenges(challengeBatch);
    notifyListeners();
  }

  void testChallenge(Challenge challenge) {
    learnOfflineService.storeDownloadedChallenge(challenge);
  }

  void setNumberOfCompletedChallenges(List<ChallengeListTile> challengeBatch) {
    int count = 0;
    if (user != null) {
      Iterable<String> completedChallengeIds =
          user!.completedChallenges.map((e) => e.id);

      for (ChallengeListTile challenge in challengeBatch) {
        if (completedChallengeIds.contains(challenge.id)) {
          count++;
        }
      }
      _challengesCompleted = count;
      notifyListeners();
    }
  }

  bool completedChallenge(String incomingId) {
    if (user != null) {
      for (CompletedChallenge challenge in user!.completedChallenges) {
        if (challenge.id == incomingId) {
          return true;
        }
      }
    }

    return false;
  }

  Icon getIcon(bool completed) {
    if (completed) {
      return const Icon(Icons.check_circle);
    }
    return const Icon(Icons.circle_outlined);
  }
}
