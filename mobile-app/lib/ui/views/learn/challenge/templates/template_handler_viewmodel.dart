import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/service/learn/learn_offline_service.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:stacked/stacked.dart';

class HandleTemplateModel extends BaseViewModel {
  Future<Challenge>? _challenge;
  Future<Challenge>? get challenge => _challenge;

  final LearnOfflineService offlineService = locator<LearnOfflineService>();

  set setChallenge(Future<Challenge> challenge) {
    _challenge = challenge;
    notifyListeners();
  }

  void initiate(Block block, String challengeId) {
    final String base = LearnService.baseUrl;

    setChallenge = offlineService.getChallenge(
      '$base/challenges/${block.superBlock.dashedName}/${block.dashedName}/$challengeId.json',
    );
  }
}
