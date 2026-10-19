import 'dart:io';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_new/auth/models/user_model.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/models/curriculum_model.dart';
import 'package:mobile_app_new/learn/models/scene_assets_model.dart';
import 'package:mobile_app_new/learn/ui/challenge/english_view.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/parsed_html.dart';
import 'package:mobile_app_new/learn/ui/widgets/scene/scene_canvas.dart';
import 'package:mobile_app_new/learn/ui/widgets/scene/scene_view.dart';
import 'package:mobile_app_new/learn/controllers/scene_controller.dart';
import 'package:mobile_app_new/services/audio_service.dart';
import 'package:mobile_app_new/services/auth_service.dart';

import 'support/fake_audio_handler.dart';

const _backgrounds =
    'https://cdn.freecodecamp.org/curriculum/english/animation-assets/images/backgrounds';
const _scene = Scene(
  setup: SceneSetup(
    background: 'english-task-fixture',
    audio: AudioClip(filename: 'greeting.mp3'),
    characters: [],
  ),
  commands: [],
);
const _description = '<p>Use a greeting before introducing yourself.</p>';
const _grammar = '<p>Contractions make spoken introductions natural.</p>';
const _feedback =
    '<p>Start with <code>Hello</code>, then use '
    '<span class="highlighted-text">my</span> before your name.</p>';
const _task = Challenge(
  id: 'english-task-design',
  block: 'greetings',
  superBlock: 'a2-english',
  title: 'Task 1',
  dashedName: 'task-1',
  challengeType: 22,
  description: _description,
  explanation: _grammar,
  instructions: '<p>Listen and complete the sentence.</p>',
  fillInTheBlank: FillInTheBlank(
    sentence: 'BLANK, BLANK name is Maria.',
    blanks: [
      Blank(answer: 'Hello', feedback: _feedback),
      Blank(answer: 'my', feedback: '<p>Use the word for yourself.</p>'),
    ],
  ),
  scene: _scene,
);
const _block = Block(
  superBlock: 'a2-english',
  dashedName: 'greetings',
  name: 'Learn Greetings in your First Day at the Office',
  layout: BlockLayout.challengeDialogue,
  label: BlockLabel.learn,
  description: [],
  challenges: [ChallengeOrder(id: 'english-task-design', title: 'Task 1')],
);

class _Guest extends AuthNotifier {
  @override
  Future<FccUserModel?> build() async => null;
}

class _Scene extends SceneNotifier {
  @override
  SceneState build(Scene scene, String title) =>
      SceneState(background: scene.setup.background, characters: []);
}

final _capture = GlobalKey();
Finder _button(String label) => find.widgetWithText(FilledButton, label);
Finder _rich(String text) => find.textContaining(text, findRichText: true);
Finder _codeText(String text) => find.byWidgetPredicate(
  (widget) =>
      widget is Text &&
      widget.data == text &&
      widget.style?.fontFamily == 'monospace',
);

Future<void> _seedBackdrop(WidgetTester tester) async {
  // Cache a neutral image so real SceneView geometry is tested without HTTP,
  // disk cache plugins, an audio engine, or animation timers.
  final image = (await tester.runAsync(() async {
    final recorder = ui.PictureRecorder();
    Canvas(recorder).drawColor(const Color(0xFFDDE9E8), BlendMode.src);
    final picture = recorder.endRecording();
    final image = await picture.toImage(16, 9);
    picture.dispose();
    return image;
  }))!;
  PaintingBinding.instance.imageCache.putIfAbsent(
    const CachedNetworkImageProvider('$_backgrounds/english-task-fixture.png'),
    () => OneFrameImageStreamCompleter(Future.value(ImageInfo(image: image))),
  );
  addTearDown(() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  });
}

