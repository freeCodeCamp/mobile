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
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:freecodecamp/ui/views/learn/block/templates/dialogue/dialogue_view.dart';
import 'package:freecodecamp/ui/views/learn/block/templates/grid/grid_view.dart';
import 'package:freecodecamp/ui/views/learn/block/templates/link/link_view.dart';
import 'package:freecodecamp/ui/views/learn/block/templates/list/list_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class BlockTemplateViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthenticationService auth = locator<AuthenticationService>();

  bool _isDev = false;
  bool get isDev => _isDev;

  int _challengesCompleted = 0;
  int get challengesCompleted => _challengesCompleted;

  final learnOfflineService = locator<LearnOfflineService>();

  final developerService = locator<DeveloperService>();

  final learnService = locator<LearnService>();

  set setIsDev(bool value) {
    _isDev = value;
    notifyListeners();
  }

  void routeToChallengeView(Block block, String challengeId) {
    _navigationService.navigateTo(
      Routes.challengeTemplateView,
      arguments: ChallengeTemplateViewArguments(
        challengeId: challengeId,
        block: block,
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
    setNumberOfCompletedChallenges(challengeBatch);
    auth.progress.stream.listen(
      (val) => setNumberOfCompletedChallenges(challengeBatch),
    );
    notifyListeners();
  }

  void setNumberOfCompletedChallenges(
    List<ChallengeListTile> challengeBatch,
  ) async {
    int count = 0;

    FccUserModel? user = await auth.userModel;
    if (user != null) {
      Iterable<String> completedChallengeIds = user.completedChallenges.map(
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

  Future<bool> completedChallenge(String incomingId) async {
    FccUserModel? user = await auth.userModel;
    if (user != null) {
      for (CompletedChallenge challenge in user.completedChallenges) {
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
    bool isOpen,
    Function isOpenFunction,
    Color color,
  ) {
    switch (layout) {
      case BlockLayout.challengeGrid:
        return BlockGridView(
          block: block,
          model: model,
          isOpen: isOpen,
          isOpenFunction: isOpenFunction,
          color: color,
        );
      case BlockLayout.challengeDialogue:
        return BlockDialogueView(
          block: block,
          model: model,
          isOpen: isOpen,
          isOpenFunction: isOpenFunction,
        );
      case BlockLayout.challengeList:
        return BlockListView(
          block: block,
          model: model,
          isOpen: isOpen,
          isOpenFunction: isOpenFunction,
        );
      case BlockLayout.challengeLink:
        return BlockLinkView(
          block: block,
          model: model,
          color: color,
        );
      default:
        return BlockGridView(
          block: block,
          model: model,
          isOpen: isOpen,
          isOpenFunction: isOpenFunction,
          color: color,
        );
    }
  }

  (IconData?, Color) getIconData(BlockLabel type) {
    switch (type) {
      case BlockLabel.lecture:
        return (Icons.menu_book_outlined, FccColors.blue30);
      case BlockLabel.quiz:
        return (Icons.help_outline, FccColors.orange30);
      case BlockLabel.lab:
        return (Icons.science_outlined, FccColors.green40);
      case BlockLabel.workshop:
        return (Icons.build_outlined, FccColors.purple10);
      case BlockLabel.exam:
        return (Icons.school, FccColors.red15);
      case BlockLabel.review:
        return (Icons.edit_document, FccColors.yellow10);
      case BlockLabel.warmup:
        return (Icons.fitbit_outlined, FccColors.blue30);
      case BlockLabel.learn:
        return (Icons.school_outlined, FccColors.green40);
      case BlockLabel.practice:
        return (Icons.edit_outlined, FccColors.purple10);
      default: // BlockLabel.legacy or unknown
        return (null, FccColors.blue05);
    }
  }
}
