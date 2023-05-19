// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i17;
import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart' as _i21;
import 'package:freecodecamp/models/news/bookmarked_tutorial_model.dart'
    as _i20;
import 'package:freecodecamp/models/podcasts/episodes_model.dart' as _i18;
import 'package:freecodecamp/models/podcasts/podcasts_model.dart' as _i19;
import 'package:freecodecamp/ui/views/code_radio/code_radio_view.dart' as _i10;
import 'package:freecodecamp/ui/views/home/home_view.dart' as _i2;
import 'package:freecodecamp/ui/views/learn/challenge/challenge_view.dart'
    as _i11;
import 'package:freecodecamp/ui/views/learn/landing/landing_view.dart' as _i13;
import 'package:freecodecamp/ui/views/learn/superblock/superblock_view.dart'
    as _i15;
import 'package:freecodecamp/ui/views/login/native_login_view.dart' as _i14;
import 'package:freecodecamp/ui/views/news/news-author/news_author_view.dart'
    as _i8;
import 'package:freecodecamp/ui/views/news/news-bookmark/news_bookmark_view.dart'
    as _i6;
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_view.dart'
    as _i7;
import 'package:freecodecamp/ui/views/news/news-image-viewer/news_image_view.dart'
    as _i9;
import 'package:freecodecamp/ui/views/news/news-tutorial/news_tutorial_view.dart'
    as _i5;
import 'package:freecodecamp/ui/views/podcast/episode/episode_view.dart' as _i4;
import 'package:freecodecamp/ui/views/podcast/podcast-list/podcast_list_view.dart'
    as _i3;
import 'package:freecodecamp/ui/views/profile/profile_view.dart' as _i12;
import 'package:freecodecamp/ui/views/settings/settings_view.dart' as _i16;
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i22;

class Routes {
  static const homeView = '/';

  static const podcastListView = '/podcast-list-view';

  static const episodeView = '/episode-view';

  static const newsTutorialView = '/news-tutorial-view';

  static const newsBookmarkTutorialView = '/news-bookmark-tutorial-view';

  static const newsFeedView = '/news-feed-view';

  static const newsAuthorView = '/news-author-view';

  static const newsImageView = '/news-image-view';

  static const codeRadioView = '/code-radio-view';

  static const challengeView = '/challenge-view';

  static const profileView = '/profile-view';

  static const learnLandingView = '/learn-landing-view';

  static const nativeLoginView = '/native-login-view';

  static const superBlockView = '/super-block-view';

  static const settingsView = '/settings-view';

