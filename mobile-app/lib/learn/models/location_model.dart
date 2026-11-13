import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_model.freezed.dart';
part 'location_model.g.dart';

@freezed
abstract class LearnLocation with _$LearnLocation {
  const factory LearnLocation({
    required String superBlock,
    required String block,
    required String challengeId,
  }) = _LearnLocation;

  factory LearnLocation.fromJson(Map<String, dynamic> json) =>
      _$LearnLocationFromJson(json);
}
