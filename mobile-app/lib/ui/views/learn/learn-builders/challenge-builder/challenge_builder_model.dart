import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/models/learn/completed_challenge_model.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/service/authentication_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ChallengeBuilderModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthenticationService _auth = locator<AuthenticationService>();

  FccUserModel? user;

  void routeToBrowserView(String url) {
    _navigationService.navigateTo(Routes.challengeView,
        arguments: ChallengeViewArguments(url: url));
  }

  void init() async {
    user = await _auth.userModel;
    notifyListeners();
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