  static const all = <String>{
    homeView,
    podcastListView,
    episodeView,
    newsTutorialView,
    newsBookmarkTutorialView,
    newsFeedView,
    newsAuthorView,
    newsImageView,
    codeRadioView,
    challengeView,
    profileView,
    learnLandingView,
    nativeLoginView,
    superBlockView,
    settingsView,
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
      Routes.episodeView,
      page: _i4.EpisodeView,
    ),
    _i1.RouteDef(
      Routes.newsTutorialView,
      page: _i5.NewsTutorialView,
    ),
    _i1.RouteDef(
      Routes.newsBookmarkTutorialView,
      page: _i6.NewsBookmarkTutorialView,
    ),
    _i1.RouteDef(
      Routes.newsFeedView,
      page: _i7.NewsFeedView,
    ),
    _i1.RouteDef(
      Routes.newsAuthorView,
      page: _i8.NewsAuthorView,
    ),
    _i1.RouteDef(
      Routes.newsImageView,
      page: _i9.NewsImageView,
    ),
    _i1.RouteDef(
      Routes.codeRadioView,
      page: _i10.CodeRadioView,
    ),
    _i1.RouteDef(
      Routes.challengeView,
      page: _i11.ChallengeView,
    ),
    _i1.RouteDef(
      Routes.profileView,
      page: _i12.ProfileView,
    ),
    _i1.RouteDef(
      Routes.learnLandingView,
      page: _i13.LearnLandingView,
    ),
    _i1.RouteDef(
      Routes.nativeLoginView,
      page: _i14.NativeLoginView,
    ),
    _i1.RouteDef(
      Routes.superBlockView,
      page: _i15.SuperBlockView,
    ),
    _i1.RouteDef(
      Routes.settingsView,
      page: _i16.SettingsView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.HomeView: (data) {
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => const _i2.HomeView(),
        settings: data,
      );
    },
    _i3.PodcastListView: (data) {
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => const _i3.PodcastListView(),
        settings: data,
      );
    },
    _i4.EpisodeView: (data) {
      final args = data.getArgs<EpisodeViewArguments>(nullOk: false);
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => _i4.EpisodeView(
            key: args.key, episode: args.episode, podcast: args.podcast),
        settings: data,
      );
    },
    _i5.NewsTutorialView: (data) {
      final args = data.getArgs<NewsTutorialViewArguments>(nullOk: false);
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => _i5.NewsTutorialView(
            key: args.key, refId: args.refId, title: args.title),
        settings: data,
      );
    },
    _i6.NewsBookmarkTutorialView: (data) {
      final args =
          data.getArgs<NewsBookmarkTutorialViewArguments>(nullOk: false);
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => _i6.NewsBookmarkTutorialView(
            key: args.key, tutorial: args.tutorial),
        settings: data,
      );
    },
    _i7.NewsFeedView: (data) {
      final args = data.getArgs<NewsFeedViewArguments>(
        orElse: () => const NewsFeedViewArguments(),
      );
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => _i7.NewsFeedView(
            key: args.key,
            slug: args.slug,
            author: args.author,
            fromAuthor: args.fromAuthor,
            fromTag: args.fromTag,
            fromSearch: args.fromSearch,
            tutorials: args.tutorials,
            subject: args.subject),
        settings: data,
      );
    },
    _i8.NewsAuthorView: (data) {
      final args = data.getArgs<NewsAuthorViewArguments>(nullOk: false);
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i8.NewsAuthorView(key: args.key, authorSlug: args.authorSlug),
        settings: data,
      );
    },
    _i9.NewsImageView: (data) {
      final args = data.getArgs<NewsImageViewArguments>(nullOk: false);
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i9.NewsImageView(key: args.key, imgUrl: args.imgUrl),
        settings: data,
      );
    },
    _i10.CodeRadioView: (data) {
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => const _i10.CodeRadioView(),
        settings: data,
      );
    },
    _i11.ChallengeView: (data) {
      final args = data.getArgs<ChallengeViewArguments>(nullOk: false);
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => _i11.ChallengeView(
            key: args.key,
            url: args.url,
            block: args.block,
            challengeId: args.challengeId,
            challengesCompleted: args.challengesCompleted,
            isProject: args.isProject),
        settings: data,
      );
    },
    _i12.ProfileView: (data) {
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => const _i12.ProfileView(),
        settings: data,
      );
    },
    _i13.LearnLandingView: (data) {
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => const _i13.LearnLandingView(),
        settings: data,
      );
    },
    _i14.NativeLoginView: (data) {
      final args = data.getArgs<NativeLoginViewArguments>(
        orElse: () => const NativeLoginViewArguments(),
      );
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i14.NativeLoginView(key: args.key, fromButton: args.fromButton),
        settings: data,
      );
    },
    _i15.SuperBlockView: (data) {
      final args = data.getArgs<SuperBlockViewArguments>(nullOk: false);
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => _i15.SuperBlockView(
            key: args.key,
            superBlockDashedName: args.superBlockDashedName,
            superBlockName: args.superBlockName,
            hasInternet: args.hasInternet),
        settings: data,
      );
    },
    _i16.SettingsView: (data) {
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => const _i16.SettingsView(),
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

  final _i17.Key? key;

  final _i18.Episodes episode;

  final _i19.Podcasts podcast;

  @override
  String toString() {
    return '{"key": "$key", "episode": "$episode", "podcast": "$podcast"}';
  }
}

