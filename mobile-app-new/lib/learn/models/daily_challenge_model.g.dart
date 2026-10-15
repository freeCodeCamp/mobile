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
