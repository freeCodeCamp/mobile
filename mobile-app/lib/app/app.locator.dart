import 'package:get_it/get_it.dart';

import '../service/audio/audio_service.dart';
import '../service/authentication/authentication_service.dart';
import '../service/developer_service.dart';
import '../service/dio_service.dart';
import '../service/firebase/analytics_service.dart';
import '../service/firebase/remote_config_service.dart';
import '../service/learn/daily_challenge_notification_service.dart';
import '../service/learn/daily_challenge_service.dart';
import '../service/learn/learn_file_service.dart';
import '../service/learn/learn_offline_service.dart';
import '../service/learn/learn_service.dart';
import '../service/locale_service.dart';
import '../service/navigation/quick_actions_service.dart';
import '../service/news/api_service.dart';
import '../service/news/bookmark_service.dart';
import '../service/podcast/download_service.dart';
import '../service/podcast/notification_service.dart';
import '../service/podcast/podcasts_service.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  _registerLazySingleton<PodcastsDatabaseService>(
    () => PodcastsDatabaseService(),
  );
  _registerLazySingleton<NotificationService>(() => NotificationService());
  _registerLazySingleton<DailyChallengeNotificationService>(
    () => DailyChallengeNotificationService(),
  );
  _registerLazySingleton<DeveloperService>(() => DeveloperService());
  _registerLazySingleton<AuthenticationService>(() => AuthenticationService());
  _registerLazySingleton<AppAudioService>(() => AppAudioService());
  _registerLazySingleton<DailyChallengeService>(() => DailyChallengeService());
  _registerLazySingleton<DownloadService>(() => DownloadService());
  _registerLazySingleton<LearnService>(() => LearnService());
  _registerLazySingleton<LearnFileService>(() => LearnFileService());
  _registerLazySingleton<LearnOfflineService>(() => LearnOfflineService());
  _registerLazySingleton<QuickActionsService>(() => QuickActionsService());
  _registerLazySingleton<AnalyticsService>(() => AnalyticsService());
  _registerLazySingleton<RemoteConfigService>(() => RemoteConfigService());
  _registerLazySingleton<BookmarksDatabaseService>(
    () => BookmarksDatabaseService(),
  );
  _registerLazySingleton<LocaleService>(() => LocaleService());
  _registerLazySingleton<DioService>(() => DioService());
  _registerLazySingleton<NewsApiService>(() => NewsApiService());
}

void _registerLazySingleton<T extends Object>(
  T Function() factoryFunction,
) {
  if (!locator.isRegistered<T>()) {
    locator.registerLazySingleton<T>(factoryFunction);
  }
}
