import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/auth/models/user_model.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/constants/curriculum.dart';
import 'package:freecodecamp/learn/controllers/curriculum_controller.dart';
import 'package:freecodecamp/learn/models/curriculum_model.dart';
import 'package:freecodecamp/learn/models/daily_challenge_model.dart';
import 'package:freecodecamp/learn/ui/daily_challenge_archive/daily_challenge_archive_view.dart';
import 'package:freecodecamp/learn/ui/daily_challenge_archive/daily_challenge_archive_viewmodel.dart';
import 'package:freecodecamp/learn/ui/landing/landing_view.dart';
import 'package:freecodecamp/learn/ui/landing/landing_viewmodel.dart';
import 'package:freecodecamp/learn/ui/module/module_view.dart';
import 'package:freecodecamp/learn/ui/superblock/superblock_view.dart';
import 'package:freecodecamp/learn/ui/widgets/block_card.dart';
import 'package:freecodecamp/services/audio_service.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:go_router/go_router.dart' hide Block;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as timezone;

import 'support/fake_audio_handler.dart';

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

class _GuestAuth extends AuthNotifier {
  @override
  Future<FccUserModel?> build() async => null;
  @override
  Future<void> refresh() async {}
}

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
  double height = 844,
  bool guest = false,
  bool settle = true,
  SuperBlock? courseData,
  Future<DailyChallengeOverview> Function()? todayLoader,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, height);
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
      key: UniqueKey(),
      overrides: [
        audioHandlerProvider.overrideWithValue(FakeAudioHandler()),
        authProvider.overrideWith(guest ? _GuestAuth.new : _Auth.new),
        curriculumStagesProvider.overrideWith(
          (ref) async => [
            (
              key: 'core',
              title: stageTitles['core']!,
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
        superBlockProvider.overrideWith(
          (ref, name) async => courseData ?? _curriculum,
        ),
        dailyChallengeTodayProvider.overrideWith(
          (ref) async => todayLoader == null ? _today : todayLoader(),
        ),
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
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump(const Duration(milliseconds: 100));
  }
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
    await (FontLoader('Lato')
          ..addFont(rootBundle.load('assets/fonts/Lato-Regular.ttf'))
          ..addFont(rootBundle.load('assets/fonts/Lato-Bold.ttf'))
          ..addFont(rootBundle.load('assets/fonts/Lato-ExtraBold.ttf'))
          ..addFont(rootBundle.load('assets/fonts/Lato-Black.ttf')))
        .load();
    await (FontLoader(
      'monospace',
    )..addFont(rootBundle.load('assets/fonts/Hack-Regular.ttf'))).load();
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
  });

  testWidgets('resume and first-time actions open the actual step', (
    tester,
  ) async {
    await _pump(tester, const LearnLandingView());
    await tester.tap(find.text('Continue step 3'));
    await tester.pumpAndSettle();
    expect(
      find.text('/learn/responsive-web-design-v9/curriculum-outline/step-3'),
      findsOneWidget,
    );
    await _pump(tester, const LearnLandingView(), guest: true);
    await tester.tap(find.text('Start step 1'));
    await tester.pumpAndSettle();
    expect(
      find.text('/learn/responsive-web-design-v9/curriculum-outline/step-1'),
      findsOneWidget,
    );
  });
  testWidgets('daily loading retains section and failure can retry', (
    tester,
  ) async {
    final pending = Completer<DailyChallengeOverview>();
    await _pump(
      tester,
      const LearnLandingView(),
      todayLoader: () => pending.future,
      settle: false,
    );
    expect(find.text('Loading today’s challenge…'), findsOneWidget);
    pending.completeError(StateError('Offline'));
    await tester.pump();
    await tester.pump();
    expect(find.text('Could not load today’s challenge.'), findsOneWidget);
    var attempts = 0;
    await _pump(
      tester,
      const LearnLandingView(),
      todayLoader: () async {
        if (attempts++ == 0) throw StateError('Offline');
        return _today;
      },
      settle: false,
    );
    await tester.pump();
    await tester.tap(find.widgetWithText(OutlinedButton, 'Try again'));
    await tester.pumpAndSettle();
    expect(find.text('Between Two Buckets'), findsOneWidget);
    expect(attempts, 2);
  });
  testWidgets('daily challenge refreshes at midnight without a countdown', (
    tester,
  ) async {
    var requests = 0;
    await _pump(
      tester,
      const LearnLandingView(),
      todayLoader: () async {
        requests++;
        return _today;
      },
    );
    expect(requests, 1);
    expect(find.textContaining('New in '), findsNothing);
    final chicago = timezone.getLocation('America/Chicago');
    final now = timezone.TZDateTime.now(chicago);
    final midnight = timezone.TZDateTime(
      chicago,
      now.year,
      now.month,
      now.day + 1,
    );
    await tester.pump(midnight.difference(now) + const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(requests, 2);
    expect(find.textContaining('New in '), findsNothing);
  });

  testWidgets('certification exam opens its website anchor', (tester) async {
    const channel = MethodChannel(
      'plugins.flutter.droibit.github.io/custom_tabs',
    );
    final urls = <String>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          if (call.method == 'launch') {
            urls.add((call.arguments as Map)['url'] as String);
          }
          return null;
        });
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null),
    );
    await _pump(
      tester,
      const SuperBlockView(dashedName: 'responsive-web-design-v9'),
      courseData: const SuperBlock.chapters([
        Chapter(dashedName: 'html', name: 'HTML', modules: []),
        Chapter(dashedName: 'css', name: 'CSS', modules: []),
        Chapter(
          dashedName: 'accessibility',
          name: 'Accessibility',
          modules: [],
        ),
        Chapter(
          dashedName: 'responsive-web-design-certification-exam',
          name: 'Certification Exam',
          modules: [],
        ),
      ]),
    );
    await tester.ensureVisible(find.text('Open exam on website'));
    await tester.pumpAndSettle();
    expect(find.text('Chapter 4'), findsOneWidget);
    expect(find.text('Finish line'), findsNothing);
    expect(find.text('FINISH LINE'), findsNothing);
    await _screenshot(tester, 'learn-exam-chapter');
    await tester.tap(find.text('Open exam on website'));
    await tester.pumpAndSettle();
    expect(urls, [
      'https://www.freecodecamp.org/learn/responsive-web-design-v9/#responsive-web-design-certification-exam',
    ]);
  });
  for (final dark in [false, true]) {
    final mode = dark ? 'dark' : 'light';
    testWidgets('Catalog keeps course availability and navigation in $mode', (
      tester,
    ) async {
      final router = await _pump(tester, const LearnLandingView(), dark: dark);
      expect(find.byType(Drawer), findsNothing);
      expect(find.byType(DrawerButton), findsNothing);
      expect(find.text('CONTINUE'), findsNothing);
      expect(find.text('Continue'), findsNothing);
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text('Courses'),
        ),
        findsOneWidget,
      );
      expect(find.textContaining('New in '), findsNothing);
      expect(find.bySemanticsLabel(RegExp('Countdown timer')), findsNothing);
      final dailyLabel = tester.widget<Text>(find.text('Daily challenge'));
      expect(dailyLabel.style!.fontFamily, 'Lato');
      expect(dailyLabel.style!.letterSpacing, 0);
      expect(find.textContaining('still in beta'), findsNothing);
      expect(find.text('Daily challenge archive'), findsNothing);
      expect(find.text('Past challenges'), findsOneWidget);
      final course = find.text('Responsive Web Design Certification').first;
      final workshop = find.text('Build a Curriculum Outline');
      expect(
        tester.getTopLeft(course).dy,
        lessThan(tester.getTopLeft(workshop).dy),
      );
      final counter = tester.getRect(find.text('2 of 11 steps'));
      final bar = tester.getRect(find.byType(LinearProgressIndicator).first);
      expect(counter.center.dy, closeTo(bar.center.dy, 1));
      expect(counter.left, greaterThan(bar.right));
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
    testWidgets(
      'Guest catalog keeps the same Continue card hierarchy in $mode',
      (tester) async {
        await _pump(tester, const LearnLandingView(), dark: dark, guest: true);
        expect(find.text('CONTINUE'), findsNothing);
        expect(find.text('Continue'), findsNothing);
        expect(find.text('Sign in to save your progress'), findsNothing);
        expect(find.text('Start step 1'), findsOneWidget);
        expect(find.text('0 of 11 steps'), findsOneWidget);
        await _screenshot(tester, 'learn-catalog-guest-$mode');
      },
    );
    testWidgets('Course progress uses actual completed steps in $mode', (
      tester,
    ) async {
      await _pump(
        tester,
        const SuperBlockView(dashedName: 'responsive-web-design-v9'),
        dark: dark,
      );
      expect(find.text('2 of 18 steps complete'), findsOneWidget);
      expect(find.text('Certification'), findsNothing);
      expect(find.text('2 chapters · 3 modules'), findsNothing);
      expect(find.textContaining('Next:'), findsNothing);
      expect(find.text('2 modules'), findsNothing);
      expect(find.text('1 module'), findsNothing);
      expect(find.text('3 blocks · 2/14 steps'), findsNothing);
      expect(find.text('2/14 steps'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text('Courses'),
        ),
        findsOneWidget,
      );
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
      expect(find.text('RESPONSIVE WEB DESIGN · HTML'), findsNothing);
      expect(find.text('Responsive Web Design · HTML'), findsNothing);
      final count = tester.getRect(find.text('2 of 11 steps'));
      final label = tester.getRect(find.text('Workshop'));
      final progress = tester.getRect(
        find.byType(LinearProgressIndicator).first,
      );
      expect(count.top, closeTo(label.top, 1));
      expect(count.right, closeTo(progress.right, 1));
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
      expect(find.textContaining('New in '), findsNothing);
      expect(find.bySemanticsLabel(RegExp('Countdown timer')), findsNothing);
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
  testWidgets('flat courses keep progress and the next-step action', (
    tester,
  ) async {
    await _pump(
      tester,
      const SuperBlockView(dashedName: 'responsive-web-design-v9'),
      courseData: SuperBlock.blocks([_workshop, _lecture]),
    );
    expect(find.text('2 blocks'), findsNothing);
    expect(find.text('2 of 13 steps complete'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Continue'));
    await tester.pumpAndSettle();
    expect(
      find.text('/learn/responsive-web-design-v9/curriculum-outline/step-3'),
      findsOneWidget,
    );
  });
  for (final title in ['HTML Review', 'HTML Concepts']) {
    testWidgets('review type stays identifiable and opens $title', (
      tester,
    ) async {
      await _pump(
        tester,
        const SuperBlockView(dashedName: 'responsive-web-design-v9'),
        courseData: SuperBlock.chapters([
          Chapter(
            dashedName: 'html',
            name: 'HTML',
            modules: [
              Module(
                dashedName: 'html-review',
                name: title,
                blocks: [
                  _lecture.copyWith(
                    label: BlockLabel.review,
                    challenges: const [
                      ChallengeOrder(id: 'review-1', title: 'HTML Review'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ]),
      );
      expect(
        find.text('Review'),
        title == 'HTML Review' ? findsNothing : findsOneWidget,
      );
      await tester.tap(find.text(title));
      await tester.pumpAndSettle();
      expect(
        find.text('/learn/responsive-web-design-v9/html-attributes/review-1'),
        findsOneWidget,
      );
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
  for (final dark in [false, true]) {
    for (final viewport in [
      const Size(320, 640),
      const Size(844, 390),
      const Size(768, 1024),
    ]) {
      for (final page in <Widget>[
        const LearnLandingView(),
        const SuperBlockView(dashedName: 'responsive-web-design-v9'),
        const ModuleView(
          superBlock: 'responsive-web-design-v9',
          module: 'basic-html',
        ),
        const DailyChallengeArchiveView(),
      ]) {
        testWidgets(
          'audit ${page.runtimeType} ${dark ? "dark" : "light"} $viewport at 200% text',
          (tester) async {
            await _pump(
              tester,
              page,
              dark: dark,
              width: viewport.width,
              height: viewport.height,
              scale: 2,
            );
            expect(find.byType(NavigationDestination), findsNWidgets(5));
            expect(tester.takeException(), isNull);
            await tester.drag(
              find.byType(Scrollable).first,
              const Offset(0, -1200),
            );
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull);
          },
        );
      }
    }
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
