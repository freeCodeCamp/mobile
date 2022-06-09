// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, unused_import, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../models/news/bookmarked_article_model.dart';
import '../ui/views/code_radio/code_radio_view.dart';
import '../ui/views/forum/forum-categories/forum_category_view.dart';
import '../ui/views/forum/forum-login/forum_login_view.dart';
import '../ui/views/forum/forum-post-feed/forum_post_feed_view.dart';
import '../ui/views/forum/forum-post/forum_post_view.dart';
import '../ui/views/forum/forum-user-profile/forum_user_profile_view.dart';
import '../ui/views/forum/forum-user/forum_user_view.dart';
import '../ui/views/home/home_view.dart';
import '../ui/views/learn/challenge_editor/challenge_view.dart';
import '../ui/views/learn/learn-builders/superblock_builder.dart';
import '../ui/views/news/news-article/news_article_view.dart';
import '../ui/views/news/news-author/news_author_view.dart';
import '../ui/views/news/news-bookmark/news_bookmark_view.dart';
import '../ui/views/news/news-feed/news_feed_view.dart';
import '../ui/views/news/news-image-viewer/news_image_viewer.dart';
import '../ui/views/podcast/podcast-list/podcast_list_view.dart';
import '../ui/views/profile/profile_view.dart';
import '../ui/views/settings/forumSettings/forum_settings_view.dart';
import '../ui/views/settings/podcastSettings/podcast_settings_view.dart';

class Routes {
  static const String homeView = '/';
  static const String podcastListView = '/podcast-list-view';
  static const String podcastSettingsView = '/podcast-settings-view';
  static const String newsArticleView = '/news-article-view';
  static const String newsBookmarkPostView = '/news-bookmark-post-view';
  static const String newsFeedView = '/news-feed-view';
  static const String newsAuthorView = '/news-author-view';
  static const String newsImageView = '/news-image-view';
  static const String forumCategoryView = '/forum-category-view';
  static const String forumPostFeedView = '/forum-post-feed-view';
  static const String forumPostView = '/forum-post-view';
  static const String forumLoginView = '/forum-login-view';
  static const String forumUserView = '/forum-user-view';
  static const String forumSettingsView = '/forum-settings-view';
  static const String forumUserProfileView = '/forum-user-profile-view';
  static const String codeRadioView = '/code-radio-view';
  static const String superBlockView = '/super-block-view';
  static const String challengeView = '/challenge-view';
  static const String profileView = '/profile-view';
  static const all = <String>{
    homeView,
    podcastListView,
    podcastSettingsView,
    newsArticleView,
    newsBookmarkPostView,
    newsFeedView,
    newsAuthorView,
    newsImageView,
    forumCategoryView,
    forumPostFeedView,
    forumPostView,
    forumLoginView,
    forumUserView,
    forumSettingsView,
    forumUserProfileView,
    codeRadioView,
    superBlockView,
    challengeView,
    profileView,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.homeView, page: HomeView),
    RouteDef(Routes.podcastListView, page: PodcastListView),
    RouteDef(Routes.podcastSettingsView, page: PodcastSettingsView),
    RouteDef(Routes.newsArticleView, page: NewsArticleView),
    RouteDef(Routes.newsBookmarkPostView, page: NewsBookmarkPostView),
    RouteDef(Routes.newsFeedView, page: NewsFeedView),
    RouteDef(Routes.newsAuthorView, page: NewsAuthorView),
    RouteDef(Routes.newsImageView, page: NewsImageView),
    RouteDef(Routes.forumCategoryView, page: ForumCategoryView),
    RouteDef(Routes.forumPostFeedView, page: ForumPostFeedView),
    RouteDef(Routes.forumPostView, page: ForumPostView),
    RouteDef(Routes.forumLoginView, page: ForumLoginView),
    RouteDef(Routes.forumUserView, page: ForumUserView),
    RouteDef(Routes.forumSettingsView, page: ForumSettingsView),
    RouteDef(Routes.forumUserProfileView, page: ForumUserProfileView),
    RouteDef(Routes.codeRadioView, page: CodeRadioView),
    RouteDef(Routes.superBlockView, page: SuperBlockView),
    RouteDef(Routes.challengeView, page: ChallengeView),
    RouteDef(Routes.profileView, page: ProfileView),
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
    NewsArticleView: (data) {
      var args = data.getArgs<NewsArticleViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => NewsArticleView(
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
      var args = data.getArgs<NewsFeedViewArguments>(
        orElse: () => NewsFeedViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => NewsFeedView(
          key: args.key,
          slug: args.slug,
          author: args.author,
          fromAuthor: args.fromAuthor,
          fromTag: args.fromTag,
          subject: args.subject,
        ),
        settings: data,
      );
    },
    NewsAuthorView: (data) {
      var args = data.getArgs<NewsAuthorViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => NewsAuthorView(
          key: args.key,
          authorSlug: args.authorSlug,
        ),
        settings: data,
      );
    },
    NewsImageView: (data) {
      var args = data.getArgs<NewsImageViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => NewsImageView(
          key: args.key,
          imgUrl: args.imgUrl,
        ),
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
      var args = data.getArgs<ForumLoginViewArguments>(
        orElse: () => ForumLoginViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => ForumLoginView(
          key: args.key,
          fromCreatePost: args.fromCreatePost,
        ),
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
    CodeRadioView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const CodeRadioView(),
        settings: data,
      );
    },
    SuperBlockView: (data) {
      var args = data.getArgs<SuperBlockViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => SuperBlockView(
          key: args.key,
          superBlockName: args.superBlockName,
        ),
        settings: data,
      );
    },
    ChallengeView: (data) {
      var args = data.getArgs<ChallengeViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => ChallengeView(
          key: args.key,
          url: args.url,
        ),
        settings: data,
      );
    },
    ProfileView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const ProfileView(),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// NewsArticleView arguments holder class
