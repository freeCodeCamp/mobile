import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';
import 'dart:ui';
import 'package:freecodecamp/widgets/forum/forum-connect.dart';

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
  final String postName;
  final String postCreateDate;
  final String postHtml;
  final int postType;
  final int postReplyCount;
  final int postReads;

  PostModel(
      {required this.username,
      required this.name,
      required this.profieImage,
      required this.postHtml,
      required this.postId,
      required this.postName,
      required this.postCreateDate,
      required this.postType,
      required this.postReplyCount,
      required this.postReads});

  factory PostModel.fromJson(Map<String, dynamic> data) {
    return PostModel(
        postId: data["post_stream"]["posts"][0]["id"].toString(),
        postName: data["title"],
        postCreateDate: data["post_stream"]["posts"][0]["created_at"],
        postType: data["post_stream"]["posts"][0]["post_type"],
        postReplyCount: data["post_stream"]["posts"][0]["reply_count"],
        postReads: data["post_stream"]["posts"][0]["post_reads"],
        postHtml: data["post_stream"]["posts"][0]['cooked'],
        username: data["post_stream"]["posts"][0]["username"],
        profieImage: data["post_stream"]["posts"][0]["avatar_template"],
        name: data["post_stream"]["posts"][0]["name"]);
  }

  static Future<PostModel> fetchPost(String id, String slug) async {
    final response = await ForumConnect.connectAndGet('/t/$slug/$id');

    if (response.statusCode == 200) {
      return PostModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Could not load post');
    }
  }

  static String parseProfileAvatUrl(String url) {
    List size = url.split('{size}');
    String avatarUrl = size[0] + '60' + size[1];
    String baseUrl = 'https://forum.freecodecamp.org';
    bool fromDiscourse = size[0]
        .toString()
        .contains(new RegExp(r'discourse-cdn', caseSensitive: false));

    if (fromDiscourse) {
      return avatarUrl;
    } else if (size.length == 1) {
      return size[0];
    } else {
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
}

class PostCreator {
  static bool? isUsersPost(Map<String, bool> data) {
    return data["yours"];
  }

  static bool? userCanEdit(Map<String, bool> data) {
    return data["can_edit"];
  }
}
