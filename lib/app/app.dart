import 'package:freecodecamp/service/episodes_service.dart';
import 'package:freecodecamp/ui/views/browser/browser_view.dart';
import 'package:freecodecamp/ui/views/forum/forum-categories/forum_category_view.dart';
import 'package:freecodecamp/ui/views/forum/forum-login/forum_login_view.dart';
import 'package:freecodecamp/ui/views/forum/forum-post-feed/forum_post_feed_view.dart';
import 'package:freecodecamp/ui/views/forum/forum-post/forum_post_view.dart';
import 'package:freecodecamp/ui/views/forum/forum-user/forum_user_view.dart';
import 'package:freecodecamp/ui/views/home/home_view.dart';
import 'package:freecodecamp/ui/views/podcast/podcast_download_view.dart';
import 'package:freecodecamp/ui/views/podcast/podcast_view.dart';
import 'package:freecodecamp/ui/views/news/news-article-post/news_article_post_view.dart';
import 'package:freecodecamp/ui/views/news/news-bookmark/news_bookmark_view.dart';
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_view.dart';
import 'package:freecodecamp/ui/views/settings/forumSettings/forum_settings_view.dart';
import 'package:freecodecamp/ui/views/settings/podcastSettings/podcast_settings_view.dart';

import '../ui/views/startup/startup_view.dart';
import '../ui/views/website/website_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:sqflite_migration_service/sqflite_migration_service.dart';

// Run 'flutter pub run build_runner build --delete-conflicting-outputs' after any changes in this file to generate updated files
@StackedApp(
  routes: [
    MaterialRoute(page: StartupView),
    MaterialRoute(page: WebsiteView),
    MaterialRoute(page: HomeView, initial: true),
    MaterialRoute(page: BrowserView),
    MaterialRoute(page: PodcastView),
    MaterialRoute(page: PodcastDownloadView),
    MaterialRoute(page: PodcastSettingsView),
    MaterialRoute(page: NewsArticlePostView),
    MaterialRoute(page: NewsBookmarkPostView),
    MaterialRoute(page: NewsFeedView),
    MaterialRoute(page: ForumCategoryView),
    MaterialRoute(page: ForumPostFeedView),
    MaterialRoute(page: ForumPostView),
    MaterialRoute(page: ForumLoginView),
    MaterialRoute(page: ForumUserView),
    MaterialRoute(page: ForumSettingsView),
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: DatabaseMigrationService),
    LazySingleton(classType: EpisodeDatabaseService)
  ],
  logger: StackedLogger(),
)
class AppSetup {
  //Serves no purpose besides having an annotation attached to it
}
