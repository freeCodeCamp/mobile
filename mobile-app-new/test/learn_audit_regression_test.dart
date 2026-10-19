import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_new/auth/models/user_model.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/models/curriculum_model.dart';
import 'package:mobile_app_new/learn/ui/challenge/english_view.dart';
import 'package:mobile_app_new/learn/ui/challenge/lesson_view.dart';
import 'package:mobile_app_new/learn/ui/challenge/python_project_view.dart';
import 'package:mobile_app_new/learn/ui/challenge/quiz_view.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/help_dialog.dart';
import 'package:mobile_app_new/learn/ui/widgets/scene/scene_controls.dart';
import 'package:mobile_app_new/learn/ui/widgets/block_card.dart';
import 'package:mobile_app_new/services/audio_service.dart';
import 'package:mobile_app_new/services/auth_service.dart';

const _challenge = Challenge(
  id: 'test',
  block: 'test',
  superBlock: 'test',
  title: 'Review the fundamentals',
  dashedName: 'review',
  challengeType: 10,
);
const _block = Block(
  superBlock: 'test',
  dashedName: 'test',
  name: 'Learning the fundamentals',
  layout: BlockLayout.challengeGrid,
  label: BlockLabel.workshop,
  description: [],
  challenges: [ChallengeOrder(id: 'test', title: 'Review the fundamentals')],
);
const _scene = Scene(
  setup: SceneSetup(
    background: 'office',
    audio: AudioClip(filename: 'greeting.mp3'),
    characters: [],
  ),
  commands: [],
);

class _Guest extends AuthNotifier {
  @override
  Future<FccUserModel?> build() async => null;
}

class _Audio extends BaseAudioHandler implements AudioPlayerHandler {
  @override
  String? curriculumClipId;
  int loadCalls = 0;
  int playCalls = 0;
  Completer<bool>? loading;
  @override
  Duration? get duration => const Duration(seconds: 20);
  @override
  Stream<Duration> get positionStream => const Stream.empty();
  @override
  Future<bool> loadCurriculumAudio(
    Uri source, {
    required String clipId,
    required String title,
    Duration start = Duration.zero,
    Duration? end,
  }) async {
    loadCalls++;
    final success = await (loading?.future ?? Future.value(false));
    if (success) curriculumClipId = clipId;
    return success;
  }

  @override
  Future<void> play() async {
    playCalls++;
  }

