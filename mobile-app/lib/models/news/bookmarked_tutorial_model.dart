class BookmarkedTutorial {
  late int bookmarkId;
  late String tutorialTitle;
  late String id;
  late String tutorialText;
  late String authorName;

  BookmarkedTutorial.fromMap(Map<String, dynamic> map) {
    bookmarkId = map['bookmark_id'];
    tutorialTitle = map['tutorialTitle'];
    id = map['tutorialId'];
    tutorialText = map['tutorialText'];
    authorName = map['authorName'];
  }

  BookmarkedTutorial(
      {required this.bookmarkId,
      required this.tutorialTitle,
      required this.id,
      required this.tutorialText,
      required this.authorName});
}
