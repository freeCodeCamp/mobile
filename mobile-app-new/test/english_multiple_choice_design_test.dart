import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_new/auth/models/user_model.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/models/curriculum_model.dart';
import 'package:mobile_app_new/learn/models/scene_assets_model.dart';
import 'package:mobile_app_new/learn/ui/challenge/lesson_view.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/parsed_html.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/questions.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/scene/scene_canvas.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/scene/scene_view.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/scene/scene_viewmodel.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/task_explanation.dart';
import 'package:mobile_app_new/services/audio_service.dart';
import 'package:mobile_app_new/services/auth_service.dart';

import 'support/fake_audio_handler.dart';

const _backgrounds =
    'https://cdn.freecodecamp.org/curriculum/english/animation-assets/images/backgrounds';
const _scene = Scene(
  setup: SceneSetup(
    background: 'english-multiple-choice-fixture',
    audio: AudioClip(filename: 'greeting.mp3'),
    characters: [],
  ),
  commands: [],
);
const _description = '<p>A team lead guides the people on a team.</p>';
const _extraExplanation = '<p>Listen for the role after the introduction.</p>';
const _feedback =
    '<p>Listen for <code>team lead</code>, rather than '
    '<span class="highlighted-text">developer</span>.</p>';
const _task = Challenge(
  id: 'english-multiple-choice',
  block: 'greetings',
  superBlock: 'a2-english-for-developers',
  title: 'Task 3',
  dashedName: 'task-3',
  challengeType: 19,
  description: _description,
  explanation: _extraExplanation,
  instructions: '<p>Listen to Maria introduce herself.</p>',
  questions: [
    Question(
      text: '<p>What is Maria’s job role?</p>',
      answers: [
        Answer(answer: '<p>A developer</p>', feedback: _feedback),
        Answer(answer: '<p>A team lead</p>'),
      ],
      solution: 2,
    ),
  ],
  scene: _scene,
);
const _block = Block(
  superBlock: 'a2-english-for-developers',
  dashedName: 'greetings',
  name: 'Learn Greetings in your First Day at the Office',
  layout: BlockLayout.challengeDialogue,
  label: BlockLabel.learn,
  description: [],
  challenges: [ChallengeOrder(id: 'english-multiple-choice', title: 'Task 3')],
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

Finder _button(String text) => find.widgetWithText(FilledButton, text);
Finder _text(String text) => find.textContaining(text, findRichText: true);

Future<void> _pump(
  WidgetTester tester, {
  bool dark = false,
  double scale = 1,
  Challenge challenge = _task,
  Block block = _block,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(scale == 1 ? 390 : 320, 844);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  // Keep real scene geometry without an audio engine, HTTP, or a disk cache.
  final image = (await tester.runAsync(() async {
    final recorder = ui.PictureRecorder();
    Canvas(recorder).drawColor(const Color(0xFFDDE9E8), BlendMode.src);
    final picture = recorder.endRecording();
    final image = await picture.toImage(16, 9);
    picture.dispose();
    return image;
  }))!;
  PaintingBinding.instance.imageCache.putIfAbsent(
    const CachedNetworkImageProvider(
      '$_backgrounds/english-multiple-choice-fixture.png',
    ),
    () => OneFrameImageStreamCompleter(Future.value(ImageInfo(image: image))),
  );
  addTearDown(() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  });
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authProvider.overrideWith(_Guest.new),
        audioHandlerProvider.overrideWithValue(FakeAudioHandler()),
        sceneAssetsProvider.overrideWith(
          (ref) async =>
              const SceneAssets(backgrounds: _backgrounds, characterAssets: {}),
        ),
        sceneProvider(_scene, challenge.title).overrideWith(_Scene.new),
      ],
      child: MaterialApp(
        theme: dark ? FccTheme.themeDark : FccTheme.themeLight,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        ),
        home: LessonView(challenge: challenge, block: block),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _tap(WidgetTester tester, Finder target) async {
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  // Answer HTML delegates its pointer events to the surrounding option.
  await tester.tapAt(tester.getCenter(target));
  await tester.pumpAndSettle();
}

void main() {
  for (final dark in [false, true]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('English choices preserve task reading and feedback '
          '${dark ? 'dark' : 'light'} at $scale text', (tester) async {
        await _pump(tester, dark: dark, scale: scale);
        expect(find.byTooltip('Ask for help'), findsNothing);
        expect(find.text('Lecture'), findsNothing);
        expect(find.text('Task 3'), findsOneWidget);
        final scene = tester.widget<SceneView>(find.byType(SceneView));
        expect(scene.edgeToEdge, isTrue);
        final sceneRect = tester.getRect(find.byType(SceneView));
        expect(sceneRect.top, tester.getBottomLeft(find.byType(AppBar)).dy);
        expect(sceneRect.left, 0);
        expect(sceneRect.width, scale == 1 ? 390 : 320);
        final canvas = tester.getSize(find.byType(SceneCanvas));
        expect(canvas.width / canvas.height, closeTo(16 / 9, .001));
        expect(_text('A team lead guides'), findsNothing);
        final explanation = tester.widget<TaskExplanation>(
          find.byType(TaskExplanation),
        );
        expect(explanation.html, '$_description\n$_extraExplanation');
        await _tap(tester, find.text('Explanation'));
        expect(_text('A team lead guides'), findsOneWidget);
        expect(_text('Listen for the role'), findsOneWidget);
        await _tap(tester, _button('Continue to questions'));
        expect(find.byType(SceneView), findsNothing);
        expect(
          tester.widget<Questions>(find.byType(Questions)).outlinedFeedbackCode,
          isTrue,
        );
        await _tap(tester, _text('A developer'));
        await _tap(tester, _button('Check answer'));
        expect(find.text('Not quite'), findsOneWidget);
        final feedback = tester.widget<ParsedHtml>(
          find.byWidgetPredicate(
            (widget) => widget is ParsedHtml && widget.html == _feedback,
          ),
        );
        expect(feedback.outlinedInlineCode, isTrue);
        final colors =
            (dark ? FccTheme.themeDark : FccTheme.themeLight).colorScheme;
        for (final token in ['team lead', 'developer']) {
          final pill = tester.widget<Container>(
            find
                .ancestor(
                  of: find.text(token),
                  matching: find.byWidgetPredicate(
                    (widget) =>
                        widget is Container &&
                        widget.decoration is BoxDecoration,
                  ),
                )
                .first,
          );
          final decoration = pill.decoration! as BoxDecoration;
          expect(decoration.color, colors.surface);
          expect(decoration.border, Border.all(color: colors.outlineVariant));
        }
        await _tap(tester, _button('Lesson'));
        expect(find.byType(TaskExplanation), findsOneWidget);
        await _tap(tester, _button('Continue to questions'));
        expect(find.text('Not quite'), findsOneWidget);
        await _tap(tester, _text('A team lead'));
        await _tap(tester, _button('Check answer'));
        expect(find.text('Correct!'), findsOneWidget);
        expect(_button('Continue'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets(
    'identical teaching notes appear once and empty notes are omitted',
    (tester) async {
      await _pump(
        tester,
        challenge: _task.copyWith(explanation: '  $_description  '),
      );
      expect(
        tester.widget<TaskExplanation>(find.byType(TaskExplanation)).html,
        _description,
      );
      await _tap(tester, find.text('Explanation'));
      expect(_text('A team lead guides'), findsOneWidget);
      await _pump(
        tester,
        challenge: _task.copyWith(description: '', explanation: ''),
      );
      expect(find.byType(TaskExplanation), findsNothing);
    },
  );

  testWidgets(
    'ordinary multiple-choice lessons keep lesson reading and feedback',
    (tester) async {
      await _pump(
        tester,
        block: _block.copyWith(layout: BlockLayout.challengeList),
      );
      expect(find.text('Lecture'), findsNothing);
      expect(find.byType(TaskExplanation), findsNothing);
      expect(_text('A team lead guides'), findsOneWidget);
      expect(
        tester.widget<SceneView>(find.byType(SceneView)).edgeToEdge,
        isFalse,
      );
      await _tap(tester, _button('Continue to questions'));
      expect(
        tester.widget<Questions>(find.byType(Questions)).outlinedFeedbackCode,
        isFalse,
      );
      await _tap(tester, _text('A developer'));
      await _tap(tester, _button('Check answer'));
      expect(
        tester
            .widget<ParsedHtml>(
              find.byWidgetPredicate(
                (widget) => widget is ParsedHtml && widget.html == _feedback,
              ),
            )
            .outlinedInlineCode,
        isFalse,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
