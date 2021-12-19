class Podcasts {
  final String id;
  final String? url;
  final String? link;
  final String? title;
  final String? description;
  final String? image;
  final String? copyright;
  final int? numEps;

  Podcasts({
    required this.id,
    this.url,
    this.link,
    this.title,
    this.description,
    this.image,
    this.copyright,
    this.numEps,
  });

  factory Podcasts.fromJson(Map<String, dynamic> json) => Podcasts(
        id: json['_id'] as String,
        url: json['feedUrl'] as String?,
        link: json['podcastLink'] as String?,
        title: json['title'] as String?,
        description: json['description'] as String?,
        image: json['imageLink'] as String?,
        copyright: json['copyright'] as String?,
        numEps: json['numOfEps'] as int?
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'feedUrl': url,
        'podcastLink': link,
        'title': title,
        'description': description,
        'imageLink': image,
        'copyright': copyright,
        'numOfEps': numEps
      };

  @override
  String toString() {
    return """Podcasts {
      _id: $id,
      feedUrl: $url,
      podcastLink: $link,
      title: $title,
      description: ${description!.substring(0, 100)},
      imageLink: $image,
      copyright: $copyright
      numOfEps: $numEps
    }""";
  }
}
