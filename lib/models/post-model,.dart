import 'dart:convert';

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
  final String postId;
  final String postName;
  final String postCreateDate;
  final int postType;
  final int postReplyCount;
  final int postReads;

  PostModel(
      {required this.postId,
      required this.postName,
      required this.postCreateDate,
      required this.postType,
      required this.postReplyCount,
      required this.postReads});

  factory PostModel.fromJson(Map<String, dynamic> data) {
    return PostModel(
        postId: data["id"],
        postName: data["name"],
        postCreateDate: data["created_at"],
        postType: data["post_type"],
        postReplyCount: data["reply_count"],
        postReads: data["post_reads"]);
  }

  static Future<PostModel> fetchPost(String id) async {
    final response = await ForumConnect.connectAndGet('/posts/$id');

    if (response.statusCode == 200) {
      return PostModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Could not load post');
    }
  }
}

// class PostCreator extends PostModel {
//   final String username;
//   final String profieImage;

//   PostCreator(this.username, this.profieImage)

//   static bool? isUsersPost(Map<String, bool> data) {
//     return data["yours"];
//   }

//   static bool? userCanEdit(Map<String, bool> data) {
//     return data["can_edit"];
//   }
// }
