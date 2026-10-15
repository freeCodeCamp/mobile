import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
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

void main() {
  testWidgets('empty mini player does not start the radio feature', (
    tester,
  ) async {
    final handler = _FakeAudioHandler();
    var radioSubscriptions = 0;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          audioHandlerProvider.overrideWithValue(handler),
          codeRadioNowPlayingProvider.overrideWith((ref) {
            radioSubscriptions++;
            return Stream.value(_radio);
          }),
        ],
        child: const MaterialApp(
          home: Scaffold(bottomNavigationBar: MiniPlayer()),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(IconButton), findsNothing);
    expect(find.byType(LinearProgressIndicator), findsNothing);
    expect(radioSubscriptions, 0);
    expect(handler.playCalls, 0);
  });

  testWidgets(
    'podcast mini player controls playback and opens the loaded episode',
    (tester) async {
      final handler = _FakeAudioHandler()..showPodcast();
      Object? routeExtra;
      var radioSubscriptions = 0;
      final router = GoRouter(
        initialLocation: '/mini',
        routes: [
          GoRoute(
            path: '/mini',
            builder: (_, _) =>
                const Scaffold(bottomNavigationBar: MiniPlayer()),
          ),
          GoRoute(
            path: '/podcasts/:podcastId/:episodeId',
            builder: (_, state) {
              routeExtra = state.extra;
              return const Scaffold(body: Text('Episode destination'));
            },
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            audioHandlerProvider.overrideWithValue(handler),
            codeRadioNowPlayingProvider.overrideWith((ref) {
              radioSubscriptions++;
              return Stream.value(_radio);
            }),
          ],
          child: MaterialApp.router(
            routerConfig: router,
            theme: FccTheme.themeLight,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(_episode.title), findsOneWidget);
      expect(find.text('0:30 of 2:00'), findsOneWidget);
      expect(
        tester
            .widget<LinearProgressIndicator>(
              find.byType(LinearProgressIndicator),
            )
            .value,
        0.25,
      );
      expect(radioSubscriptions, 0);

      await tester.tap(find.byTooltip('Pause audio'));
      await tester.pumpAndSettle();
      expect(handler.pauseCalls, 1);
      expect(find.text('Episode destination'), findsNothing);

      await tester.tap(find.byTooltip('Resume audio'));
      await tester.pumpAndSettle();
      expect(handler.playCalls, 1);

      await tester.tap(find.text(_episode.title));
      await tester.pumpAndSettle();
      expect(find.text('Episode destination'), findsOneWidget);
      expect(routeExtra, (_podcast, _episode));
    },
  );

  testWidgets('radio mini player shows live metadata and opens Code Radio', (
    tester,
  ) async {
    final handler = _FakeAudioHandler()..showRadio();
    final router = GoRouter(
      initialLocation: '/mini',
      routes: [
        GoRoute(
          path: '/mini',
          builder: (_, _) => const Scaffold(bottomNavigationBar: MiniPlayer()),
        ),
        GoRoute(
          path: '/code-radio',
          builder: (_, _) => const Scaffold(body: Text('Radio destination')),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          audioHandlerProvider.overrideWithValue(handler),
          codeRadioNowPlayingProvider.overrideWith(
            (ref) => Stream.value(_radio),
          ),
          codeRadioElapsedProvider.overrideWith((ref) => Stream.value(30)),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          theme: FccTheme.themeDark,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Code Radio'), findsOneWidget);
    expect(find.text('Focus · A musician'), findsOneWidget);
    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      0.25,
    );

    await tester.tap(find.text('Code Radio'));
    await tester.pumpAndSettle();
    expect(find.text('Radio destination'), findsOneWidget);
  });

  testWidgets(
    'mini player disables controls while buffering and disappears on stop',
    (tester) async {
      final handler = _FakeAudioHandler()..showPodcast();
      handler.playbackState.add(
        handler.playbackState.value.copyWith(
          processingState: AudioProcessingState.buffering,
        ),
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [audioHandlerProvider.overrideWithValue(handler)],
          child: const MaterialApp(
            home: Scaffold(bottomNavigationBar: MiniPlayer()),
          ),
        ),
      );
      await tester.pump();

      expect(
        tester.widget<IconButton>(find.byType(IconButton)).onPressed,
        isNull,
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await handler.stop();
      await tester.pumpAndSettle();
      expect(find.byType(IconButton), findsNothing);
      expect(find.text(_episode.title), findsNothing);
    },
  );
}

class _FakeAudioHandler extends BaseAudioHandler implements AudioPlayerHandler {
  bool _isRadio = false;
  (Podcast, Episode)? _episode;
  int pauseCalls = 0;
  int playCalls = 0;

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
