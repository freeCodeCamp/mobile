import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/routing/router.dart';
import 'package:mobile_app_new/services/dio_service.dart';

void main() async {
  await dotenv.load();
  await DioService().init();

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Flutter Demo',
      theme: FccTheme.themeDark,
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
