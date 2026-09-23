import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile_app_new/news/models/author_model.dart';
import 'package:mobile_app_new/news/models/post_model.dart';

part 'post_summary_model.freezed.dart';
part 'post_summary_model.g.dart';

@freezed
abstract class PostSummary with _$PostSummary {
  const factory PostSummary({
    required String id,
    required String slug,
    required String title,
    required Author author,
    @Default([]) List<Tag> tags,
    CoverImage? coverImage,
    required int readTimeInMinutes,
    required String publishedAt,
  }) = _PostSummary;

  factory PostSummary.fromJson(Map<String, Object?> json) =>
      _$PostSummaryFromJson(json);
}
