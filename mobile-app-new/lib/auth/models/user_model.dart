import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile_app_new/learn/models/challenge_file_model.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

DateTime _fromEpochMs(int ms) => DateTime.fromMillisecondsSinceEpoch(ms);
int _toEpochMs(DateTime date) => date.millisecondsSinceEpoch;

// NOTE: The API sends a mix of numbers and strings.
List<String> _yearsToStrings(List<Object?> years) =>
    years.map((year) => year.toString()).toList();

@freezed
abstract class Portfolio with _$Portfolio {
  const factory Portfolio({
    required String id,
    String? title,
    String? url,
    String? image,
    String? description,
  }) = _Portfolio;

  factory Portfolio.fromJson(Map<String, Object?> json) =>
      _$PortfolioFromJson(json);
}

@freezed
abstract class CompletedChallenge with _$CompletedChallenge {
  const factory CompletedChallenge({
    required String id,
    String? solution,
    String? githubLink,
    int? challengeType,
    @JsonKey(fromJson: _fromEpochMs, toJson: _toEpochMs)
    required DateTime completedDate,
    @Default([]) List<ChallengeFile> files,
  }) = _CompletedChallenge;

  factory CompletedChallenge.fromJson(Map<String, Object?> json) =>
      _$CompletedChallengeFromJson(json);
}

@freezed
abstract class CompletedDailyChallenge with _$CompletedDailyChallenge {
  const factory CompletedDailyChallenge({
    required String id,
    @JsonKey(fromJson: _fromEpochMs, toJson: _toEpochMs)
    required DateTime completedDate,
    @Default([]) List<String> languages,
  }) = _CompletedDailyChallenge;

  factory CompletedDailyChallenge.fromJson(Map<String, Object?> json) =>
      _$CompletedDailyChallengeFromJson(json);
}

@freezed
abstract class SavedChallenge with _$SavedChallenge {
  const factory SavedChallenge({
    required String id,
    @Default([]) List<ChallengeFile> files,
  }) = _SavedChallenge;

  factory SavedChallenge.fromJson(Map<String, Object?> json) =>
      _$SavedChallengeFromJson(json);
}

@freezed
abstract class FccUserModel with _$FccUserModel {
  const FccUserModel._();

  const factory FccUserModel({
    required String id,
    required String email,
    required String username,
    @Default('') String name,
    @Default('') String picture,
    String? currentChallengeId,
    String? githubProfile,
    String? linkedin,
    String? twitter,
    String? website,
    String? location,
    String? about,
    @Default(false) bool emailVerified,
    @Default(false) bool isEmailVerified,
    @Default(false) bool isCheater,
    @Default(false) bool isDonating,
    @Default(false) bool isHonest,
    @Default(false) bool isBanned,
    @Default(false) bool isFrontEndCert,
    @Default(false) bool isDataVisCert,
    @Default(false) bool isBackEndCert,
    @Default(false) bool isFullStackCert,
    @Default(false) bool isRespWebDesignCert,
    @Default(false) bool is2018DataVisCert,
    @Default(false) bool isFrontEndLibsCert,
    @Default(false) bool isJsAlgoDataStructCert,
    @Default(false) bool isApisMicroservicesCert,
    @Default(false) bool isInfosecQaCert,
    @Default(false) bool isQaCertV7,
    @Default(false) bool isInfosecCertV7,
    @Default(false) bool is2018FullStackCert,
    @Default(false) bool isSciCompPyCertV7,
    @Default(false) bool isDataAnalysisPyCertV7,
    @Default(false) bool isMachineLearningPyCertV7,
    @Default(false) bool isRelationalDatabaseCertV8,
    @Default(false) bool isCollegeAlgebraPyCertV8,
    @Default(false) bool isFoundationalCSharpCertV8,
    required DateTime joinDate,
    @Default(0) int points,
    // NOTE: Keys are epoch seconds as strings, plus a stray 'NaN' key.
    @Default({}) Map<String, int> calendar,
    @Default([]) List<CompletedChallenge> completedChallenges,
    @Default([]) List<CompletedDailyChallenge> completedDailyCodingChallenges,
    @Default([]) List<SavedChallenge> savedChallenges,
    @Default([]) List<Portfolio> portfolio,
    @JsonKey(fromJson: _yearsToStrings)
    @Default([])
    List<String> yearsTopContributor,
  }) = _FccUserModel;

  factory FccUserModel.fromJson(Map<String, Object?> json) =>
      _$FccUserModelFromJson(json);

  // Points per local calendar day, for the heatmap and streaks.
  Map<DateTime, int> get heatMapCal {
    final days = <DateTime, int>{};

    for (final MapEntry(:key, :value) in calendar.entries) {
      final seconds = int.tryParse(key);
      if (seconds == null) continue;

      final time = _fromEpochMs(seconds * 1000);
      final day = DateTime(time.year, time.month, time.day);
      days[day] = (days[day] ?? 0) + value;
    }

    return days;
  }
}
