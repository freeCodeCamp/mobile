// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i24;
import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart' as _i28;
import 'package:freecodecamp/models/news/bookmarked_article_model.dart' as _i27;
import 'package:freecodecamp/models/podcasts/episodes_model.dart' as _i25;
import 'package:freecodecamp/models/podcasts/podcasts_model.dart' as _i26;
import 'package:freecodecamp/ui/views/code_radio/code_radio_view.dart' as _i18;
import 'package:freecodecamp/ui/views/forum/forum-categories/forum_category_view.dart'
    as _i11;
import 'package:freecodecamp/ui/views/forum/forum-login/forum_login_view.dart'
    as _i14;
import 'package:freecodecamp/ui/views/forum/forum-post-feed/forum_post_feed_view.dart'
    as _i12;
import 'package:freecodecamp/ui/views/forum/forum-post/forum_post_view.dart'
    as _i13;
import 'package:freecodecamp/ui/views/forum/forum-user-profile/forum_user_profile_view.dart'
    as _i17;
import 'package:freecodecamp/ui/views/forum/forum-user/forum_user_view.dart'
    as _i15;
import 'package:freecodecamp/ui/views/home/home_view.dart' as _i2;
import 'package:freecodecamp/ui/views/learn/challenge_editor/challenge_view.dart'
    as _i20;
import 'package:freecodecamp/ui/views/learn/learn-builders/superblock_builder.dart'
    as _i19;
import 'package:freecodecamp/ui/views/learn/learn/learn_view.dart' as _i23;
import 'package:freecodecamp/ui/views/news/news-tutorial/news_tutorial_view.dart'
    as _i6;
import 'package:freecodecamp/ui/views/news/news-author/news_author_view.dart'
    as _i9;
import 'package:freecodecamp/ui/views/news/news-bookmark/news_bookmark_view.dart'
    as _i7;
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_view.dart'
    as _i8;
import 'package:freecodecamp/ui/views/news/news-image-viewer/news_image_viewer.dart'
    as _i10;
import 'package:freecodecamp/ui/views/podcast/episode-view/episode_view.dart'
    as _i5;
import 'package:freecodecamp/ui/views/podcast/podcast-list/podcast_list_view.dart'
    as _i3;
import 'package:freecodecamp/ui/views/profile/profile_view.dart' as _i21;
import 'package:freecodecamp/ui/views/settings/forumSettings/forum_settings_view.dart'
    as _i16;
import 'package:freecodecamp/ui/views/settings/podcastSettings/podcast_settings_view.dart'
    as _i4;
import 'package:freecodecamp/ui/views/web_view/web_view_view.dart' as _i22;
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i29;

class Routes {
  static const homeView = '/';

  static const podcastListView = '/podcast-list-view';

  static const podcastSettingsView = '/podcast-settings-view';

  static const episodeView = '/episode-view';

  static const newsTutorialView = '/news-tutorial-view';

  static const newsBookmarkPostView = '/news-bookmark-post-view';

  static const newsFeedView = '/news-feed-view';

  static const newsAuthorView = '/news-author-view';

  static const newsImageView = '/news-image-view';

  static const forumCategoryView = '/forum-category-view';

  static const forumPostFeedView = '/forum-post-feed-view';

  static const forumPostView = '/forum-post-view';

  static const forumLoginView = '/forum-login-view';

  static const forumUserView = '/forum-user-view';

  static const forumSettingsView = '/forum-settings-view';

  static const forumUserProfileView = '/forum-user-profile-view';

  static const codeRadioView = '/code-radio-view';

  static const superBlockView = '/super-block-view';

  static const challengeView = '/challenge-view';

  static const profileView = '/profile-view';

  static const webViewView = '/web-view-view';

  static const learnView = '/learn-view';

