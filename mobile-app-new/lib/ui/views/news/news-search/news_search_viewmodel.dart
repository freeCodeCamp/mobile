import 'package:mobile_app_new/models/news/search_post_model.dart';
import 'package:mobile_app_new/services/news/search_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'news_search_viewmodel.g.dart';

@riverpod
class NewsSearchNotifier extends _$NewsSearchNotifier {
  @override
  AsyncValue<List<SearchPost>> build() {
    final subscription = ref
        .watch(newsSearchServiceProvider)
        .results
        .listen(
          (results) => state = AsyncData(results),
          onError: (Object error, StackTrace stackTrace) =>
              state = AsyncError(error, stackTrace),
        );

    ref.onDispose(subscription.cancel);

    return const AsyncData([]);
  }

  void search(String term) {
    if (term.isEmpty) {
      state = const AsyncData([]);
      return;
    }

    state = const AsyncLoading();
    ref.read(newsSearchServiceProvider).query(term);
  }
}
