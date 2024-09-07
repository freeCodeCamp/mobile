import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/news/tutorial_model.dart';
import 'package:freecodecamp/service/news/api_service.dart';
import 'package:stacked/stacked.dart';

class NewsAuthorViewModel extends BaseViewModel {
  final _newsApiService = locator<NewsApiServive>();

  Future<Author> fetchAuthor(String authorSlug) async {
    await dotenv.load(fileName: '.env');

    final authorData = await _newsApiService.getAuthor(authorSlug);

    return Author.toAuthorFromJson(authorData);
  }
}
