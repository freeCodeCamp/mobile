import 'dart:convert';

import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/models/forum_user_model.dart';
import 'package:freecodecamp/ui/views/forum/forum_connect.dart';
import 'package:html/parser.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ForumUserModel extends BaseViewModel {
  late Future<User> _future;
  Future<User> get future => _future;

  void initState(username) {
    _future = fetchUser(username);
  }

  Future<User> fetchUser(String username) async {
    final response = await ForumConnect.connectAndGet('/u/$username');

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }
    throw Exception('could not load user data: ' + response.body.toString());
  }

  Future<List<UserTopic>?> getUserTopics(username, amount) async {
    UserSummary userSummary = await fetchUserSummary(username);

    List<dynamic>? userTopics = userSummary.topics;
    List<UserTopic>? topics = [];

    for (int i = 0; i < userTopics!.length; i++) {
      if (i == amount) break;
      topics.add(UserTopic.fromJson(userTopics[i]));
    }
    return topics;
  }

  // A summary fetched from the Discourse API used by the user profile file.

  Future<UserSummary> fetchUserSummary(String username) async {
    final response = await ForumConnect.connectAndGet('/u/$username/summary');
    if (response.statusCode == 200) {
      return UserSummary.fromJson(jsonDecode(response.body));
    }
    throw Exception('could not load user summary: ' + response.body.toString());
  }

  // A badge of badges fetched from the Discourse api

  Future<List<UserBadge>> fetchUserBadges(String username, int max) async {
    final response = await ForumConnect.connectAndGet('/user-badges/$username');
    List<dynamic> badgesJson = jsonDecode(response.body)['badges'];
    List<UserBadge> badges = [];
    if (response.statusCode == 200) {
      for (int i = 0; i < badgesJson.length; i++) {
        if (i == max) break;
        badges.add(UserBadge.fromJson(badgesJson[i]));
      }
    } else {
      throw Exception('failed loading badges: ' + response.body.toString());
    }

    return badges;
  }

  // static FaIcon discourseIconParser(String icon) {
  //   List iconParts = icon.split('-');
  //   dev.log(iconParts[1]);
  //   return FaIcon(iconParts[1]);
  // }

  // This parses the badge description so it has no anchor tags.

  static String parseBadgeDescription(String desc) {
    final document = parse(desc);
    final String parsedDesc = parse(document.body!.text).documentElement!.text;
    return parsedDesc;
  }

  final NavigationService _navigationService = locator<NavigationService>();
  void navigateToPost(slug, id) {
    id = id.toString();
    _navigationService.navigateTo(Routes.forumPostView,
        arguments: ForumPostViewArguments(id: id, slug: slug));
  }
}
