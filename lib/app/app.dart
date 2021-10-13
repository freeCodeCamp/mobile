import 'package:freecodecamp/service/episodes_service.dart';
import 'package:freecodecamp/ui/views/browser/browser_view.dart';
import 'package:freecodecamp/ui/views/home/home_view.dart';
import 'package:freecodecamp/ui/views/podcast/podcast_download_view.dart';
import 'package:freecodecamp/ui/views/podcast/podcast_view.dart';

import '../ui/views/startup/startup_view.dart';
import '../ui/views/website/website_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:sqflite_migration_service/sqflite_migration_service.dart';

// Run 'flutter pub run build_runner build --delete-conflicting-outputs' after any changes in this file to generate updated files
@StackedApp(
  routes: [
    MaterialRoute(page: StartupView, initial: true),
    MaterialRoute(page: WebsiteView),
    MaterialRoute(page: HomeView),
    MaterialRoute(page: BrowserView),
    MaterialRoute(page: PodcastView),
    MaterialRoute(page: PodcastDownloadView)
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
