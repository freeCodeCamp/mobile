import 'dart:convert';
import 'dart:developer' as dev;
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/models/forum_post_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../forum_connect.dart';

class ForumPostFeedModel extends BaseViewModel {
  late Future<PostModel> _future;
  Future<PostModel> get future => _future;

  int itemRequestThreshold = 28;

  int _pageNumber = 0;

  List<PostModel> posts = [];

  Future<List<PostModel>> fetchPosts(slug, id) async {
    final response = await ForumConnect.connectAndGet(
        '/c/$slug/$id?page=${_pageNumber.toString()}');

    if (response.statusCode == 200) {
      var topics = json.decode(response.body)["topic_list"]["topics"];
      for (int i = 0; i < topics.length; i++) {
        posts.add(PostModel.fromTopicFeedJson(topics[i]));
      }
      return posts;
    } else {
      throw Exception(response.body);
    }
  }

  final NavigationService _navigationService = locator<NavigationService>();
  void navigateToPost(slug, id) {
    id = id.toString();
    _navigationService.navigateTo(Routes.forumPostView,
        arguments: ForumPostViewArguments(id: id, slug: slug));
  }

  Future handlePostLazyLoading(int index) async {
    var itemPosition = index + 1;
    var request = itemPosition % itemRequestThreshold == 0;
    var pageToRequest = itemPosition ~/ itemRequestThreshold + 1;
    if (request && pageToRequest > _pageNumber) {
      _pageNumber = pageToRequest;
      notifyListeners();
    }
  }
}
