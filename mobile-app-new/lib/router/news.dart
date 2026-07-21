import 'package:go_router/go_router.dart';
import 'package:mobile_app_new/ui/views/news/news-feed/news_feed_view.dart';

const newsFeedPath = '/news';

final newsRoutes = [
  GoRoute(path: newsFeedPath, builder: (context, state) => NewsFeedView()),
];
