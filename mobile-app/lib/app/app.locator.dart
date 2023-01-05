// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, implementation_imports, depend_on_referenced_packages

import 'package:sqflite_migration_service/src/database_migration_service.dart';
import 'package:stacked_core/stacked_core.dart';
import 'package:stacked_services/src/dialog/dialog_service.dart';
import 'package:stacked_services/src/navigation/navigation_service.dart';
import 'package:stacked_services/src/snackbar/snackbar_service.dart';

import '../service/audio/audio_service.dart';
import '../service/authentication/authentication_service.dart';
import '../service/developer_service.dart';
import '../service/learn/learn_file_service.dart';
import '../service/learn/learn_offline_service.dart';
import '../service/learn/learn_service.dart';
import '../service/navigation/quick_actions_service.dart';
import '../service/podcast/download_service.dart';
import '../service/podcast/notification_service.dart';
import '../service/podcast/podcasts_service.dart';

final locator = StackedLocator.instance;

Future<void> setupLocator(
    {String? environment, EnvironmentFilter? environmentFilter}) async {
// Register environments
  locator.registerEnvironment(
      environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => DatabaseMigrationService());
  locator.registerLazySingleton(() => PodcastsDatabaseService());
  locator.registerLazySingleton(() => NotificationService());
  locator.registerLazySingleton(() => DeveloperService());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => AppAudioService());
  locator.registerLazySingleton(() => DownloadService());
  locator.registerLazySingleton(() => LearnService());
  locator.registerLazySingleton(() => LearnFileService());
  locator.registerLazySingleton(() => LearnOfflineService());
  locator.registerLazySingleton(() => QuickActionsService());
}
