import 'package:mobile_app_new/models/news/post_model.dart';
import 'package:mobile_app_new/services/news/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'news_post_viewmodel.g.dart';

@riverpod
class NewsPostNotifier extends _$NewsPostNotifier {
  @override
  FutureOr<Post> build(String slug) async {
    final service = ref.read(newsApiServiceProvider);
    return service.getPostBySlug(slug);
  }
}
