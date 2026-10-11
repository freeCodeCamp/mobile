import 'package:collection/collection.dart';
import 'package:mobile_app_new/learn/models/daily_challenge_model.dart';
import 'package:mobile_app_new/learn/repositories/daily_challenge_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'daily_challenge_service.g.dart';

typedef DailyChallengeMonth = ({
  DateTime month,
  List<DailyChallengeOverview> challenges,
});

@riverpod
LearnDailyChallengeService learnDailyChallengeService(Ref ref) =>
    LearnDailyChallengeService(
      ref.watch(learnDailyChallengeRepositoryProvider),
    );

class LearnDailyChallengeService {
  LearnDailyChallengeService(this._repo);

  final LearnDailyChallengeRepository _repo;

  Future<DailyChallengeOverview> getToday() async =>
      DailyChallengeOverview.fromJson(await _repo.getToday());

  Future<List<DailyChallengeMonth>> getArchive() async {
    final challenges = [
      for (final raw in await _repo.getAll())
        DailyChallengeOverview.fromJson(raw),
    ];
    final byMonth = groupBy(
      challenges,
      (challenge) => DateTime.utc(challenge.date.year, challenge.date.month),
    );

    return [
      for (final month in byMonth.keys.sorted((a, b) => b.compareTo(a)))
        (
          month: month,
          challenges: byMonth[month]!.sorted(
            (a, b) => b.challengeNumber.compareTo(a.challengeNumber),
          ),
        ),
    ];
  }
}
