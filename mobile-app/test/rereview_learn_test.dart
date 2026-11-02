import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/auth/models/user_model.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/controllers/curriculum_controller.dart';
import 'package:freecodecamp/learn/models/curriculum_model.dart';
import 'package:freecodecamp/learn/models/daily_challenge_model.dart';
import 'package:freecodecamp/learn/ui/daily_challenge_archive/daily_challenge_archive_view.dart';
import 'package:freecodecamp/learn/ui/daily_challenge_archive/daily_challenge_archive_viewmodel.dart';
import 'package:freecodecamp/learn/ui/landing/daily_challenge_card.dart';
import 'package:freecodecamp/learn/ui/landing/landing_view.dart';
import 'package:freecodecamp/learn/ui/landing/landing_viewmodel.dart';
import 'package:freecodecamp/learn/ui/landing/learning_resume.dart';
import 'package:freecodecamp/learn/ui/module/module_view.dart';
import 'package:freecodecamp/learn/ui/superblock/superblock_view.dart';
import 'package:freecodecamp/learn/ui/widgets/block_card.dart';
import 'package:freecodecamp/learn/ui/widgets/challenge_grid.dart';
import 'package:freecodecamp/learn/ui/widgets/dialogue_block_card.dart';
import 'package:freecodecamp/learn/ui/widgets/exam_card.dart';
import 'package:freecodecamp/learn/ui/widgets/learn_presentation.dart';
import 'package:freecodecamp/learn/utils/learning_action.dart';
import 'package:freecodecamp/services/audio_service.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:go_router/go_router.dart' hide Block;
import 'package:timezone/data/latest.dart' as tz;
import 'rereview_learn_fonts.dart';

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
final _chapters = [
  for (final (index, count) in [6, 1, 21, 1].indexed)
    Chapter(
      dashedName: index == 3
          ? 'responsive-web-design-certification-exam'
          : 'chapter-$index',
      name: ['HTML', 'Computers', 'CSS', 'Exam'][index],
      modules: [
        for (var i = 0; i < count; i++)
          Module(
            dashedName: 'module-$index-$i',
            name: i == 0 && index == 0 ? 'Basic HTML' : 'Module $index-$i',
            blocks: [
              if (i == 0 && index == 0)
                _block
              else
                _block.copyWith(
                  dashedName: 'block-$index-$i',
                  challenges: [
                    ChallengeOrder(id: 'extra-$index-$i', title: 'Step 1'),
                  ],
                ),
            ],
          ),
      ],
    ),
];
final _curriculum = SuperBlock.chapters(_chapters);
final _daily = DailyChallengeOverview(
  id: 'daily',
  challengeNumber: 80,
  date: DateTime(2026, 11, 2),
  title: 'Palindrome',
);

class _Auth extends AuthNotifier {
  _Auth(this.user);
  final FccUserModel? user;
  @override
  Future<FccUserModel?> build() async => user;
  @override
  Future<void> refresh() async {}
}

