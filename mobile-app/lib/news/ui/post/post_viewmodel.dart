import 'package:freecodecamp/news/models/post_model.dart';
import 'package:freecodecamp/news/services/api_service.dart';
import 'package:freecodecamp/utils/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_viewmodel.g.dart';

@Riverpod(retry: noRetry)
Future<Post> newsPost(Ref ref, String slug) {
  return ref.watch(newsApiServiceProvider).getPostBySlug(slug);
}
