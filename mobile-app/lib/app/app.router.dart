// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../models/bookmarked_article_model.dart';
import '../ui/views/browser/browser_view.dart';
import '../ui/views/forum/forum-categories/forum_category_view.dart';
import '../ui/views/forum/forum-login/forum_login_view.dart';
import '../ui/views/forum/forum-post-feed/forum_post_feed_view.dart';
import '../ui/views/forum/forum-post/forum_post_view.dart';
import '../ui/views/forum/forum-user-profile/forum_user_profile_view.dart';
import '../ui/views/forum/forum-user/forum_user_view.dart';
import '../ui/views/home/home_view.dart';
import '../ui/views/news/news-article-post/news_article_post_view.dart';
import '../ui/views/news/news-bookmark/news_bookmark_view.dart';
import '../ui/views/news/news-feed/news_feed_view.dart';
import '../ui/views/podcast/podcast-list/podcast_list_view.dart';
import '../ui/views/settings/forumSettings/forum_settings_view.dart';
import '../ui/views/settings/podcastSettings/podcast_settings_view.dart';

class Routes {
  static const String homeView = '/';
  static const String browserView = '/browser-view';
  static const String podcastListView = '/podcast-list-view';
  static const String podcastSettingsView = '/podcast-settings-view';
  static const String newsArticlePostView = '/news-article-post-view';
  static const String newsBookmarkPostView = '/news-bookmark-post-view';
  static const String newsFeedView = '/news-feed-view';
  static const String forumCategoryView = '/forum-category-view';
  static const String forumPostFeedView = '/forum-post-feed-view';
  static const String forumPostView = '/forum-post-view';
  static const String forumLoginView = '/forum-login-view';
  static const String forumUserView = '/forum-user-view';
  static const String forumSettingsView = '/forum-settings-view';
  static const String forumUserProfileView = '/forum-user-profile-view';
  static const all = <String>{
    homeView,
    browserView,
    podcastListView,
    podcastSettingsView,
    newsArticlePostView,
    newsBookmarkPostView,
    newsFeedView,
    forumCategoryView,
    forumPostFeedView,
    forumPostView,
    forumLoginView,
    forumUserView,
    forumSettingsView,
    forumUserProfileView,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.homeView, page: HomeView),
    RouteDef(Routes.browserView, page: BrowserView),
    RouteDef(Routes.podcastListView, page: PodcastListView),
    RouteDef(Routes.podcastSettingsView, page: PodcastSettingsView),
    RouteDef(Routes.newsArticlePostView, page: NewsArticlePostView),
    RouteDef(Routes.newsBookmarkPostView, page: NewsBookmarkPostView),
    RouteDef(Routes.newsFeedView, page: NewsFeedView),
    RouteDef(Routes.forumCategoryView, page: ForumCategoryView),
    RouteDef(Routes.forumPostFeedView, page: ForumPostFeedView),
    RouteDef(Routes.forumPostView, page: ForumPostView),
    RouteDef(Routes.forumLoginView, page: ForumLoginView),
    RouteDef(Routes.forumUserView, page: ForumUserView),
    RouteDef(Routes.forumSettingsView, page: ForumSettingsView),
    RouteDef(Routes.forumUserProfileView, page: ForumUserProfileView),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    HomeView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const HomeView(),
        settings: data,
      );
    },
    BrowserView: (data) {
      var args = data.getArgs<BrowserViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => BrowserView(
          key: args.key,
          url: args.url,
        ),
        settings: data,
      );
    },
    PodcastListView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const PodcastListView(),
        settings: data,
      );
    },
    PodcastSettingsView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const PodcastSettingsView(),
        settings: data,
      );
    },
    NewsArticlePostView: (data) {
      var args = data.getArgs<NewsArticlePostViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => NewsArticlePostView(
          key: args.key,
          refId: args.refId,
        ),
        settings: data,
      );
    },
    NewsBookmarkPostView: (data) {
      var args = data.getArgs<NewsBookmarkPostViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => NewsBookmarkPostView(
          key: args.key,
          article: args.article,
        ),
        settings: data,
      );
    },
    NewsFeedView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const NewsFeedView(),
        settings: data,
      );
    },
    ForumCategoryView: (data) {
      var args = data.getArgs<ForumCategoryViewArguments>(
        orElse: () => ForumCategoryViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => ForumCategoryView(key: args.key),
        settings: data,
      );
    },
    ForumPostFeedView: (data) {
      var args = data.getArgs<ForumPostFeedViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => ForumPostFeedView(
          key: args.key,
          slug: args.slug,
          id: args.id,
          name: args.name,
        ),
        settings: data,
      );
    },
    ForumPostView: (data) {
      var args = data.getArgs<ForumPostViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => ForumPostView(
          key: args.key,
          id: args.id,
          slug: args.slug,
        ),
        settings: data,
      );
    },
    ForumLoginView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const ForumLoginView(),
        settings: data,
      );
    },
    ForumUserView: (data) {
      var args = data.getArgs<ForumUserViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => ForumUserView(
          key: args.key,
          username: args.username,
        ),
        settings: data,
      );
    },
    ForumSettingsView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const ForumSettingsView(),
        settings: data,
      );
    },
    ForumUserProfileView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const ForumUserProfileView(),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// BrowserView arguments holder class
class BrowserViewArguments {
  final Key? key;
  final String url;
  BrowserViewArguments({this.key, required this.url});
}

/// NewsArticlePostView arguments holder class
class NewsArticlePostViewArguments {
  final Key? key;
  final String refId;
  NewsArticlePostViewArguments({this.key, required this.refId});
}

/// NewsBookmarkPostView arguments holder class
class NewsBookmarkPostViewArguments {
  final Key? key;
  final BookmarkedArticle article;
  NewsBookmarkPostViewArguments({this.key, required this.article});
}

/// ForumCategoryView arguments holder class
class ForumCategoryViewArguments {
  final Key? key;
  ForumCategoryViewArguments({this.key});
}

/// ForumPostFeedView arguments holder class
class ForumPostFeedViewArguments {
  final Key? key;
  final String slug;
  final String id;
  final String name;
  ForumPostFeedViewArguments(
      {this.key, required this.slug, required this.id, required this.name});
}

/// ForumPostView arguments holder class
class ForumPostViewArguments {
  final Key? key;
  final String id;
  final String slug;
  ForumPostViewArguments({this.key, required this.id, required this.slug});
}

/// ForumUserView arguments holder class
class ForumUserViewArguments {
  final Key? key;
  final String username;
  ForumUserViewArguments({this.key, required this.username});
}
