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
import 'package:freecodecamp/learn/models/challenge_file_model.dart';
import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/learn/models/curriculum_model.dart';
import 'package:freecodecamp/learn/repositories/prefs_repository.dart';
import 'package:freecodecamp/learn/services/code_service.dart';
import 'package:freecodecamp/learn/services/test_runner_service.dart';
import 'package:freecodecamp/learn/ui/editor_challenge/editor_challenge_view.dart';
import 'package:freecodecamp/learn/ui/editor_challenge/editor_challenge_viewmodel.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:go_router/go_router.dart' hide Block;
import 'package:phone_ide/highlighting/textmate_highlighter_registry.dart';
import 'package:phone_ide/phone_ide.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _html = ChallengeFile(
  ext: Ext.html,
  name: 'index',
  contents: '<h1>CatPhotoApp</h1>',
  fileKey: 'indexhtml',
);
const _css = ChallengeFile(
  ext: Ext.css,
  name: 'styles',
  contents: 'h1 { color: purple; }',
  fileKey: 'stylescss',
);
const _challenge = Challenge(
  id: 'step-1',
  superBlock: 'responsive-web-design',
  block: 'build-a-cat-photo-app',
  dashedName: 'step-1',
  title: 'Step 1',
  challengeType: 0,
  description: '<p>Build your first page with an HTML heading.</p>',
  instructions: '<p>Add an <code>h1</code> containing CatPhotoApp.</p>',
  challengeFiles: [_html, _css],
  tests: [
    ChallengeTest(
      text: '<p>Your page should contain an <code>h1</code> element.</p>',
      testString: 'hasHeading()',
    ),
    ChallengeTest(
      text: '<p>Your heading should contain CatPhotoApp.</p>',
      testString: 'hasHeadingText()',
    ),
  ],
);
final _longInstructionsChallenge = _challenge.copyWith(
  description: '<p>Build your first page with an HTML heading.</p>',
  instructions: [
    for (var paragraph = 1; paragraph <= 12; paragraph++)
      '<p>Instruction $paragraph: add a heading, check its contents, and keep the surrounding HTML intact.</p>',
  ].join(),
);
const _block = Block(
  superBlock: 'responsive-web-design',
  dashedName: 'build-a-cat-photo-app',
  name: 'Build a Cat Photo App',
  layout: BlockLayout.challengeGrid,
  label: BlockLabel.workshop,
  description: [],
  challenges: [
    ChallengeOrder(id: 'step-1', title: 'Step 1'),
    ChallengeOrder(id: 'step-2', title: 'Step 2'),
  ],
);

Finder _sheet(String name) => find.byKey(ValueKey('editor-sheet-$name'));
Finder _file(String name) => find.byKey(ValueKey('editor-file-$name'));
Finder _tool(String label) => find.widgetWithText(TextButton, label);
Finder _text(String text) => find.textContaining(text, findRichText: true);
Finder get _instructionsToggle =>
    find.byKey(const ValueKey('editor-instructions-toggle'));
Finder get _instructionsBody =>
    find.byKey(const ValueKey('editor-instructions-body'));
Finder get _editable => find.descendant(
  of: find.byType(Editor),
  matching: find.byWidgetPredicate(
    (widget) => widget is TextField && !widget.readOnly,
  ),
);

