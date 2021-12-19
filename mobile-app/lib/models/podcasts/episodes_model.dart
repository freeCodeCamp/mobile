// This class name might be changed in the future
class Episodes {
  final String guid;
  final String podcastId;
  final String title;
  final String? description;
  // Convert to millisecondsSinceEpoch
  final DateTime? publicationDate;
  final String? contentUrl;
  // Convert to milliseconds
  final Duration? duration;
  // Usual boolean to int
  bool downloaded;

  Episodes({
    required this.guid,
    required this.podcastId,
    required this.title,
    this.description,
    this.publicationDate,
    this.contentUrl,
    this.duration,
    this.downloaded = false,
  });

  factory Episodes.fromJson(Map<String, dynamic> json) => Episodes(
        guid: json['_id'] as String,
        podcastId: json['podcastId'] as String,
        title: json['title'] as String,
        description: json['description'] as String?,
        publicationDate: json['publicationDate'] == null
            ? null
            : DateTime.parse(json['publicationDate']),
        contentUrl: json['audioUrl'] as String?,
        duration:
            json['duration'] == null ? null : parseDuration(json['duration']),
        downloaded: json['downloaded'] as int == 1 ? true : false,
      );

  Map<String, dynamic> toJson() => {
        'id': guid,
        'podcastId': podcastId,
        'title': title,
        'description': description,
        'publicationDate': publicationDate?.toIso8601String(),
        'audioUrl': contentUrl,
        'duration': duration.toString(),
        'downloaded': downloaded ? 1 : 0
      };

  @override
  String toString() {
    return """Episodes {
      id: $guid, 
      podcastId: $podcastId, 
      title: $title, 
      description: ${description!.substring(0, 100)},
      publicationDate: $publicationDate, 
      audioUrl: $contentUrl, 
      duration: $duration, 
      downloaded: $downloaded
    }""";
  }
}

Duration parseDuration(String s) {
  var hours = 0;
  var minutes = 0;
  var seconds = 0;
  final parts = s.split(':');
  if (parts.length > 2) {
    hours = int.tryParse(parts[parts.length - 3]) ?? 0;
  }
  if (parts.length > 1) {
    minutes = int.tryParse(parts[parts.length - 2]) ?? 0;
  }
  seconds = int.tryParse(parts[parts.length - 1]) ?? 0;
  return Duration(
    hours: hours,
    minutes: minutes,
    seconds: seconds,
  );
}
