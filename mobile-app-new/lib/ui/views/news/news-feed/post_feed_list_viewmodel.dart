import 'package:mobile_app_new/models/news/post_model.dart';
import 'package:mobile_app_new/services/news/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_feed_list_viewmodel.g.dart';

@riverpod
class NewsFeedNotifier extends _$NewsFeedNotifier {
  bool _isFetchingNext = false;

  String _endCursor = '';
  bool _hasNextPage = true;
  final List<Post> _posts = [];

  bool get hasNextPage => _hasNextPage;

  @override
  FutureOr<List<Post>> build({String tagSlug = ''}) async {
    return _fetchPage();
  }

  Future<List<Post>> _fetchPage() async {
    final service = ref.read(newsApiServiceProvider);
    final page = tagSlug.isEmpty
        ? await service.getAllPosts(afterCursor: _endCursor)
        : await service.getPostsByTag(tagSlug, afterCursor: _endCursor);

    _endCursor = page.endCursor;
    _hasNextPage = page.hasNextPage;
    _posts.addAll(page.posts);

    return List.unmodifiable(_posts);
  }

  Future<void> fetchNextPage() async {
    if (!_hasNextPage || _isFetchingNext) return;

    _isFetchingNext = true;
    state = await AsyncValue.guard(() => _fetchPage());
    _isFetchingNext = false;
  }
}
