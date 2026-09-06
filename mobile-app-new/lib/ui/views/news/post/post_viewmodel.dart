import 'package:mobile_app_new/models/news/post_model.dart';
import 'package:mobile_app_new/services/news/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_viewmodel.g.dart';

@riverpod
Future<Post> newsPost(Ref ref, String slug) {
  return ref.read(newsApiServiceProvider).getPostBySlug(slug);
}
