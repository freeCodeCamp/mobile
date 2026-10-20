import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart' hide Block;
import 'package:mobile_app_new/auth/models/user_model.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/controllers/curriculum_controller.dart';
import 'package:mobile_app_new/learn/models/curriculum_model.dart';
import 'package:mobile_app_new/learn/ui/module/module_view.dart';
import 'package:mobile_app_new/services/audio_service.dart';
import 'package:mobile_app_new/services/auth_service.dart';

import 'support/fake_audio_handler.dart';

class _Auth extends AuthNotifier {
  @override
  Future<FccUserModel?> build() async => FccUserModel(
    id: 'camper',
    email: 'camper@example.com',
    username: 'camper',
    joinDate: DateTime(2020),
    completedChallenges: [
      for (var i = 1; i <= 2; i++)
        CompletedChallenge(id: 'step-$i', completedDate: DateTime(2026)),
    ],
  );
}

final _workshop = Block(
  superBlock: 'course',
  dashedName: 'workshop',
  name: 'Build a Curriculum Outline',
  layout: BlockLayout.challengeGrid,
  label: BlockLabel.workshop,
  description: [
    'Welcome to freeCodeCamp! This workshop will serve as your introduction to HTML and coding in general.',
  ],
  challenges: [
    for (var i = 1; i <= 11; i++)
      ChallengeOrder(id: 'step-$i', title: 'Step $i'),
  ],
);
Future<GoRouter> _pump(
  WidgetTester tester, {
  bool dark = false,
  double width = 390,
  double scale = 1,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 844);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  final router = GoRouter(
    initialLocation: '/module',
    routes: [
      GoRoute(
        path: '/module',
        builder: (_, _) =>
            const ModuleView(superBlock: 'course', module: 'basic-html'),
      ),
      GoRoute(
        path: '/learn/:course',
        builder: (_, _) => const Scaffold(body: Text('Course destination')),
      ),
      GoRoute(
        path: '/learn/:course/:block/:id',
        builder: (_, state) => Scaffold(body: Text(state.uri.path)),
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        audioHandlerProvider.overrideWithValue(FakeAudioHandler()),
        authProvider.overrideWith(_Auth.new),
        curriculumStagesProvider.overrideWith(
          (ref) async => [
            (
              key: 'core',
              title: 'Courses',
              superBlocks: [
                const SuperBlockSummary(
                  dashedName: 'course',
                  title: 'Responsive Web Design Certification',
                  isPublic: true,
                ),
              ],
            ),
          ],
        ),
        superBlockProvider('course').overrideWith(
          (ref) async => SuperBlock.chapters([
            Chapter(
              dashedName: 'html',
              name: 'HTML',
              modules: [
                Module(
                  dashedName: 'basic-html',
                  name: 'Basic HTML',
                  blocks: [_workshop],
                ),
              ],
            ),
          ]),
        ),
      ],
      child: MaterialApp.router(
        theme: dark ? FccTheme.themeDark : FccTheme.themeLight,
        routerConfig: router,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return router;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await (FontLoader(
      'Lato',
    )..addFont(rootBundle.load('assets/fonts/Lato-Regular.ttf'))).load();
    await (FontLoader(
      'monospace',
    )..addFont(rootBundle.load('assets/fonts/Hack-Regular.ttf'))).load();
  });
  for (final dark in [false, true]) {
    for (final config in [
      (390.0, 1.0),
      (390.0, 2.0),
      (320.0, 2.0),
      (1024.0, 2.0),
    ]) {
      testWidgets(
        'module matches header and compact square grid ${dark ? 'dark' : 'light'} ${config.$1} text ${config.$2}',
        (tester) async {
          await _pump(tester, dark: dark, width: config.$1, scale: config.$2);
          expect(find.text('RESPONSIVE WEB DESIGN · HTML'), findsNothing);
          expect(find.text('Responsive Web Design · HTML'), findsNothing);
          final appBar = tester.widget<AppBar>(find.byType(AppBar));
          final context = tester.element(find.byType(AppBar));
          expect(
            appBar.foregroundColor,
            FccDesignColors.of(context).accentText,
          );
          expect(
            (appBar.title! as Text).style!.color,
            FccDesignColors.of(context).accentText,
          );
          expect(find.byIcon(Icons.chevron_left), findsOneWidget);
          expect(
            tester.widget<Text>(find.text('Basic HTML')).style!.fontWeight,
            FontWeight.w800,
          );
          final eyebrow = tester.getRect(find.text('Workshop'));
          final label = tester.widget<Text>(find.text('Workshop'));
          expect(label.style!.fontFamily, 'Lato');
          expect(label.style!.letterSpacing, 0);
          final count = tester.getRect(find.text('2 of 11 steps'));
          expect(count.top, closeTo(eyebrow.top, .01));
          expect(count.left, greaterThan(eyebrow.right));
          expect(
            count.right,
            closeTo(tester.getRect(find.byType(GridView)).right, .01),
          );
          expect(find.text('Responsive Web Design'), findsOneWidget);
          expect(
            find.text('Responsive Web Design Certification'),
            findsNothing,
          );
          final grid = tester.widget<GridView>(find.byType(GridView));
          final delegate =
              grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
          if (config.$1 == 390 && config.$2 == 1) {
            expect(delegate.crossAxisCount, 6);
          }
          if (config.$1 > 1000) expect(delegate.crossAxisCount, greaterThan(6));
          final buttons = find.descendant(
            of: find.byType(GridView),
            matching: find.byType(TextButton),
          );
          final colors = Theme.of(context).colorScheme;
          final design = FccDesignColors.of(context);
          for (var i = 0; i < 2; i++) {
            final completed = tester.widget<TextButton>(buttons.at(i));
            expect(
              completed.style!.backgroundColor!.resolve({}),
              design.successContainer,
            );
            expect(
              completed.style!.foregroundColor!.resolve({}),
              design.success,
            );
          }
          final current = tester.widget<TextButton>(buttons.at(2));
          expect(
            current.style!.backgroundColor!.resolve({}),
            colors.surfaceContainer,
          );
          expect(
            (current.style!.shape!.resolve({})! as RoundedRectangleBorder)
                .side
                .color,
            colors.primary,
          );
          final pending = tester.widget<TextButton>(buttons.at(3));
          expect(pending.style!.backgroundColor!.resolve({}), colors.surface);
          expect(
            (pending.style!.shape!.resolve({})! as RoundedRectangleBorder)
                .side
                .color,
            colors.outlineVariant,
          );
          for (final element in buttons.evaluate()) {
            final size = (element.renderObject! as RenderBox).size;
            expect(size.width, closeTo(size.height, .01));
            expect(size.width, greaterThanOrEqualTo(48));
            expect(
              size.width,
              lessThan(75),
              reason:
                  'The square should be proportionate to its numeral, including at large text.',
            );
          }
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
  testWidgets(
    'course chevron returns to the course and numbered steps still navigate',
    (tester) async {
      final router = await _pump(tester);
      await tester.tap(find.byTooltip('Back to Responsive Web Design'));
      await tester.pumpAndSettle();
      expect(find.text('Course destination'), findsOneWidget);
      router.go('/module');
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.widgetWithText(TextButton, '3'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, '3'));
      await tester.pumpAndSettle();
      expect(find.text('/learn/course/workshop/step-3'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
