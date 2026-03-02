// Provider bridge: exposes existing GetIt/StackedLocator singletons as
// Riverpod providers.  All services remain owned by the locator for now; these
// providers simply fetch from it so that future feature views can read them via
// ref.read/ref.watch without touching the locator directly.
//
// Usage:
//   final auth = ref.watch(authenticationServiceProvider);
//
// When a service is fully migrated off the locator, replace the provider body
// with a standalone Riverpod implementation.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/service/audio/audio_service.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/developer_service.dart';
import 'package:freecodecamp/service/dio_service.dart';
import 'package:freecodecamp/service/firebase/analytics_service.dart';
import 'package:freecodecamp/service/firebase/remote_config_service.dart';
import 'package:freecodecamp/service/learn/daily_challenge_notification_service.dart';
import 'package:freecodecamp/service/learn/daily_challenge_service.dart';
import 'package:freecodecamp/service/learn/learn_file_service.dart';
import 'package:freecodecamp/service/learn/learn_offline_service.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:freecodecamp/service/locale_service.dart';
import 'package:freecodecamp/service/navigation/quick_actions_service.dart';
import 'package:freecodecamp/service/news/api_service.dart';
import 'package:freecodecamp/service/news/bookmark_service.dart';
import 'package:freecodecamp/service/podcast/download_service.dart';
import 'package:freecodecamp/service/podcast/notification_service.dart';
import 'package:freecodecamp/service/podcast/podcasts_service.dart';

// ---------------------------------------------------------------------------
// Core / infrastructure services
// ---------------------------------------------------------------------------

/// Provides the [AuthenticationService] singleton registered in the locator.
final authenticationServiceProvider = Provider<AuthenticationService>(
  (ref) => locator<AuthenticationService>(),
);

/// Provides the [DioService] singleton registered in the locator.
final dioServiceProvider = Provider<DioService>(
  (ref) => locator<DioService>(),
);

/// Provides the [LocaleService] singleton registered in the locator.
final localeServiceProvider = Provider<LocaleService>(
  (ref) => locator<LocaleService>(),
);

/// Provides the [DeveloperService] singleton registered in the locator.
final developerServiceProvider = Provider<DeveloperService>(
  (ref) => locator<DeveloperService>(),
);

// ---------------------------------------------------------------------------
// Firebase services
// ---------------------------------------------------------------------------

/// Provides the [AnalyticsService] singleton registered in the locator.
final analyticsServiceProvider = Provider<AnalyticsService>(
  (ref) => locator<AnalyticsService>(),
);

/// Provides the [RemoteConfigService] singleton registered in the locator.
final remoteConfigServiceProvider = Provider<RemoteConfigService>(
  (ref) => locator<RemoteConfigService>(),
);

// ---------------------------------------------------------------------------
// Audio service
// ---------------------------------------------------------------------------

/// Provides the [AppAudioService] singleton registered in the locator.
final appAudioServiceProvider = Provider<AppAudioService>(
  (ref) => locator<AppAudioService>(),
);

// ---------------------------------------------------------------------------
// Learn services
// ---------------------------------------------------------------------------

/// Provides the [LearnService] singleton registered in the locator.
final learnServiceProvider = Provider<LearnService>(
  (ref) => locator<LearnService>(),
);

/// Provides the [LearnFileService] singleton registered in the locator.
final learnFileServiceProvider = Provider<LearnFileService>(
  (ref) => locator<LearnFileService>(),
);

/// Provides the [LearnOfflineService] singleton registered in the locator.
final learnOfflineServiceProvider = Provider<LearnOfflineService>(
  (ref) => locator<LearnOfflineService>(),
);

/// Provides the [DailyChallengeService] singleton registered in the locator.
final dailyChallengeServiceProvider = Provider<DailyChallengeService>(
  (ref) => locator<DailyChallengeService>(),
);

/// Provides the [DailyChallengeNotificationService] singleton registered in the locator.
final dailyChallengeNotificationServiceProvider =
    Provider<DailyChallengeNotificationService>(
  (ref) => locator<DailyChallengeNotificationService>(),
);

// ---------------------------------------------------------------------------
// News / Podcast services
// ---------------------------------------------------------------------------

/// Provides the [NewsApiService] singleton registered in the locator.
final newsApiServiceProvider = Provider<NewsApiService>(
  (ref) => locator<NewsApiService>(),
);

/// Provides the [BookmarksDatabaseService] singleton registered in the locator.
final bookmarksDatabaseServiceProvider = Provider<BookmarksDatabaseService>(
  (ref) => locator<BookmarksDatabaseService>(),
);

/// Provides the [PodcastsDatabaseService] singleton registered in the locator.
final podcastsDatabaseServiceProvider = Provider<PodcastsDatabaseService>(
  (ref) => locator<PodcastsDatabaseService>(),
);

/// Provides the [DownloadService] singleton registered in the locator.
final downloadServiceProvider = Provider<DownloadService>(
  (ref) => locator<DownloadService>(),
);

/// Provides the [NotificationService] singleton registered in the locator.
final notificationServiceProvider = Provider<NotificationService>(
  (ref) => locator<NotificationService>(),
);

// ---------------------------------------------------------------------------
// Navigation helpers
// ---------------------------------------------------------------------------

/// Provides the [QuickActionsService] singleton registered in the locator.
final quickActionsServiceProvider = Provider<QuickActionsService>(
  (ref) => locator<QuickActionsService>(),
);
