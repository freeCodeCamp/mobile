import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_new/ui/views/news/news-feed/news_feed_view.dart';
import 'package:mobile_app_new/ui/views/news/news-view-handler/news_view_handler_view.dart';

part 'news.g.dart';

const newsBookmarksPath = '/news/bookmarks';
const newsFeedPath = '/news';
const newsSearchPath = '/news/search';

@TypedShellRoute<NewsShellRoute>(
  routes: [
    TypedGoRoute<NewsBookmarksRoute>(path: newsBookmarksPath),
    TypedGoRoute<NewsFeedRoute>(path: newsFeedPath),
    TypedGoRoute<NewsSearchRoute>(path: newsSearchPath),
  ],
)
class NewsShellRoute extends ShellRouteData {
  const NewsShellRoute();

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return NewsViewHandlerView(child: navigator);
  }
}

class NewsBookmarksRoute extends GoRouteData with $NewsBookmarksRoute {
  const NewsBookmarksRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      const NoTransitionPage(child: Center(child: Text('Bookmarks - Coming Soon')));
}

class NewsFeedRoute extends GoRouteData with $NewsFeedRoute {
  const NewsFeedRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      const NoTransitionPage(child: NewsFeedView());
}

class NewsSearchRoute extends GoRouteData with $NewsSearchRoute {
  const NewsSearchRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      const NoTransitionPage(child: Center(child: Text('Search - Coming Soon')));
}
