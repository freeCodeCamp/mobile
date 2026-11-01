import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/auth/models/user_model.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/controllers/curriculum_controller.dart';
import 'package:freecodecamp/learn/models/curriculum_model.dart';
import 'package:freecodecamp/learn/models/daily_challenge_model.dart';
import 'package:freecodecamp/learn/ui/landing/landing_view.dart';
import 'package:freecodecamp/learn/ui/landing/landing_viewmodel.dart';
import 'package:freecodecamp/learn/ui/landing/learning_resume.dart';
import 'package:freecodecamp/learn/ui/module/module_view.dart';
import 'package:freecodecamp/learn/ui/widgets/block_card.dart';
import 'package:freecodecamp/services/audio_service.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:go_router/go_router.dart' hide Block;
import 'package:timezone/data/latest.dart' as tz;

const _course = SuperBlockSummary(
  dashedName: 'responsive-web-design',
  title: 'Responsive Web Design Certification',
  isPublic: true,
);
final _block = Block(
  superBlock: _course.dashedName,
  dashedName: 'curriculum-outline',
  name: 'Build a Curriculum Outline',
  layout: BlockLayout.challengeGrid,
  label: BlockLabel.workshop,
  description: ['Build your first page.'],
  challenges: List.generate(
    11,
    (i) => ChallengeOrder(id: 'step-$i', title: 'Step ${i + 1}'),
  ),
);
final _blocks = List.generate(
  10,
  (i) => i == 0
      ? _block
      : _block.copyWith(dashedName: 'block-$i', name: 'Workshop $i'),
);
final _curriculum = SuperBlock.chapters([
  Chapter(
    dashedName: 'html',
    name: 'HTML',
    modules: [
      Module(dashedName: 'basic-html', name: 'Basic HTML', blocks: _blocks),
    ],
  ),
]);

class _Auth extends AuthNotifier {
  _Auth(this.returning);
  final bool returning;
  @override
  Future<FccUserModel?> build() async => returning
      ? FccUserModel(
          id: 'test',
          email: 'test@example.invalid',
          username: 'camper',
          joinDate: DateTime(2024),
          currentChallengeId: 'step-1',
        )
      : null;
}

class _Audio extends BaseAudioHandler implements AudioPlayerHandler {
  @override
  String? get codeRadioSongId => null;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<void> _pump(
  WidgetTester tester,
  Widget screen, {
  bool returning = false,
  bool dark = true,
  double scale = 1,
}) async {
  final router = GoRouter(
    initialLocation: '/test',
    routes: [
      GoRoute(path: '/test', builder: (_, _) => screen),
      GoRoute(
        path: '/login',
        builder: (_, _) => const Scaffold(body: Text('Login destination')),
      ),
      GoRoute(
        path: '/learn/:course/:block/:id',
        builder: (_, state) =>
            Scaffold(body: Text('Challenge ${state.pathParameters['id']}')),
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authProvider.overrideWith(() => _Auth(returning)),
        audioHandlerProvider.overrideWithValue(_Audio()),
        curriculumStagesProvider.overrideWith(
          (ref) async => [
            (
              key: 'core',
              title: 'Recommended curriculum',
              superBlocks: [_course],
            ),
          ],
        ),
        superBlockProvider(
          _course.dashedName,
        ).overrideWith((ref) async => _curriculum),
        learningResumeProvider.overrideWith(
          (ref) async => LearningResume(
            course: _course,
            block: _block,
            challenge: _block.challenges[returning ? 1 : 0],
            completed: returning ? 1 : 0,
            isReturning: returning,
          ),
        ),
        dailyChallengeTodayProvider.overrideWith(
          (ref) async => DailyChallengeOverview(
            id: 'daily',
            challengeNumber: 1,
            date: DateTime(2026, 10, 29),
            title: 'Palindrome',
          ),
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
}

void main() {
  setUpAll(tz.initializeTimeZones);
  testWidgets(
    'HN1 guest hero offers first course and sign in without returning progress',
    (tester) async {
      await _pump(tester, const LearnLandingView());
      expect(find.text('New here? Start here'), findsOneWidget);
      expect(
        find.text('Learn to code for free, one short hands-on step at a time.'),
        findsOneWidget,
      );
      expect(
        find.text('First up: Build a Curriculum Outline · 11 steps'),
        findsOneWidget,
      );
      expect(find.text('0 of 11 steps'), findsNothing);
      await tester.ensureVisible(find.text('Sign in'));
      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();
      expect(find.text('Login destination'), findsOneWidget);
    },
  );
  testWidgets('HN1 returning learner keeps progress and current step', (
    tester,
  ) async {
    await _pump(tester, const LearnLandingView(), returning: true);
    expect(find.text('New here? Start here'), findsNothing);
    expect(find.text('1 of 11 steps'), findsOneWidget);
    expect(find.text('Continue step 2'), findsOneWidget);
  });
  testWidgets(
    'M2 module action stays fixed while blocks scroll and opens current challenge',
    (tester) async {
      await _pump(
        tester,
        const ModuleView(
          superBlock: 'responsive-web-design',
          module: 'basic-html',
        ),
      );
      expect(find.byType(BlockActionButton), findsOneWidget);
      final position = tester.getTopLeft(find.byType(ModuleActionBar));
      await tester.drag(find.byType(ListView).first, const Offset(0, -400));
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(find.byType(ModuleActionBar)), position);
      await tester.tap(find.text('Start workshop'));
      await tester.pumpAndSettle();
      expect(find.text('Challenge step-0'), findsOneWidget);
    },
  );
  for (final dark in [false, true]) {
    testWidgets(
      'Courses and Module stay usable at360dp1.3 ${dark ? 'dark' : 'light'}',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(360, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await _pump(tester, const LearnLandingView(), dark: dark, scale: 1.3);
        expect(tester.takeException(), isNull);
        await tester.drag(
          find.byType(SingleChildScrollView).first,
          const Offset(0, -600),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
        await _pump(
          tester,
          const ModuleView(
            superBlock: 'responsive-web-design',
            module: 'basic-html',
          ),
          dark: dark,
          scale: 1.3,
        );
        expect(tester.takeException(), isNull);
        expect(
          tester.getSize(find.byType(BlockActionButton)).height,
          greaterThanOrEqualTo(52),
        );
      },
    );
  }
}
