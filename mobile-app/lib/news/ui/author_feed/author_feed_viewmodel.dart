import 'package:freecodecamp/news/models/author_model.dart';
import 'package:freecodecamp/news/services/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'author_feed_viewmodel.g.dart';

// Only used on a cold deep link; in-app navigation hands the author over as extra
@riverpod
Future<Author> newsAuthor(Ref ref, String username) {
  return ref.watch(newsApiServiceProvider).getAuthor(username);
}
