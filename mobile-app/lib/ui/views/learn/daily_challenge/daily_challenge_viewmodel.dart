import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/models/learn/completed_challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/models/learn/daily_challenge_model.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/learn/daily_challenge_service.dart';
import 'package:freecodecamp/ui/views/learn/utils/challenge_utils.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DailyChallengeViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthenticationService _auth = locator<AuthenticationService>();
  final DailyChallengeService _dailyChallengeService =
      locator<DailyChallengeService>();

  List<DailyChallengeBlock> _blocks = [];
  List<DailyChallengeBlock> get blocks => _blocks;

  Map<String, bool> _blockOpenStates = {};
  Map<String, bool> get blockOpenStates => _blockOpenStates;

  Future<void> init() async {
    await _fetchAndGroupChallenges();
    _initAuthenticationListener();
  }

  void _initAuthenticationListener() {
    // Listen to authentication state changes to refresh completion status
    _auth.isLoggedIn.listen((isLoggedIn) async {
      notifyListeners();
    });

    // Also listen to progress stream for user data updates
    _auth.progress.stream.listen((_) {
      notifyListeners();
    });
  }

  void toggleBlock(String monthYear) {
    _blockOpenStates[monthYear] = !(_blockOpenStates[monthYear] ?? false);
    notifyListeners();
  }

  Future<void> _fetchAndGroupChallenges() async {
    setBusy(true);

    try {
      final List<DailyChallengeOverview> challenges =
          await _dailyChallengeService.fetchAllDailyChallenges();

      if (challenges.isNotEmpty) {
        Map<String, List<DailyChallengeOverview>> challengesByMonth = {};

        // Group challenges by month
        for (var challenge in challenges) {
          String monthYear = formatMonthFromDate(challenge.date);
          if (!challengesByMonth.containsKey(monthYear)) {
            challengesByMonth[monthYear] = [];
          }
          challengesByMonth[monthYear]!.add(challenge);
        }

        // Sort months in descending order (newest first)
        List<String> sortedMonths = challengesByMonth.keys.toList()
          ..sort((a, b) {
            DateTime dateA = parseMonthYear(a);
            DateTime dateB = parseMonthYear(b);
            return dateB.compareTo(dateA);
          });

        _blocks = [];
        _blockOpenStates = {};

        // Create challenge groups for each month
        for (String monthYear in sortedMonths) {
          List<DailyChallengeOverview> monthChallenges =
              challengesByMonth[monthYear]!;

          // Sort challenges within the month by challengeNumber in descending order (greater first)
          monthChallenges.sort((a, b) {
            return b.challengeNumber.compareTo(a.challengeNumber);
          });

          final block = DailyChallengeBlock(
            monthYear: monthYear,
            challenges: monthChallenges,
            description:
                'Explore the daily coding challenges for $monthYear. Stay motivated and keep your learning streak alive!',
          );

          _blocks.add(block);
          _blockOpenStates[monthYear] = false;
        }

        // Open the first (most recent) group by default
        if (_blocks.isNotEmpty) {
          _blockOpenStates[_blocks.first.monthYear] = true;
        }
      }
    } catch (e) {
      print('Exception occurred: $e');
    } finally {
      setBusy(false);
    }
  }

  Future<bool> checkIfChallengeCompleted(String challengeId) async {
    FccUserModel? user = await _auth.userModel;
    if (user != null) {
      for (CompletedDailyChallenge challenge
          in user.completedDailyCodingChallenges) {
        if (challenge.id == challengeId) {
          return true;
        }
      }
    }
    return false;
  }

  Future<void> navigateToDailyChallenge(
      DailyChallengeOverview challenge) async {
    String monthYear = formatMonthFromDate(challenge.date);

    // Map to curriculum block so ChallengeTemplateView can use it
    Block block = DailyChallengeBlock(
      monthYear: monthYear,
      challenges: [challenge],
      description:
          'Explore the daily coding challenges for $monthYear. Stay motivated and keep your learning streak alive!',
    ).toCurriculumBlock();

    _navigationService.navigateTo(
      Routes.challengeTemplateView,
      arguments: ChallengeTemplateViewArguments(
        challengeId: challenge.id,
        block: block,
        challengeDate: challenge.date,
      ),
    );
  }

  Future<int> getCompletedChallengesForBlock(DailyChallengeBlock block) async {
    int count = 0;

    for (var challenge in block.challenges) {
      if (await checkIfChallengeCompleted(challenge.id)) {
        count++;
      }
    }

    return count;
  }
}
