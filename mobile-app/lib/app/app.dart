import 'package:freecodecamp/service/test_service.dart';
import 'package:freecodecamp/service/notification_service.dart';
import 'package:freecodecamp/service/podcasts_service.dart';
import 'package:freecodecamp/service/authentication_service.dart';
import 'package:freecodecamp/service/audio_service.dart';
import 'package:freecodecamp/service/download_service.dart';
import 'package:freecodecamp/service/learn_service.dart';
import 'package:freecodecamp/service/learn_file_service.dart';
import 'package:freecodecamp/service/quick_actions_service.dart';

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
import 'package:freecodecamp/ui/views/podcast/episode/episode_view.dart';
import 'package:freecodecamp/ui/views/news/news-article/news_article_view.dart';
import 'package:freecodecamp/ui/views/news/news-bookmark/news_bookmark_view.dart';
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_view.dart';
import 'package:freecodecamp/ui/views/settings/forumSettings/forum_settings_view.dart';
import 'package:freecodecamp/ui/views/settings/podcastSettings/podcast_settings_view.dart';
import 'package:freecodecamp/ui/views/learn/learn/learn_view.dart';
import 'package:freecodecamp/ui/views/learn/learn-builders/superblock_builder.dart';
import 'package:freecodecamp/ui/views/learn/challenge_editor/challenge_view.dart';
import 'package:freecodecamp/ui/views/web_view/web_view_view.dart';
import 'package:freecodecamp/ui/views/profile/profile_view.dart';

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
    MaterialRoute(page: EpisodeView),
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
    MaterialRoute(page: SuperBlockView),
    MaterialRoute(page: ChallengeView),
    MaterialRoute(page: ProfileView),
    MaterialRoute(page: WebViewView),
    MaterialRoute(page: LearnView)
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: DatabaseMigrationService),
    LazySingleton(classType: PodcastsDatabaseService),
    LazySingleton(classType: NotificationService),
    LazySingleton(classType: TestService),
    LazySingleton(classType: AuthenticationService),
    LazySingleton(classType: AppAudioService),
    LazySingleton(classType: DownloadService),
    LazySingleton(classType: LearnService),
    LazySingleton(classType: LearnFileService),
    LazySingleton(classType: QuickActionsService),
  ],
  logger: StackedLogger(),
)
class AppSetup {
  //Serves no purpose besides having an annotation attached to it
}
