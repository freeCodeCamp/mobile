import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/models/curriculum_model.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/help_dialog.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/quiz_audio_player.dart';
import 'package:mobile_app_new/learn/ui/widgets/scene/scene_controls.dart';
import 'package:mobile_app_new/services/audio_service.dart';

const _challenge = Challenge(
  id: 'lesson',
  block: 'html-basics',
  superBlock: 'responsive-web-design',
  title: 'Understand attributes',
  dashedName: 'understand-attributes',
  challengeType: 11,
  helpCategory: 'HTML-CSS',
);
const _block = Block(
  superBlock: 'responsive-web-design',
  dashedName: 'html-basics',
  name: 'Basic HTML',
  layout: BlockLayout.challengeList,
  label: BlockLabel.lecture,
  description: [],
  challenges: [],
);
const _audio = QuizAudioData(
  audio: AudioClip(filename: 'greeting.mp3'),
  transcript: [
    TranscriptLine(character: 'Maria', text: 'Welcome to the team.'),
  ],
);
const _scene = Scene(
  setup: SceneSetup(
    background: 'office',
    audio: AudioClip(filename: 'greeting.mp3'),
    characters: [],
  ),
  commands: [],
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  for (final dark in [false, true]) {
    testWidgets(
      'help keeps confirmation requirements and opens a draft (${dark ? 'dark' : 'light'})',
      (tester) async {
        tester.view.physicalSize = const Size(320, 720);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final opened = <Uri>[];
        const channel = MethodChannel('plugins.flutter.io/url_launcher');
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          channel,
          (call) async {
            if (call.method == 'launch') {
              opened.add(
                Uri.parse(
                  (call.arguments as Map<Object?, Object?>)['url']! as String,
                ),
              );
            }
            return true;
          },
        );
        addTearDown(
          () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
            channel,
            null,
          ),
        );
        await tester.pumpWidget(
          MaterialApp(
            theme: dark ? FccTheme.themeDark : FccTheme.themeLight,
            home: Scaffold(
              body: Builder(
                builder: (context) => TextButton(
                  onPressed: () =>
                      showHelpDialog(context, _challenge, _block.name),
                  child: const Text('Help'),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Help'));
        await tester.pumpAndSettle();
        expect(find.text('Stuck? Get help'), findsOneWidget);
        await tester.tap(find.text('Create a post'));
        await tester.pumpAndSettle();
        expect(opened, isEmpty);
        FilledButton submit() => tester.widget<FilledButton>(
          find.widgetWithText(FilledButton, 'Continue to forum'),
        );
        expect(submit().onPressed, isNull);
        expect(find.text('Add at least 50 more characters.'), findsOneWidget);
        await tester.enterText(find.byType(TextField), 'short');
        await tester.pump();
        expect(find.text('Add at least 45 more characters.'), findsOneWidget);
        expect(submit().onPressed, isNull);
        const description =
            'I tried changing the link attributes, but the lesson still reports that my answer is incorrect.';
        await tester.enterText(find.byType(TextField), description);
        await tester.pump();
        expect(find.textContaining('Add at least'), findsNothing);
        expect(find.text("Great, that's enough detail."), findsNothing);
        expect(submit().onPressed, isNull);
        await tester.ensureVisible(find.byType(Checkbox).first);
        await tester.tap(find.byType(Checkbox).first);
        await tester.pump();
        expect(submit().onPressed, isNull);
        await tester.ensureVisible(find.byType(Checkbox).last);
        await tester.tap(find.byType(Checkbox).last);
        await tester.pump();
        expect(submit().onPressed, isNotNull);
        expect(opened, isEmpty);
        await tester.tap(find.text('Continue to forum'));
        await tester.pumpAndSettle();
        expect(opened, hasLength(1));
        expect(opened.single.path, '/new-topic');
        expect(opened.single.queryParameters['body'], contains(description));
        expect(
          opened.single.queryParameters['body'],
          contains(
            'https://www.freecodecamp.org/learn/responsive-web-design/html-basics/understand-attributes',
          ),
        );
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('quiz audio can retry, play, pause and reveal its transcript', (
    tester,
  ) async {
    final handler = _FakeAudioHandler()..loadSucceeds = false;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [audioHandlerProvider.overrideWithValue(handler)],
        child: MaterialApp(
          theme: FccTheme.themeLight,
          home: const Scaffold(body: QuizAudioPlayer(audioData: _audio)),
        ),
      ),
    );
    await tester.tap(find.byTooltip('Play audio'));
    await tester.pumpAndSettle();
    expect(find.text("We couldn't load this audio."), findsOneWidget);
    handler.loadSucceeds = true;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(handler.playCalls, 1);
    await tester.tap(find.byTooltip('Pause audio'));
    await tester.pumpAndSettle();
    expect(handler.pauseCalls, 1);
    await tester.tap(find.text('Transcript'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Welcome to the team.', findRichText: true),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'scene controls retain captions, playback and fullscreen at narrow width',
    (tester) async {
      tester.view.physicalSize = const Size(320, 720);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final handler = _FakeAudioHandler();
      var fullscreenCalls = 0;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [audioHandlerProvider.overrideWithValue(handler)],
          child: MaterialApp(
            theme: FccTheme.themeDark,
            home: Scaffold(
              body: SceneControls(
                scene: _scene,
                title: 'Greetings',
                onFullscreen: () => fullscreenCalls++,
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byTooltip('Show captions'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Hide captions'), findsOneWidget);
      await tester.tap(find.byTooltip('Play'));
      await tester.pumpAndSettle();
      expect(handler.playCalls, 1);
      await tester.tap(find.byTooltip('Pause'));
      await tester.pumpAndSettle();
      expect(handler.pauseCalls, 1);
      await tester.tap(find.byTooltip('Fullscreen'));
      expect(fullscreenCalls, 1);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
    },
  );
}

class _FakeAudioHandler extends BaseAudioHandler implements AudioPlayerHandler {
  @override
  String? curriculumClipId;
  bool loadSucceeds = true;
  int playCalls = 0;
  int pauseCalls = 0;

  @override
  Duration? get duration => const Duration(seconds: 20);

  @override
  Stream<Duration> get positionStream =>
      Stream.value(const Duration(seconds: 2));

  @override
  Future<bool> loadCurriculumAudio(
    Uri source, {
    required String clipId,
    required String title,
    Duration start = Duration.zero,
    Duration? end,
  }) async {
    if (!loadSucceeds) return false;
    curriculumClipId = clipId;
    playbackState.add(
      PlaybackState(processingState: AudioProcessingState.ready),
    );
    return true;
  }

  @override
  Future<void> play() async {
    playCalls++;
    playbackState.add(playbackState.value.copyWith(playing: true));
  }

  @override
  Future<void> pause() async {
    pauseCalls++;
    playbackState.add(playbackState.value.copyWith(playing: false));
  }

  @override
  Future<void> stop() async {
    curriculumClipId = null;
    playbackState.add(PlaybackState());
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
