import 'package:flutter/material.dart';
import 'package:freecodecamp/service/code_radio_service.dart';
import 'package:freecodecamp/service/notification_service.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:stacked_services/stacked_services.dart';

import 'app/app.locator.dart';
import 'app/app.router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  await NotificationService().init();

  setupLocator();

  // enable audio streaming

  final audioService = locator<CodeRadioService>();
  audioService.initAppStateObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'freeCodeCamp',
      theme: FccTheme.themeDark,
      debugShowCheckedModeBanner: false,
      navigatorKey: StackedService.navigatorKey,
      onGenerateRoute: StackedRouter().onGenerateRoute,
    );
  }
}
