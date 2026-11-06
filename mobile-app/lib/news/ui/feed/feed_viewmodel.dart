import 'package:freecodecamp/news/controllers/feed_controller.dart';
import 'package:freecodecamp/news/models/post_model.dart';
import 'package:freecodecamp/news/models/post_summary_model.dart';
import 'package:freecodecamp/news/models/search_post_model.dart';
import 'package:freecodecamp/news/services/search_service.dart';
import 'package:freecodecamp/utils/riverpod.dart';
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

@Riverpod(retry: noRetry)
class NewsSearchNotifier extends _$NewsSearchNotifier {
  String? _lastTerm;
  List<SearchPost>? _lastResults;
  String _activeTerm = '';
  int _generation = 0;

  @override
  AsyncValue<List<SearchPost>> build() {
    final generation = ++_generation;
    _lastTerm = null;
    _lastResults = null;
    try {
      final service = ref.watch(newsSearchServiceProvider);
      final subscription = service.results.listen(
        (result) {
          if (!ref.mounted ||
              generation != _generation ||
              _activeTerm.isEmpty ||
              result.term != _activeTerm) {
            return;
          }
          _lastTerm = result.term;
          state = AsyncData(_lastResults = result.posts);
        },
        onError: (Object error, StackTrace stackTrace) {
          if (ref.mounted &&
              generation == _generation &&
              _activeTerm.isNotEmpty) {
            state = AsyncError(error, stackTrace);
          }
        },
      );

      ref.onDispose(() {
        _generation++;
        subscription.cancel();
      });

      if (_activeTerm.isEmpty) return const AsyncData([]);
      service.query(_activeTerm);
      return const AsyncLoading();
    } catch (error, stackTrace) {
      return AsyncError(error, stackTrace);
    }
  }

  void retry() {
    ref.invalidate(newsSearchServiceProvider);
    ref.invalidateSelf();
  }

  void search(String term) {
    _activeTerm = term;
    if (term.isEmpty) {
      state = const AsyncData([]);
      return;
    }

    if (term == _lastTerm && _lastResults != null) {
      state = AsyncData(_lastResults!);
      return;
    }

    _lastTerm = term;
    _lastResults = null;
    state = const AsyncLoading();
    try {
      ref.read(newsSearchServiceProvider).query(term);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}