Future<void> _settle(WidgetTester tester) async {
  for (var frame = 0; frame < 6; frame++) {
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Future<void> _tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pump();
  await tester.tap(finder);
}

void _insideViewport(
  WidgetTester tester,
  Finder finder, {
  double keyboard = 0,
}) {
  final rect = tester.getRect(finder);
  expect(rect.left, greaterThanOrEqualTo(0));
  expect(rect.right, lessThanOrEqualTo(tester.view.physicalSize.width));
  expect(rect.top, greaterThanOrEqualTo(0));
  expect(
    rect.bottom,
    lessThanOrEqualTo(tester.view.physicalSize.height - keyboard),
  );
}

class _Fixture {
  _Fixture(
    this.container,
    this.code,
    this.runner,
    this.router,
    this.keyboard,
    this.capture,
    this.challenge,
  );
  final ProviderContainer container;
  final _Code code;
  final _Runner runner;
  final GoRouter router;
  final ValueNotifier<double> keyboard;
  final GlobalKey capture;
  final Challenge challenge;

  EditorChallengeState get state =>
      container.read(editorChallengeProvider(challenge));
}

Future<void> _shot(WidgetTester tester, _Fixture fixture, String name) async {
  const directory = String.fromEnvironment('UI_SCREENSHOT_DIR');
  if (directory.isEmpty) return;
  await tester.runAsync(() async {
    final boundary =
        fixture.capture.currentContext!.findRenderObject()!
            as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 2);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File('$directory/$name.png');
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes!.buffer.asUint8List());
    image.dispose();
  });
}

