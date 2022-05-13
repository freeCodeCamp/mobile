import 'package:freecodecamp/service/episode_audio_service.dart';
import 'package:freecodecamp/service/test_service.dart';
import 'package:freecodecamp/service/notification_service.dart';
import 'package:freecodecamp/service/podcasts_service.dart';
import 'package:freecodecamp/service/code_radio_service.dart';
import 'package:freecodecamp/service/authentication_service.dart';

import 'package:freecodecamp/ui/views/browser/browser_view.dart';
import 'package:freecodecamp/ui/views/code_radio/code_radio_view.dart';
import 'package:freecodecamp/ui/views/forum/forum-categories/forum_category_view.dart';
import 'package:freecodecamp/ui/views/forum/forum-login/forum_login_view.dart';
import 'package:freecodecamp/ui/views/forum/forum-post-feed/forum_post_feed_view.dart';
import 'package:freecodecamp/ui/views/forum/forum-post/forum_post_view.dart';
import 'package:freecodecamp/ui/views/forum/forum-user-profile/forum_user_profile_view.dart';
import 'package:freecodecamp/ui/views/forum/forum-user/forum_user_view.dart';
import 'package:freecodecamp/ui/views/home/home_view.dart';
import 'package:freecodecamp/ui/views/news/news-author/news_author_view.dart';
import 'package:freecodecamp/ui/views/podcast/podcast-list/podcast_list_view.dart';
import 'package:freecodecamp/ui/views/news/news-article/news_article_view.dart';
import 'package:freecodecamp/ui/views/news/news-bookmark/news_bookmark_view.dart';
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_view.dart';
import 'package:freecodecamp/ui/views/settings/forumSettings/forum_settings_view.dart';
import 'package:freecodecamp/ui/views/settings/podcastSettings/podcast_settings_view.dart';
import 'package:freecodecamp/ui/views/auth/auth_view.dart';

import 'package:freecodecamp/ui/views/news/news-image-viewer/news_image_viewer.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:sqflite_migration_service/sqflite_migration_service.dart';

// Run 'flutter pub run build_runner build --delete-conflicting-outputs' after any changes in this file to generate updated files
@StackedApp(
  routes: [
    MaterialRoute(page: HomeView, initial: true),
    MaterialRoute(page: PodcastListView),
    MaterialRoute(page: PodcastSettingsView),
    MaterialRoute(page: NewsArticleView),
    MaterialRoute(page: NewsBookmarkPostView),
    MaterialRoute(page: NewsFeedView),
    MaterialRoute(page: NewsAuthorView),
    MaterialRoute(page: NewsImageView),
    MaterialRoute(page: ForumCategoryView),
    MaterialRoute(page: ForumPostFeedView),
    MaterialRoute(page: ForumPostView),
    MaterialRoute(page: ForumLoginView),
    MaterialRoute(page: ForumUserView),
    MaterialRoute(page: ForumSettingsView),
    MaterialRoute(page: ForumUserProfileView),
    MaterialRoute(page: CodeRadioView),
    MaterialRoute(page: AuthView)
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: DatabaseMigrationService),
    LazySingleton(classType: PodcastsDatabaseService),
    LazySingleton(classType: NotificationService),
    LazySingleton(classType: EpisodeAudioService),
    LazySingleton(classType: TestService),
    LazySingleton(classType: CodeRadioService),
    LazySingleton(classType: AuthenticationService),
  ],
  logger: StackedLogger(),
)
class AppSetup {
  //Serves no purpose besides having an annotation attached to it
}