  static const all = <String>{
    homeView,
    podcastListView,
    podcastSettingsView,
    episodeView,
    newsTutorialView,
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
    webViewView,
    learnView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.homeView,
      page: _i2.HomeView,
    ),
    _i1.RouteDef(
      Routes.podcastListView,
      page: _i3.PodcastListView,
    ),
    _i1.RouteDef(
      Routes.podcastSettingsView,
      page: _i4.PodcastSettingsView,
    ),
    _i1.RouteDef(
      Routes.episodeView,
      page: _i5.EpisodeView,
    ),
    _i1.RouteDef(
      Routes.newsTutorialView,
      page: _i6.NewsTutorialView,
    ),
    _i1.RouteDef(
      Routes.newsBookmarkPostView,
      page: _i7.NewsBookmarkPostView,
    ),
    _i1.RouteDef(
      Routes.newsFeedView,
      page: _i8.NewsFeedView,
    ),
    _i1.RouteDef(
      Routes.newsAuthorView,
      page: _i9.NewsAuthorView,
    ),
    _i1.RouteDef(
      Routes.newsImageView,
      page: _i10.NewsImageView,
    ),
    _i1.RouteDef(
      Routes.forumCategoryView,
      page: _i11.ForumCategoryView,
    ),
    _i1.RouteDef(
      Routes.forumPostFeedView,
      page: _i12.ForumPostFeedView,
    ),
    _i1.RouteDef(
      Routes.forumPostView,
      page: _i13.ForumPostView,
    ),
    _i1.RouteDef(
      Routes.forumLoginView,
      page: _i14.ForumLoginView,
    ),
    _i1.RouteDef(
      Routes.forumUserView,
      page: _i15.ForumUserView,
    ),
    _i1.RouteDef(
      Routes.forumSettingsView,
      page: _i16.ForumSettingsView,
    ),
    _i1.RouteDef(
      Routes.forumUserProfileView,
      page: _i17.ForumUserProfileView,
    ),
    _i1.RouteDef(
      Routes.codeRadioView,
      page: _i18.CodeRadioView,
    ),
    _i1.RouteDef(
      Routes.superBlockView,
      page: _i19.SuperBlockView,
    ),
    _i1.RouteDef(
      Routes.challengeView,
      page: _i20.ChallengeView,
    ),
    _i1.RouteDef(
      Routes.profileView,
      page: _i21.ProfileView,
    ),
    _i1.RouteDef(
      Routes.webViewView,
      page: _i22.WebViewView,
    ),
    _i1.RouteDef(
      Routes.learnView,
      page: _i23.LearnView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.HomeView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const _i2.HomeView(),
        settings: data,
      );
    },
    _i3.PodcastListView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const _i3.PodcastListView(),
        settings: data,
      );
    },
    _i4.PodcastSettingsView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const _i4.PodcastSettingsView(),
        settings: data,
      );
    },
    _i5.EpisodeView: (data) {
      final args = data.getArgs<EpisodeViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i5.EpisodeView(
            key: args.key, episode: args.episode, podcast: args.podcast),
        settings: data,
      );
    },
    _i6.NewsTutorialView: (data) {
      final args = data.getArgs<NewsTutorialViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i6.NewsTutorialView(key: args.key, refId: args.refId),
        settings: data,
      );
    },
    _i7.NewsBookmarkPostView: (data) {
      final args = data.getArgs<NewsBookmarkPostViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i7.NewsBookmarkPostView(key: args.key, tutorial: args.tutorial),
        settings: data,
      );
    },
    _i8.NewsFeedView: (data) {
      final args = data.getArgs<NewsFeedViewArguments>(
        orElse: () => const NewsFeedViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i8.NewsFeedView(
            key: args.key,
            slug: args.slug,
            author: args.author,
            fromAuthor: args.fromAuthor,
            fromTag: args.fromTag,
            fromSearch: args.fromSearch,
            articles: args.articles,
            subject: args.subject),
        settings: data,
      );
    },
    _i9.NewsAuthorView: (data) {
      final args = data.getArgs<NewsAuthorViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i9.NewsAuthorView(key: args.key, authorSlug: args.authorSlug),
        settings: data,
      );
    },
    _i10.NewsImageView: (data) {
      final args = data.getArgs<NewsImageViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i10.NewsImageView(key: args.key, imgUrl: args.imgUrl),
        settings: data,
      );
    },
    _i11.ForumCategoryView: (data) {
      final args = data.getArgs<ForumCategoryViewArguments>(
        orElse: () => const ForumCategoryViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i11.ForumCategoryView(key: args.key),
        settings: data,
      );
    },
    _i12.ForumPostFeedView: (data) {
      final args = data.getArgs<ForumPostFeedViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i12.ForumPostFeedView(
            key: args.key, slug: args.slug, id: args.id, name: args.name),
        settings: data,
      );
    },
    _i13.ForumPostView: (data) {
      final args = data.getArgs<ForumPostViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i13.ForumPostView(key: args.key, id: args.id, slug: args.slug),
        settings: data,
      );
    },
    _i14.ForumLoginView: (data) {
      final args = data.getArgs<ForumLoginViewArguments>(
        orElse: () => const ForumLoginViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i14.ForumLoginView(
            key: args.key, fromCreatePost: args.fromCreatePost),
        settings: data,
      );
    },
    _i15.ForumUserView: (data) {
      final args = data.getArgs<ForumUserViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i15.ForumUserView(key: args.key, username: args.username),
        settings: data,
      );
    },
    _i16.ForumSettingsView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const _i16.ForumSettingsView(),
        settings: data,
      );
    },
    _i17.ForumUserProfileView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const _i17.ForumUserProfileView(),
        settings: data,
      );
    },
    _i18.CodeRadioView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const _i18.CodeRadioView(),
        settings: data,
      );
    },
    _i19.SuperBlockView: (data) {
      final args = data.getArgs<SuperBlockViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i19.SuperBlockView(
            key: args.key,
            superBlockDashedName: args.superBlockDashedName,
            superblockName: args.superblockName),
        settings: data,
      );
    },
    _i20.ChallengeView: (data) {
      final args = data.getArgs<ChallengeViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i20.ChallengeView(
            key: args.key,
            url: args.url,
            block: args.block,
            challengesCompleted: args.challengesCompleted),
        settings: data,
      );
    },
    _i21.ProfileView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const _i21.ProfileView(),
        settings: data,
      );
    },
    _i22.WebViewView: (data) {
      final args = data.getArgs<WebViewViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i22.WebViewView(key: args.key, url: args.url),
        settings: data,
      );
    },
    _i23.LearnView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const _i23.LearnView(),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;
  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class EpisodeViewArguments {
  const EpisodeViewArguments({
    this.key,
    required this.episode,
    required this.podcast,
  });

  final _i24.Key? key;

  final _i25.Episodes episode;

  final _i26.Podcasts podcast;
}

