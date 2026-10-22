import 'package:freecodecamp/learn/models/challenge_file_model.dart';
import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_challenge_model.freezed.dart';
part 'daily_challenge_model.g.dart';

enum DailyChallengeLanguage {
  javascript('JavaScript'),
  python('Python');

  const DailyChallengeLanguage(this.label);

  final String label;
}

@freezed
abstract class DailyChallengeOverview with _$DailyChallengeOverview {
  const factory DailyChallengeOverview({
    required String id,
    required int challengeNumber,
    required DateTime date,
    required String title,
  }) = _DailyChallengeOverview;

  const DailyChallengeOverview._();

  // NOTE: MM-DD. The 365 challenges repeat every year, so the year in `date` means nothing.
  String get monthDay => date.toIso8601String().substring(5, 10);

  factory DailyChallengeOverview.fromJson(Map<String, dynamic> json) =>
      _$DailyChallengeOverviewFromJson(json);
}

@freezed
abstract class DailyChallenge with _$DailyChallenge {
  const factory DailyChallenge({
    required String id,
    required int challengeNumber,
    required DateTime date,
    required String title,
    required String description,
    required DailyChallengeLanguageData javascript,
    required DailyChallengeLanguageData python,
  }) = _DailyChallenge;

  factory DailyChallenge.fromJson(Map<String, dynamic> json) =>
      _$DailyChallengeFromJson(json);
}

@freezed
abstract class DailyChallengeLanguageData with _$DailyChallengeLanguageData {
  const factory DailyChallengeLanguageData({
    @Default([]) List<ChallengeTest> tests,
    @Default([]) List<ChallengeFile> challengeFiles,
  }) = _DailyChallengeLanguageData;

  factory DailyChallengeLanguageData.fromJson(Map<String, dynamic> json) =>
      _$DailyChallengeLanguageDataFromJson(json);
}
