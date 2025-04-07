import 'dart:async';
import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/models/learn/completed_challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/developer_service.dart';
import 'package:freecodecamp/service/learn/learn_offline_service.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:freecodecamp/ui/views/learn/block/templates/dialogue/dialogue_view.dart';
import 'package:freecodecamp/ui/views/learn/block/templates/grid/grid_view.dart';
import 'package:freecodecamp/ui/views/learn/block/templates/link/link_view.dart';
import 'package:freecodecamp/ui/views/learn/block/templates/list/list_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class BlockTemplateViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthenticationService _auth = locator<AuthenticationService>();

  FccUserModel? user;

  bool _isDev = false;
  bool get isDev => _isDev;

  bool _isOpen = false;
  bool get isOpen => _isOpen;

  int _challengesCompleted = 0;
  int get challengesCompleted => _challengesCompleted;

  final learnOfflineService = locator<LearnOfflineService>();

  final developerService = locator<DeveloperService>();

  final learnService = locator<LearnService>();

  set setIsOpen(bool widgetIsOpened) {
    _isOpen = widgetIsOpened;
    notifyListeners();
  }

  set setIsDev(bool value) {
    _isDev = value;
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

  void routeToChallengeView(Block block, String challengeId) {
    _navigationService.navigateTo(
      Routes.challengeTemplateView,
      arguments: ChallengeTemplateViewArguments(
        challengeId: challengeId,
        block: block,
        challengesCompleted: _challengesCompleted,
      ),
    );
  }

  Future<void> routeToCertification(Block block) async {
    String challengeId = block.challengeTiles[0].id;

    routeToChallengeView(
      block,
      challengeId,
    );
  }

  void init(List<ChallengeListTile> challengeBatch) async {
    user = await _auth.userModel;
    setNumberOfCompletedChallenges(challengeBatch);
    notifyListeners();
  }

  void setNumberOfCompletedChallenges(List<ChallengeListTile> challengeBatch) {
    int count = 0;
    if (user != null) {
      Iterable<String> completedChallengeIds = user!.completedChallenges.map(
        (e) => e.id,
      );

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

  Widget getLayout(
    BlockLayout layout,
    BlockTemplateViewModel model,
    Block block,
  ) {
    switch (layout) {
      case BlockLayout.challengeGrid:
        return BlockGridView(
          block: block,
          model: model,
        );
      case BlockLayout.challengeDialogue:
        return BlockDialogueView(
          block: block,
          model: model,
        );
      case BlockLayout.challengeList:
        return BlockListView(
          block: block,
          model: model,
        );
      case BlockLayout.challengeLink:
        return BlockLinkView(
          block: block,
          model: model,
        );
      default:
        return BlockGridView(
          block: block,
          model: model,
        );
    }
  }
}