class NewsTutorialViewArguments {
  const NewsTutorialViewArguments({
    this.key,
    required this.refId,
  });

  final _i24.Key? key;

  final String refId;
}

class NewsBookmarkPostViewArguments {
  const NewsBookmarkPostViewArguments({
    this.key,
    required this.tutorial,
  });

  final _i24.Key? key;

  final _i27.BookmarkedTutorial tutorial;
}

class NewsFeedViewArguments {
  const NewsFeedViewArguments({
    this.key,
    this.slug = '',
    this.author = '',
    this.fromAuthor = false,
    this.fromTag = false,
    this.fromSearch = false,
    this.articles = const [],
    this.subject = '',
  });

  final _i24.Key? key;

  final String slug;

  final String author;

  final bool fromAuthor;

  final bool fromTag;

  final bool fromSearch;

  final List<dynamic> articles;

  final String subject;
}

class NewsAuthorViewArguments {
  const NewsAuthorViewArguments({
    this.key,
    required this.authorSlug,
  });

  final _i24.Key? key;

  final String authorSlug;
}

class NewsImageViewArguments {
  const NewsImageViewArguments({
    this.key,
    required this.imgUrl,
  });

  final _i24.Key? key;

  final String imgUrl;
}

class ForumCategoryViewArguments {
  const ForumCategoryViewArguments({this.key});

  final _i24.Key? key;
}

class ForumPostFeedViewArguments {
  const ForumPostFeedViewArguments({
    this.key,
    required this.slug,
    required this.id,
    required this.name,
  });

  final _i24.Key? key;

  final String slug;

  final String id;

  final String name;
}

class ForumPostViewArguments {
  const ForumPostViewArguments({
    this.key,
    required this.id,
    required this.slug,
  });

  final _i24.Key? key;

  final String id;

  final String slug;
}

class ForumLoginViewArguments {
  const ForumLoginViewArguments({
    this.key,
    this.fromCreatePost = false,
  });

  final _i24.Key? key;

  final bool fromCreatePost;
}