Future<void> _pump(
  WidgetTester tester, {
  required bool dark,
  double scale = 1,
  double keyboard = 0,
  Challenge task = _task,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(scale == 1 ? 390 : 320, 844);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  await _seedBackdrop(tester);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authProvider.overrideWith(_Guest.new),
        audioHandlerProvider.overrideWithValue(FakeAudioHandler()),
        sceneAssetsProvider.overrideWith(
          (ref) async =>
              const SceneAssets(backgrounds: _backgrounds, characterAssets: {}),
        ),
        sceneProvider(_scene, task.title).overrideWith(_Scene.new),
      ],
      child: RepaintBoundary(
        key: _capture,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: dark ? FccTheme.themeDark : FccTheme.themeLight,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(scale),
              viewInsets: EdgeInsets.only(bottom: keyboard),
            ),
            child: child!,
          ),
          home: EnglishView(challenge: task, block: _block),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _reveal(WidgetTester tester, Finder target) async {
  await tester.scrollUntilVisible(
    target,
    120,
    scrollable: find
        .descendant(
          of: find.byType(ListView),
          matching: find.byType(Scrollable),
        )
        .first,
  );
  await tester.pumpAndSettle();
}

Future<void> _tap(WidgetTester tester, Finder target) async {
  await tester.ensureVisible(target);
  await tester.tap(target);
  await tester.pumpAndSettle();
}

void _expectButton(WidgetTester tester, String label, ColorScheme colors) {
  final button = tester.widget<FilledButton>(_button(label));
  final text = find.text(label);
  final style = DefaultTextStyle.of(
    tester.element(text),
  ).style.merge(tester.widget<Text>(text).style);
  expect(style.fontSize, 16);
  expect(style.fontWeight, FontWeight.w800);
  expect(tester.getSize(_button(label)).height, greaterThanOrEqualTo(50));
  expect(button.style!.backgroundColor!.resolve({}), colors.secondary);
  expect(
    (button.style!.shape!.resolve({})! as RoundedRectangleBorder).borderRadius,
    BorderRadius.circular(10),
  );
}

BoxDecoration _pillDecoration(WidgetTester tester, String text) {
  final pill = find
      .ancestor(
        of: _codeText(text),
        matching: find.byWidgetPredicate(
          (widget) => widget is Container && widget.decoration is BoxDecoration,
        ),
      )
      .first;
  return tester.widget<Container>(pill).decoration! as BoxDecoration;
}

void _expectOutlinedPill(WidgetTester tester, String text, ColorScheme colors) {
  final decoration = _pillDecoration(tester, text);
  expect(decoration.color, colors.surface);
  expect(decoration.border, Border.all(color: colors.outlineVariant));
  expect(decoration.borderRadius, BorderRadius.circular(4));
  expect(tester.widget<Text>(_codeText(text)).style!.fontFamily, 'monospace');
  expect(tester.widget<Text>(_codeText(text)).style!.color, colors.onSurface);
}

