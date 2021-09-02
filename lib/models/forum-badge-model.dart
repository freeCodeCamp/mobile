class Badge {
  final int id;
  final int grantCount;
  final String name;
  final String description;
  final String slug;
  final bool allowTitle;
  final bool listable;
  final bool enabled;
  final bool manuallyGrantable;

  Badge(
      {required this.id,
      required this.grantCount,
      required this.name,
      required this.description,
      required this.slug,
      required this.allowTitle,
      required this.listable,
      required this.enabled,
      required this.manuallyGrantable});

  factory Badge.fromJson(Map<String, dynamic> data) {
    return Badge(
        id: data['id'],
        grantCount: data['grant_count'],
        name: data['name'],
        description: data['description'],
        slug: data['slug'],
        allowTitle: data['allow_title'],
        listable: data['listable'],
        enabled: data['enabled'],
        manuallyGrantable: data['manually_grantable']);
  }
}
