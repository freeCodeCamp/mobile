import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/firebase_options.dart';
import 'package:freecodecamp/l10n/app_localizations.dart';
import 'package:freecodecamp/service/audio/audio_service.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/dio_service.dart';
import 'package:freecodecamp/service/firebase/analytics_service.dart';
import 'package:freecodecamp/service/firebase/remote_config_service.dart';
import 'package:freecodecamp/service/learn/daily_challenge_notification_service.dart';
import 'package:freecodecamp/service/locale_service.dart';
import 'package:freecodecamp/service/navigation/quick_actions_service.dart';
import 'package:freecodecamp/service/news/api_service.dart';
import 'package:freecodecamp/service/podcast/notification_service.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:freecodecamp/utils/upgrade_controller.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:upgrader/upgrader.dart';

Future<void> main({bool testing = false}) async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  locator<LocaleService>().init();

  await DioService().init();
  await AppAudioService().init();
  await AuthenticationService().init();
  await NewsApiService().init();
  var fbApp = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (!testing) {
    if (kReleaseMode) {
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
      await fbApp.setAutomaticDataCollectionEnabled(true);
    } else {
      await fbApp.setAutomaticDataCollectionEnabled(false);
    }
  }
  await RemoteConfigService().init();
  await NotificationService().init();
  await DailyChallengeNotificationService().init();

  runApp(const FreeCodeCampMobileApp());

  await QuickActionsService().init();
}

class FreeCodeCampMobileApp extends StatelessWidget {
  const FreeCodeCampMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Locale>(
      initialData: locator<LocaleService>().locale,
      stream: locator<LocaleService>().localeStream,
      builder: (context, snapshot) {
        log('locale: ${snapshot.data}');

        return MaterialApp(
          title: 'freeCodeCamp',
          theme: FccTheme.themeDark,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: locator<LocaleService>().locales,
          locale: snapshot.data ?? locator<LocaleService>().locale,
          debugShowCheckedModeBanner: false,
          navigatorKey: StackedService.navigatorKey,
          onGenerateRoute: StackedRouter().onGenerateRoute,
          navigatorObservers: [
            locator<AnalyticsService>().getAnalyticsObserver()
          ],
          builder: (context, child) {
            return UpgradeAlert(
              navigatorKey: StackedService.navigatorKey,
              dialogStyle: Platform.isIOS
                  ? UpgradeDialogStyle.cupertino
                  : UpgradeDialogStyle.material,
              showIgnore: false,
              upgrader: upgraderController,
              child: Overlay(
                initialEntries: [OverlayEntry(builder: (context) => child!)],
              ),
            );
          },
        );
      },
    );
  }
}
