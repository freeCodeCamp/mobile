import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:freecodecamp/widgets/forum/forum-connect.dart';
import 'package:jiffy/jiffy.dart';
import 'package:share/share.dart';
import 'dart:developer' as dev;

class PostList {
  static List<dynamic> returnPosts(Map<String, dynamic> data) {
    return data["topic_list"]["topics"];
  }

  static List<dynamic> returnCategoryUsers(Map<String, dynamic> data) {
    return data["users"];
  }

  static List<dynamic> returnProfilePictures(Map<String, dynamic> data) {
    return data["details"]["participants"];
  }

  PostList.error() {
    throw Exception('Unable to load posts');
  }

  PostList.errorProfile() {
    throw Exception('unable to load post profile pictures');
  }
}

class PostModel {
  final String username;
  final String name;
  final String profieImage;
  final String postId;
  final String? postName;
  final String postSlug;
  final dynamic postCreateDate;
  final String postHtml;
  final List? postComments;
  final int postType;
  final int postReplyCount;
  final int postReads;
  final int? postLikes;

  PostModel(
      {required this.username,
      required this.name,
      required this.profieImage,
      required this.postHtml,
      required this.postId,
      this.postName,
      required this.postSlug,
      required this.postCreateDate,
      required this.postType,
      required this.postReplyCount,
      required this.postReads,
      this.postLikes,
      this.postComments});

  factory PostModel.fromPostJson(Map<String, dynamic> data) {
    return PostModel(
        postComments: data["post_stream"]["posts"],
        postId: data["post_stream"]["posts"][0]["id"].toString(),
        postName: data["title"],
        postSlug: data["post_stream"]["posts"][0]["topic_slug"],
        postCreateDate: data["post_stream"]["posts"][0]["created_at"],
        postType: data["post_stream"]["posts"][0]["post_type"],
        postReplyCount: data["post_stream"]["posts"][0]["reply_count"],
        postReads: data["post_stream"]["posts"][0]["reads"],
        postLikes: data["like_count"],
        postHtml: data["post_stream"]["posts"][0]['cooked'],
        username: data["post_stream"]["posts"][0]["username"],
        profieImage: data["post_stream"]["posts"][0]["avatar_template"],
        name: data["post_stream"]["posts"][0]["name"]);
  }

  factory PostModel.fromCommentJson(Map<String, dynamic> data) {
    return PostModel(
        postId: data["id"].toString(),
        postCreateDate: data["created_at"],
        postType: data["post_type"],
        postReplyCount: data["reply_count"],
        postReads: data["reads"],
        postHtml: data['cooked'],
        username: data["username"],
        postSlug: data["topic_slug"],
        profieImage: data["avatar_template"],
        name: data["name"]);
  }

  factory PostModel.fromCommentBotJson(Map<String, dynamic> data) {
    return PostModel(
        postId: data["postId"].toString(),
        postCreateDate: data["postCreateDate"],
        postType: data["postType"],
        postReplyCount: data["postReplyCount"],
        postReads: data["postReads"],
        postHtml: data['postHtml'],
        username: data["username"],
        postSlug: data["postSlug"],
        profieImage: data["profieImage"],
        name: data["name"]);
  }

  static Future<PostModel> fetchPost(String id, String slug) async {
    final response = await ForumConnect.connectAndGet('/t/$slug/$id');

    if (response.statusCode == 200) {
      return PostModel.fromPostJson(jsonDecode(response.body));
    } else {
      throw Exception('Could not load post');
    }
  }

  static String parseProfileAvatUrl(
    String? url,
    String size,
  ) {
    List urlPart = url!.split('{size}');
    String avatarUrl = '';
    String baseUrl = 'https://forum.freecodecamp.org';
    bool fromDiscourse = urlPart[0]
        .toString()
        .contains(new RegExp(r'discourse-cdn', caseSensitive: false));

    if (urlPart.length > 1) {
      avatarUrl = urlPart[0] + size + urlPart[1];
    }

    if (urlPart.length == 1) {
      return urlPart[0];
    } else if (fromDiscourse) {
      return avatarUrl;
    } else {
      dev.log(baseUrl + avatarUrl);
      return baseUrl + avatarUrl;
    }
  }

  static Color randomBorderColor() {
    final random = new Random();

    List borderColor = [
      Color.fromRGBO(0x99, 0xC9, 0xFF, 1),
      Color.fromRGBO(0xAC, 0xD1, 0x57, 1),
      Color.fromRGBO(0xFF, 0xFF, 0x00, 1),
      Color.fromRGBO(0x80, 0x00, 0x80, 1),
    ];

    int index = random.nextInt(borderColor.length);

    return borderColor[index];
  }

  static parseDate(String date) {
    return Jiffy(date).fromNow();
  }

  static parseShareUrl(BuildContext context, String slug) {
    Share.share('https://forum.freecodecamp.org/t/$slug',
        subject: 'Question from the freecodecamp forum');
  }
}

class PostCreator {
  static bool? isUsersPost(Map<String, bool> data) {
    return data["yours"];
  }

  static bool? userCanEdit(Map<String, bool> data) {
    return data["can_edit"];
  }
}

class Comment {
  static List<PostModel> returnCommentList(data) {
    List<PostModel> comments = [];
    List jsonComments = data;

    if (jsonComments.length > 1) {
      jsonComments.forEach((comment) {
        comments.add(PostModel.fromCommentJson(comment));
      });
      comments.removeAt(0);
    } else if (comments.length == 0) {
      comments.add(PostModel.fromCommentBotJson({
        "username": 'FreeCodeCamp Bot',
        "name": 'Cliff',
        "profieImage":
            'https://pbs.twimg.com/profile_images/1276770212927410176/qTgTIejk_400x400.jpg',
        "postHtml":
            '<p> No comments yet a contributor will be here shortly!</p>',
        "postId": 9999999,
        "postSlug": '',
        "postCreateDate": data[0]["created_at"],
        "postType": 0,
        "postReplyCount": 0,
        "postReads": 0
      }));
    }
    return comments;
  }
}
