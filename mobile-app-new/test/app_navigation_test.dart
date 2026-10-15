import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/services/audio_service.dart';
import 'package:mobile_app_new/widgets/app_bottom_navigation.dart';
import 'support/fake_audio_handler.dart';

void main() {
  testWidgets(
    'five destinations navigate consistently and Donate opens the website',
    (tester) async {
      final opened = <String>[];
      const channel = MethodChannel(
        'plugins.flutter.droibit.github.io/custom_tabs',
      );
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            if (call.method == 'launch') {
              opened.add((call.arguments as Map)['url'] as String);
            }
            return null;
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null),
      );
      final locations = ['/learn', '/news', '/podcasts', '/profile'];
      final destinations = [
        AppDestination.learn,
        AppDestination.tutorials,
        AppDestination.listen,
        AppDestination.profile,
      ];
      final router = GoRouter(
        initialLocation: '/learn',
        routes: [
          for (var i = 0; i < locations.length; i++)
            GoRoute(
              path: locations[i],
              builder: (_, state) => Scaffold(
                body: Text('Page ${state.uri.path}'),
                bottomNavigationBar: AppNavigationFooter(
                  selected: destinations[i],
                ),
              ),
            ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            audioHandlerProvider.overrideWithValue(FakeAudioHandler()),
          ],
          child: MaterialApp.router(
            theme: FccTheme.themeLight,
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();
      for (final label in ['Articles', 'Listen', 'Profile', 'Courses']) {
        await tester.tap(find.text(label));
        await tester.pumpAndSettle();
        final expected = {
          'Articles': '/news',
          'Listen': '/podcasts',
          'Profile': '/profile',
          'Courses': '/learn',
        }[label];
        expect(router.routeInformationProvider.value.uri.path, expected);
        expect(find.byType(NavigationDestination), findsNWidgets(5));
      }
      await tester.tap(find.text('Donate'));
      await tester.pumpAndSettle();
      expect(opened, ['https://www.freecodecamp.org/donate/']);
      expect(router.routeInformationProvider.value.uri.path, '/learn');
      expect(tester.takeException(), isNull);
    },
  );
}
