import 'package:flutter/foundation.dart';
import 'package:jiffy/jiffy.dart';

String parseDate(String date) {
  try {
    final jiffyDate = Jiffy.parseFromDateTime(DateTime.parse(date));
    return Jiffy.parseFromJiffy(jiffyDate).fromNow().toUpperCase();
  } catch (e) {
    debugPrint('Error parsing date: $e');
    return '';
  }
}
