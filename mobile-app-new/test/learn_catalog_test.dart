import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart' hide Block;
import 'package:mobile_app_new/auth/models/user_model.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/controllers/curriculum_controller.dart';
import 'package:mobile_app_new/learn/models/curriculum_model.dart';
import 'package:mobile_app_new/learn/models/daily_challenge_model.dart';
import 'package:mobile_app_new/learn/ui/daily_challenge_archive/daily_challenge_archive_view.dart';
import 'package:mobile_app_new/learn/ui/daily_challenge_archive/daily_challenge_archive_viewmodel.dart';
import 'package:mobile_app_new/learn/ui/landing/landing_view.dart';
import 'package:mobile_app_new/learn/ui/landing/landing_viewmodel.dart';
import 'package:mobile_app_new/learn/ui/module/module_view.dart';
import 'package:mobile_app_new/learn/ui/superblock/superblock_view.dart';
import 'package:mobile_app_new/learn/ui/widgets/block_card.dart';
import 'package:mobile_app_new/services/auth_service.dart';
import 'package:timezone/data/latest.dart' as tz;

final _user = FccUserModel(
  id: 'camper',
  email: 'camper@example.com',
  username: 'camper',
  joinDate: DateTime(2020),
  completedChallenges: [
    CompletedChallenge(id: 'step-1', completedDate: DateTime(2026)),
    CompletedChallenge(id: 'step-2', completedDate: DateTime(2026)),
  ],
  completedDailyCodingChallenges: [
    CompletedDailyChallenge(id: 'daily-1', completedDate: DateTime(2026)),
  ],
);

class _Auth extends AuthNotifier {
  @override
  Future<FccUserModel?> build() async => _user;
  @override
  Future<void> refresh() async {}
}

