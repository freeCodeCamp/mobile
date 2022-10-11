import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/service/audio_service.dart';
// import 'package:freecodecamp/service/authentication_service.dart';
import 'package:freecodecamp/service/new_auth_service.dart';
import 'package:freecodecamp/service/notification_service.dart';
import 'package:freecodecamp/service/quick_actions_service.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:stacked_services/stacked_services.dart';

import 'app/app.locator.dart';
import 'app/app.router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();

  // await AuthenticationService().init();
  await NewAuthService().init();
  await NotificationService().init();
  await AppAudioService().init();
  await FkUserAgent.init();

  runApp(const MyApp());

  await QuickActionsService().init();
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
