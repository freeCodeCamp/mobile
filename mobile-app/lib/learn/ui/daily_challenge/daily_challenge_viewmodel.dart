import 'package:freecodecamp/learn/models/daily_challenge_model.dart';
import 'package:freecodecamp/learn/services/daily_challenge_service.dart';
import 'package:freecodecamp/utils/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'daily_challenge_viewmodel.g.dart';

@Riverpod(retry: noRetry)
Future<DailyChallenge> dailyChallenge(Ref ref, String day) =>
    ref.watch(learnDailyChallengeServiceProvider).getChallenge(day);

@Riverpod(retry: noRetry)
class DailyChallengeLanguageNotifier extends _$DailyChallengeLanguageNotifier {
  @override
  Future<DailyChallengeLanguage> build() =>
      ref.watch(learnDailyChallengeServiceProvider).getLanguage();

  Future<void> select(DailyChallengeLanguage language) async {
    state = AsyncData(language);
    await ref.read(learnDailyChallengeServiceProvider).setLanguage(language);
  }
}
