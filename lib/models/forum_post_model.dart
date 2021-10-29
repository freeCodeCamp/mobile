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

// This types and converts the JSON into the instances of the PostModel class.
class PostModel {
  final String username;
  final String name;
  final String profieImage;
  final String postId;
  final String? postName;
  final String postSlug;
  final dynamic postCreateDate;
  final String postCooked;
  final List? postComments;
  final int postType;
  final int postReplyCount;
  final int postReads;
  final int? postLikes;
  final bool postCanEdit;
  final bool postCanDelete;
  final bool postCanRecover;
  final bool isModerator;
  final bool isAdmin;
  final bool isStaff;
  final bool postLikedByUser;
  final bool postIsUsers;

  PostModel(
      {required this.username,
      required this.name,
      required this.profieImage,
      required this.postCooked,
      required this.postId,
      this.postName,
      required this.postSlug,
      required this.postCreateDate,
      required this.postType,
      required this.postReplyCount,
      required this.postReads,
      this.postLikes,
      this.postComments,
      this.postLikedByUser = false,
      required this.postIsUsers,
      required this.postCanEdit,
      required this.postCanDelete,
      required this.postCanRecover,
      required this.isModerator,
      required this.isAdmin,
      required this.isStaff});

  // this is for endpoint /t/{slug}/{id}.json
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
        postCooked: data["post_stream"]["posts"][0]['cooked'],
        username: data["post_stream"]["posts"][0]["username"],
        profieImage: data["post_stream"]["posts"][0]["avatar_template"],
        name: data["post_stream"]["posts"][0]["name"],
        postCanDelete: data["details"]["can_delete"],
        postCanEdit: data["details"]["can_edit"],
        postCanRecover: data["details"]["can_recover"],
        isAdmin: data["post_stream"]["posts"][0]["admin"],
        isModerator: data["post_stream"]["posts"][0]["moderator"],
        isStaff: data["post_stream"]["posts"][0]["staff"],
        postIsUsers: data["post_stream"]["posts"][0]["yours"]);
  }

  static bool getIfLikedPost(List<dynamic> data) {
    for (int i = 0; i < data.length; i++) {
      if (data[i]["id"] == 2) {
        if (data[i]["acted"] == true) return true;
      }
    }
    return false;
  }

  static int getLikesPost(List<dynamic> data) {
    int? result;

    for (int i = 0; i < data.length; i++) {
      if (data[i]["id"] == 2) {
        result = data[i]["count"];
      }
    }
    return result ?? 0;
  }
  // this is for the same endpoint as fromPostJson only it needs to be parsed
  // differently to be able to "type" these as comments.

  factory PostModel.fromCommentJson(Map<String, dynamic> data) {
    return PostModel(
        postId: data["id"].toString(),
        postCreateDate: data["created_at"],
        postType: data["post_type"],
        postReplyCount: data["reply_count"],
        postReads: data["reads"],
        postCooked: data['cooked'],
        username: data["username"],
        postSlug: data["topic_slug"],
        profieImage: data["avatar_template"],
        name: data["name"],
        postCanDelete: data["can_delete"],
        postCanEdit: data["can_edit"],
        postCanRecover: data["can_recover"],
        isAdmin: data["admin"],
        isModerator: data["moderator"],
        isStaff: data["staff"],
        postIsUsers: data["yours"],
        postLikedByUser:
            data["yours"] ? false : getIfLikedPost(data["actions_summary"]),
        postLikes: getLikesPost(data["actions_summary"]));
  }

  // this is an offline factory that does not parse any data from an endpoint
  factory PostModel.fromCommentBotJson(Map<String, dynamic> data) {
    return PostModel(
        postId: data["postId"].toString(),
        postCreateDate: data["postCreateDate"],
        postType: data["postType"],
        postReplyCount: data["postReplyCount"],
        postReads: data["postReads"],
        postCooked: data['postCooked'],
        username: data["username"],
        postSlug: data["postSlug"],
        profieImage: data["profieImage"],
        name: data["name"],
        postCanDelete: data["postCanDelete"],
        postCanEdit: data["postCanEdit"],
        postCanRecover: data["postCanRecover"],
        isAdmin: data["isAdmin"],
        isModerator: data["isModerator"],
        isStaff: data["isStaff"],
        postIsUsers: data["postIsUsers"]);
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

// This returns a list of comments, if there are no comments present on an users post
// there wil be a standard message from CamperBot that a contributor wil be there shortly
class Comment {
  static List<PostModel> returnCommentList(data) {
    List<PostModel> comments = [];
    List jsonComments = data;

    if (jsonComments.length > 1) {
      for (var comment in jsonComments) {
        comments.add(PostModel.fromCommentJson(comment));
      }
      comments.removeAt(0);
    } else if (comments.isEmpty) {
      comments.add(PostModel.fromCommentBotJson({
        "username": 'camperbot',
        "name": 'Cliff',
        "profieImage":
            'https://sea1.discourse-cdn.com/freecodecamp/user_avatar/forum.freecodecamp.org/camperbot/240/18364_2.png',
        "postCooked":
            '<p> No comments yet a contributor will be here shortly!</p>',
        "postId": 9999999,
        "postSlug": '',
        "postCreateDate": data[0]["created_at"],
        "postType": 0,
        "postReplyCount": 0,
        "postReads": 0,
        "postCanEdit": false,
        "postCanDelete": false,
        "postCanRecover": false,
        "isAdmin": true,
        "isModerator": true,
        "isStaff": true,
        "postIsUsers": true
      }));
    }
    return comments;
  }
}
