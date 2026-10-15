import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app_new/code_radio/ui/player/player_view.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile_app_new/code_radio/models/code_radio_model.dart';
import 'package:mobile_app_new/code_radio/ui/player/player_viewmodel.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/podcasts/models/episode_model.dart';
import 'package:mobile_app_new/podcasts/models/podcast_model.dart';
import 'package:mobile_app_new/services/audio_service.dart';
import 'package:mobile_app_new/widgets/mini_player.dart';

const _podcast = Podcast(
  id: 'show-1',
  feedUrl: '',
  podcastLink: '',
  title: 'The freeCodeCamp Podcast',
  imageLink: '',
);
const _episode = Episode(
  id: 'episode-1',
  podcastId: 'show-1',
  title: 'Learning to code',
  audioUrl: 'https://example.com/episode.mp3',
  duration: Duration(minutes: 2),
);
const _radio = CodeRadio(
  station: Station(listenUrl: 'https://example.com/radio'),
  listeners: Listeners(total: 42),
  nowPlaying: NowPlaying(
    duration: 120,
    elapsed: 30,
    song: Song(
      id: 'song-1',
      title: 'Focus',
      artist: 'A musician',
      album: '',
      art: '',
    ),
  ),
  playingNext: PlayingNext(
    song: Song(
      id: 'song-2',
      title: 'Next song',
      artist: 'An artist',
      album: '',
      art: '',
    ),
  ),
);

final capture = GlobalKey();
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await (FontLoader(
      'Lato',
    )..addFont(rootBundle.load('assets/fonts/Lato-Regular.ttf'))).load();
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
  });
  for (final viewport in [
    const Size(390, 844),
    const Size(320, 640),
    const Size(844, 390),
    const Size(768, 1024),
  ]) {
    for (final dark in [false, true]) {
      testWidgets(
        'radio entry preserves podcast until explicit play ${dark ? "dark" : "light"} $viewport',
        (tester) async {
          tester.view.physicalSize = viewport;
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          final handler = _FakeAudioHandler()..showPodcast();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                audioHandlerProvider.overrideWithValue(handler),
                codeRadioNowPlayingProvider.overrideWith(
                  (ref) => Stream.value(_radio),
                ),
                codeRadioElapsedProvider.overrideWith(
                  (ref) => Stream.value(30),
                ),
              ],
              child: RepaintBoundary(
                key: capture,
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: dark ? FccTheme.themeDark : FccTheme.themeLight,
                  builder: (context, child) => MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaler: TextScaler.linear(
                        viewport.width == 390 ? 1 : 2,
                      ),
                    ),
                    child: child!,
                  ),
                  home: const CodeRadioPlayerView(),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(handler.radioLoads, 0);
          expect(handler.playCalls, 0);
          expect(handler.currentPodcastEpisode, isNotNull);
          expect(find.byType(MiniPlayer), findsOneWidget);
          expect(find.byTooltip('Play Code Radio'), findsOneWidget);
          await tester.ensureVisible(find.byTooltip('Play Code Radio'));
          await tester.pumpAndSettle();
          await tester.tap(find.byTooltip('Play Code Radio'));
          await tester.pumpAndSettle();
          expect(handler.radioLoads, 1);
          expect(handler.playCalls, 1);
          expect(handler.currentPodcastEpisode, isNull);
          expect(find.byType(MiniPlayer), findsNothing);
          expect(find.byType(NavigationDestination), findsNWidgets(5));
          expect(find.byTooltip('Pause Code Radio'), findsOneWidget);
          const dir = String.fromEnvironment('UI_SCREENSHOT_DIR');
          if (dir.isNotEmpty && viewport.width == 390) {
            await tester.drag(
              find.byType(CustomScrollView),
              const Offset(0, 2000),
            );
            await tester.pumpAndSettle();
            await tester.runAsync(() async {
              final img =
                  await (capture.currentContext!.findRenderObject()
                          as RenderRepaintBoundary)
                      .toImage(pixelRatio: 2);
              final data = await img.toByteData(format: ui.ImageByteFormat.png);
              await File(
                '$dir/radio-${dark ? "dark" : "light"}.png',
              ).create(recursive: true);
              await File(
                '$dir/radio-${dark ? "dark" : "light"}.png',
              ).writeAsBytes(data!.buffer.asUint8List());
              img.dispose();
            });
          }
          await tester.ensureVisible(find.byTooltip('Pause Code Radio'));
          await tester.pumpAndSettle();
          await tester.tap(find.byTooltip('Pause Code Radio'));
          await tester.pumpAndSettle();
          expect(handler.pauseCalls, 1);
          expect(find.byTooltip('Play Code Radio'), findsOneWidget);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}

class _FakeAudioHandler extends BaseAudioHandler implements AudioPlayerHandler {
  bool _isRadio = false;
  (Podcast, Episode)? _episode;
  int pauseCalls = 0;
  int playCalls = 0;
  int radioLoads = 0;
  @override
  Future<void> loadCodeRadio(CodeRadio radio) async {
    radioLoads++;
    showRadio();
  }

  @override
  (Podcast, Episode)? get currentPodcastEpisode => _episode;

  @override
  String? get codeRadioSongId => _isRadio ? mediaItem.value?.id : null;

  @override
  String? get episodeId => _episode?.$2.id;

  @override
  bool get isPlayingCodeRadio => _isRadio && playbackState.value.playing;

  @override
  Duration? get duration => mediaItem.value?.duration;

  @override
  Stream<Duration> get positionStream =>
      Stream.value(const Duration(seconds: 30));

  void showPodcast() {
    _isRadio = false;
    _episode = (_podcast, _episodeModel);
    mediaItem.add(
      const MediaItem(
        id: 'episode-1',
        title: 'Learning to code',
        album: 'The freeCodeCamp Podcast',
        duration: Duration(minutes: 2),
      ),
    );
    playbackState.add(
      PlaybackState(playing: true, processingState: AudioProcessingState.ready),
    );
  }

  void showRadio() {
    _isRadio = true;
    _episode = null;
    mediaItem.add(
      const MediaItem(id: 'song-1', title: 'Focus', artist: 'A musician'),
    );
    playbackState.add(
      PlaybackState(playing: true, processingState: AudioProcessingState.ready),
    );
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
    _isRadio = false;
    _episode = null;
    mediaItem.add(null);
    playbackState.add(PlaybackState());
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// Avoid shadowing the test fixture with the fake handler's current model field.
const _episodeModel = _episode;
