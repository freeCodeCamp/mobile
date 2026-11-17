import 'dart:developer';

import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freecodecamp/utils/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_repository.g.dart';

const _indexName = 'news';

@Riverpod(retry: noRetry)
NewsSearchRepository newsSearchRepository(Ref ref) {
  final repository = NewsSearchRepository();
  ref.onDispose(repository.dispose);
  return repository;
}

class NewsSearchRepository {
  HitsSearcher? _client;

  HitsSearcher get _searcher => _client ??= HitsSearcher(
    applicationID: dotenv.get('ALGOLIAAPPID'),
    apiKey: dotenv.get('ALGOLIAKEY'),
    indexName: _indexName,
  );

  Stream<SearchResponse> get responses => _searcher.responses;

  void query(String term) {
    if (_searcher.snapshot().query == term) {
      _searcher.rerun();
    } else {
      _searcher.query(term);
    }
  }

  void dispose() {
    log('Disposing NewsSearchRepository');
    _client?.dispose();
  }
}
