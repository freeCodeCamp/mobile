import 'dart:async';

import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/service/learn/curriculum_language_service.dart';
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
  final CurriculumLanguageService _curriculumLanguageService =
      locator<CurriculumLanguageService>();

  StreamSubscription<CurriculumLanguage>? _languageSubscription;
  Block? _block;
  String? _challengeId;

  set setChallenge(Future<Challenge> challenge) {
    _challenge = challenge;
    notifyListeners();
  }

  void initiate(Block block, String challengeId, DateTime? challengeDate) {
    if (challengeDate != null) {
      final formattedChallengeDate = formatChallengeDate(challengeDate);
      setChallenge = _dailyChallengeService.getDailyChallenge(
          formattedChallengeDate, block);
      return;
    }

    _block = block;
    _challengeId = challengeId;

    _languageSubscription ??=
        _curriculumLanguageService.stream.listen((_) => _reload());

    _reload();
  }

  void _reload() {
    final String url =
        '${_curriculumLanguageService.baseUrl}/challenges/${_block!.superBlock.dashedName}/${_block!.dashedName}/$_challengeId.json';

    setChallenge = _learnOfflineService.getChallenge(url);
    _learnService.setLastVisitedChallenge(url, _block!);
  }

  @override
  void dispose() {
    _languageSubscription?.cancel();
    super.dispose();
  }
}