class NewsTutorialViewArguments {
  const NewsTutorialViewArguments({
    this.key,
    required this.refId,
    required this.title,
  });

  final _i17.Key? key;

  final String refId;

  final String? title;

  @override
  String toString() {
    return '{"key": "$key", "refId": "$refId", "title": "$title"}';
  }
}

class NewsBookmarkTutorialViewArguments {
  const NewsBookmarkTutorialViewArguments({
    this.key,
    required this.tutorial,
  });

  final _i17.Key? key;

  final _i20.BookmarkedTutorial tutorial;

  @override
  String toString() {
    return '{"key": "$key", "tutorial": "$tutorial"}';
  }
}

class NewsFeedViewArguments {
  const NewsFeedViewArguments({
    this.key,
    this.slug = '',
    this.author = '',
    this.fromAuthor = false,
    this.fromTag = false,
    this.fromSearch = false,
    this.tutorials = const [],
    this.subject = '',
  });

  final _i17.Key? key;

  final String slug;

  final String author;

  final bool fromAuthor;

  final bool fromTag;

  final bool fromSearch;

  final List<dynamic> tutorials;

  final String subject;

  @override
  String toString() {
    return '{"key": "$key", "slug": "$slug", "author": "$author", "fromAuthor": "$fromAuthor", "fromTag": "$fromTag", "fromSearch": "$fromSearch", "tutorials": "$tutorials", "subject": "$subject"}';
  }
}

class NewsAuthorViewArguments {
  const NewsAuthorViewArguments({
    this.key,
    required this.authorSlug,
  });

  final _i17.Key? key;

  final String authorSlug;

  @override
  String toString() {
    return '{"key": "$key", "authorSlug": "$authorSlug"}';
  }
}

class NewsImageViewArguments {
  const NewsImageViewArguments({
    this.key,
    required this.imgUrl,
  });

  final _i17.Key? key;

  final String imgUrl;

  @override
  String toString() {
    return '{"key": "$key", "imgUrl": "$imgUrl"}';
  }
}

class ChallengeViewArguments {
  const ChallengeViewArguments({
    this.key,
    required this.url,
    required this.block,
    required this.challengeId,
    required this.challengesCompleted,
    required this.isProject,
  });

  final _i17.Key? key;

  final String url;

  final _i21.Block block;

  final String challengeId;

  final int challengesCompleted;

  final bool isProject;

  @override
  String toString() {
    return '{"key": "$key", "url": "$url", "block": "$block", "challengeId": "$challengeId", "challengesCompleted": "$challengesCompleted", "isProject": "$isProject"}';
  }
}

class NativeLoginViewArguments {
  const NativeLoginViewArguments({
    this.key,
    this.fromButton = false,
  });

  final _i17.Key? key;

  final bool fromButton;

  @override
  String toString() {
    return '{"key": "$key", "fromButton": "$fromButton"}';
  }
}

class SuperBlockViewArguments {
  const SuperBlockViewArguments({
    this.key,
    required this.superBlockDashedName,
    required this.superBlockName,
    required this.hasInternet,
  });

  final _i17.Key? key;

  final String superBlockDashedName;

  final String superBlockName;

  final bool hasInternet;

  @override
  String toString() {
    return '{"key": "$key", "superBlockDashedName": "$superBlockDashedName", "superBlockName": "$superBlockName", "hasInternet": "$hasInternet"}';
  }
}

extension NavigatorStateExtension on _i22.NavigationService {
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