final _workshop = Block(
  superBlock: 'responsive-web-design-v9',
  dashedName: 'curriculum-outline',
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
final _lecture = Block(
  superBlock: 'responsive-web-design-v9',
  dashedName: 'html-attributes',
  name: 'Understanding HTML Attributes',
  layout: BlockLayout.challengeList,
  label: BlockLabel.lecture,
  description: ['Learn about HTML attributes.'],
  challenges: const [
    ChallengeOrder(id: 'lecture-1', title: 'What are HTML attributes?'),
    ChallengeOrder(id: 'lecture-2', title: 'How do you use HTML attributes?'),
  ],
);
final _lab = Block(
  superBlock: 'responsive-web-design-v9',
  dashedName: 'profile',
  name: "Debug Camperbot's Profile Page",
  layout: BlockLayout.challengeLink,
  label: BlockLabel.lab,
  description: ['Practice your HTML skills.'],
  challenges: const [ChallengeOrder(id: 'lab-1', title: 'Debug the profile')],
);
final _curriculum = SuperBlock.chapters([
  Chapter(
    dashedName: 'html',
    name: 'HTML',
    modules: [
      Module(
        dashedName: 'basic-html',
        name: 'Basic HTML',
        blocks: [_workshop, _lab, _lecture],
      ),
      Module(
        dashedName: 'semantic-html',
        name: 'Semantic HTML',
        blocks: [_lecture],
      ),
    ],
  ),
  Chapter(
    dashedName: 'css',
    name: 'CSS',
    modules: [
      Module(dashedName: 'basic-css', name: 'Basic CSS', blocks: [_lecture]),
    ],
  ),
]);
final _today = DailyChallengeOverview(
  id: 'daily-2',
  challengeNumber: 2,
  date: DateTime(2026, 10, 15),
  title: 'Between Two Buckets',
);
final _yesterday = DailyChallengeOverview(
  id: 'daily-1',
  challengeNumber: 1,
  date: DateTime(2026, 10, 14),
  title: 'Bucket Fill',
);
final _capture = GlobalKey();

Future<GoRouter> _pump(
  WidgetTester tester,
  Widget page, {
  bool dark = false,
  double width = 390,
  double scale = 1,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 844);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (_, _) => page),
      GoRoute(
        path: '/learn/daily-challenges/:day',
        builder: (_, state) => Scaffold(body: Text(state.uri.path)),
      ),
      GoRoute(
        path: '/learn/:course/:block/:id',
        builder: (_, state) => Scaffold(body: Text(state.uri.path)),
      ),
      GoRoute(
        path: '/learn/:course/:module',
        builder: (_, state) => Scaffold(body: Text(state.uri.path)),
      ),
      GoRoute(
        path: '/learn/:course',
        builder: (_, state) => Scaffold(body: Text(state.uri.path)),
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authProvider.overrideWith(_Auth.new),
        curriculumStagesProvider.overrideWith(
          (ref) async => [
            (
              key: 'core',
              title: 'Recommended curriculum',
              superBlocks: const [
                SuperBlockSummary(
                  dashedName: 'responsive-web-design-v9',
                  title: 'Responsive Web Design Certification',
                  isPublic: true,
                ),
                SuperBlockSummary(
                  dashedName: 'javascript-v9',
                  title: 'JavaScript Certification',
                  isPublic: true,
                ),
                SuperBlockSummary(
                  dashedName: 'python-v9',
                  title: 'Python Certification',
                  isPublic: false,
                  isDisabledByOverride: true,
                ),
              ],
            ),
          ],
        ),
        superBlockProvider.overrideWith((ref, name) async => _curriculum),
        dailyChallengeTodayProvider.overrideWith((ref) async => _today),
        dailyChallengeArchiveProvider.overrideWith(
          (ref) async => [
            (month: DateTime(2026, 10), challenges: [_today, _yesterday]),
          ],
        ),
      ],
      child: RepaintBoundary(
        key: _capture,
        child: MaterialApp.router(
          routerConfig: router,
          theme: dark ? FccTheme.themeDark : FccTheme.themeLight,
          debugShowCheckedModeBanner: false,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(scale)),
            child: child!,
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return router;
}

Future<void> _screenshot(WidgetTester tester, String name) async {
  const dir = String.fromEnvironment('UI_SCREENSHOT_DIR');
  if (dir.isEmpty) return;
  await tester.runAsync(() async {
    final image =
        await (_capture.currentContext!.findRenderObject()
                as RenderRepaintBoundary)
            .toImage(pixelRatio: 2);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    await File('$dir/$name.png').create(recursive: true);
    await File('$dir/$name.png').writeAsBytes(bytes!.buffer.asUint8List());
    image.dispose();
  });
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tz.initializeTimeZones();
    await (FontLoader(
      'Lato',
    )..addFont(rootBundle.load('assets/fonts/Lato-Regular.ttf'))).load();
    await (FontLoader(
      'monospace',
    )..addFont(rootBundle.load('assets/fonts/Hack-Regular.ttf'))).load();
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
  });

  for (final dark in [false, true]) {
    final mode = dark ? 'dark' : 'light';
    testWidgets('Catalog keeps course availability and navigation in $mode', (
      tester,
    ) async {
      final router = await _pump(tester, const LearnLandingView(), dark: dark);
      await _screenshot(tester, 'learn-catalog-$mode');
      await tester.ensureVisible(find.text('Python Certification'));
      await tester.tap(find.text('Python Certification'));
      await tester.pumpAndSettle();
      expect(
        find.text('Temporarily unavailable, come back soon.'),
        findsOneWidget,
      );
      expect(router.routeInformationProvider.value.uri.path, '/');
      await tester.ensureVisible(find.text('JavaScript Certification'));
      await tester.tap(find.text('JavaScript Certification'));
      await tester.pumpAndSettle();
      expect(find.text('/learn/javascript-v9'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
    testWidgets('Course progress uses actual completed steps in $mode', (
      tester,
    ) async {
      await _pump(
        tester,
        const SuperBlockView(dashedName: 'responsive-web-design-v9'),
        dark: dark,
      );
      expect(find.text('2 of 18 steps complete'), findsOneWidget);
      await _screenshot(tester, 'learn-course-$mode');
      await tester.tap(find.widgetWithText(FilledButton, 'Continue'));
      await tester.pumpAndSettle();
      expect(
        find.text('/learn/responsive-web-design-v9/curriculum-outline/step-3'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
    testWidgets('Module progress and step navigation in $mode', (tester) async {
      await _pump(
        tester,
        const ModuleView(
          superBlock: 'responsive-web-design-v9',
          module: 'basic-html',
        ),
        dark: dark,
      );
      expect(find.text('2 of 11 steps'), findsOneWidget);
      await _screenshot(tester, 'learn-module-$mode');
      await tester.tap(find.text('Continue step 3'));
      await tester.pumpAndSettle();
      expect(
        find.text('/learn/responsive-web-design-v9/curriculum-outline/step-3'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
    testWidgets('Archive filters actual completions in $mode', (tester) async {
      await _pump(tester, const DailyChallengeArchiveView(), dark: dark);
      expect(find.text('1 of 2 done'), findsOneWidget);
      await _screenshot(tester, 'learn-daily-$mode');
      await tester.tap(find.widgetWithText(ChoiceChip, 'Done'));
      await tester.pumpAndSettle();
      expect(find.text('Bucket Fill'), findsOneWidget);
      expect(
        find.text('Between Two Buckets'),
        findsOneWidget,
      ); // Today card remains visible.
      await tester.tap(find.widgetWithText(ChoiceChip, 'Not done yet'));
      await tester.pumpAndSettle();
      expect(find.text('Bucket Fill'), findsNothing);
      expect(find.text('Between Two Buckets'), findsNWidgets(2));
      expect(tester.takeException(), isNull);
    });
  }
  for (final page in <Widget>[
    const LearnLandingView(),
    const SuperBlockView(dashedName: 'responsive-web-design-v9'),
    const ModuleView(
      superBlock: 'responsive-web-design-v9',
      module: 'basic-html',
    ),
    const DailyChallengeArchiveView(),
  ]) {
    testWidgets('${page.runtimeType} supports narrow screens and large text', (
      tester,
    ) async {
      await _pump(tester, page, width: 320, scale: 1.6);
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -600));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('Long step grids remain scrollable with large text', (
    tester,
  ) async {
    final block = _workshop.copyWith(
      challenges: [
        for (var i = 1; i <= 20; i++)
          ChallengeOrder(id: 'step-$i', title: 'Step $i'),
      ],
    );
    await _pump(
      tester,
      Scaffold(
        body: SingleChildScrollView(
          child: BlockCard(block: block, isOpen: true, onToggle: () {}),
        ),
      ),
      scale: 1.6,
    );
    await tester.ensureVisible(find.byType(GridView));
    await tester.drag(find.byType(GridView), const Offset(0, -250));
    await tester.pumpAndSettle();
    await tester.tap(find.text('20'));
    await tester.pumpAndSettle();
    expect(
      find.text('/learn/responsive-web-design-v9/curriculum-outline/step-20'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
  testWidgets('Empty blocks do not claim completion or offer a broken start', (
    tester,
  ) async {
    await _pump(
      tester,
      Scaffold(
        body: BlockCard(
          block: _lab.copyWith(challenges: []),
          isOpen: true,
          onToggle: () {},
        ),
      ),
    );
    expect(find.text('No challenges available right now.'), findsOneWidget);
    expect(find.byType(FilledButton), findsNothing);
    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      0,
    );
  });
}
