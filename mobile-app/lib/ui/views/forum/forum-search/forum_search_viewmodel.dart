import 'dart:developer' as dev;
import 'dart:convert';

import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/models/forum/forum_search_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../forum_connect.dart';

class ForumSearchModel extends BaseViewModel {
  bool _queryToShort = false;
  bool get queryToShort => _queryToShort;

  bool _hasSearched = false;
  bool get hasSearched => _hasSearched;

  String _searchTerm = '';
  String get searchTerm => _searchTerm;

  void checkQuery(value) {
    if (value.length <= 2) {
      _queryToShort = true;
      _hasSearched = true;
      notifyListeners();
    } else {
      _queryToShort = false;
      _hasSearched = true;
      _searchTerm = value;
      notifyListeners();
    }
  }

  final NavigationService _navigationService = locator<NavigationService>();
  void goToPost(slug, id) {
    id = id.toString();
    _navigationService.navigateTo(Routes.forumPostView,
        arguments: ForumPostViewArguments(id: id, slug: slug));
  }

  Future<List<SearchModel>> search(String query) async {
    final response = await ForumConnect.connectAndGet(
        '/search/query?term=$query&in=title&status=public&order=latest');
    List<SearchModel> searchedPosts = [];

    List posts = json.decode(response.body)['topics'];
    dev.log(posts.toString());

    if (query.length <= 2 || posts.isEmpty) {
      return searchedPosts;
    }

    if (response.statusCode == 200) {
      for (int i = 0; i < posts.length; i++) {
        searchedPosts.add(SearchModel(
            title: posts[i]['title'],
            postLikeCount: posts[i]['like_count'],
            postUsername: posts[i]['username'],
            topicId: posts[i]["id"],
            slug: posts[i]["slug"]));
      }
      dev.log(searchedPosts.toString());
      return searchedPosts;
    }

    throw Exception(response.body);
  }
}
