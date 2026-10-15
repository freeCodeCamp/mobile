import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

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

Future<void> sharePodcast(
  BuildContext context,
  String title,
  String url,
) async {
  final box = context.findRenderObject() as RenderBox?;
  try {
    await SharePlus.instance.share(
      ShareParams(
        text: '$title\n\n$url',
        sharePositionOrigin: box == null
            ? null
            : box.localToGlobal(Offset.zero) & box.size,
      ),
    );
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to share right now. Please try again.'),
        ),
      );
    }
  }
}
