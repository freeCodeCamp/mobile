import 'package:freecodecamp/services/auth_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_viewmodel.g.dart';

@riverpod
({int longest, int current}) profileStreak(Ref ref) {
  final days = ref.watch(authProvider).value?.heatMapCal ?? <DateTime, int>{};
  final activeDays = days.entries
      .where((entry) => entry.value > 0)
      .map((entry) => entry.key)
      .toSet();
  final sorted = activeDays.toList()..sort();
  var longest = 0;
  var current = 0;
  for (final day in sorted) {
    final previous = DateTime(day.year, day.month, day.day - 1);
    current = activeDays.contains(previous) ? current + 1 : 1;
    if (current > longest) longest = current;
  }
  final now = DateTime.now();
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  if (sorted.isEmpty || sorted.last.isBefore(yesterday)) current = 0;
  return (longest: longest, current: current);
}
