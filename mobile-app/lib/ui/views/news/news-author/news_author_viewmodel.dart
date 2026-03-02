import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/core/providers/service_providers.dart';
import 'package:freecodecamp/models/news/tutorial_model.dart';
import 'package:freecodecamp/service/news/api_service.dart';

class NewsAuthorViewModel {
  NewsAuthorViewModel(this._newsApiService);

  final NewsApiService _newsApiService;

  Future<Author> fetchAuthor(String authorSlug) async {
    await dotenv.load(fileName: '.env');

    final authorData = await _newsApiService.getAuthor(authorSlug);

    return Author.toAuthorFromJson(authorData);
  }
}

final newsAuthorViewModelProvider = Provider<NewsAuthorViewModel>((ref) {
  final newsApiService = ref.watch(newsApiServiceProvider);
  return NewsAuthorViewModel(newsApiService);
});
