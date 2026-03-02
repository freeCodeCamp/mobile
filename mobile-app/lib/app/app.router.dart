import 'package:flutter/widgets.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/models/news/bookmarked_tutorial_model.dart';
import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';

class Routes {
  static const newsViewHandlerView = '/news-view-handler-view';
  static const podcastListView = '/podcast-list-view';
  static const episodeView = '/episode-view';
  static const newsTutorialView = '/news-tutorial-view';
  static const newsBookmarkTutorialView = '/news-bookmark-tutorial-view';
  static const newsFeedView = '/news-feed-view';
  static const newsAuthorView = '/news-author-view';
  static const newsImageView = '/news-image-view';
  static const codeRadioView = '/code-radio-view';
  static const challengeTemplateView = '/challenge-template-view';
  static const chapterView = '/chapter-view';
  static const chapterBlockView = '/chapter-block-view';
  static const profileView = '/profile-view';
  static const learnLandingView = '/';
  static const nativeLoginView = '/native-login-view';
  static const superBlockView = '/super-block-view';
  static const settingsView = '/settings-view';
  static const deleteAccountView = '/delete-account-view';
  static const dailyChallengeView = '/daily-challenge-view';

  static const all = <String>{
    newsViewHandlerView,
    podcastListView,
    episodeView,
    newsTutorialView,
    newsBookmarkTutorialView,
    newsFeedView,
    newsAuthorView,
    newsImageView,
    codeRadioView,
    challengeTemplateView,
    chapterView,
    chapterBlockView,
    profileView,
    learnLandingView,
    nativeLoginView,
    superBlockView,
    settingsView,
    deleteAccountView,
    dailyChallengeView,
  };
}

class EpisodeViewArguments {
  const EpisodeViewArguments({
    this.key,
    required this.episode,
    required this.podcast,
  });

  final Key? key;
  final Episodes episode;
  final Podcasts podcast;
}

class NewsTutorialViewArguments {
  const NewsTutorialViewArguments({
    this.key,
    required this.refId,
    required this.slug,
  });

  final Key? key;
  final String refId;
  final String slug;
}

class NewsBookmarkTutorialViewArguments {
  const NewsBookmarkTutorialViewArguments({
    this.key,
    required this.tutorial,
  });

  final Key? key;
  final BookmarkedTutorial tutorial;
}

class NewsFeedViewArguments {
  const NewsFeedViewArguments({
    this.key,
    this.tagSlug = '',
    this.authorId = '',
    this.fromAuthor = false,
    this.fromTag = false,
    this.fromSearch = false,
    this.tutorials = const [],
    this.subject = '',
  });

  final Key? key;
  final String tagSlug;
  final String authorId;
  final bool fromAuthor;
  final bool fromTag;
  final bool fromSearch;
  final List<dynamic> tutorials;
  final String subject;
}

class NewsAuthorViewArguments {
  const NewsAuthorViewArguments({
    this.key,
    required this.authorSlug,
  });

  final Key? key;
  final String authorSlug;
}

class NewsImageViewArguments {
  const NewsImageViewArguments({
    this.key,
    required this.imgUrl,
    required this.isDataUrl,
  });

  final Key? key;
  final String imgUrl;
  final bool isDataUrl;
}

class ChallengeTemplateViewArguments {
  const ChallengeTemplateViewArguments({
    this.key,
    required this.block,
    required this.challengeId,
    this.challengeDate,
  });

  final Key? key;
  final Block block;
  final String challengeId;
  final DateTime? challengeDate;
}

class ChapterViewArguments {
  const ChapterViewArguments({
    this.key,
    required this.superBlockDashedName,
    required this.superBlockName,
  });

  final Key? key;
  final String superBlockDashedName;
  final String superBlockName;
}

class ChapterBlockViewArguments {
  const ChapterBlockViewArguments({
    this.key,
    required this.moduleName,
    required this.blocks,
  });

  final Key? key;
  final String moduleName;
  final List<Block> blocks;
}

class NativeLoginViewArguments {
  const NativeLoginViewArguments({
    this.key,
    this.fromButton = false,
  });

  final Key? key;
  final bool fromButton;
}

class SuperBlockViewArguments {
  const SuperBlockViewArguments({
    this.key,
    required this.superBlockDashedName,
    required this.superBlockName,
    required this.hasInternet,
  });

  final Key? key;
  final String superBlockDashedName;
  final String superBlockName;
  final bool hasInternet;
}
