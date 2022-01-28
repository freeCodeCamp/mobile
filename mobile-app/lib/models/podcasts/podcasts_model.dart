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
      id: json['id'] as String,
      url: json['url'] as String?,
      link: json['link'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      copyright: json['copyright'] as String?,
      numEps: json['numEps'] as int?);

  Map<String, dynamic> toJson() => {
        'id': id,
        'url': url,
        'link': link,
        'title': title,
        'description': description,
        'image': image,
        'copyright': copyright,
        'numEps': numEps
      };

  @override
  String toString() {
    return '''Podcasts {
      id: $id,
      url: $url,
      link: $link,
      title: $title,
      description: ${description!.substring(0, 100)},
      image: $image,
      copyright: $copyright
      numEps: $numEps
    }''';
  }
}
