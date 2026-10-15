import 'package:mobile_app_new/news/models/post_model.dart';
import 'package:mobile_app_new/news/services/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_viewmodel.g.dart';

@riverpod
Future<Post> newsPost(Ref ref, String slug) {
  return ref.watch(newsApiServiceProvider).getPostBySlug(slug);
}
