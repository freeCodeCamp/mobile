import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_challenge_model.freezed.dart';
part 'daily_challenge_model.g.dart';

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
