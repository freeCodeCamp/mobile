import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/service/learn/learn_offline_service.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:stacked/stacked.dart';
import 'package:freecodecamp/service/learn/daily_challenges_service.dart';
import 'package:freecodecamp/models/learn/daily_challenge_model.dart';

class ChallengeTemplateViewModel extends BaseViewModel {
  Future<Challenge>? _challenge;
  Future<Challenge>? get challenge => _challenge;

  final LearnOfflineService _learnOfflineService =
      locator<LearnOfflineService>();
  final LearnService _learnService = locator<LearnService>();
  final DailyChallengesService _dailyChallengesService =
      locator<DailyChallengesService>();
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
      // Format date to YYYY-MM-DD
      final formattedDate =
          '${challengeDate.year.toString().padLeft(4, '0')}-${challengeDate.month.toString().padLeft(2, '0')}-${challengeDate.day.toString().padLeft(2, '0')}';
      setChallenge = _fetchAndMapDailyChallenge(formattedDate, block);
    }
  }

  Future<Challenge> _fetchAndMapDailyChallenge(String date, Block block) async {
    try {
      DailyChallenge dailyChallenge =
          await _dailyChallengesService.fetchChallengeByDate(date);

      // TODO: Support Python and allow the users to select/toggle between Python and JS.
      return Challenge(
        id: dailyChallenge.id,
        block: block.dashedName,
        title: dailyChallenge.title,
        description: dailyChallenge.description,
        instructions: '',
        dashedName: '',
        superBlock: block.superBlock.dashedName,
        videoId: null,
        challengeType: 28,
        tests: dailyChallenge.javascript.tests,
        files: dailyChallenge.javascript.challengeFiles,
        helpCategory: HelpCategory.javascript,
        explanation: '',
        transcript: '',
        hooks: Hooks.fromJson({'beforeAll': ''}),
        fillInTheBlank: null,
        audio: null,
        scene: null,
        questions: null,
        assignments: null,
        quizzes: null,
      );
    } catch (e) {
      notifyListeners();
      rethrow;
    }
  }
}
