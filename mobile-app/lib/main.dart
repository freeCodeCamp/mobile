import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/firebase_options.dart';
import 'package:freecodecamp/service/firebase/analytics_service.dart';
import 'package:freecodecamp/service/audio/audio_service.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/podcast/notification_service.dart';
import 'package:freecodecamp/service/navigation/quick_actions_service.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';

import 'package:stacked_services/stacked_services.dart';

import 'app/app.locator.dart';
import 'app/app.router.dart';

Future<void> main({bool testing = false}) async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();

  var fbApp = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);
  if (!testing) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    if (kReleaseMode) {
      await fbApp.setAutomaticDataCollectionEnabled(true);
    } else {
      await fbApp.setAutomaticDataCollectionEnabled(false);
    }
  }
  await AuthenticationService().init();
  await NotificationService().init();
  await AppAudioService().init();
  await FkUserAgent.init();

  runApp(const FreeCodeCampMobileApp());

  await QuickActionsService().init();
}

class FreeCodeCampMobileApp extends StatelessWidget {
  const FreeCodeCampMobileApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'freeCodeCamp',
      theme: FccTheme.themeDark,
      debugShowCheckedModeBanner: false,
      navigatorKey: StackedService.navigatorKey,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      navigatorObservers: [locator<AnalyticsService>().getAnalyticsObserver()],
    );
  }
}
