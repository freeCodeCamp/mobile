import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freecodecamp/models/news/tutorial_model.dart';
import 'package:http/http.dart' as http;
import 'package:stacked/stacked.dart';

class NewsAuthorViewModel extends BaseViewModel {
  late Future<Author> _author;
  Future<Author> get author => _author;

  Future<Author> fetchAuthor(String authorSlug) async {
    // Load the news url and key

    await dotenv.load(fileName: '.env');

    String url = dotenv.get('NEWSURL', fallback: 'failed');
    String key = dotenv.get('NEWSKEY', fallback: 'failed');

    if (url == 'failed' || key == 'failed') {
      throw Exception('could not find news url or key');
    }

    // Request current author

    String queryUrl = '${url}authors/slug/$authorSlug/?key=$key';

    http.Response response = await http.get(Uri.parse(queryUrl));

    if (response.statusCode == 200) {
      return Author.toAuthorFromJson(jsonDecode(response.body)['authors'][0]);
    } else {
      throw Exception('${response.body}\n Author: $authorSlug');
    }
  }
}
