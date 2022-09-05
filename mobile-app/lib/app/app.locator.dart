// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:sqflite_migration_service/sqflite_migration_service.dart';
import 'package:stacked_core/stacked_core.dart';
import 'package:stacked_services/stacked_services.dart';

import '../service/audio_service.dart';
import '../service/authentication_service.dart';
import '../service/download_service.dart';
import '../service/learn_service.dart';
import '../service/notification_service.dart';
import '../service/podcasts_service.dart';
import '../service/test_service.dart';

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
  locator.registerLazySingleton(() => TestService());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => AppAudioService());
  locator.registerLazySingleton(() => DownloadService());
  locator.registerLazySingleton(() => LearnService());
}
