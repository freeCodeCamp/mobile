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
  final String? postHtml;
  final List? postComments;
  final int? postViews;
  final int? postType;
  final int postReplyCount;
  final int? postReads;
  final int? postLikes;

  PostModel(
      {required this.username,
      this.name,
      this.profieImage,
      this.postHtml,
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

  factory PostModel.fromTopicFeedJson(Map<String, dynamic> data) {
    return PostModel(
        postId: data["id"].toString(),
        postName: data["title"],
        postLastActivity: data["bumped_at"],
        postCreateDate: data["created_at"],
        postViews: data["views"],
        postReplyCount: data["reply_count"],
        postSlug: data["slug"],
        username: data["last_poster_username"]);
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
