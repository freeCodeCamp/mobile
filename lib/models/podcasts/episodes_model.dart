// This class name might be changed in the future
class Episodes {
  final String guid;
  final String podcastId;
  final String? title;
  final String? description;
  final String? link;
  // Convert to millisecondsSinceEpoch
  final DateTime? publicationDate;
  final String? contentUrl;
  final String? imageUrl;
  // Convert to milliseconds
  final Duration? duration;
  // Usual boolean to int
  bool downloaded;

  Episodes({
    required this.guid,
    required this.podcastId,
    this.title,
    this.description,
    this.link = '',
    this.publicationDate,
    this.contentUrl,
    this.imageUrl,
    this.duration,
    this.downloaded = false,
  });

  factory Episodes.fromJson(Map<String, dynamic> json) => Episodes(
        guid: json['guid'] as String,
        podcastId: json['podcastId'] as String,
        title: json['title'] as String?,
        description: json['description'] as String?,
        link: json['link'] as String?,
        publicationDate: json['publicationDate'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(
                json['publicationDate'] as int),
        contentUrl: json['contentUrl'] as String?,
        imageUrl: json['imageUrl'] as String?,
        duration: json['duration'] == null
            ? null
            : Duration(milliseconds: json['duration'] as int),
        downloaded: json['downloaded'] as int == 1 ? true : false,
      );

  Map<String, dynamic> toJson() => {
        'guid': guid,
        'podcastId': podcastId,
        'title': title,
        'description': description,
        'link': link,
        'publicationDate': publicationDate?.millisecondsSinceEpoch,
        'contentUrl': contentUrl,
        'imageUrl': imageUrl,
        'duration': duration?.inMilliseconds,
        'downloaded': downloaded ? 1 : 0
      };

  @override
  String toString() {
    return """Episodes{guid: $guid, podcastId: $podcastId, title: $title, description: $description,
      link: $link, publicationDate: $publicationDate, contentUrl: $contentUrl, imageUrl: $imageUrl,
      duration: $duration, downloaded: $downloaded}""";
  }
}