Future<void> _screenshot(WidgetTester tester, String name) async {
  const directory = String.fromEnvironment('UI_SCREENSHOT_DIR');
  if (directory.isEmpty) return;
  await tester.runAsync(() async {
    final boundary =
        _capture.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 2);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File('$directory/$name.png');
    await file.parent.create(recursive: true);
    await file.writeAsBytes(data!.buffer.asUint8List());
    image.dispose();
  });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final lato = FontLoader('Lato');
    for (final weight in ['Regular', 'Bold', 'ExtraBold', 'Black']) {
      lato.addFont(rootBundle.load('assets/fonts/Lato-$weight.ttf'));
    }
    await lato.load();
    for (final font in {
      'monospace': 'assets/fonts/Hack-Regular.ttf',
      'MaterialIcons': 'fonts/MaterialIcons-Regular.otf',
    }.entries) {
      await (FontLoader(font.key)..addFont(rootBundle.load(font.value))).load();
    }
  });

  for (final dark in [false, true]) {
    final theme = dark ? FccTheme.themeDark : FccTheme.themeLight;
    final colors = theme.colorScheme;
    for (final scale in [1.0, 2.0]) {
      final mode = '${dark ? 'dark' : 'light'}-text${(scale * 100).toInt()}';
      testWidgets('English task layout and feedback preserve input $mode', (
        tester,
      ) async {
        await _pump(tester, dark: dark, scale: scale);
        expect(find.byTooltip('Ask for help'), findsNothing);
        expect(find.byIcon(Icons.help_outline), findsNothing);
        expect(find.byType(SceneView), findsOneWidget);
        final sceneRect = tester.getRect(find.byType(SceneView));
        expect(sceneRect.left, 0);
        expect(sceneRect.width, scale == 1 ? 390 : 320);
        final canvas = tester.getSize(find.byType(SceneCanvas));
        expect(canvas.width / canvas.height, closeTo(16 / 9, .001));
        final container = tester.widget<Container>(
          find
              .descendant(
                of: find.byType(SceneView),
                matching: find.byType(Container),
              )
              .first,
        );
        final decoration = container.decoration! as BoxDecoration;
        expect(decoration.borderRadius, BorderRadius.zero);
        expect(decoration.border, isNull);
        _expectButton(tester, 'Check answer', colors);
        expect(
          tester.widget<FilledButton>(_button('Check answer')).onPressed,
          isNull,
        );
        expect(
          _rich('Use a greeting before introducing yourself.'),
          findsNothing,
        );
        expect(
          _rich('Contractions make spoken introductions natural.'),
          findsNothing,
        );
        await _screenshot(tester, 'english-task-$mode');

        await _reveal(tester, find.byType(TextField).first);
        await tester.enterText(find.byType(TextField).at(0), 'Wrong');
        await tester.enterText(find.byType(TextField).at(1), 'my');
        await tester.pumpAndSettle();
        await _reveal(tester, find.text('Explanation'));
        await _tap(tester, find.text('Explanation'));
        expect(
          _rich('Use a greeting before introducing yourself.'),
          findsOneWidget,
        );
        expect(
          _rich('Contractions make spoken introductions natural.'),
          findsOneWidget,
        );
        await _tap(tester, find.text('Explanation'));
        expect(
          _rich('Use a greeting before introducing yourself.'),
          findsNothing,
        );
        expect(
          tester
              .widget<TextField>(find.byType(TextField).first)
              .controller!
              .text,
          'Wrong',
        );
        expect(
          tester
              .widget<TextField>(find.byType(TextField).last)
              .controller!
              .text,
          'my',
        );

        await _tap(tester, _button('Check answer'));
        await _reveal(tester, find.text('Not quite'));
        _expectButton(tester, 'Check again', colors);
        _expectOutlinedPill(tester, 'Hello', colors);
        _expectOutlinedPill(tester, 'my', colors);
        await _screenshot(tester, 'english-task-feedback-$mode');
        await _tap(tester, find.text('Explanation'));
        expect(find.text('Not quite'), findsOneWidget);
        expect(
          tester
              .widget<TextField>(find.byType(TextField).first)
              .controller!
              .text,
          'Wrong',
        );
        await _tap(tester, find.text('Explanation'));

        await tester.ensureVisible(find.byType(TextField).first);
        await tester.enterText(find.byType(TextField).first, 'Hello');
        await tester.pumpAndSettle();
        expect(find.text('Not quite'), findsNothing);
        await _tap(tester, _button('Check answer'));
        await _reveal(tester, find.text('Correct!'));
        _expectButton(tester, 'Continue', colors);
        await _screenshot(tester, 'english-task-correct-$mode');
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets(
      'Task 1 description supplies the explanation ${dark ? 'dark' : 'light'}',
      (tester) async {
        final task = _task.copyWith(
          explanation: '',
          description:
              '<p>Contractions sound natural in speech.</p>'
              '<p><code>You\'re</code> is a contraction of '
              '<span class="highlighted-text">you are</span>.</p>',
          fillInTheBlank: const FillInTheBlank(
            sentence: '<p>Hello. BLANK the new graphic designer, right?</p>',
            blanks: [
              Blank(
                answer: "You're",
                feedback:
                    '<p>Use a contraction of '
                    '<span class="highlighted-text">you are</span>. '
                    'The first letter is capitalized.</p>',
              ),
            ],
          ),
        );
        await _pump(tester, dark: dark, task: task);
        expect(_rich('Contractions sound natural in speech.'), findsNothing);
        await _reveal(tester, find.text('Explanation'));
        await _tap(tester, find.text('Explanation'));
        expect(_rich('Contractions sound natural in speech.'), findsOneWidget);
        await _tap(tester, find.text('Explanation'));
        await tester.ensureVisible(find.byType(TextField));
        await tester.enterText(find.byType(TextField), 'Your');
        await tester.pumpAndSettle();
        await _tap(tester, _button('Check answer'));
        await _reveal(tester, find.text('Not quite'));
        _expectOutlinedPill(tester, 'you are', colors);
        await _screenshot(
          tester,
          'english-task1-feedback-${dark ? 'dark' : 'light'}',
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'English explanation deduplicates matching notes ${dark ? 'dark' : 'light'}',
      (tester) async {
        await _pump(
          tester,
          dark: dark,
          task: _task.copyWith(explanation: '  $_description  '),
        );
        expect(
          _rich('Use a greeting before introducing yourself.'),
          findsNothing,
        );
        await _reveal(tester, find.text('Explanation'));
        await _tap(tester, find.text('Explanation'));
        expect(
          _rich('Use a greeting before introducing yourself.'),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'outlined HTML updates cached content and preserves copy ${dark ? 'dark' : 'light'}',
      (tester) async {
        final mode = ValueNotifier(0);
        addTearDown(mode.dispose);
        final copied = <String>[];
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          (call) async {
            if (call.method == 'Clipboard.setData') {
              copied.add((call.arguments as Map)['text'] as String);
            }
            return null;
          },
        );
        addTearDown(() {
          tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
            SystemChannels.platform,
            null,
          );
        });
        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            home: Scaffold(
              body: ValueListenableBuilder(
                valueListenable: mode,
                builder: (context, value, child) => ParsedHtml(
                  '<p><code>code-marker</code> and '
                  '<span class="highlighted-text">span-marker</span></p>'
                  '<blockquote><p><code>nested-marker</code></p></blockquote>',
                  outlinedInlineCode: value > 0,
                  enableTapActions: value != 2,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final originalState = tester.state(find.byType(ParsedHtml));
        expect(
          _pillDecoration(tester, 'code-marker').color,
          colors.outlineVariant,
        );
        expect(_pillDecoration(tester, 'code-marker').border, isNull);
        expect(_codeText('span-marker'), findsNothing);

        mode.value = 1;
        await tester.pumpAndSettle();
        expect(tester.state(find.byType(ParsedHtml)), same(originalState));
        for (final text in ['code-marker', 'span-marker', 'nested-marker']) {
          _expectOutlinedPill(tester, text, colors);
        }
        expect(find.byType(SelectionArea), findsWidgets);
        await _tap(tester, _codeText('code-marker'));
        expect(copied, ['code-marker']);
        expect(
          find.ancestor(
            of: _codeText('span-marker'),
            matching: find.byType(InkWell),
          ),
          findsNothing,
        );
        await _tap(tester, _codeText('span-marker'));
        expect(copied, ['code-marker']);
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        mode.value = 2;
        await tester.pumpAndSettle();
        await _tap(tester, _codeText('code-marker'));
        await _tap(tester, _codeText('span-marker'));
        expect(copied, ['code-marker']);
        mode.value = 0;
        await tester.pumpAndSettle();
        expect(
          _pillDecoration(tester, 'code-marker').color,
          colors.outlineVariant,
        );
        expect(_pillDecoration(tester, 'code-marker').border, isNull);
        expect(_codeText('span-marker'), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'English task footer stays above keyboard ${dark ? 'dark' : 'light'}',
      (tester) async {
        await _pump(tester, dark: dark, scale: 2, keyboard: 280);
        expect(
          tester.getRect(_button('Check answer')).bottom,
          lessThanOrEqualTo(564),
        );
        await _reveal(tester, find.byType(TextField).first);
        await tester.enterText(find.byType(TextField).first, 'Hello');
        await _reveal(tester, find.byType(TextField).last);
        await tester.enterText(find.byType(TextField).last, 'my');
        await tester.pumpAndSettle();
        await _tap(tester, _button('Check answer'));
        await _reveal(tester, find.text('Correct!'));
        expect(
          tester.getRect(_button('Continue')).bottom,
          lessThanOrEqualTo(564),
        );
        expect(_button('Continue').hitTestable(), findsOneWidget);
        _expectButton(tester, 'Continue', colors);
        await _screenshot(
          tester,
          'english-task-keyboard-${dark ? 'dark' : 'light'}',
        );
        expect(tester.takeException(), isNull);
      },
    );
  }
}
