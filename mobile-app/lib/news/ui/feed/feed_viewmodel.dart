import 'package:freecodecamp/news/controllers/feed_controller.dart';
import 'package:freecodecamp/news/models/post_model.dart';
import 'package:freecodecamp/news/models/post_summary_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_viewmodel.g.dart';

@riverpod
List<Tag> newsFeedTags(Ref ref) {
  final feed = ref.watch(newsFeedProvider(const NewsFeedSource.all()));
  final tags = <String, Tag>{};
  for (final post in feed.value?.posts ?? const <PostSummary>[]) {
    for (final tag in post.tags) {
      tags.putIfAbsent(tag.slug, () => tag);
    }
  }
  return tags.values.take(12).toList();
}
