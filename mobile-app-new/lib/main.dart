import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/firebase_options.dart';
import 'package:mobile_app_new/learn/services/daily_challenge_reminder_service.dart';
import 'package:mobile_app_new/podcasts/services/library_service.dart';
import 'package:mobile_app_new/routing/router.dart';
import 'package:mobile_app_new/services/analytics_service.dart';
import 'package:mobile_app_new/services/audio_service.dart';
import 'package:mobile_app_new/services/auth_service.dart';
import 'package:mobile_app_new/services/notification_service.dart';
import 'package:mobile_app_new/services/remote_config_service.dart';
import 'package:mobile_app_new/settings/services/app_preferences.dart';
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
    });
  }

  Future<void> _scheduleReminders() async {
    await ref.read(notificationServiceProvider).requestPermission();
    final user = await ref.read(authProvider.future).catchError((_) => null);
    await ref.read(learnDailyChallengeReminderServiceProvider).reschedule(user);
  }

  void _logScreenView() {
    unawaited(
      ref
          .read(analyticsProvider)
          .logScreenView(screenName: router.state.matchedLocation),
    );
  }

  @override
  void dispose() {
    router.routerDelegate.removeListener(_logScreenView);
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
      themeMode:
          ref.watch(appPreferencesProvider).value?.themeMode ??
          ThemeMode.system,
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
