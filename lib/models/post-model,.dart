class PostList {
  static List<dynamic> returnPosts(Map<String, dynamic> data) {
    return data["topic_list"]["topics"];
  }

  static int postPerPage(Map<String, dynamic> data) {
    return data["topic_list"]["per_page"];
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

class PostModel {}
