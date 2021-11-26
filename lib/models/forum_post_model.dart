// This types and converts the JSON into the instances of the PostModel class.
class PostModel {
  final String username;
  final String? name;
  final String? profieImage;
  final String postId;
  final String? postName;
  final String postSlug;
  final dynamic postCreateDate;
  final String? postLastActivity;
  final String? postCooked;
  final String? postAction;
  final List? postComments;
  final int? postViews;
  final int? postType;
  final int postReplyCount;
  final int? postReads;
  final int? postLikes;
  final bool postCanEdit;
  final bool postCanDelete;
  final bool postCanRecover;
  final bool isModerator;
  final bool isAdmin;
  final bool isStaff;
  final bool postHasAnswer;
  final List? postUsers;
  final List? userImages;

  PostModel(
      {required this.username,
      required this.name,
      required this.profieImage,
      this.postCooked,
      this.postAction,
      required this.postId,
      this.postName,
      this.postLastActivity,
      required this.postSlug,
      required this.postCreateDate,
      this.postType,
      required this.postReplyCount,
      this.postReads,
      this.postViews,
      this.postLikes,
      this.postComments,
      required this.postCanEdit,
      required this.postCanDelete,
      required this.postCanRecover,
      required this.isModerator,
      required this.isAdmin,
      required this.isStaff,
      required this.postHasAnswer,
      this.postUsers,
      this.userImages});

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
        postHasAnswer: data["post_stream"]["posts"][0]["has_accepted_answer"]);
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
        postAction: data['action_code'],
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
        postHasAnswer: data["has_accepted_answer"] ?? false);
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
        postHasAnswer: data["has_accepted_answer"]);
  }

  static String parseProfileAvatar(String? url) {
    List urlPart = url!.split('{size}');
    String avatarUrl = '';

    if (urlPart.length > 1) {
      avatarUrl = urlPart[0] + "60" + urlPart[1];
    }

    if (urlPart.length == 1) {
      return urlPart[0];
    } else {
      return avatarUrl;
    }
  }

  static bool fromDiscourse(url) {
    bool fromDiscourse =
        url.toString().contains(RegExp(r'discourse-cdn', caseSensitive: false));

    return fromDiscourse;
  }

  static List parseAvatars(List images, List postUsers) {
    List userImages = [];

    for (int i = 0; i < postUsers.length; i++) {
      for (int j = 0; j < images.length; j++) {
        bool hasUserImage = userImages.contains(images[i]["avatar_template"]);

        if (postUsers[i]["user_id"] == images[j]["id"] && !hasUserImage) {
          userImages.add(parseProfileAvatar(images[j]["avatar_template"]));
        }
      }
    }
    return userImages;
  }

  factory PostModel.fromTopicFeedJson(Map<String, dynamic> data, images) {
    return PostModel(
        postId: data["id"].toString(),
        postName: data["title"],
        postLastActivity: data["bumped_at"],
        postCreateDate: data["created_at"],
        postViews: data["views"],
        postReplyCount: data["reply_count"],
        postSlug: data["slug"],
        username: data["last_poster_username"],
        profieImage: data["avatar_template"],
        name: data["name"],
        postCanDelete: data["can_delete"],
        postCanEdit: data["can_edit"],
        postCanRecover: data["can_recover"],
        isAdmin: data["admin"],
        isModerator: data["moderator"],
        isStaff: data["staff"],
        postHasAnswer: data["has_accepted_answer"],
        userImages: parseAvatars(images, data["posters"]));
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
        "has_accepted_answer": false
      }));
    }
    return comments;
  }
}
