class SearchModel {
  final int topicId;
  final String postUsername;
  final int postLikeCount;
  final String title;
  final String slug;

  SearchModel(
      {required this.title,
      required this.postLikeCount,
      required this.postUsername,
      required this.topicId,
      required this.slug});
}
