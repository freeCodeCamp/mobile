import 'package:intl/intl.dart';

String podcastDuration(Duration? duration) {
  if (duration == null) return 'Play';
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  if (hours == 0) return '${duration.inMinutes} min';
  return minutes == 0 ? '$hours hr' : '$hours hr $minutes min';
}

String podcastTimestamp(Duration duration) {
  final seconds = duration.inSeconds.clamp(0, 1 << 32);
  final hours = seconds ~/ 3600;
  final minutes = (seconds % 3600) ~/ 60;
  final rest = seconds % 60;
  String two(int n) => n.toString().padLeft(2, '0');
  return hours > 0
      ? '$hours:${two(minutes)}:${two(rest)}'
      : '$minutes:${two(rest)}';
}

String podcastFileSize(int bytes, String locale) {
  final megabytes = bytes / 1000000;
  final format = NumberFormat.decimalPattern(locale)
    ..minimumFractionDigits = megabytes < 10 ? 1 : 0
    ..maximumFractionDigits = megabytes < 10 ? 1 : 0;
  return '${format.format(megabytes)} MB';
}

String podcastDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}
