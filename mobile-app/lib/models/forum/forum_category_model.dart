class Category {
  final int id;
  final String name;
  final String slug;
  final String color;
  final String textColor;
  final String description;
  final int topicCount;
  final int topicWeek;

  Category(
      {required this.id,
      required this.name,
      required this.slug,
      required this.color,
      required this.textColor,
      required this.description,
      required this.topicCount,
      required this.topicWeek});

  factory Category.fromJson(Map<String, dynamic> data) {
    return Category(
        id: data["id"],
        name: data["name"],
        slug: data["slug"],
        color: data["color"],
        textColor: data["text_color"],
        description: data["description"],
        topicCount: data["topic_count"],
        topicWeek: data["topics_week"]);
  }
}

// 19 november 10 uur  