class NewsArticleViewArguments {
  final Key? key;
  final String refId;
  NewsArticleViewArguments({this.key, required this.refId});
}

/// NewsBookmarkPostView arguments holder class
class NewsBookmarkPostViewArguments {
  final Key? key;
  final BookmarkedArticle article;
  NewsBookmarkPostViewArguments({this.key, required this.article});
}

/// NewsFeedView arguments holder class
class NewsFeedViewArguments {
  final Key? key;
  final String slug;
  final String author;
  final bool fromAuthor;
  final bool fromTag;
  final String subject;
  NewsFeedViewArguments(
      {this.key,
      this.slug = '',
      this.author = '',
      this.fromAuthor = false,
      this.fromTag = false,
      this.subject = ''});
}

/// NewsAuthorView arguments holder class
class NewsAuthorViewArguments {
  final Key? key;
  final String authorSlug;
  NewsAuthorViewArguments({this.key, required this.authorSlug});
}

/// NewsImageView arguments holder class
class NewsImageViewArguments {
  final Key? key;
  final String imgUrl;
  NewsImageViewArguments({this.key, required this.imgUrl});
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

/// ForumLoginView arguments holder class
class ForumLoginViewArguments {
  final Key? key;
  final bool fromCreatePost;
  ForumLoginViewArguments({this.key, this.fromCreatePost = false});
}

/// ForumUserView arguments holder class
class ForumUserViewArguments {
  final Key? key;
  final String username;
  ForumUserViewArguments({this.key, required this.username});
}

/// SuperBlockView arguments holder class
class SuperBlockViewArguments {
  final Key? key;
  final String superBlockName;
  SuperBlockViewArguments({this.key, required this.superBlockName});
}

/// ChallengeView arguments holder class
class ChallengeViewArguments {
  final Key? key;
  final String url;
  ChallengeViewArguments({this.key, required this.url});
}

/// ************************************************************************
/// Extension for strongly typed navigation
/// *************************************************************************

extension NavigatorStateExtension on NavigationService {
  Future<dynamic> navigateToHomeView({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.homeView,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToPodcastListView({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.podcastListView,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToPodcastSettingsView({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.podcastSettingsView,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToNewsArticleView({
    Key? key,
    required String refId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.newsArticleView,
      arguments: NewsArticleViewArguments(key: key, refId: refId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToNewsBookmarkPostView({
    Key? key,
    required BookmarkedArticle article,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.newsBookmarkPostView,
      arguments: NewsBookmarkPostViewArguments(key: key, article: article),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToNewsFeedView({
    Key? key,
    String slug = '',
    String author = '',
    bool fromAuthor = false,
    bool fromTag = false,
    String subject = '',
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.newsFeedView,
      arguments: NewsFeedViewArguments(
          key: key,
          slug: slug,
          author: author,
          fromAuthor: fromAuthor,
          fromTag: fromTag,
          subject: subject),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToNewsAuthorView({
    Key? key,
    required String authorSlug,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.newsAuthorView,
      arguments: NewsAuthorViewArguments(key: key, authorSlug: authorSlug),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToNewsImageView({
    Key? key,
    required String imgUrl,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.newsImageView,
      arguments: NewsImageViewArguments(key: key, imgUrl: imgUrl),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToForumCategoryView({
    Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.forumCategoryView,
      arguments: ForumCategoryViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToForumPostFeedView({
    Key? key,
    required String slug,
    required String id,
    required String name,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.forumPostFeedView,
      arguments:
          ForumPostFeedViewArguments(key: key, slug: slug, id: id, name: name),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToForumPostView({
    Key? key,
    required String id,
    required String slug,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.forumPostView,
      arguments: ForumPostViewArguments(key: key, id: id, slug: slug),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToForumLoginView({
    Key? key,
    bool fromCreatePost = false,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.forumLoginView,
      arguments:
          ForumLoginViewArguments(key: key, fromCreatePost: fromCreatePost),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToForumUserView({
    Key? key,
    required String username,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.forumUserView,
      arguments: ForumUserViewArguments(key: key, username: username),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToForumSettingsView({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.forumSettingsView,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToForumUserProfileView({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.forumUserProfileView,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToCodeRadioView({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.codeRadioView,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToSuperBlockView({
    Key? key,
    required String superBlockName,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.superBlockView,
      arguments:
          SuperBlockViewArguments(key: key, superBlockName: superBlockName),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToChallengeView({
    Key? key,
    required String url,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.challengeView,
      arguments: ChallengeViewArguments(key: key, url: url),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToProfileView({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.profileView,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }
}