Future<_Fixture> _pump(
  WidgetTester tester, {
  bool dark = false,
  double scale = 1,
  Challenge challenge = _challenge,
}) async {
  SharedPreferences.setMockInitialValues({});
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(scale == 1 ? 390 : 320, 844);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final code = _Code();
  final runner = _Runner();
  final keyboard = ValueNotifier(0.0);
  final capture = GlobalKey();
  final container = ProviderContainer(
    overrides: [
      learnCodeServiceProvider.overrideWithValue(code),
      learnTestRunnerServerProvider.overrideWith((ref) async {}),
      learnTestRunnerServiceProvider.overrideWith((ref, type) async => runner),
      authProvider.overrideWith(_Guest.new),
      passQuoteProvider.overrideWith(
        (ref) async => (quote: 'Fixture quote', author: 'Fixture author'),
      ),
    ],
  );
  final router = GoRouter(
    initialLocation: '/editor',
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => const Scaffold(body: Text('Course overview')),
        routes: [
          GoRoute(
            path: 'editor',
            builder: (_, _) =>
                EditorChallengeView(challenge: challenge, block: _block),
          ),
        ],
      ),
      GoRoute(
        path: '/learn/:superBlock/:block/:challengeId',
        builder: (_, state) => Scaffold(
          body: Text('Next challenge: ${state.pathParameters['challengeId']}'),
        ),
      ),
    ],
  );
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox.shrink());
    router.dispose();
    keyboard.dispose();
    container.dispose();
    await runner._messages.close();
  });
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: RepaintBoundary(
        key: capture,
        child: MaterialApp.router(
          routerConfig: router,
          debugShowCheckedModeBanner: false,
          theme: dark ? FccTheme.themeDark : FccTheme.themeLight,
          builder: (context, child) => ValueListenableBuilder<double>(
            valueListenable: keyboard,
            builder: (context, inset, _) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(scale),
                viewInsets: EdgeInsets.only(bottom: inset),
                disableAnimations: true,
              ),
              child: child!,
            ),
          ),
        ),
      ),
    ),
  );
  await _settle(tester);
  return _Fixture(
    container,
    code,
    runner,
    router,
    keyboard,
    capture,
    challenge,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final lato = FontLoader('Lato');
    for (final weight in ['Regular', 'Bold', 'ExtraBold', 'Black']) {
      lato.addFont(rootBundle.load('assets/fonts/Lato-$weight.ttf'));
    }
    await lato.load();
    for (final family in ['Hack', 'monospace']) {
      await (FontLoader(
        family,
      )..addFont(rootBundle.load('assets/fonts/Hack-Regular.ttf'))).load();
    }
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
    await TextMateHighlighterRegistry.instance.initialize();
  });

  for (final dark in [false, true]) {
    testWidgets(
      'instruction header dragging resizes and restores height dark=$dark',
      (tester) async {
        final fixture = await _pump(
          tester,
          dark: dark,
          challenge: _longInstructionsChallenge,
        );
        await tester.enterText(_editable, '<h1>Edited heading</h1>');
        await _settle(tester);
        final editor = tester.state<EditorState>(find.byType(Editor));
        final controller = tester.widget<TextField>(_editable).controller!;
        const selection = TextSelection(baseOffset: 4, extentOffset: 10);
        controller.selection = selection;
        await tester.pump();
        final initialHeight = tester.getSize(_instructionsBody).height;

        await tester.drag(_instructionsToggle, const Offset(0, 90));
        await _settle(tester);
        final grownHeight = tester.getSize(_instructionsBody).height;
        expect(grownHeight, greaterThan(initialHeight + 20));
        await tester.drag(_instructionsToggle, const Offset(0, -50));
        await _settle(tester);
        final customHeight = tester.getSize(_instructionsBody).height;
        expect(customHeight, lessThan(grownHeight));
        expect(customHeight, greaterThan(0));
        await tester.tap(_instructionsToggle);
        await _settle(tester);
        expect(_instructionsBody, findsNothing);
        await tester.tap(_instructionsToggle);
        await _settle(tester);
        expect(
          tester.getSize(_instructionsBody).height,
          closeTo(customHeight, 1),
        );

        await tester.drag(_instructionsToggle, const Offset(0, -700));
        await _settle(tester);
        expect(_instructionsBody, findsNothing);
        await tester.drag(_instructionsToggle, const Offset(0, 110));
        await _settle(tester);
        expect(_instructionsBody, findsOneWidget);
        expect(tester.getSize(_instructionsBody).height, greaterThan(0));
        expect(tester.state<EditorState>(find.byType(Editor)), same(editor));
        expect(
          tester.widget<TextField>(_editable).controller,
          same(controller),
        );
        expect(controller.text, '<h1>Edited heading</h1>');
        expect(controller.selection, selection);
        expect(
          await fixture.code.contents(_longInstructionsChallenge, _html),
          '<h1>Edited heading</h1>',
        );
        await _shot(tester, fixture, 'editor-instructions-resized-dark$dark');
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'instruction content scrolls without resizing the panel dark=$dark',
      (tester) async {
        await _pump(tester, dark: dark, challenge: _longInstructionsChallenge);
        final scrollable = find.descendant(
          of: _instructionsBody,
          matching: find.byType(Scrollable),
        );
        final scroll = tester.state<ScrollableState>(scrollable).position;
        final height = tester.getSize(_instructionsBody).height;
        expect(scroll.pixels, 0);
        await tester.drag(_instructionsBody, const Offset(0, -110));
        await _settle(tester);
        expect(scroll.pixels, greaterThan(0));
        expect(tester.getSize(_instructionsBody).height, closeTo(height, 1));
        expect(
          tester.widget<TextField>(_editable).controller!.text,
          _html.contents,
        );
        expect(tester.takeException(), isNull);
      },
    );

    for (final scale in [1.0, 2.0]) {
      testWidgets(
        'instruction resizing stays usable above keyboard dark=$dark scale=$scale',
        (tester) async {
          final fixture = await _pump(
            tester,
            dark: dark,
            scale: scale,
            challenge: _longInstructionsChallenge,
          );
          await tester.drag(_instructionsToggle, const Offset(0, 1500));
          await _settle(tester);
          final expandedHeight = tester.getSize(_instructionsBody).height;
          _insideViewport(tester, _file('index.html'));
          _insideViewport(tester, find.byType(Editor));
          _insideViewport(tester, find.text('Check'));
          expect(tester.getSize(find.byType(Editor)).height, greaterThan(0));

          await tester.showKeyboard(_editable);
          fixture.keyboard.value = 290;
          await _settle(tester);
          final keyboardHeight = tester.getSize(_instructionsBody).height;
          expect(keyboardHeight, lessThan(expandedHeight));
          _insideViewport(tester, _file('index.html'), keyboard: 290);
          _insideViewport(tester, find.byType(Editor), keyboard: 290);
          _insideViewport(tester, find.text('Check'), keyboard: 290);
          expect(tester.getSize(find.byType(Editor)).height, greaterThan(0));
          await _shot(
            tester,
            fixture,
            'editor-instructions-keyboard-dark$dark-scale$scale',
          );

          fixture.keyboard.value = 0;
          await _settle(tester);
          expect(
            tester.getSize(_instructionsBody).height,
            closeTo(expandedHeight, 1),
          );
          await tester.drag(_instructionsToggle, const Offset(0, -1500));
          await _settle(tester);
          expect(_instructionsBody, findsNothing);
          _insideViewport(tester, _file('index.html'));
          _insideViewport(tester, find.byType(Editor));
          _insideViewport(tester, find.text('Check'));
          expect(tester.takeException(), isNull);
        },
      );
    }

    testWidgets('editing passed code keeps keyboard focus dark=$dark', (
      tester,
    ) async {
      final fixture = await _pump(tester, dark: dark);
      fixture.runner._pass = true;
      await tester.tap(find.text('Check'));
      await _settle(tester);
      expect(_sheet('pass'), findsOneWidget);
      expect(fixture.state.passed, isTrue);

      await tester.enterText(_editable, '<h1>Another heading</h1>');
      await _settle(tester);
      final input = tester.widget<EditableText>(
        find.descendant(of: _editable, matching: find.byType(EditableText)),
      );
      expect(input.focusNode.hasFocus, isTrue);
      expect(tester.testTextInput.isVisible, isTrue);
      expect(_sheet('pass'), findsNothing);
      expect(fixture.state.passed, isFalse);
      expect(find.text('Next step'), findsNothing);
      expect(find.text('Check'), findsOneWidget);
      expect(
        await fixture.code.contents(_challenge, _html),
        '<h1>Another heading</h1>',
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('Back closes the panel before leaving the editor dark=$dark', (
      tester,
    ) async {
      final fixture = await _pump(tester, dark: dark);
      await _tapVisible(tester, _tool('Tests'));
      await _settle(tester);
      expect(_sheet('tests'), findsOneWidget);
      await tester.binding.handlePopRoute();
      await _settle(tester);
      expect(_sheet('tests'), findsNothing);
      expect(find.byType(Editor), findsOneWidget);
      expect(fixture.router.routeInformationProvider.value.uri.path, '/editor');
      await tester.binding.handlePopRoute();
      await _settle(tester);
      expect(find.text('Course overview'), findsOneWidget);
      expect(find.byType(Editor), findsNothing);
      expect(fixture.router.routeInformationProvider.value.uri.path, '/');
      expect(tester.takeException(), isNull);
    });

    for (final scale in [1.0, 2.0]) {
      testWidgets('editor navigation and panels dark=$dark scale=$scale', (
        tester,
      ) async {
        final fixture = await _pump(tester, dark: dark, scale: scale);
        await _shot(tester, fixture, 'editor-dark$dark-scale$scale');
        final toggle = find.byKey(const ValueKey('editor-instructions-toggle'));
        expect(_text('Build your first page'), findsOneWidget);
        await tester.tap(toggle);
        await _settle(tester);
        expect(_text('Build your first page'), findsNothing);
        await tester.tap(toggle);
        await _settle(tester);
        expect(_text('Build your first page'), findsOneWidget);

        await tester.tap(_file('styles.css'));
        await _settle(tester);
        expect(fixture.state.file, _css);
        expect(
          tester.widget<Editor>(find.byType(Editor)).defaultValue,
          _css.contents,
        );
        await tester.tap(_file('index.html'));
        await _settle(tester);
        expect(fixture.state.file, _html);

        await _tapVisible(tester, _tool('Tests'));
        await _settle(tester);
        expect(_sheet('tests'), findsOneWidget);
        expect(fixture.state.body, EditorBody.tests);
        await tester.tap(find.byTooltip('Hide panel'));
        await _settle(tester);
        expect(_sheet('tests'), findsNothing);

        await _tapVisible(tester, _tool('Console'));
        await _settle(tester);
        expect(_sheet('console'), findsOneWidget);
        await _tapVisible(tester, _tool('Console'));
        await _settle(tester);
        expect(_sheet('console'), findsNothing);

        await _tapVisible(tester, _tool('Preview'));
        await _settle(tester);
        expect(_sheet('preview'), findsOneWidget);
        fixture.code._preview.completeError(
          StateError('Fixture preview error'),
        );
        await _settle(tester);
        expect(_text('preview could not'), findsOneWidget);
        await tester.tap(find.byTooltip('Expand preview'));
        await _settle(tester);
        expect(find.byTooltip('Close preview'), findsOneWidget);
        await tester.tap(find.byTooltip('Close preview'));
        await _settle(tester);
        expect(_sheet('preview'), findsOneWidget);
        await tester.tap(find.byTooltip('Hide panel'));
        await _settle(tester);
        expect(_sheet('preview'), findsNothing);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
        'editor controls stay above keyboard dark=$dark scale=$scale',
        (tester) async {
          final fixture = await _pump(tester, dark: dark, scale: scale);
          await tester.tap(
            find.byKey(const ValueKey('editor-instructions-toggle')),
          );
          await _settle(tester);
          await tester.tapAt(
            tester.getTopLeft(_editable) + const Offset(24, 12),
          );
          fixture.keyboard.value = 290;
          await _settle(tester);
          _insideViewport(tester, find.text('Check'), keyboard: 290);
          _insideViewport(
            tester,
            find.byIcon(Icons.keyboard_tab_rounded),
            keyboard: 290,
          );
          _insideViewport(
            tester,
            find.byTooltip('Hide keyboard'),
            keyboard: 290,
          );
          _insideViewport(tester, _file('index.html'), keyboard: 290);
          expect(find.byType(Editor), findsOneWidget);
          await _shot(tester, fixture, 'editor-keyboard-dark$dark-scale$scale');
          expect(tester.takeException(), isNull);
        },
      );
    }

    for (final scale in [1.0, 2.0]) {
      testWidgets(
        'failed tests expose existing hint and console dark=$dark scale=$scale',
        (tester) async {
          final fixture = await _pump(tester, dark: dark, scale: scale);
          await tester.tap(find.text('Check'));
          await _settle(tester);
          expect(fixture.runner._runs, 1);
          expect(fixture.state.testResults, [false, true]);
          expect(_sheet('tests'), findsOneWidget);
          await _shot(tester, fixture, 'editor-tests-dark$dark-scale$scale');
          await _tapVisible(tester, find.text('Ask Socrates for a hint'));
          await _settle(tester);
          expect(_sheet('hint'), findsOneWidget);
          await _shot(tester, fixture, 'editor-hint-dark$dark-scale$scale');
          expect(_text('Your page should contain an'), findsOneWidget);
          expect(
            tester
                .widget<OutlinedButton>(
                  find.widgetWithText(OutlinedButton, 'Ask for another hint'),
                )
                .onPressed,
            isNull,
          );
          await tester.tap(find.byTooltip('Hide panel'));
          await _settle(tester);
          await _tapVisible(tester, _tool('Tests'));
          await _settle(tester);
          expect(find.text('Your hint'), findsOneWidget);
          await _tapVisible(tester, _tool('Console'));
          await _settle(tester);
          final consoleScroll = find.descendant(
            of: _sheet('console'),
            matching: find.byType(Scrollable),
          );
          await tester.scrollUntilVisible(
            _text('fixture console output'),
            100,
            scrollable: consoleScroll,
          );
          expect(_text('fixture console output'), findsOneWidget);
          await tester.scrollUntilVisible(
            _text('<input value="3" id="number-input">'),
            100,
            scrollable: consoleScroll,
          );
          expect(_text('<input value="3" id="number-input">'), findsOneWidget);
          await _shot(tester, fixture, 'editor-console-dark$dark-scale$scale');
          expect(tester.takeException(), isNull);
        },
      );

      testWidgets(
        'success supports reviewing code and next step dark=$dark scale=$scale',
        (tester) async {
          final fixture = await _pump(tester, dark: dark, scale: scale);
          fixture.runner._pass = true;
          await tester.tap(find.text('Check'));
          await _settle(tester);
          expect(fixture.state.passed, isTrue);
          expect(_sheet('pass'), findsOneWidget);
          await _shot(tester, fixture, 'editor-pass-dark$dark-scale$scale');
          await _tapVisible(tester, find.text('Review code'));
          await _settle(tester);
          expect(_sheet('pass'), findsNothing);
          expect(find.byType(Editor), findsOneWidget);
          await tester.tap(find.text('Next step'));
          await _settle(tester);
          expect(find.text('Next challenge: step-2'), findsOneWidget);
          expect(
            GoRouterState.of(
              tester.element(find.text('Next challenge: step-2')),
            ).uri.path,
            '/learn/responsive-web-design/build-a-cat-photo-app/step-2',
          );
          expect(tester.takeException(), isNull);
        },
      );

      testWidgets(
        'reset cancellation preserves code and confirmation resets dark=$dark scale=$scale',
        (tester) async {
          final fixture = await _pump(tester, dark: dark, scale: scale);
          await tester.tap(
            find.byKey(const ValueKey('editor-instructions-toggle')),
          );
          await _settle(tester);
          await tester.enterText(_editable, '<h1>My edited heading</h1>');
          await _settle(tester);
          expect(
            await fixture.code.contents(_challenge, _html),
            '<h1>My edited heading</h1>',
          );

          await tester.tap(find.byTooltip('Reset code'));
          await _settle(tester);
          await tester.tap(find.text('Cancel'));
          await _settle(tester);
          expect(fixture.code._resets, 0);
          expect(
            await fixture.code.contents(_challenge, _html),
            '<h1>My edited heading</h1>',
          );
          await tester.tap(find.byTooltip('Reset code'));
          await _settle(tester);
          await tester.tap(find.text('Reset'));
          await _settle(tester);
          expect(fixture.code._resets, 1);
          expect(fixture.state.resetCount, 1);
          expect(
            await fixture.code.contents(_challenge, _html),
            _html.contents,
          );
          expect(
            tester.widget<TextField>(_editable).controller!.text,
            _html.contents,
          );
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}

class _MemoryPrefs extends LearnPrefsRepository {
  final _values = <String, String>{};
  @override
  Future<String?> read(String key) async => _values[key];
  @override
  Future<void> write(String key, String value) async => _values[key] = value;
  @override
  Future<void> remove(String key) async => _values.remove(key);
}

class _Code extends LearnCodeService {
  _Code() : super(_MemoryPrefs());
  final _preview = Completer<String>();
  int _resets = 0;

  @override
  Future<String> previewHtml(Challenge challenge, Transpile transpile) =>
      _preview.future;

  @override
  Future<void> reset(Challenge challenge) async {
    _resets++;
    await super.reset(challenge);
  }
}

class _Runner implements LearnTestRunnerService {
  final _messages = StreamController<String>.broadcast(sync: true);
  bool _pass = false;
  int _runs = 0;

  @override
  String get workerType => 'dom';
  @override
  Stream<String> get consoleMessages => _messages.stream;
  @override
  Future<String> transpile(String code, {required String challengeId}) async =>
      code;
  @override
  Future<List<TestResult>> run({
    required String userCode,
    required String combinedCode,
    required String editableContents,
    required Hooks hooks,
    required List<ChallengeTest> tests,
  }) async {
    _runs++;
    _messages.add('fixture console output');
    _messages.add('<input value="3" id="number-input">');
    return [(pass: _pass, err: null), (pass: true, err: null)];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Guest extends AuthNotifier {
  @override
  Future<FccUserModel?> build() async => null;
}
