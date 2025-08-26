class BookmarkedTutorial {
  late int bookmarkId;
  late String tutorialTitle;
  late String id;
  late String tutorialText;
  late String authorName;

  // Legacy constructor for database migration
  BookmarkedTutorial.fromMap(Map<String, dynamic> map) {
    bookmarkId = map['bookmark_id'];
    tutorialTitle = map['articleTitle'];
    id = map['articleId'];
    tutorialText = map['articleText'];
    authorName = map['authorName'];
  }

  // New constructor for JSON serialization
  BookmarkedTutorial.fromJson(Map<String, dynamic> json) {
    bookmarkId = json['bookmarkId'] ?? 0;
    tutorialTitle = json['tutorialTitle'] ?? '';
    id = json['id'] ?? '';
    tutorialText = json['tutorialText'] ?? '';
    authorName = json['authorName'] ?? '';
  }

  BookmarkedTutorial({
    required this.bookmarkId,
    required this.tutorialTitle,
    required this.id,
    required this.tutorialText,
    required this.authorName,
  });

  // Convert to JSON for file storage
  Map<String, dynamic> toJson() {
    return {
      'bookmarkId': bookmarkId,
      'tutorialTitle': tutorialTitle,
      'id': id,
      'tutorialText': tutorialText,
      'authorName': authorName,
    };
  }
}