  @override
  Future<void> stop() async {}
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final _capture = GlobalKey();
Future<void> _pump(
  WidgetTester tester,
  Widget widget, {
  Size size = const Size(390, 844),
  double scale = 1,
  bool dark = false,
  double keyboard = 0,
  _Audio? audio,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authProvider.overrideWith(_Guest.new),
        if (audio != null) audioHandlerProvider.overrideWithValue(audio),
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
          home: widget,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _shot(WidgetTester tester, String name) async {
  if (!const bool.fromEnvironment('CAPTURE_UI')) return;
  await tester.pumpAndSettle();
  await tester.runAsync(() async {
    final boundary =
        _capture.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final dir = Directory('../../audit-after/screenshots')
      ..createSync(recursive: true);
    File('${dir.path}/$name.png').writeAsBytesSync(bytes!.buffer.asUint8List());
    image.dispose();
  });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    for (final font in {
      'Lato': 'assets/fonts/Lato-Regular.ttf',
      'monospace': 'assets/fonts/Hack-Regular.ttf',
      'MaterialIcons': 'fonts/MaterialIcons-Regular.otf',
    }.entries) {
      await (FontLoader(font.key)..addFont(rootBundle.load(font.value))).load();
    }
  });
  testWidgets(
    'oversized help text stays editable and failed launches retain valid drafts',
    (tester) async {
      final opened = <Uri>[];
      const channel = MethodChannel('plugins.flutter.io/url_launcher');
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
        call,
      ) async {
        if (call.method == 'launch') {
          opened.add(Uri.parse((call.arguments as Map)['url'] as String));
        }
        return false;
      });
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          channel,
          null,
        ),
      );
      await _pump(
        tester,
        Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => showHelpDialog(context, _challenge, _block.name),
              child: const Text('Help'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Help'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Create a post'));
      await tester.pumpAndSettle();
      final description =
          'UNIQUE_ISSUE_${List.filled(1200, 'problem').join(' ')}';
      await tester.enterText(find.byType(TextField), description);
      await tester.pump();
      for (final finder in [
        find.byType(Checkbox).first,
        find.byType(Checkbox).last,
      ]) {
        await tester.ensureVisible(finder);
        await tester.tap(finder);
        await tester.pump();
      }
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Continue to forum'),
            )
            .onPressed,
        isNull,
      );
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        description,
      );
      expect(find.textContaining('description is too long'), findsOneWidget);
      expect(opened, isEmpty);
      final shorter =
          'I tried changing the image source but the preview still shows a broken image.';
      await tester.enterText(find.byType(TextField), shorter);
      await tester.pump();
      await tester.tap(find.text('Continue to forum'));
      await tester.pumpAndSettle();
      expect(opened.single.queryParameters['body'], contains(shorter));
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        shorter,
      );
      expect(find.textContaining('Could not open the forum'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'dialogue shows loading and a recoverable failure, then retry plays',
    (tester) async {
      final audio = _Audio()..loading = Completer<bool>();
      await _pump(
        tester,
        const Scaffold(
          body: SceneControls(scene: _scene, title: 'Dialogue'),
        ),
        audio: audio,
        size: const Size(320, 568),
        scale: 2,
        dark: true,
      );
      await tester.tap(find.byTooltip('Play'));
      await tester.pump();
      expect(find.byTooltip('Loading dialogue'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      audio.loading!.complete(false);
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Could not load this dialogue'),
        findsOneWidget,
      );
      expect(find.byTooltip('Retry dialogue'), findsOneWidget);
      await _shot(tester, 'dialogue-error-dark-320-text200');
      audio.loading = Completer<bool>();
      await tester.tap(find.byTooltip('Retry dialogue'));
      await tester.pump();
      audio.loading!.complete(true);
      await tester.pumpAndSettle();
      expect(audio.loadCalls, 2);
      expect(audio.playCalls, 1);
      expect(find.textContaining('Could not load'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
  for (final dark in [false, true]) {
    final mode = dark ? 'dark' : 'light';
    for (final shape in [
      (const Size(320, 568), 2.0),
      (const Size(390, 844), 1.0),
      (const Size(844, 390), 2.0),
      (const Size(1024, 768), 2.0),
    ]) {
      final size = shape.$1;
      final scale = shape.$2;
      final suffix =
          '$mode-${size.width.toInt()}x${size.height.toInt()}-text${(scale * 100).toInt()}';
      testWidgets('workshop tiles stay square and reachable $suffix', (
        tester,
      ) async {
        final block = _block.copyWith(
          challenges: [
            for (var i = 1; i <= 36; i++)
              ChallengeOrder(id: '$i', title: 'Step $i'),
          ],
        );
        await _pump(
          tester,
          Scaffold(
            body: SingleChildScrollView(
              child: BlockCard(block: block, isOpen: true, onToggle: () {}),
            ),
          ),
          size: size,
          scale: scale,
          dark: dark,
        );
        final buttons = find.descendant(
          of: find.byType(GridView),
          matching: find.byType(TextButton),
        );
        for (final element in buttons.evaluate()) {
          final box = element.renderObject as RenderBox;
          expect(box.size.width, closeTo(box.size.height, .01));
          expect(box.size.width, greaterThanOrEqualTo(48));
        }
        await _shot(tester, 'workshop-$suffix');
        await tester.ensureVisible(find.byType(GridView));
        await tester.scrollUntilVisible(
          find.text('36'),
          240,
          scrollable: find
              .descendant(
                of: find.byType(GridView),
                matching: find.byType(Scrollable),
              )
              .first,
        );
        await tester.pumpAndSettle();
        expect(find.text('36'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
      testWidgets(
        'challenge pages remain usable through answers and results $suffix',
        (tester) async {
          final lesson = _challenge.copyWith(
            challengeType: 11,
            description:
                '<p>Read this lesson about <code>image</code> attributes and how they change the behavior of an element.</p>',
            questions: [
              const Question(
                text: 'Which attribute describes the image?',
                answers: [
                  Answer(answer: 'alt'),
                  Answer(answer: 'href'),
                ],
                solution: 1,
              ),
            ],
          );
          await _pump(
            tester,
            LessonView(challenge: lesson, block: _block),
            size: size,
            scale: scale,
            dark: dark,
          );
          await tester.tap(find.text('Continue to questions'));
          await tester.pumpAndSettle();
          await tester.scrollUntilVisible(
            find.text('alt', findRichText: true),
            120,
            scrollable: find
                .descendant(
                  of: find.byType(ListView),
                  matching: find.byType(Scrollable),
                )
                .first,
          );
          await tester.pumpAndSettle();
          await tester.tap(
            find
                .ancestor(
                  of: find.text('alt', findRichText: true),
                  matching: find.byType(InkWell),
                )
                .first,
          );
          await tester.pumpAndSettle();
          await tester.tap(find.widgetWithText(FilledButton, 'Check answer'));
          await tester.pumpAndSettle();
          expect(find.widgetWithText(FilledButton, 'Continue'), findsOneWidget);
          expect(tester.takeException(), isNull);
          final quiz = _challenge.copyWith(
            challengeType: 25,
            quizzes: [
              Quiz(
                questions: [
                  for (var i = 1; i <= 3; i++)
                    QuizQuestion(
                      text: 'Choose an answer for question $i.',
                      answer: 'Correct choice $i',
                      distractors: ['Wrong choice $i'],
                    ),
                ],
              ),
            ],
          );
          await _pump(
            tester,
            QuizView(challenge: quiz, block: _block),
            size: size,
            scale: scale,
            dark: dark,
          );
          for (var i = 1; i <= 3; i++) {
            final choice = find.text(
              i == 3 ? 'Wrong choice $i' : 'Correct choice $i',
              findRichText: true,
            );
            await tester.scrollUntilVisible(
              choice,
              120,
              scrollable: find
                  .descendant(
                    of: find.byType(ListView),
                    matching: find.byType(Scrollable),
                  )
                  .first,
            );
            await tester.pumpAndSettle();
            final answerCard = find
                .ancestor(of: choice, matching: find.byType(InkWell))
                .first;
            await Scrollable.ensureVisible(
              tester.element(answerCard),
              alignment: .5,
            );
            await tester.pumpAndSettle();
            await tester.tap(answerCard);
            await tester.pumpAndSettle();
            expect(find.text('Question $i of 3 · $i answered'), findsOneWidget);
            await tester.pumpAndSettle();
            await tester.tap(
              find.widgetWithText(
                FilledButton,
                i == 3 ? 'Submit quiz' : 'Next question',
              ),
            );
            await tester.pumpAndSettle();
          }
          expect(
            find.text('2 of 3 correct'),
            findsOneWidget,
            reason: tester
                .widgetList<Text>(find.byType(Text))
                .map((text) => text.data)
                .join(' | '),
          );
          expect(
            find.text('Correct choice 1', findRichText: true),
            findsNothing,
            reason:
                'Correct answers are compact; only incorrect answers need their answer details expanded.',
          );
          await tester.scrollUntilVisible(
            find.textContaining(
              'Your answer: Wrong choice 3',
              findRichText: true,
            ),
            120,
            scrollable: find
                .descendant(
                  of: find.byType(ListView),
                  matching: find.byType(Scrollable),
                )
                .first,
          );
          expect(
            find.textContaining(
              'Correct answer: Correct choice 3',
              findRichText: true,
            ),
            findsOneWidget,
          );
          await _shot(tester, 'quiz-wrong-answer-$suffix');
          expect(tester.takeException(), isNull);
          await tester.tap(find.widgetWithText(FilledButton, 'Try again'));
          await tester.pumpAndSettle();
          expect(find.text('Question 1 of 3 · 0 answered'), findsOneWidget);
          expect(tester.takeException(), isNull);
        },
      );
      testWidgets(
        'review topic bar stays visible and tracks manual scrolling $suffix',
        (tester) async {
          final review = _challenge.copyWith(
            challengeType: 31,
            nodules: [
              for (var topic = 1; topic <= 4; topic++)
                Nodule.paragraph(
                  contents:
                      '<h2>Topic $topic</h2>${List.filled(6, '<p>Review the examples and learn how each concept works with a longer explanation.</p>').join()}',
                ),
            ],
          );
          await _pump(
            tester,
            LessonView(challenge: review, block: _block),
            size: size,
            scale: scale,
            dark: dark,
          );
          final barBefore = tester.getRect(find.byType(ChoiceChip).first);
          expect(find.text('Topic 1 of 4'), findsOneWidget);
          final list = find.byType(ListView);
          expect(
            tester.getSize(list).height,
            greaterThan(80),
            reason:
                'The article must remain readable under the pinned controls.',
          );
          await tester.drag(list, const Offset(0, -1800));
          await tester.pumpAndSettle();
          expect(
            tester.getRect(find.byType(ChoiceChip).first).top,
            closeTo(barBefore.top, .01),
          );
          expect(tester.takeException(), isNull);
          final controller = tester.widget<ListView>(list).controller!;
          controller.jumpTo(controller.position.maxScrollExtent);
          await tester.pumpAndSettle();
          expect(find.text('Topic 4 of 4'), findsOneWidget);
          expect(
            tester
                .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Topic 4'))
                .selected,
            isTrue,
          );
          await _shot(tester, 'review-$suffix');
          controller.jumpTo(0);
          await tester.pumpAndSettle();
          expect(find.text('Topic 1 of 4'), findsOneWidget);
          expect(tester.takeException(), isNull);
        },
      );
    }
    for (final english in [false, true]) {
      testWidgets(
        'keyboard leaves ${english ? 'English' : 'project'} action reachable $mode',
        (tester) async {
          final challenge = _challenge.copyWith(
            challengeType: 22,
            fillInTheBlank: const FillInTheBlank(
              sentence: 'Hello BLANK.',
              blanks: [Blank(answer: 'world')],
            ),
          );
          await _pump(
            tester,
            english
                ? EnglishView(challenge: challenge, block: _block)
                : const PythonProjectView(challenge: _challenge, block: _block),
            size: const Size(320, 700),
            scale: 2,
            keyboard: 280,
            dark: dark,
          );
          final label = english ? 'Check answer' : 'Check link';
          final button = find.widgetWithText(FilledButton, label);
          expect(tester.getRect(button).bottom, lessThanOrEqualTo(420));
          final scrollable = find
              .descendant(
                of: find.byType(ListView),
                matching: find.byType(Scrollable),
              )
              .first;
          await tester.scrollUntilVisible(
            find.byType(TextField),
            150,
            scrollable: scrollable,
          );
          await tester.enterText(
            find.byType(TextField).first,
            english ? 'world' : 'https://example.com/project',
          );
          await tester.pumpAndSettle();
          await tester.tap(button);
          await tester.pumpAndSettle();
          final result = english
              ? find.text('Correct!')
              : find.byIcon(Icons.check_circle_outline);
          await tester.scrollUntilVisible(result, 150, scrollable: scrollable);
          expect(result, findsOneWidget);
          if (!english) {
            final submit = find.widgetWithText(FilledButton, 'Submit project');
            expect(submit, findsOneWidget);
            expect(tester.getRect(submit).bottom, lessThanOrEqualTo(420));
          }
          await _shot(
            tester,
            '${english ? 'english' : 'project'}-keyboard-$mode',
          );
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
