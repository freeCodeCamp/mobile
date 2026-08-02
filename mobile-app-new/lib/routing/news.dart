import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_new/ui/views/news/news-feed/news_feed_view.dart';

part 'news.g.dart';

const newsFeedPath = '/news';

@TypedGoRoute<NewsFeedRoute>(path: newsFeedPath)
class NewsFeedRoute extends GoRouteData with $NewsFeedRoute {
  const NewsFeedRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const NewsFeedView();
}