  Future<dynamic> navigateToEpisodeView({
    _i17.Key? key,
    required _i18.Episodes episode,
    required _i19.Podcasts podcast,
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
    _i17.Key? key,
    required String refId,
    required String? title,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.newsTutorialView,
        arguments:
            NewsTutorialViewArguments(key: key, refId: refId, title: title),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNewsBookmarkTutorialView({
    _i17.Key? key,
    required _i20.BookmarkedTutorial tutorial,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.newsBookmarkTutorialView,
        arguments:
            NewsBookmarkTutorialViewArguments(key: key, tutorial: tutorial),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNewsFeedView({
    _i17.Key? key,
    String slug = '',
    String author = '',
    bool fromAuthor = false,
    bool fromTag = false,
    bool fromSearch = false,
    List<dynamic> tutorials = const [],
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
            tutorials: tutorials,
            subject: subject),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNewsAuthorView({
    _i17.Key? key,
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
    _i17.Key? key,
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

  Future<dynamic> navigateToChallengeView({
    _i17.Key? key,
    required String url,
    required _i21.Block block,
    required String challengeId,
    required int challengesCompleted,
    required bool isProject,
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
            challengeId: challengeId,
            challengesCompleted: challengesCompleted,
            isProject: isProject),
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

  Future<dynamic> navigateToLearnLandingView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.learnLandingView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNativeLoginView({
    _i17.Key? key,
    bool fromButton = false,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.nativeLoginView,
        arguments: NativeLoginViewArguments(key: key, fromButton: fromButton),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSuperBlockView({
    _i17.Key? key,
    required String superBlockDashedName,
    required String superBlockName,
    required bool hasInternet,
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
            superBlockName: superBlockName,
            hasInternet: hasInternet),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSettingsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.settingsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithPodcastListView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.podcastListView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithEpisodeView({
    _i17.Key? key,
    required _i18.Episodes episode,
    required _i19.Podcasts podcast,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.episodeView,
        arguments:
            EpisodeViewArguments(key: key, episode: episode, podcast: podcast),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNewsTutorialView({
    _i17.Key? key,
    required String refId,
    required String? title,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.newsTutorialView,
        arguments:
            NewsTutorialViewArguments(key: key, refId: refId, title: title),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNewsBookmarkTutorialView({
    _i17.Key? key,
    required _i20.BookmarkedTutorial tutorial,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.newsBookmarkTutorialView,
        arguments:
            NewsBookmarkTutorialViewArguments(key: key, tutorial: tutorial),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNewsFeedView({
    _i17.Key? key,
    String slug = '',
    String author = '',
    bool fromAuthor = false,
    bool fromTag = false,
    bool fromSearch = false,
    List<dynamic> tutorials = const [],
    String subject = '',
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.newsFeedView,
        arguments: NewsFeedViewArguments(
            key: key,
            slug: slug,
            author: author,
            fromAuthor: fromAuthor,
            fromTag: fromTag,
            fromSearch: fromSearch,
            tutorials: tutorials,
            subject: subject),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNewsAuthorView({
    _i17.Key? key,
    required String authorSlug,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.newsAuthorView,
        arguments: NewsAuthorViewArguments(key: key, authorSlug: authorSlug),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNewsImageView({
    _i17.Key? key,
    required String imgUrl,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.newsImageView,
        arguments: NewsImageViewArguments(key: key, imgUrl: imgUrl),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCodeRadioView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.codeRadioView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithChallengeView({
    _i17.Key? key,
    required String url,
    required _i21.Block block,
    required String challengeId,
    required int challengesCompleted,
    required bool isProject,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.challengeView,
        arguments: ChallengeViewArguments(
            key: key,
            url: url,
            block: block,
            challengeId: challengeId,
            challengesCompleted: challengesCompleted,
            isProject: isProject),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithProfileView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.profileView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithLearnLandingView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.learnLandingView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNativeLoginView({
    _i17.Key? key,
    bool fromButton = false,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.nativeLoginView,
        arguments: NativeLoginViewArguments(key: key, fromButton: fromButton),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSuperBlockView({
    _i17.Key? key,
    required String superBlockDashedName,
    required String superBlockName,
    required bool hasInternet,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.superBlockView,
        arguments: SuperBlockViewArguments(
            key: key,
            superBlockDashedName: superBlockDashedName,
            superBlockName: superBlockName,
            hasInternet: hasInternet),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSettingsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.settingsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
