import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/models/forum_post_model.dart';
import 'package:jiffy/jiffy.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../forum_connect.dart';

class PostViewModel extends BaseViewModel {
  late Future<PostModel> _future;
  Future<PostModel> get future => _future;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  bool _isEditingPost = false;
  bool get isEditingPost => _isEditingPost;

  bool _recentlyDeletedPost = false;
  bool get recentlyDeletedPost => _recentlyDeletedPost;

  String _recentlyDeletedPostId = '';
  String get recentlyDeletedPostId => _recentlyDeletedPostId;

  String _editedPostId = '';
  String get editedPostId => _editedPostId;

  String _requestedRaw = '';
  String get requestedRaw => _requestedRaw;

  Timer? _timer;

  String _baseUrl = '';
  String get baseUrl => _baseUrl;

  final commentText = TextEditingController();

  void initState(slug, id) async {
    _future = fetchPost(id, slug);
    notifyListeners();
    _baseUrl = await ForumConnect.getCurrentUrl();
    _isLoggedIn = await checkLoggedIn();
    enableTimer(id, slug);
  }

  void disposeTimer() {
    _timer!.cancel();
    notifyListeners();
  }

  void enableTimer(id, slug) {
    _timer = Timer.periodic(const Duration(seconds: 30), (Timer timer) {
      _recentlyDeletedPost = false;
      _recentlyDeletedPostId = '';
      _future = fetchPost(id, slug);
      notifyListeners();
    });
  }

  Future<bool> checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('loggedIn') ?? false;
  }

  Future<PostModel> fetchPost(String id, String slug) async {
    final response = await ForumConnect.connectAndGet('/t/$slug/$id');
    if (response.statusCode == 200) {
      return PostModel.fromPostJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Future<Map<String, dynamic>?> getRawText(String postId) async {
    final response = await ForumConnect.connectAndGet('/posts/$postId');

    if (response.statusCode == 200) {
      _requestedRaw = json.decode(response.body)['raw'];
      notifyListeners();
    }

    return null;
  }

  void editPost(String postId, String commentValue) async {
    _isEditingPost = true;
    _editedPostId = postId;

    // to get the raw markdown a seperate request has to be made for some reason

    await getRawText(postId);
    commentText.text = _requestedRaw;
    notifyListeners();
  }

  Future<void> updatePost(postId, postSlug) async {
    Map<String, dynamic> body = {
      "post": {"raw": commentText.text}
    };

    if (commentText.text.isNotEmpty) {
      await ForumConnect.connectAndPut('/posts/$_editedPostId', body);
      _future = fetchPost(postId, postSlug);
      notifyListeners();
    }

    _isEditingPost = false;
    _editedPostId = '';

    notifyListeners();
  }

  Future<void> updateTopic(postId, postSlug) async {
    Map<String, dynamic> body = {
      "post": {"raw": commentText.text}
    };

    if (commentText.text.isNotEmpty) {
      await ForumConnect.connectAndPut('/posts/$_editedPostId', body);
      _future = fetchPost(postId, postSlug);
      notifyListeners();
    }

    _isEditingPost = false;
    _editedPostId = '';

    notifyListeners();
  }

  void cancelUpdatePost() {
    _isEditingPost = false;
    _editedPostId = '';
    notifyListeners();
  }

  Future<void> deletePost(commentId, postId, postSlug) async {
    final response =
        await ForumConnect.connectAnDelete('/posts/$commentId', {});

    if (response.statusCode == 200) {
      _recentlyDeletedPost = true;
      _recentlyDeletedPostId = commentId;

      notifyListeners();
    } else {
      throw Exception(response.body);
    }
  }

  Future<void> deleteTopic(topicId, context) async {
    final response = await ForumConnect.connectAnDelete('/t/$topicId', {});
    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      throw Exception(response.body);
    }
  }

  Future<void> recoverPost(id) async {
    final response = await ForumConnect.connectAndPut('/posts/$id/recover', {});

    if (response.statusCode == 200) {
      _recentlyDeletedPost = false;
      _recentlyDeletedPostId = '';
      notifyListeners();
    } else {
      throw Exception(response.body);
    }
  }

  // This provides a random border color to the profile pictures

  Color randomBorderColor() {
    final random = Random();

    List borderColor = [
      const Color.fromRGBO(0xAC, 0xD1, 0x57, 1),
    ];

    int index = random.nextInt(borderColor.length);

    return borderColor[index];
  }

  // This returns a parsed date from ISO to : 20 minutes ago
  static String parseDate(String date) {
    return Jiffy(date).fromNow();
  }

  static String parseDateShort(String date) {
    String jiffyDate = Jiffy(date).fromNow();

    List parsedDate = jiffyDate.split(" ");

    if (jiffyDate.contains("minutes")) {
      return parsedDate[0] + 'm';
    }

    if (jiffyDate.contains("hour")) return '1h';

    if (jiffyDate.contains("hours")) return parsedDate[0] + 'h';

    if (jiffyDate.contains('days')) return parsedDate[0] + 'd';

    if (jiffyDate.contains('day')) return '1d';

    if (jiffyDate.contains('months')) return parsedDate[0] + 'm';

    if (jiffyDate.contains('month')) return '1m';

    if (jiffyDate.contains('years')) return parsedDate[0] + 'y';

    if (jiffyDate.contains('year')) return '1y';

    return jiffyDate;
  }

  // This returns a parsed url for sharing a post
  void parseShareUrl(BuildContext context, String slug) {
    Share.share('https://forum.freecodecamp.org/t/$slug',
        subject: 'Question from the freecodecamp forum');
  }

  final NavigationService _navigationService = locator<NavigationService>();
  void goToUserProfile(username) {
    _navigationService.navigateTo(Routes.forumUserView,
        arguments: ForumUserViewArguments(username: username));
  }

  Row returnAction(Icon icon, String message, TextStyle style) {
    return Row(
      children: [
        icon,
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(message, style: style),
        )
      ],
    );
  }

  Row postActionParser(String action, String date) {
    Icon? icon;
    String? message;

    TextStyle style = const TextStyle(color: Colors.white, fontSize: 16);

    date = Jiffy(date).fromNow().toUpperCase();

    switch (action) {
      case "visible.disabled":
        message = "UNLISTED " + date;
        icon = const Icon(
          FontAwesomeIcons.eyeSlash,
          color: Colors.white,
        );
        return returnAction(icon, message, style);
      case "split_topic":
        message = "SPLIT THIS TOPIC " + date;
        icon = const Icon(FontAwesomeIcons.signOutAlt, color: Colors.white);
        return returnAction(icon, message, style);
      case "closed.enabled":
        message = "CLOSED " + date;
        icon = const Icon(FontAwesomeIcons.lock, color: Colors.white);
        return returnAction(icon, message, style);
      default:
        message = "UNKNOWN ACTON: " + action;
        return Row(
          children: [Text(message, style: style)],
        );
    }
  }
}
