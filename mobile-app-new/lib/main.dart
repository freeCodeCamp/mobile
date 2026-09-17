import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/podcasts/services/library_service.dart';
import 'package:mobile_app_new/routing/router.dart';
import 'package:mobile_app_new/services/audio_service.dart';
import 'package:mobile_app_new/services/dio_service.dart';
import 'package:mobile_app_new/services/notification_service.dart';

Future<void> main() async {
  await dotenv.load();
  await DioService().init();

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
      unawaited(ref.read(notificationServiceProvider).requestPermission());
      // NOTE: Deletes audio and artwork that no store row points at
      unawaited(ref.read(podcastLibraryServiceProvider).sweepOrphanedFiles());
    });
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
