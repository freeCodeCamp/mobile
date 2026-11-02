import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/firebase_options.dart';
import 'package:freecodecamp/learn/services/daily_challenge_reminder_service.dart';
import 'package:freecodecamp/learn/ui/challenge/challenge_viewmodel.dart';
import 'package:freecodecamp/podcasts/services/library_service.dart';
import 'package:freecodecamp/routing/learn.dart' show learnChallengePath;
import 'package:freecodecamp/routing/router.dart';
import 'package:freecodecamp/services/analytics_service.dart';
import 'package:freecodecamp/services/app_preferences_service.dart';
import 'package:freecodecamp/services/audio_service.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:freecodecamp/services/experiment_service.dart';
import 'package:freecodecamp/services/notification_service.dart';
import 'package:freecodecamp/services/remote_config_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:upgrader/upgrader.dart';

Future<void> main() async {
  // NOTE: The native splash stays until the first frame, which MyApp allows once the session is restored.
  WidgetsFlutterBinding.ensureInitialized().deferFirstFrame();
  await dotenv.load();
  final firebaseApp = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kReleaseMode) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack);
      return true;
    };
  }
  await firebaseApp.setAutomaticDataCollectionEnabled(kReleaseMode);
  tz.initializeTimeZones();

  await initRemoteConfig();

  final audioHandler = await initAudioService();

  runApp(
    ProviderScope(
      overrides: [audioHandlerProvider.overrideWithValue(audioHandler)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final _upgrader = Upgrader();
  StreamSubscription<NotificationKind?>? _notificationTaps;
  ProviderSubscription<AsyncValue<ChallengeScreenData>>? _pendingChallenge;

  @override
  void initState() {
    super.initState();

    router.routerDelegate.addListener(_logScreenView);
    ref.listenManual(remoteConfigProvider, (_, next) {
      _upgrader.updateState(
        _upgrader.state.copyWith(
          minAppVersion: Upgrader.parseVersion(
            next.minAppVersion,
            'minAppVersion',
            false,
          ),
        ),
      );
    }, fireImmediately: true);
    ref.listenManual(authProvider, (_, next) {
      if (next.hasValue) {
        unawaited(ref.read(analyticsProvider).setSignedIn(next.value != null));
      }
    }, fireImmediately: true);

    unawaited(
      ref
          .read(authProvider.future)
          .timeout(const Duration(seconds: 10))
          .catchError((_) => null)
          .whenComplete(_onSessionRestored),
    );
  }

  void _onSessionRestored() {
    WidgetsBinding.instance.allowFirstFrame();
    // NOTE: Post-frame callbacks also fire for deferred frames, so these wait until the splash is gone.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_scheduleReminders());
      // NOTE: Deletes audio and artwork that no store row points at
      unawaited(ref.read(podcastLibraryServiceProvider).sweepOrphanedFiles());
      ref.read(experimentsProvider.notifier).logExposure(Experiment.aaTest);
      unawaited(logInstallationIdForTesting());
      unawaited(_trackNotificationTaps());
    });
  }

  Future<void> _trackNotificationTaps() async {
    final notifications = ref.read(notificationServiceProvider);
    final analytics = ref.read(analyticsProvider);
    _notificationTaps = notifications.opened.listen(
      (kind) => unawaited(analytics.notificationOpened(kind)),
    );
    final launch = await notifications.launchedFrom();
    if (launch != null) await analytics.notificationOpened(launch.kind);
  }

  Future<void> _scheduleReminders() async {
    final granted = await ref
        .read(notificationServiceProvider)
        .requestPermission();
    unawaited(
      ref
          .read(analyticsProvider)
          .reportNotificationPermission(granted: granted),
    );
    final user = await ref.read(authProvider.future).catchError((_) => null);
    await ref.read(learnDailyChallengeReminderServiceProvider).reschedule(user);
  }

  void _logScreenView() {
    _pendingChallenge?.close();
    _pendingChallenge = null;

    final screen = screenViewOf(router);
    if (screen.route != learnChallengePath) {
      unawaited(ref.read(analyticsProvider).screenView(screen));
      return;
    }

    // NOTE: The challenge's web path needs its slug, which only arrives with the challenge. Listening shares the screen's own fetch, and a new navigation cancels the wait.
    final params = router.state.pathParameters;
    var logged = false;
    _pendingChallenge = ref.listenManual(
      challengeScreenProvider(
        params['superBlock']!,
        params['block']!,
        params['challengeId']!,
      ),
      (_, next) {
        if (logged || next.isLoading) return;
        logged = true;
        final slug = next.value?.challenge.dashedName;
        unawaited(
          ref
              .read(analyticsProvider)
              .screenView(
                slug == null
                    ? screen
                    : (
                        path: challengeWebPath(
                          superBlock: params['superBlock']!,
                          block: params['block']!,
                          slug: slug,
                        ),
                        route: screen.route,
                      ),
                challengeId: params['challengeId'],
              ),
        );
      },
      fireImmediately: true,
    );
  }

  @override
  void dispose() {
    router.routerDelegate.removeListener(_logScreenView);
    unawaited(_notificationTaps?.cancel());
    _pendingChallenge?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'freeCodeCamp',
      debugShowCheckedModeBanner: false,
      theme: FccTheme.themeLight,
      darkTheme: FccTheme.themeDark,
      themeMode: ref.watch(
        appPreferencesProvider.select(
          (preferences) => preferences.value?.themeMode ?? ThemeMode.dark,
        ),
      ),
      builder: (context, child) => UpgradeAlert(
        navigatorKey: router.routerDelegate.navigatorKey,
        dialogStyle: Platform.isIOS
            ? UpgradeDialogStyle.cupertino
            : UpgradeDialogStyle.material,
        showIgnore: false,
        upgrader: _upgrader,
        child: child,
      ),
    );
  }
}
