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
import 'package:freecodecamp/learn/ui/daily_challenge/daily_challenge_view.dart';
import 'package:freecodecamp/learn/ui/editor_challenge/editor_challenge_view.dart';
import 'package:freecodecamp/learn/ui/editor_challenge/editor_challenge_viewmodel.dart';
import 'package:freecodecamp/learn/ui/editor_challenge/editor_panels.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:phone_ide/phone_ide.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _challenge = Challenge(
  id: 'audit-example',
  block: 'test-block',
  superBlock: 'test-course',
  title: 'Double a number',
  dashedName: 'double-a-number',
  challengeType: 28,
  description: '<p>Return twice the given number.</p><p>Keep the sign.</p>',
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

class _TestAuth extends AuthNotifier {
  _TestAuth(this.user);
  final FccUserModel? user;

  @override
  Future<FccUserModel?> build() async => user;
}

class _PassedEditor extends EditorChallengeNotifier {
  @override
  EditorChallengeState build(Challenge challenge) =>
      super.build(challenge).copyWith(passed: true, testResults: [true]);
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('daily language segments forward the chosen language', (
    tester,
  ) async {
    var selected = DailyChallengeLanguage.javascript;
    await tester.pumpWidget(
      MaterialApp(
        theme: FccTheme.themeDark,
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => DailyChallengeLanguageSelector(
              selected: selected,
              onSelected: (value) => setState(() => selected = value),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(DropdownButton<DailyChallengeLanguage>), findsNothing);
    await tester.tap(find.text('Python'));
    await tester.pump();
    expect(selected, DailyChallengeLanguage.python);
    expect(
      tester
          .widget<SegmentedButton<DailyChallengeLanguage>>(
            find.byType(SegmentedButton<DailyChallengeLanguage>),
          )
          .selected,
      {DailyChallengeLanguage.python},
    );
  });

  for (final theme in [FccTheme.themeDark, FccTheme.themeLight]) {
    testWidgets(
      '${theme.brightness.name} daily editor uses real content at 360dp and 1.3 scale',
      (tester) async {
        tester.view.physicalSize = const Size(360, 640);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authProvider.overrideWith(() => _TestAuth(null)),
              learnTestRunnerServiceProvider('javascript').overrideWith(
                (ref) async => LearnTestRunnerService('javascript'),
              ),
            ],
            child: MaterialApp(
              theme: theme,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(1.3)),
                child: child!,
              ),
              home: EditorChallengeView(
                challenge: _challenge,
                dailyChallengeNumber: 42,
                selector: DailyChallengeLanguageSelector(
                  selected: DailyChallengeLanguage.javascript,
                  onSelected: (_) {},
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text('Challenge 42'), findsOneWidget);
        expect(find.text('Daily coding challenge'), findsOneWidget);
        expect(find.text('Get help'), findsOneWidget);
        expect(find.text('Double a number'), findsOneWidget);
        expect(find.byTooltip('Reset code'), findsNothing);
        expect(find.text('Tests'), findsNothing);
        expect(find.text('Console'), findsNothing);
        final check = find.widgetWithText(FilledButton, 'Check your code');
        expect(check, findsOneWidget);
        expect(tester.getSize(check).width, 336);
        expect(tester.getSize(check).height, greaterThanOrEqualTo(50));
        expect(
          tester
              .widget<DailyChallengeExample>(find.byType(DailyChallengeExample))
              .test,
          _challenge.tests.single,
        );
        final exampleCode = tester.widget<Text>(
          find.descendant(
            of: find.byType(DailyChallengeExample),
            matching: find.text('double(3)'),
          ),
        );
        expect(exampleCode.style?.fontFamily, 'JetBrains Mono');
        expect(exampleCode.style?.fontSize, 13);
        final editor = tester.widget<Editor>(find.byType(Editor));
        expect(editor.options.fontFamily, 'Hack');
        expect(editor.options.linebarBorderColor, Colors.transparent);
        expect(editor.options.linebarColor, theme.colorScheme.surface);
        expect(tester.takeException(), isNull);

        await tester.ensureVisible(find.text('Read more'));
        await tester.tap(find.text('Read more'));
        await tester.pump(const Duration(milliseconds: 300));
        expect(find.byType(InstructionPanel), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('help dialog preserves code attachment and post validation', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: FccTheme.themeDark,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => showHelpDialog(
                context,
                _challenge,
                'Test block',
                code: '\n```js\ndouble(3);\n```',
              ),
              child: const Text('Open help'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open help'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.feedback_outlined), findsOneWidget);
    expect(
      find.text(
        'Still stuck? Post it. We add your code and the challenge link.',
      ),
      findsOneWidget,
    );
    final notNow = tester.widget<Text>(find.text('Not now'));
    expect(notNow.style?.decoration, TextDecoration.underline);
    expect(notNow.style?.fontSize, 15);
    await tester.tap(find.text('Create a post'));
    await tester.pumpAndSettle();
    expect(find.text('Your code so far'), findsOneWidget);
    expect(find.text('Describe your issue in detail here...'), findsOneWidget);
    expect(find.text('Tick both boxes to post.'), findsOneWidget);
    expect(find.textContaining('Add at least'), findsNothing);
    final submit = find.widgetWithText(FilledButton, 'Post to the forum');
    expect(tester.widget<FilledButton>(submit).onPressed, isNull);
    await tester.enterText(
      find.byType(TextField),
      'The output does not match the expected result for this example input.',
    );
    await tester.tap(
      find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.label ==
                'I have tried the Read-Search-Ask method',
      ),
    );
    await tester.tap(
      find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.label ==
                'I have searched for similar questions that have already been answered on the forum',
      ),
    );
    await tester.pump();
    expect(tester.widget<FilledButton>(submit).onPressed, isNotNull);
    expect(tester.takeException(), isNull);
  });

  for (final signedIn in [false, true]) {
    testWidgets(
      'passed step action uses the ${signedIn ? 'member' : 'guest'} style',
      (tester) async {
        final user = signedIn
            ? FccUserModel(
                id: 'audit-user',
                email: 'audit@example.com',
                username: 'audit',
                joinDate: DateTime(2026),
              )
            : null;
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authProvider.overrideWith(() => _TestAuth(user)),
              editorChallengeProvider(
                _challenge,
              ).overrideWith(_PassedEditor.new),
              learnTestRunnerServiceProvider('javascript').overrideWith(
                (ref) async => LearnTestRunnerService('javascript'),
              ),
            ],
            child: MaterialApp(
              theme: FccTheme.themeDark,
              home: const EditorChallengeView(
                challenge: _challenge,
                block: Block(
                  superBlock: 'test-course',
                  dashedName: 'test-block',
                  name: 'Test block',
                  layout: BlockLayout.challengeGrid,
                  label: BlockLabel.workshop,
                  description: [],
                  challenges: [
                    ChallengeOrder(id: 'audit-example', title: 'Step 1'),
                    ChallengeOrder(id: 'next', title: 'Step 2'),
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        final next = tester.widget<FilledButton>(
          find.widgetWithText(FilledButton, 'Next step'),
        );
        expect(
          next.style?.backgroundColor?.resolve({}),
          signedIn ? const Color(0xffffc83d) : Colors.transparent,
        );
        expect(
          next.style?.foregroundColor?.resolve({}),
          signedIn ? const Color(0xff1a1530) : const Color(0xffbbbfff),
        );
        expect(
          next.style?.textStyle?.resolve({})?.fontWeight,
          signedIn ? FontWeight.w900 : FontWeight.w700,
        );
        final badge = tester.widget<Container>(
          find.descendant(
            of: find.byType(Badge),
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is Container &&
                  widget.decoration is BoxDecoration &&
                  (widget.decoration! as BoxDecoration).border != null,
            ),
          ),
        );
        final badgeDecoration = badge.decoration! as BoxDecoration;
        expect(badgeDecoration.color, const Color(0xff03572b));
        expect(
          badgeDecoration.border,
          Border.all(color: const Color(0xff1a1530), width: 2),
        );
        final testsButton = find.widgetWithText(TextButton, 'Tests');
        await tester.tap(testsButton);
        await tester.pump();
        expect(find.byIcon(Icons.fact_check_rounded), findsOneWidget);
        expect(
          tester
              .widget<TextButton>(testsButton)
              .style
              ?.backgroundColor
              ?.resolve({}),
          Colors.transparent,
        );
        expect(
          tester
              .widget<Text>(
                find.descendant(of: testsButton, matching: find.text('Tests')),
              )
              .style
              ?.fontWeight,
          FontWeight.w900,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'guest completion explains local progress and uses the audited copy',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [authProvider.overrideWith(() => _TestAuth(null))],
          child: MaterialApp(
            theme: FccTheme.themeDark,
            home: Scaffold(
              body: PassPanel(challenge: _challenge, onReviewCode: () {}),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(
        find.text(
          "You're not signed in, so this progress is only saved on this device.",
        ),
        findsOneWidget,
      );
      expect(find.text('Sign in to save progress'), findsOneWidget);
      expect(find.text('Sign in to save your progress'), findsNothing);
      expect(
        tester.widget<Text>(find.text('Challenge complete!')).style?.fontSize,
        26,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
