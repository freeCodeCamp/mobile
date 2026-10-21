import 'package:mobile_app_new/news/models/search_post_model.dart';
import 'package:mobile_app_new/news/services/search_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_viewmodel.g.dart';

@riverpod
class NewsSearchNotifier extends _$NewsSearchNotifier {
  // NOTE: Algolia drops a query identical to its last one, so a repeat is answered from here.
  String? _lastTerm;
  List<SearchPost>? _lastResults;

  @override
  AsyncValue<List<SearchPost>> build() {
    final subscription = ref
        .watch(newsSearchServiceProvider)
        .results
        .listen(
          (results) => state = AsyncData(_lastResults = results),
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

    if (term == _lastTerm && _lastResults != null) {
      state = AsyncData(_lastResults!);
      return;
    }

    _lastTerm = term;
    _lastResults = null;
    state = const AsyncLoading();
    ref.read(newsSearchServiceProvider).query(term);
  }
}
