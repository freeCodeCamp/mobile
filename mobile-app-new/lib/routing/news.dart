import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_new/news/models/bookmarked_post_model.dart';
import 'package:mobile_app_new/news/ui/bookmark_feed/bookmark_feed_view.dart';
import 'package:mobile_app_new/news/ui/bookmark_post/bookmark_post_view.dart';
import 'package:mobile_app_new/news/ui/feed/feed_view.dart';
import 'package:mobile_app_new/news/ui/post/post_view.dart';
import 'package:mobile_app_new/news/ui/search/search_view.dart';
import 'package:mobile_app_new/news/models/author_model.dart';
import 'package:mobile_app_new/news/ui/author_feed/author_feed_view.dart';
import 'package:mobile_app_new/news/ui/tag_feed/tag_feed_view.dart';
import 'package:mobile_app_new/news/ui/news_shell.dart';
import 'package:mobile_app_new/news/ui/image/image_view.dart';

part 'news.g.dart';

const newsBookmarksPath = '/news/bookmarks';
const newsFeedPath = '/news';
const newsSearchPath = '/news/search';
const newsPostPath = '/news/:slug';
const newsImagePath = '/news/image';
const newsTagFeedPath = '/news/tag/:tagSlug';
const newsAuthorPath = '/news/author/:username';
const newsBookmarkPostPath = '/news/bookmarks/:id';

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
    return NewsShell(child: navigator);
  }
}

class NewsBookmarksRoute extends GoRouteData with $NewsBookmarksRoute {
  const NewsBookmarksRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      const NoTransitionPage(child: NewsBookmarkFeedView());
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
      const NoTransitionPage(child: NewsSearchView());
}

@TypedGoRoute<NewsImageRoute>(path: newsImagePath)
class NewsImageRoute extends GoRouteData with $NewsImageRoute {
  const NewsImageRoute({required this.$extra});

  final String $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      NewsImageView(imgUrl: $extra);
}

@TypedGoRoute<NewsTagFeedRoute>(path: newsTagFeedPath)
class NewsTagFeedRoute extends GoRouteData with $NewsTagFeedRoute {
  const NewsTagFeedRoute({required this.tagSlug, this.$extra});

  final String tagSlug;

  // NOTE: Tag display name
  final String? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      NewsTagFeedView(tagSlug: tagSlug, tagName: $extra);
}

@TypedGoRoute<NewsAuthorRoute>(path: newsAuthorPath)
class NewsAuthorRoute extends GoRouteData with $NewsAuthorRoute {
  const NewsAuthorRoute({required this.username, this.$extra});

  final String username;

  // NOTE: Author, when the caller already has it
  final Author? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      NewsAuthorFeedView(username: username, author: $extra);
}

@TypedGoRoute<NewsBookmarkPostRoute>(path: newsBookmarkPostPath)
class NewsBookmarkPostRoute extends GoRouteData with $NewsBookmarkPostRoute {
  const NewsBookmarkPostRoute({required this.id, required this.$extra});

  final String id;

  // NOTE: The bookmarked post passed from feed so we don't have to fetch it again
  final BookmarkedPost $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      NewsBookmarkPostView(post: $extra);
}

@TypedGoRoute<NewsPostRoute>(path: newsPostPath)
class NewsPostRoute extends GoRouteData with $NewsPostRoute {
  const NewsPostRoute({required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      NewsPostView(slug: slug);
}