class _Audio extends BaseAudioHandler implements AudioPlayerHandler {
  @override
  String? get codeRadioSongId => null;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

FccUserModel _user(Set<String> done, {String? current}) => FccUserModel(
  id: 'test',
  email: 'test@example.invalid',
  username: 'learner',
  joinDate: DateTime(2024),
  currentChallengeId: current,
  completedChallenges: [
    for (final id in done)
      CompletedChallenge(id: id, completedDate: DateTime(2026)),
  ],
);

Future<void> _pump(
  WidgetTester tester,
  Widget screen, {
  FccUserModel? user,
  bool dark = true,
  double scale = 1,
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final router = GoRouter(
    initialLocation: '/test',
    routes: [
      GoRoute(path: '/test', builder: (_, _) => screen),
      GoRoute(
        path: '/learn/:course/:block/:id',
        builder: (_, state) =>
            Scaffold(body: Text('Opened ${state.pathParameters['id']}')),
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authProvider.overrideWith(() => _Auth(user)),
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
          (ref) async => resolveLearningResume([(_course, _curriculum)], user),
        ),
        dailyChallengeTodayProvider.overrideWith((ref) async => _daily),
        dailyChallengeArchiveProvider.overrideWith(
          (ref) async => [
            (month: DateTime(2026, 11), challenges: [_daily]),
          ],
        ),
      ],
      child: MaterialApp.router(
        theme: dark ? FccTheme.themeDark : FccTheme.themeLight,
        routerConfig: router,
        builder: (context, child) => RepaintBoundary(
          key: const ValueKey('rereview-capture'),
          child: MediaQuery(
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
  await captureLearningDesign(
    tester,
    '${screen.runtimeType}-${dark ? 'dark' : 'light'}-${user == null
        ? 'guest'
        : user.completedChallenges.isEmpty
        ? 'new'
        : 'returning'}-$scale',
  );
}

TextStyle _rendered(WidgetTester tester, String text) => tester
    .widget<RichText>(
      find.descendant(of: find.text(text), matching: find.byType(RichText)),
    )
    .text
    .style!;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadLearningDesignFonts);
  setUpAll(tz.initializeTimeZones);
  test('CHAP-N1 shared resume chooses same progress, step and wording', () {
    for (final done in [
      <String>{},
      {'step-0'},
      {'step-0', 'step-1'},
    ]) {
      final action = resolveLearningAction([_block], done)!;
      expect(
        action.label(),
        done.isEmpty ? 'Start step 1' : 'Continue step ${done.length + 1}',
      );
      expect(action.label(chapter: true), done.isEmpty ? 'Start' : 'Continue');
    }
    final allDone = _block.challenges.map((c) => c.id).toSet();
    final second = _block.copyWith(
      challenges: [const ChallengeOrder(id: 'new', title: 'Step 1')],
    );
    final action = resolveLearningAction([_block, second], allDone)!;
    expect(action.next?.id, 'new');
    expect(action.label(), 'Continue step 1');
    expect(resolveLearningAction([_block], allDone)!.label(), 'Review steps');
    expect(
      resolveLearningAction(
        [_block],
        {},
        currentChallengeId: 'step-4',
      )!.label(),
      'Start step 1',
    );
    expect(
      resolveLearningResume([(_course, _curriculum)], null)!.action.label(),
      'Start step 1',
    );
    expect(
      resolveLearningAction(
        [_block],
        {'step-0'},
        currentChallengeId: 'step-4',
      )!.label(),
      'Continue step 5',
    );
  });

  test('CTA labels number steps and lectures, never single-unit blocks', () {
    Block of(BlockLabel label, {BlockLayout? layout}) => _block.copyWith(
      label: label,
      layout: layout ?? _block.layout,
      challenges: [
        for (var i = 0; i < 3; i++)
          ChallengeOrder(id: '$label-$i', title: 'Item'),
      ],
    );
    String label(Block block, Set<String> done) =>
        resolveLearningAction([block], done)!.label();

    final lecture = of(BlockLabel.lecture);
    expect(label(lecture, {}), 'Start lecture 1');
    expect(label(lecture, {'BlockLabel.lecture-0'}), 'Continue lecture 2');
    expect(
      label(lecture, lecture.challenges.map((c) => c.id).toSet()),
      'Review lectures',
    );

    for (final (kind, unit) in [
      (BlockLabel.lab, 'lab'),
      (BlockLabel.quiz, 'quiz'),
      (BlockLabel.review, 'review'),
    ]) {
      final block = of(kind);
      expect(label(block, {}), 'Start $unit');
      expect(label(block, {'$kind-0'}), 'Continue $unit');
      expect(
        label(block, block.challenges.map((c) => c.id).toSet()),
        kind == BlockLabel.review ? 'Review' : 'Review $unit',
      );
      expect(blockUnitCount(block), isNull);
      expect(blockUnitCount(block, done: 1), isNull);
    }
    // Exams are left out of resume targets, so build the action directly.
    final exam = of(BlockLabel.exam);
    expect(
      LearningAction(
        block: exam,
        next: exam.challenges.first,
        hasProgress: false,
      ).label(),
      'Start exam',
    );

    final tasks = of(BlockLabel.learn, layout: BlockLayout.challengeDialogue);
    expect(label(tasks, {'BlockLabel.learn-0'}), 'Continue task 2');
    expect(blockUnitCount(tasks), '3 tasks');

    expect(blockUnitCount(_block), '11 steps');
    expect(blockUnitCount(_block, done: 1), '1 of 11 steps');
    expect(blockUnitCount(lecture, done: 0), '0 of 3 lectures');
    expect(label(_block, {}), 'Start step 1');
    expect(resolveLearningAction([_block], {})!.label(chapter: true), 'Start');
  });

  testWidgets('chapter rail runs through the centre of every module dot', (
    tester,
  ) async {
    await _pump(
      tester,
      const SuperBlockView(dashedName: 'responsive-web-design'),
    );
    final rail = find.byKey(const ValueKey('chapter-module-rail'));
    expect(rail, findsOneWidget);
    final railCentre = tester.getCenter(rail).dx;
    final dots = find.descendant(
      of: find.ancestor(of: rail, matching: find.byType(Stack)).first,
      matching: find.byType(LearnStatus),
    );
    expect(dots, findsNWidgets(_chapters.first.modules.length));
    for (final dot in tester.elementList(dots)) {
      expect(
        tester.getCenter(find.byElementPredicate((e) => e == dot)).dx,
        closeTo(railCentre, .5),
      );
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'USER-welcome no-progress member sees essentials rather than resume',
    (tester) async {
      await _pump(
        tester,
        const LearnLandingView(),
        user: _user({}, current: 'step-4'),
      );
      expect(find.byType(FirstVisitHero), findsOneWidget);
      expect(
        find.text('Choose a certification or start with the essentials.'),
        findsOneWidget,
      );
      expect(find.text('Start step 1'), findsOneWidget);
      expect(find.text('Sign in'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'USER-labs linked lab opens when module suppresses per-block buttons',
    (tester) async {
      final lab = _block.copyWith(
        dashedName: 'lab',
        name: 'Build a lab',
        label: BlockLabel.lab,
        layout: BlockLayout.challengeLink,
        challenges: [
          const ChallengeOrder(id: 'lab-challenge', title: 'Build a lab'),
        ],
      );
      await _pump(
        tester,
        Scaffold(
          body: BlockList(
            blocks: [lab],
            padding: const EdgeInsets.all(16),
            showActions: false,
          ),
        ),
      );
      expect(find.byType(BlockActionButton), findsNothing);
      await tester.tap(find.text('Build a lab'));
      await tester.pumpAndSettle();
      expect(find.text('Opened lab-challenge'), findsOneWidget);
    },
  );

  testWidgets('HN1 guest hero measures compact inline signin and type', (
    tester,
  ) async {
    await _pump(tester, const LearnLandingView());
    expect(find.text('Start step 1'), findsOneWidget);
    final sign = find.widgetWithText(OutlinedButton, 'Sign in');
    expect(tester.getSize(sign).height, 48);
    expect(_rendered(tester, 'Sign in').fontSize, 14);
    expect(_rendered(tester, 'Sign in').fontWeight, FontWeight.w700);
    final sentence = tester.getRect(
      find.text('Already learning? Sign in to pick up where you left off.'),
    );
    expect(tester.getRect(sign).left, greaterThan(sentence.right));
    expect(find.text('New here? Start here'), findsNothing);
    final intro = _rendered(
      tester,
      'Choose a certification or start with the essentials.',
    );
    expect(intro.fontSize, 15);
    expect(intro.height, 1.45);
    expect(tester.takeException(), isNull);
  });

  testWidgets('HOME-N1 HOME-N2 HOME-N3 home progress gap and daily CTA', (
    tester,
  ) async {
    await _pump(tester, const LearnLandingView(), user: _user({'step-0'}));
    expect(
      tester.getSize(find.byType(LinearProgressIndicator).first).height,
      8,
    );
    final hero = find
        .ancestor(
          of: find.text('Continue step 2'),
          matching: find.byType(Container),
        )
        .first;
    final daily = find.byType(DailyChallengeCard);
    final dailyPaint = find
        .descendant(of: daily, matching: find.byType(DecoratedBox))
        .first;
    expect(tester.getRect(dailyPaint).top - tester.getRect(hero).bottom, 16);
    final button = find.widgetWithText(OutlinedButton, 'Start challenge');
    expect(tester.getSize(button).height, 48);
    expect(_rendered(tester, 'Start challenge').fontSize, 16);
    expect(_rendered(tester, 'Start challenge').fontWeight, FontWeight.w700);
    expect(_rendered(tester, 'Past challenges').fontSize, 15);
    expect(
      tester.getRect(find.text('Palindrome')).top -
          tester.getRect(find.text('Daily challenge')).bottom,
      2,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'CHAP-N1 home chapters and module share current target and label',
    (tester) async {
      final user = _user({'step-0'}, current: 'step-4');
      await _pump(tester, const LearnLandingView(), user: user);
      expect(find.text('Continue step 5'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      await _pump(
        tester,
        const SuperBlockView(dashedName: 'responsive-web-design'),
        user: user,
      );
      expect(find.text('Continue'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(find.text('Opened step-4'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      await _pump(
        tester,
        const ModuleView(
          superBlock: 'responsive-web-design',
          module: 'module-0-0',
        ),
        user: user,
      );
      expect(find.text('Continue step 5'), findsOneWidget);
      final currentTile = tester.widget<TextButton>(
        find.widgetWithText(TextButton, '5'),
      );
      final otherTile = tester.widget<TextButton>(
        find.widgetWithText(TextButton, '2'),
      );
      expect(currentTile.style!.side!.resolve({})!.width, 2);
      expect(otherTile.style!.side!.resolve({})!.width, 1);
      await tester.tap(find.text('Continue step 5'));
      await tester.pumpAndSettle();
      expect(find.text('Opened step-4'), findsOneWidget);
    },
  );

  testWidgets('CHAP-N1 saved later block expands its current challenge', (
    tester,
  ) async {
    final later = _block.copyWith(
      dashedName: 'later-block',
      name: 'Later workshop',
      challenges: const [
        ChallengeOrder(id: 'later-0', title: 'Step 1'),
        ChallengeOrder(id: 'later-1', title: 'Step 2'),
      ],
    );
    await _pump(
      tester,
      Scaffold(
        body: BlockList(
          blocks: [_block, later],
          padding: const EdgeInsets.all(16),
        ),
      ),
      user: _user({'step-0'}, current: 'later-1'),
    );
    expect(find.byType(ChallengeGrid), findsOneWidget);
    final grid = tester.widget<ChallengeGrid>(find.byType(ChallengeGrid));
    expect(grid.challenges, later.challenges);
    expect(grid.currentChallengeId, 'later-1');
    expect(find.text('Continue step 2'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('CHAP-N1 dialogue current task agrees with resume at 1.3 scale', (
    tester,
  ) async {
    final dialogue = _block.copyWith(
      layout: BlockLayout.challengeDialogue,
      name: 'Greetings at the office',
      challenges: [
        const ChallengeOrder(
          id: 'dialogue',
          title: 'Dialogue 1: First greeting',
        ),
        for (var i = 0; i < 5; i++)
          ChallengeOrder(id: 'task-$i', title: 'Task ${i + 1}'),
      ],
    );
    for (final dark in [true, false]) {
      await tester.pumpWidget(const SizedBox.shrink());
      await _pump(
        tester,
        Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: DialogueBlockCard(block: dialogue),
          ),
        ),
        user: _user({'dialogue', 'task-0'}, current: 'task-4'),
        scale: 1.3,
        dark: dark,
      );
      final grid = tester.widget<ChallengeGrid>(find.byType(ChallengeGrid));
      expect(grid.currentChallengeId, 'task-4');
      expect(find.text('Continue task 5'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await captureLearningDesign(
        tester,
        'DialogueBlockCard-${dark ? 'dark' : 'light'}-returning-1.3',
      );
    }
  });

  testWidgets('C2 CHAP-N2 CHAP-N3 chapter segments sizes and module geometry', (
    tester,
  ) async {
    await _pump(
      tester,
      const SuperBlockView(dashedName: 'responsive-web-design'),
    );
    final bars = find.byType(LinearProgressIndicator);
    final sizes = [
      for (var i = 0; i < 4; i++) tester.getSize(bars.at(i)).width,
    ];
    expect(sizes[1], 14);
    expect(sizes[3], 14);
    expect(sizes[2] / sizes[0], closeTo(21 / 6, .001));
    final tiles = tester.widgetList<ExpansionTile>(find.byType(ExpansionTile));
    expect(tiles.first.iconColor, const Color(0xffcabeea));
    final node = find.byType(LearnStatus).first;
    expect(tester.getSize(node), const Size(26, 26));
    final ink = find.ancestor(of: node, matching: find.byType(InkWell)).first;
    expect(tester.getSize(ink).height, greaterThanOrEqualTo(60));
    final nodeBox = tester.widget<Container>(
      find.descendant(of: node, matching: find.byType(Container)).first,
    );
    expect(
      ((nodeBox.decoration as BoxDecoration).border as Border).top.width,
      3,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('C5 C6 CHAP-N4 completed chapters and exam preserve geometry', (
    tester,
  ) async {
    final done = _chapters.first.modules
        .expand((m) => m.blocks)
        .expand((b) => b.challenges)
        .map((c) => c.id)
        .toSet();
    await _pump(
      tester,
      const SuperBlockView(dashedName: 'responsive-web-design'),
      user: _user(done),
    );
    final firstTile = tester.widget<ExpansionTile>(
      find.byType(ExpansionTile).first,
    );
    final tile = firstTile.leading! as Container;
    expect((tile.decoration as BoxDecoration).color, const Color(0xff8ddba3));
    expect((tile.child! as Icon).color, const Color(0xff1a1530));
    expect(
      tester.getRect(find.text('Done')).top,
      greaterThan(tester.getRect(find.text('HTML')).bottom),
    );
    final dots = find.descendant(
      of: find.byType(Card).first,
      matching: find.byWidgetPredicate(
        (w) => w is Container && w.constraints?.maxWidth == 8,
      ),
    );
    expect(
      tester.getRect(dots.first).top,
      greaterThan(tester.getRect(find.text('Done')).bottom),
    );
    expect(
      tester.getRect(find.byType(Card).at(1)).top -
          tester.getRect(find.byType(Card).first).bottom,
      16,
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: FccTheme.themeDark,
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: ExamCard(
              title: 'Certification Exam',
              locked: false,
              onOpen: () {},
            ),
          ),
        ),
      ),
    );
    final sentence = find.text("Take it on the website when you're ready.");
    expect(
      _rendered(tester, "Take it on the website when you're ready.").fontSize,
      14,
    );
    expect(
      _rendered(tester, "Take it on the website when you're ready.").height,
      1.4,
    );
    expect(
      _rendered(tester, "Take it on the website when you're ready.").color,
      const Color(0xffcabeea),
    );
    expect(
      tester.getRect(find.text('Open')).left,
      greaterThan(tester.getRect(sentence).right),
    );
    expect(
      tester.getRect(find.byIcon(Icons.open_in_new)).left,
      greaterThan(tester.getRect(find.text('Open')).right),
    );
    expect(_rendered(tester, 'Open').fontSize, 15);
    expect(_rendered(tester, 'Open').fontWeight, FontWeight.w700);
    final trophy = tester.widget<Container>(
      find
          .ancestor(
            of: find.byIcon(Icons.emoji_events_outlined),
            matching: find.byType(Container),
          )
          .first,
    );
    expect(
      (trophy.decoration as BoxDecoration).borderRadius,
      BorderRadius.circular(14),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'M2 MODU-N1 MODU-N2 MODU-N3 MODU-N4 module metrics and zero count',
    (tester) async {
      await _pump(
        tester,
        const ModuleView(
          superBlock: 'responsive-web-design',
          module: 'module-0-0',
        ),
      );
      expect(find.text('0 of 11 steps'), findsOneWidget);
      final bar = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(ModuleActionBar),
              matching: find.byType(Container),
            )
            .first,
      );
      expect((bar.decoration as BoxDecoration).color, const Color(0xff1a1530));
      expect(_rendered(tester, 'Responsive Web Design').fontSize, 16);
      final action = find.byType(BlockActionButton);
      expect(tester.getSize(action).height, 52);
      await tester.pumpWidget(
        MaterialApp(
          theme: FccTheme.themeDark,
          home: const Scaffold(
            body: Row(
              children: [
                LearnStatus(complete: false, active: true, large: true),
                LearnStatus(complete: true),
              ],
            ),
          ),
        ),
      );
      expect(
        tester.getSize(find.byType(LearnStatus).first),
        const Size(28, 28),
      );
      final circle = tester.widget<Container>(
        find.descendant(
          of: find.byType(LearnStatus).first,
          matching: find.byType(Container),
        ),
      );
      expect(
        ((circle.decoration as BoxDecoration).border as Border).top.width,
        2.5,
      );
      expect(tester.widget<Icon>(find.byIcon(Icons.circle)).size, 10);
      expect(
        tester.widget<Icon>(find.byIcon(Icons.check)).color,
        const Color(0xff1a1530),
      );
    },
  );

  testWidgets(
    'DAIL-N1 DAN2 SAVE-N2 archive today is yellow and row typography matches',
    (tester) async {
      await _pump(tester, const DailyChallengeArchiveView());
      final action = find.widgetWithText(FilledButton, 'Start challenge');
      expect(tester.getSize(action).height, 48);
      expect(_rendered(tester, 'Start challenge').fontSize, 16);
      expect(_rendered(tester, 'Start challenge').fontWeight, FontWeight.w900);
      expect(_rendered(tester, '#80 · Nov 2').fontFamily, 'JetBrains Mono');
      expect(_rendered(tester, '#80 · Nov 2').fontWeight, FontWeight.w400);
      expect(_rendered(tester, '#80 · Nov 2').fontSize, 12);
      expect(_rendered(tester, 'Daily coding challenges').fontSize, 16);
      expect(tester.takeException(), isNull);
    },
  );

  for (final dark in [true, false]) {
    testWidgets(
      'learn touched screens render 390x844 at 1.3 ${dark ? 'dark' : 'light'}',
      (tester) async {
        for (final screen in [
          const LearnLandingView(),
          const SuperBlockView(dashedName: 'responsive-web-design'),
          const ModuleView(
            superBlock: 'responsive-web-design',
            module: 'module-0-0',
          ),
          const DailyChallengeArchiveView(),
        ]) {
          await tester.pumpWidget(const SizedBox.shrink());
          await _pump(tester, screen, dark: dark, scale: 1.3);
          expect(
            tester.takeException(),
            isNull,
            reason: screen.runtimeType.toString(),
          );
        }
      },
    );
  }
}
