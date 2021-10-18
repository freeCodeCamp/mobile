class BookmarkedArticle {
  late int bookmarkId;
  late String articleTitle;
  late String id;
  late String articleText;
  late String authorName;

  BookmarkedArticle.fromMap(Map<String, dynamic> map) {
    bookmarkId = map['bookmark_id'];
    articleTitle = map['articleTitle'];
    id = map['articleId'];
    articleText = map['articleText'];
    authorName = map['authorName'];
  }

  BookmarkedArticle(
      {required this.bookmarkId,
      required this.articleTitle,
      required this.id,
      required this.articleText,
      required this.authorName});
}
