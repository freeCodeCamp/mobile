class Portfolio {
  final String id;
  // Below properties may be empty string instead of null, CONFIRM
  final String? title;
  final String? url;
  final String? image;
  final String? description;

  Portfolio({
    required this.id,
    this.title,
    this.url,
    this.image,
    this.description,
  });

  factory Portfolio.fromJson(Map<String, dynamic> data) {
    return Portfolio(
        id: data['id'],
        title: data['title'],
        url: data['url'],
        image: data['image'],
        description: data['description']);
  }
}
