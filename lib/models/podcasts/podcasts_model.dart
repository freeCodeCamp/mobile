class Podcasts {
  final String id;
  final String? url;
  final String? link;
  final String? title;
  final String? description;
  final String? image;
  final String? copyright;

  Podcasts({
    required this.id,
    this.url,
    this.link,
    this.title,
    this.description,
    this.image,
    this.copyright,
  });

  factory Podcasts.fromJson(Map<String, dynamic> json) => Podcasts(
        id: json['id'] as String,
        url: json['url'] as String?,
        link: json['link'] as String?,
        title: json['title'] as String?,
        description: json['description'] as String?,
        image: json['image'] as String?,
        copyright: json['copyright'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'url': url,
        'link': link,
        'title': title,
        'description': description,
        'image': image,
        'copyright': copyright,
      };

  @override
  String toString() {
    return """Episodes{
      id: $id,
      url: $url,
      link: $link,
      title: $title,
      description: ${description!.substring(0, 100)},
      image: $image,
      copyright: $copyright
    }""";
  }
}
