class Article {
  final String id;
  final String title;
  final String featureImage;
  final String profileImage;
  final String authorName;
  final String? createdAt;
  final String? tagName;
  final String? url;
  final String? text;

  Article(
      {required this.id,
      required this.featureImage,
      required this.title,
      required this.profileImage,
      required this.authorName,
      this.createdAt,
      this.tagName,
      this.url,
      this.text});

  // this factory is for the endpoint where all article thumbnails are received

  factory Article.fromJson(Map<String, dynamic> data) {
    return Article(
        createdAt: data["published_at"],
        featureImage: data["feature_image"],
        title: data["title"],
        profileImage: data['authors'][0]['profile_image'],
        authorName: data['authors'][0]['name'],
        tagName:
            data['tags'].length > 0 ? data['tags'][0]['name'] : 'FreeCodeCamp',
        id: data["id"]);
  }

  // this is factory is for the post view

  factory Article.toPostFromJson(Map<String, dynamic> json) {
    return Article(
        authorName: json['posts'][0]['primary_author']['name'],
        profileImage: json['posts'][0]['primary_author']['profile_image'],
        id: json['posts'][0]['id'],
        title: json['posts'][0]['title'],
        url: json['posts'][0]['url'],
        text: json['posts'][0]['html'],
        featureImage: json['posts'][0]['feature_image']);
  }
}
