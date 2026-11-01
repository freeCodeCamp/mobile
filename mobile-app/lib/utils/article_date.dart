import 'package:jiffy/jiffy.dart';

String articleDate(String value) {
  final date = DateTime.tryParse(value);
  return date == null
      ? ''
      : Jiffy.parseFromDateTime(date).format(pattern: 'MMM d, yyyy');
}
