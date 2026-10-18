import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/firebase_options.dart';
import 'package:mobile_app_new/learn/services/daily_challenge_reminder_service.dart';
import 'package:mobile_app_new/podcasts/services/library_service.dart';
import 'package:mobile_app_new/routing/router.dart';
import 'package:mobile_app_new/services/audio_service.dart';
import 'package:mobile_app_new/services/auth_service.dart';
import 'package:mobile_app_new/services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  await dotenv.load();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  tz.initializeTimeZones();

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
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_scheduleReminders());
      // NOTE: Starts restoring the stored session so the drawer rarely sees it loading.
      ref.read(authProvider);
      // NOTE: Deletes audio and artwork that no store row points at
      unawaited(ref.read(podcastLibraryServiceProvider).sweepOrphanedFiles());
    });
  }

  Future<void> _scheduleReminders() async {
    await ref.read(notificationServiceProvider).requestPermission();
    final user = await ref.read(authProvider.future).catchError((_) => null);
    await ref.read(learnDailyChallengeReminderServiceProvider).reschedule(user);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Flutter Demo',
      theme: FccTheme.themeDark,
    );
  }
}
