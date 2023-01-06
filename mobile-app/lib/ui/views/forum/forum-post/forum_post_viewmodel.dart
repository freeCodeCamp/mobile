import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/models/forum/forum_post_model.dart';
import 'package:freecodecamp/ui/views/forum/forum-comment/forum_comment_view.dart';
import 'package:jiffy/jiffy.dart';
import 'package:share_plus/share_plus.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../forum_connect.dart';

class PostViewModel extends BaseViewModel {
  late Future<PostModel> _future;
  Future<PostModel> get future => _future;

  List<PostModel> _posts = [];
  List<PostModel> get posts => _posts;

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

  String _baseUrl = '';
  String get baseUrl => _baseUrl;

  final _commentText = TextEditingController();
  TextEditingController get commentText => _commentText;

  final _createPostText = TextEditingController();
  TextEditingController get createPostText => _createPostText;

  bool _hasError = false;
  bool get commentHasError => _hasError;

  String _errorMessage = '';
  String get errorMesssage => _errorMessage;

  Future<void> initState(id, slug) async {
    _future = fetchPost(id, slug);
    _baseUrl = await ForumConnect.getCurrentUrl();
    _isLoggedIn = await ForumConnect.checkLoggedIn();
    notifyListeners();
  }

  Future<PostModel> fetchPost(String id, String slug) async {
    final response = await ForumConnect.connectAndGet('/t/$slug/$id');
    if (response.statusCode == 200) {
      PostModel post = PostModel.fromPostJson(jsonDecode(response.body));
      _posts = [];
      _posts.addAll(post.postComments);
      return post;
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

  Future<void> updatePost(List<PostModel> posts) async {
    Map<String, dynamic> body = {
      'post': {'raw': commentText.text}
    };
    if (commentText.text.isNotEmpty) {
      final res =
          await ForumConnect.connectAndPut('/posts/$_editedPostId', body);

      PostModel newPostModel =
          PostModel.fromCommentJson(jsonDecode(res.body)['post']);

      int index =
          posts.indexWhere((PostModel post) => post.postId == editedPostId);

      posts[index].editedText = newPostModel.postCooked;
      _posts = posts;
      notifyListeners();
    }

    _isEditingPost = false;
    _editedPostId = '';

    notifyListeners();
  }

  Widget postBuilder(String slug, String id) {
    return ForumCommentView(
        topicId: id,
        topicPosts: _posts,
        postId: id,
        postSlug: slug,
        baseUrl: _baseUrl);
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

  Future<void> createPost(String topicId, String text, PostModel topic) async {
    Map<String, String> headers = {
      'X-Requested-With': 'XMLHttpRequest',
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    final response = await ForumConnect.connectAndPost(
        '/posts.json?&topic_id=$topicId&raw=$text', headers);
    Map<String, dynamic> body = json.decode(response.body);

    if (response.statusCode == 200) {
      _posts.add(PostModel.fromCommentJson(jsonDecode(response.body)));
      _createPostText.text = '';
      notifyListeners();
    } else {
      if (body.containsKey('errors')) {
        _hasError = true;
        _errorMessage = body['errors'][0];
        notifyListeners();
      }
    }
  }

  Future<void> updateTopic(postId, postSlug) async {
    Map<String, dynamic> body = {
      'post': {'raw': commentText.text}
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

  Future<void> deleteTopic(topicId, context) async {
    final response = await ForumConnect.connectAnDelete('/t/$topicId', {});
    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      throw Exception(response.body);
    }
  }

  // This returns a parsed date from ISO to : 20 minutes ago
  static String parseDate(String date) {
    return Jiffy(date).fromNow();
  }

  static String parseDateShort(String date) {
    String jiffyDate = Jiffy(date).fromNow();

    List parsedDate = jiffyDate.split(' ');

    if (jiffyDate.contains('minutes')) {
      return parsedDate[0] + 'm';
    }

    if (jiffyDate.contains('hour')) return '1h';

    if (jiffyDate.contains('hours')) return parsedDate[0] + 'h';

    if (jiffyDate.contains('days')) return parsedDate[0] + 'd';

    if (jiffyDate.contains('day')) return '1d';

    if (jiffyDate.contains('months')) return parsedDate[0] + 'm';

    if (jiffyDate.contains('month')) return '1m';

    if (jiffyDate.contains('years')) return parsedDate[0] + 'y';

    if (jiffyDate.contains('year')) return '1y';

    return jiffyDate;
  }

  // This returns a parsed url for sharing a post
  void parseShareUrl(String slug, String postId, [int? index]) {
    var i = index != null ? index + 2 : '';

    Share.share(
        'https://forum.freecodecamp.org/t/$slug/$postId/${i.toString()}',
        subject: 'Question from the freecodecamp forum');
  }

  final NavigationService _navigationService = locator<NavigationService>();
  void goToUserProfile(username) {
    _navigationService.navigateTo(Routes.forumUserView,
        arguments: ForumUserViewArguments(username: username));
  }

  void goToLoginPage() {
    _navigationService.navigateTo(Routes.forumLoginView);
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

    TextStyle style = const TextStyle(color: Colors.white, fontSize: 14);

    date = Jiffy(date).fromNow().toUpperCase();

    switch (action) {
      case 'visible.disabled':
        message = 'UNLISTED $date';
        icon = const Icon(
          FontAwesomeIcons.eyeSlash,
          color: Colors.white,
        );
        return returnAction(icon, message, style);
      case 'split_topic':
        message = 'SPLIT THIS TOPIC $date';
        icon =
            const Icon(FontAwesomeIcons.rightFromBracket, color: Colors.white);
        return returnAction(icon, message, style);
      case 'closed.enabled':
        message = 'CLOSED $date';
        icon = const Icon(FontAwesomeIcons.lock, color: Colors.white);
        return returnAction(icon, message, style);
      default:
        message = 'UNKNOWN ACTON: $action';
        return Row(
          children: [Text(message, style: style)],
        );
    }
  }

  List<PopupMenuItem> postOptionHandler(
      PostModel post, PostViewModel model, String postId, String postSlug) {
    List<PopupMenuItem> options = [];

    if (post.postCanDelete && model.recentlyDeletedPostId != post.postId) {
      options.add(PopupMenuItem(
          onTap: () {
            model.deletePost(post.postId, postId, postSlug);
          },
          child: Row(children: const [
            Icon(
              Icons.delete_sharp,
              color: Colors.white,
            ),
            Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            )
          ])));
    }

    if (post.postCanEdit && !model.isEditingPost) {
      options.add(PopupMenuItem(
          onTap: () {
            model.editPost(post.postId, post.postCooked);
          },
          child: Row(
            children: const [
              Icon(
                Icons.edit_sharp,
                color: Colors.white,
              ),
              Text(
                'Edit',
                style: TextStyle(color: Colors.white),
              )
            ],
          )));
    }

    return options;
  }
}
