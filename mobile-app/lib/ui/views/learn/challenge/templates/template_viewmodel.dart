import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/service/learn/daily_challenge_service.dart';
import 'package:freecodecamp/service/learn/learn_offline_service.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:freecodecamp/ui/views/learn/utils/challenge_utils.dart';
import 'package:stacked/stacked.dart';

class ChallengeTemplateViewModel extends BaseViewModel {
  Future<Challenge>? _challenge;
  Future<Challenge>? get challenge => _challenge;

  final LearnOfflineService _learnOfflineService =
      locator<LearnOfflineService>();
  final DailyChallengeService _dailyChallengeService =
      locator<DailyChallengeService>();
  final LearnService _learnService = locator<LearnService>();

  set setChallenge(Future<Challenge> challenge) {
    _challenge = challenge;
    notifyListeners();
  }

  void initiate(Block block, String challengeId, DateTime? challengeDate) {
    if (challengeDate == null) {
      final String base = LearnService.baseUrlV2;

      String url =
          '$base/challenges/${block.superBlock.dashedName}/${block.dashedName}/$challengeId.json';

      setChallenge = _learnOfflineService.getChallenge(url);

      _learnService.setLastVisitedChallenge(url, block);
    } else {
      final formattedChallengeDate = formatChallengeDate(challengeDate);

      setChallenge = _dailyChallengeService.getDailyChallenge(
          formattedChallengeDate, block);
    }
  }
}
