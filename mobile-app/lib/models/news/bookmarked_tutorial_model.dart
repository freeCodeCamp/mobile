class BookmarkedTutorial {
  late String id;
  late String tutorialTitle;
  late String authorName;
  late String tutorialText;

  BookmarkedTutorial.fromMap(Map<String, dynamic> map) {
    id = map['articleId'];
    tutorialTitle = map['articleTitle'];
    authorName = map['authorName'];
    tutorialText = map['articleText'];
  }

  BookmarkedTutorial({
    required this.id,
    required this.tutorialTitle,
    required this.authorName,
    required this.tutorialText,
  });
}
