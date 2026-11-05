import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/auth/models/user_model.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/models/challenge_file_model.dart';
import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/learn/models/curriculum_model.dart';
import 'package:freecodecamp/learn/models/daily_challenge_model.dart';
import 'package:freecodecamp/learn/services/test_runner_service.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/help_dialog.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/quiz_leave_dialog.dart';
import 'package:freecodecamp/learn/ui/daily_challenge/daily_challenge_view.dart';
import 'package:freecodecamp/learn/ui/editor_challenge/editor_challenge_view.dart';
import 'package:freecodecamp/learn/ui/editor_challenge/editor_challenge_viewmodel.dart';
import 'package:freecodecamp/learn/ui/editor_challenge/editor_panels.dart';
import 'package:freecodecamp/learn/ui/widgets/celebration_confetti.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:freecodecamp/widgets/segmented_tabs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'rereview_learn_fonts.dart';

const _challenge = Challenge(
  id: 'step-1',
  block: 'test-block',
  superBlock: 'test-course',
  title: 'Step 1',
  dashedName: 'step-1',
  challengeType: 28,
  description:
      '<p>Return twice the given number. This is a long first paragraph which must be shown in full, including this final sentence without ellipsis.</p><p>Keep the sign.</p>',
  tests: [
    ChallengeTest(
      text: '<code>double(3)</code> should return <code>6</code>.',
      testString: 'assert.equal(double(3), 6)',
    ),
  ],
  challengeFiles: [
    ChallengeFile(
      ext: Ext.js,
      name: 'script',
      contents: 'function double(n) { return n * 2; }',
      fileKey: 'scriptjs',
    ),
  ],
);
const _block = Block(
  superBlock: 'test-course',
  dashedName: 'test-block',
  name: 'Workshop',
  layout: BlockLayout.challengeGrid,
  label: BlockLabel.workshop,
  description: [],
  challenges: [
    ChallengeOrder(id: 'step-1', title: 'Step 1'),
    ChallengeOrder(id: 'step-2', title: 'Step 2'),
  ],
);

class _Auth extends AuthNotifier {
  _Auth(this.signedIn);
  final bool signedIn;
  @override
  Future<FccUserModel?> build() async => signedIn
      ? FccUserModel(
          id: 'test',
          email: 'test@example.invalid',
          username: 'learner',
          joinDate: DateTime(2026),
        )
      : null;
}

class _Passed extends EditorChallengeNotifier {
  @override
  EditorChallengeState build(Challenge challenge) =>
      super.build(challenge).copyWith(passed: true, testResults: [true]);
}

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  bool signedIn = false,
  bool passed = false,
  bool dark = true,
  double scale = 1,
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authProvider.overrideWith(() => _Auth(signedIn)),
        if (passed)
          editorChallengeProvider(_challenge).overrideWith(_Passed.new),
        learnTestRunnerServiceProvider(
          'javascript',
        ).overrideWith((ref) async => LearnTestRunnerService('javascript')),
      ],
      child: MaterialApp(
        theme: dark ? FccTheme.themeDark : FccTheme.themeLight,
        builder: (context, child) => RepaintBoundary(
          key: const ValueKey('rereview-capture'),
          child: MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(scale)),
            child: child!,
          ),
        ),
        home: child,
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
  final name = child is EditorChallengeView
      ? 'editor-${child.dailyChallengeNumber != null ? 'daily' : child.block?.challenges.length ?? 0}'
      : child.runtimeType.toString();
  await captureLearningDesign(
    tester,
    '$name-${dark ? 'dark' : 'light'}-${signedIn ? 'member' : 'guest'}-${passed ? 'passed' : 'initial'}-$scale',
  );
}

