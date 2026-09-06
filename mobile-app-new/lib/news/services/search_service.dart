import 'dart:io';

import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:mobile_app_new/news/constants/radio_articles.dart';
import 'package:mobile_app_new/news/models/search_post_model.dart';
import 'package:mobile_app_new/news/repositories/search_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_service.g.dart';

@riverpod
NewsSearchService newsSearchService(Ref ref) {
  final repo = ref.watch(newsSearchRepositoryProvider);
  return NewsSearchService(repo);
}

class NewsSearchService {
  final NewsSearchRepository _repository;

  NewsSearchService(this._repository);

  Stream<List<SearchPost>> get results => _repository.responses.map(_toPosts);

  void query(String term) => _repository.query(term);

  List<SearchPost> _toPosts(SearchResponse response) {
    final hits = Platform.isIOS
        ? response.hits.where((hit) => !radioArticles.contains(hit['objectID']))
        : response.hits;

    return hits.map((hit) => SearchPost.fromJson(hit)).toList();
  }
}
