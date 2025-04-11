import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:freecodecamp/ui/views/profile/profile_view.dart';
import 'package:stacked_services/stacked_services.dart';

import '../helpers/test_helpers.dart';

Future<void> main() async {
  group('ProfileViewModel', () {
    setUp(() => registerServices());
    tearDown(() => unregisterService());

    testWidgets('MyWidget has a title and message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          navigatorKey: StackedService.navigatorKey,
          locale: const Locale('en', ''),
          theme: FccTheme.themeDark,
          onGenerateRoute: StackedRouter().onGenerateRoute,
          supportedLocales: const [
            Locale('en', ''),
          ],
          home: const ProfileView(),
        ),
      );

      final titleFinder = find.byKey(
        const ValueKey('certification_title'),
      );
      await tester.pump();

      expect(titleFinder, findsOneWidget);
    });
  });
}
