// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../ui/views/browser/browser_view.dart';
import '../ui/views/home/home_view.dart';
import '../ui/views/news/news-article-post/news_article_post_view.dart';
import '../ui/views/startup/startup_view.dart';
import '../ui/views/website/website_view.dart';

class Routes {
  static const String startupView = '/';
  static const String websiteView = '/website-view';
  static const String homeView = '/home-view';
  static const String browserView = '/browser-view';
  static const String newsArticlePostView = '/news-article-post-view';
  static const all = <String>{
    startupView,
    websiteView,
    homeView,
    browserView,
    newsArticlePostView,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.startupView, page: StartupView),
    RouteDef(Routes.websiteView, page: WebsiteView),
    RouteDef(Routes.homeView, page: HomeView),
    RouteDef(Routes.browserView, page: BrowserView),
    RouteDef(Routes.newsArticlePostView, page: NewsArticlePostView),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    StartupView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const StartupView(),
        settings: data,
      );
    },
    WebsiteView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const WebsiteView(),
        settings: data,
      );
    },
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
