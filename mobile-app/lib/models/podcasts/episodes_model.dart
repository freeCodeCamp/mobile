// This class name might be changed in the future
class Episodes {
  final String id;
  final String podcastId;
  final String title;
  final String? description;
  final DateTime? publicationDate;
  final String? contentUrl;
  final Duration? duration;

  Episodes({
    required this.id,
    required this.podcastId,
    required this.title,
    this.description,
    this.publicationDate,
    this.contentUrl,
    this.duration,
  });

  factory Episodes.fromAPIJson(Map<String, dynamic> json) => Episodes(
        id: json['_id'] as String,
        podcastId: json['podcastId'] as String,
        title: json['title'] as String,
        description: json['description'] as String?,
        publicationDate: json['publicationDate'] == null
            ? null
            : DateTime.parse(json['publicationDate']),
        contentUrl: json['audioUrl'] as String?,
        duration:
            json['duration'] == null ? null : parseDuration(json['duration']),
      );

  factory Episodes.fromDBJson(Map<String, dynamic> json) => Episodes(
        id: json['id'] as String,
        podcastId: json['podcastId'] as String,
        title: json['title'] as String,
        description: json['description'] as String?,
        publicationDate: json['publicationDate'] == null
            ? null
            : DateTime.parse(json['publicationDate']),
        contentUrl: json['contentUrl'] as String?,
        duration:
            json['duration'] == null ? null : parseDuration(json['duration']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'podcastId': podcastId,
        'title': title,
        'description': description,
        'publicationDate': publicationDate?.toIso8601String(),
        'contentUrl': contentUrl,
        'duration': duration.toString(),
      };

  @override
  String toString() {
    return '''Episodes {
      id: $id,
      podcastId: $podcastId,
      title: $title,
      description: ${description!.substring(0, 100)},
      publicationDate: $publicationDate,
      contentUrl: $contentUrl,
      duration: $duration,
    }''';
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