class ForumUserViewArguments {
  const ForumUserViewArguments({
    this.key,
    required this.username,
  });

  final _i24.Key? key;

  final String username;
}

class SuperBlockViewArguments {
  const SuperBlockViewArguments({
    this.key,
    required this.superBlockDashedName,
    required this.superblockName,
  });

  final _i24.Key? key;

  final String superBlockDashedName;

  final String superblockName;
}

class ChallengeViewArguments {
  const ChallengeViewArguments({
    this.key,
    required this.url,
    required this.block,
    required this.challengesCompleted,
  });

  final _i24.Key? key;

  final String url;

  final _i28.Block block;

  final int challengesCompleted;
}

class WebViewViewArguments {
  const WebViewViewArguments({
    this.key,
    required this.url,
  });

  final _i24.Key? key;

  final String url;
}

extension NavigatorStateExtension on _i29.NavigationService {
  Future<dynamic> navigateToHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToPodcastListView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.podcastListView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToPodcastSettingsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.podcastSettingsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToEpisodeView({
    _i24.Key? key,
    required _i25.Episodes episode,
    required _i26.Podcasts podcast,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.episodeView,
        arguments:
            EpisodeViewArguments(key: key, episode: episode, podcast: podcast),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNewsTutorialView({
    _i24.Key? key,
    required String refId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.newsTutorialView,
        arguments: NewsTutorialViewArguments(key: key, refId: refId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNewsBookmarkPostView({
    _i24.Key? key,
    required _i27.BookmarkedTutorial tutorial,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.newsBookmarkPostView,
        arguments: NewsBookmarkPostViewArguments(key: key, tutorial: tutorial),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNewsFeedView({
    _i24.Key? key,
    String slug = '',
    String author = '',
    bool fromAuthor = false,
    bool fromTag = false,
    bool fromSearch = false,
    List<dynamic> articles = const [],
    String subject = '',
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.newsFeedView,
        arguments: NewsFeedViewArguments(
            key: key,
            slug: slug,
            author: author,
            fromAuthor: fromAuthor,
            fromTag: fromTag,
            fromSearch: fromSearch,
            articles: articles,
            subject: subject),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNewsAuthorView({
    _i24.Key? key,
    required String authorSlug,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.newsAuthorView,
        arguments: NewsAuthorViewArguments(key: key, authorSlug: authorSlug),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNewsImageView({
    _i24.Key? key,
    required String imgUrl,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.newsImageView,
        arguments: NewsImageViewArguments(key: key, imgUrl: imgUrl),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToForumCategoryView({
    _i24.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.forumCategoryView,
        arguments: ForumCategoryViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToForumPostFeedView({
    _i24.Key? key,
    required String slug,
    required String id,
    required String name,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.forumPostFeedView,
        arguments: ForumPostFeedViewArguments(
            key: key, slug: slug, id: id, name: name),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToForumPostView({
    _i24.Key? key,
    required String id,
    required String slug,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.forumPostView,
        arguments: ForumPostViewArguments(key: key, id: id, slug: slug),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToForumLoginView({
    _i24.Key? key,
    bool fromCreatePost = false,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.forumLoginView,
        arguments:
            ForumLoginViewArguments(key: key, fromCreatePost: fromCreatePost),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToForumUserView({
    _i24.Key? key,
    required String username,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.forumUserView,
        arguments: ForumUserViewArguments(key: key, username: username),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToForumSettingsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.forumSettingsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToForumUserProfileView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.forumUserProfileView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCodeRadioView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.codeRadioView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSuperBlockView({
    _i24.Key? key,
    required String superBlockDashedName,
    required String superblockName,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.superBlockView,
        arguments: SuperBlockViewArguments(
            key: key,
            superBlockDashedName: superBlockDashedName,
            superblockName: superblockName),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToChallengeView({
    _i24.Key? key,
    required String url,
    required _i28.Block block,
    required int challengesCompleted,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.challengeView,
        arguments: ChallengeViewArguments(
            key: key,
            url: url,
            block: block,
            challengesCompleted: challengesCompleted),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToProfileView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.profileView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToWebViewView({
    _i24.Key? key,
    required String url,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.webViewView,
        arguments: WebViewViewArguments(key: key, url: url),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToLearnView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.learnView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
