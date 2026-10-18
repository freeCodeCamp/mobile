import 'package:collection/collection.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/models/daily_challenge_model.dart';
import 'package:mobile_app_new/learn/repositories/daily_challenge_repository.dart';
import 'package:mobile_app_new/learn/repositories/prefs_repository.dart';
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
      ref.watch(learnPrefsRepositoryProvider),
    );

const _languageKey = 'selectedDailyChallengeLanguage';

class LearnDailyChallengeService {
  LearnDailyChallengeService(this._repo, this._prefs);

  final LearnDailyChallengeRepository _repo;
  final LearnPrefsRepository _prefs;

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

  Future<DailyChallenge> getChallenge(String monthDay) async {
    final raw = await _repo.getDay(monthDay);

    for (final (language, name, ext) in [
      ('javascript', 'script', 'js'),
      ('python', 'main', 'py'),
    ]) {
      for (final file
          in raw[language]?['challengeFiles'] as List? ?? const []) {
        (file as Map)
          ..['name'] = name
          ..['ext'] = ext;
      }
    }

    return DailyChallenge.fromJson(raw);
  }

  Challenge toChallenge(DailyChallenge daily, DailyChallengeLanguage language) {
    final (data, type) = switch (language) {
      DailyChallengeLanguage.javascript => (daily.javascript, 28),
      DailyChallengeLanguage.python => (daily.python, 29),
    };

    return Challenge(
      id: daily.id,
      block: 'daily-coding-challenge',
      superBlock: 'daily-coding-challenge',
      title: daily.title,
      dashedName: '',
      challengeType: type,
      helpCategory: language.label,
      description: daily.description,
      tests: data.tests,
      challengeFiles: data.challengeFiles,
    );
  }

  Future<DailyChallengeLanguage> getLanguage() async {
    final saved = await _prefs.read(_languageKey);
    return DailyChallengeLanguage.values.asNameMap()[saved] ??
        DailyChallengeLanguage.javascript;
  }

  Future<void> setLanguage(DailyChallengeLanguage language) =>
      _prefs.write(_languageKey, language.name);

  Future<void> complete(Challenge challenge) => _repo.postCompleted({
    'id': challenge.id,
    'language': challenge.challengeType == 29 ? 'python' : 'javascript',
  });
}
