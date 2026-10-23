// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_challenge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DailyChallengeOverview _$DailyChallengeOverviewFromJson(
  Map<String, dynamic> json,
) => _DailyChallengeOverview(
  id: json['id'] as String,
  challengeNumber: (json['challengeNumber'] as num).toInt(),
  date: DateTime.parse(json['date'] as String),
  title: json['title'] as String,
);

Map<String, dynamic> _$DailyChallengeOverviewToJson(
  _DailyChallengeOverview instance,
) => <String, dynamic>{
  'id': instance.id,
  'challengeNumber': instance.challengeNumber,
  'date': instance.date.toIso8601String(),
  'title': instance.title,
};

_DailyChallenge _$DailyChallengeFromJson(Map<String, dynamic> json) =>
    _DailyChallenge(
      id: json['id'] as String,
      challengeNumber: (json['challengeNumber'] as num).toInt(),
      date: DateTime.parse(json['date'] as String),
      title: json['title'] as String,
      description: json['description'] as String,
      javascript: DailyChallengeLanguageData.fromJson(
        json['javascript'] as Map<String, dynamic>,
      ),
      python: DailyChallengeLanguageData.fromJson(
        json['python'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$DailyChallengeToJson(_DailyChallenge instance) =>
    <String, dynamic>{
      'id': instance.id,
      'challengeNumber': instance.challengeNumber,
      'date': instance.date.toIso8601String(),
      'title': instance.title,
      'description': instance.description,
      'javascript': instance.javascript,
      'python': instance.python,
    };

_DailyChallengeLanguageData _$DailyChallengeLanguageDataFromJson(
  Map<String, dynamic> json,
) => _DailyChallengeLanguageData(
  tests:
      (json['tests'] as List<dynamic>?)
          ?.map((e) => ChallengeTest.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  challengeFiles:
      (json['challengeFiles'] as List<dynamic>?)
          ?.map((e) => ChallengeFile.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$DailyChallengeLanguageDataToJson(
  _DailyChallengeLanguageData instance,
) => <String, dynamic>{
  'tests': instance.tests,
  'challengeFiles': instance.challengeFiles,
};