TextStyle _style(WidgetTester tester, String label) => tester
    .widget<RichText>(
      find.descendant(of: find.text(label), matching: find.byType(RichText)),
    )
    .text
    .style!;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadLearningDesignFonts);
  setUp(() => SharedPreferences.setMockInitialValues({}));
  for (final signedIn in [false, true]) {
    for (final block in [
      _block,
      _block.copyWith(challenges: [_block.challenges.first]),
      null,
    ]) {
      final label = block == null
          ? 'Finish challenge'
          : block.challenges.length == 1
          ? 'Finish'
          : 'Next step';
      testWidgets(
        'E3 $label ${signedIn ? 'member' : 'guest'} is intrinsic 48px one line',
        (tester) async {
          await _pump(
            tester,
            EditorChallengeView(challenge: _challenge, block: block),
            passed: true,
            signedIn: signedIn,
          );
          final button = find.widgetWithText(FilledButton, label);
          expect(tester.getSize(button).height, 48);
          final text = find.text(label);
          final rich = tester.widget<RichText>(
            find.descendant(of: text, matching: find.byType(RichText)),
          );
          expect(rich.text.style!.fontSize, 16);
          expect(rich.text.style!.fontFamily, 'Lato');
          expect(
            rich.text.style!.fontWeight,
            signedIn ? FontWeight.w900 : FontWeight.w700,
          );
          final painter = TextPainter(
            text: rich.text,
            textDirection: TextDirection.ltr,
          )..layout(maxWidth: tester.getSize(text).width);
          expect(painter.computeLineMetrics(), hasLength(1));
          painter.dispose();
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  testWidgets(
    'EDIT-N1 EDIT-N2 DED-N1 actual headers checklist and instruction control',
    (tester) async {
      await _pump(
        tester,
        const EditorChallengeView(challenge: _challenge, block: _block),
      );
      expect(_style(tester, 'Step 1 of 2').fontSize, 15);
      expect(_style(tester, 'Step 1 of 2').fontWeight, FontWeight.w900);
      expect(find.byIcon(Icons.checklist), findsOneWidget);
      expect(_style(tester, 'Hide').fontWeight, FontWeight.w700);
      expect(_style(tester, 'Hide').fontSize, 14);
      await tester.tap(find.text('Hide'));
      await tester.pump();
      expect(_style(tester, 'Show').fontWeight, FontWeight.w700);
      expect(_style(tester, 'Show').fontSize, 14);
      await tester.pumpWidget(const SizedBox.shrink());
      await _pump(
        tester,
        const EditorChallengeView(
          challenge: _challenge,
          dailyChallengeNumber: 80,
        ),
      );
      expect(_style(tester, 'Challenge 80').fontSize, 16);
      expect(_style(tester, 'Challenge 80').fontWeight, FontWeight.w700);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'DE2 DEN1 full paragraph left aligned read more and inline chips',
    (tester) async {
      await _pump(
        tester,
        Scaffold(
          body: Column(
            children: [
              DailyInstructionCard(challenge: _challenge, maxHeight: 400),
              const DailyChallengeExample(
                test: ChallengeTest(
                  text: '<code>double(3)</code> should return <code>6</code>.',
                  testString: '',
                ),
              ),
            ],
          ),
        ),
      );
      final summary = find.textContaining('including this final sentence');
      expect(tester.widget<Text>(summary).maxLines, isNull);
      expect(_style(tester, tester.widget<Text>(summary).data!).fontSize, 15);
      expect(_style(tester, tester.widget<Text>(summary).data!).height, 1.5);
      expect(
        tester.getTopLeft(find.text('Read more')).dx,
        tester.getTopLeft(find.text('Step 1')).dx,
      );
      expect(
        tester.getSize(find.widgetWithText(TextButton, 'Read more')).height,
        greaterThanOrEqualTo(48),
      );
      final example = find.byType(DailyChallengeExample);
      expect(tester.getSize(example).height, lessThan(40));
      final first = find.text('double(3)');
      final last = find.text('6');
      expect(tester.getRect(first).top, tester.getRect(last).top);
      final chip = tester.widget<Container>(
        find.ancestor(of: first, matching: find.byType(Container)).first,
      );
      expect((chip.decoration as BoxDecoration).color, const Color(0xff3f3557));
      expect((chip.decoration as BoxDecoration).border, isNull);
      expect(
        (chip.decoration as BoxDecoration).borderRadius,
        BorderRadius.circular(4),
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('DE3 shared track separate selected inset and mono weights', (
    tester,
  ) async {
    await _pump(
      tester,
      Scaffold(
        body: DailyChallengeLanguageSelector(
          selected: DailyChallengeLanguage.javascript,
          onSelected: (_) {},
        ),
      ),
    );
    expect(find.byType(SegmentedButton<DailyChallengeLanguage>), findsNothing);
    expect(find.byType(SegmentedTabs<DailyChallengeLanguage>), findsOneWidget);
    expect(_style(tester, 'JavaScript').fontFamily, 'JetBrains Mono');
    expect(_style(tester, 'JavaScript').fontSize, 14);
    expect(_style(tester, 'JavaScript').fontWeight, FontWeight.w700);
    expect(_style(tester, 'Python').fontWeight, FontWeight.w600);
    final material = tester.widget<Material>(
      find
          .ancestor(
            of: find.text('JavaScript'),
            matching: find.byType(Material),
          )
          .first,
    );
    expect(material.color, const Color(0xff29216c));
    expect(
      (material.shape as RoundedRectangleBorder).borderRadius,
      BorderRadius.circular(8),
    );
    expect(
      (material.shape as RoundedRectangleBorder).side,
      const BorderSide(color: Color(0xffbbbfff), width: 1.5),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('HELP-N1 HPN3 truthful footer validation and measured controls', (
    tester,
  ) async {
    await _pump(
      tester,
      Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => showHelpDialog(context, _challenge, 'Workshop'),
            child: const Text('Help'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Help'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create a post'));
    await tester.pumpAndSettle();
    await captureLearningDesign(tester, 'help-create-post-dark');
    expect(_style(tester, 'Before you post, please confirm:').fontSize, 15);
    expect(_style(tester, 'Tick both boxes to post.').fontSize, 13);
    final boxes = find.byWidgetPredicate(
      (w) => w is Semantics && w.properties.checked != null,
    );
    for (var i = 0; i < 2; i++) {
      expect(tester.getSize(boxes.at(i)), const Size(48, 48));
      await tester.tap(boxes.at(i));
      await tester.pump();
    }
    expect(find.text('Add 50 more characters to post.'), findsOneWidget);
    final submit = find.widgetWithText(FilledButton, 'Post to the forum');
    expect(tester.getSize(submit).height, 50);
    await tester.enterText(find.byType(TextField), 'x' * 49);
    await tester.pump();
    expect(find.text('Add 1 more character to post.'), findsOneWidget);
    expect(tester.widget<FilledButton>(submit).onPressed, isNull);
    await tester.enterText(find.byType(TextField), 'x' * 50);
    await tester.pump();
    expect(tester.widget<FilledButton>(submit).onPressed, isNotNull);
    await tester.enterText(find.byType(TextField), 'x' * 8100);
    await tester.pump();
    expect(
      find.text('Your description is too long. Shorten it to post.'),
      findsOneWidget,
    );
    expect(tester.widget<FilledButton>(submit).onPressed, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'USER-confetti finishes once within three seconds and respects reduced motion',
    (tester) async {
      await _pump(
        tester,
        const Scaffold(body: SizedBox.expand(child: CelebrationConfetti())),
      );
      expect(tester.binding.transientCallbackCount, greaterThan(0));
      await tester.pump(const Duration(seconds: 3));
      expect(tester.binding.transientCallbackCount, 0);
      await tester.pump(const Duration(seconds: 3));
      expect(tester.binding.transientCallbackCount, 0);
      await _pump(
        tester,
        const MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: Scaffold(body: CelebrationConfetti()),
        ),
      );
      expect(tester.binding.transientCallbackCount, 0);
    },
  );

  for (final dark in [true, false]) {
    testWidgets(
      'help and leave quiz dialogs support 1.3 scale ${dark ? 'dark' : 'light'}',
      (tester) async {
        await _pump(
          tester,
          Scaffold(
            body: Builder(
              builder: (context) => Column(
                children: [
                  TextButton(
                    onPressed: () =>
                        showHelpDialog(context, _challenge, 'Workshop'),
                    child: const Text('Help'),
                  ),
                  TextButton(
                    onPressed: () =>
                        showQuizLeaveDialog(context, answered: 4, total: 20),
                    child: const Text('Exit quiz'),
                  ),
                ],
              ),
            ),
          ),
          dark: dark,
          scale: 1.3,
        );
        await tester.tap(find.text('Help'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.tap(find.text('Create a post'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await captureLearningDesign(
          tester,
          'help-${dark ? 'dark' : 'light'}-1.3',
        );
        Navigator.of(tester.element(find.text('Create a post'))).pop();
        await tester.pumpAndSettle();
        await tester.tap(find.text('Exit quiz'));
        await tester.pumpAndSettle();
        for (final label in ['Keep going', 'Leave quiz']) {
          expect(_style(tester, label).fontSize, 17);
          expect(
            _style(tester, label).fontWeight,
            label == 'Keep going' ? FontWeight.w900 : FontWeight.w700,
          );
          expect(
            tester
                .getSize(
                  find.widgetWithText(
                    label == 'Keep going' ? FilledButton : OutlinedButton,
                    label,
                  ),
                )
                .height,
            greaterThanOrEqualTo(50),
          );
        }
        expect(tester.takeException(), isNull);
        await captureLearningDesign(
          tester,
          'leave-quiz-${dark ? 'dark' : 'light'}-1.3',
        );
      },
    );
    testWidgets(
      'editor touched screens support 1.3 scale ${dark ? 'dark' : 'light'}',
      (tester) async {
        for (final daily in [false, true]) {
          await tester.pumpWidget(const SizedBox.shrink());
          await _pump(
            tester,
            EditorChallengeView(
              challenge: _challenge,
              block: daily ? null : _block,
              dailyChallengeNumber: daily ? 80 : null,
              selector: daily
                  ? DailyChallengeLanguageSelector(
                      selected: DailyChallengeLanguage.javascript,
                      onSelected: (_) {},
                    )
                  : null,
            ),
            dark: dark,
            scale: 1.3,
            passed: true,
          );
          expect(tester.takeException(), isNull);
        }
      },
    );
  }
}
