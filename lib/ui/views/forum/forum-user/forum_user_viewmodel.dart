import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/models/forum_user_model.dart';
import 'package:freecodecamp/ui/views/forum/forum_connect.dart';
import 'package:html/parser.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter_font_awesome_web_names/flutter_font_awesome.dart';

class ForumUserModel extends BaseViewModel {
  late Future<User> _future;
  Future<User> get future => _future;

  late String _baseUrl;
  String get baseUrl => _baseUrl;

  void initState(username) async {
    _future = fetchUser(username);
    _baseUrl = await ForumConnect.getCurrentUrl();
    notifyListeners();
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

  FaIcon parseBages(String iconName, double size, int badgeType) {
    Color? color;

    List<String> icons = searchFontAwesomeIcons(
        text: iconName, searchFilter: FaSearchFilter.contains, maxResults: 20);

    if (icons.isNotEmpty) {
      for (int i = 0; i < icons.length; i++) {
        if (icons[i].contains(iconName)) {
          iconName = icons[i];
          break;
        }
      }
    } else {
      iconName = 'fas fa-certificate';
    }

    switch (badgeType) {
      case 1:
        color = Colors.amber.shade400;
        break;
      case 2:
        color = Colors.grey.shade400;
        break;
      case 3:
        color = Colors.amber.shade800;

        break;
      default:
        color = Colors.grey.shade400;
    }

    return FaIcon(iconName, size: size, color: color);
  }

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
