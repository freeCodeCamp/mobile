class Streak {
  final int longest;
  final int current;

  Streak({required this.longest, required this.current});

  factory Streak.fromJson(Map<String, dynamic> data) {
    return Streak(longest: data['longest'] ?? 0, current: data['current'] ?? 0);
  }
}
