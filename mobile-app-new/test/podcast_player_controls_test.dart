import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/podcasts/controllers/library_controller.dart';
import 'package:mobile_app_new/podcasts/controllers/player_controller.dart';
import 'package:mobile_app_new/podcasts/models/episode_model.dart';
import 'package:mobile_app_new/podcasts/models/podcast_model.dart';
import 'package:mobile_app_new/podcasts/services/library_service.dart';
import 'package:mobile_app_new/podcasts/ui/episode/episode_view.dart';
import 'package:mobile_app_new/podcasts/ui/widgets/episode_tile.dart';

const _podcast = Podcast(
  id: 'show',
  feedUrl: '',
  podcastLink: '',
  title: 'A podcast',
  imageLink: '',
);
const _episode = Episode(
  id: 'displayed',
  podcastId: 'show',
  title: 'The displayed episode',
  audioUrl: 'https://example.com/episode.mp3',
  duration: Duration(minutes: 10),
);

Future<_RecordingPlayer> _pumpPlayer(
  WidgetTester tester, {
  String currentId = 'displayed',
  Widget? body,
  double width = 390,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 844);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final player = _RecordingPlayer(currentId);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        podcastPlayerProvider.overrideWith(() => player),
        podcastLibraryProvider.overrideWith(_EmptyLibrary.new),
        podcastPlaybackPositionProvider.overrideWith(
          (ref) => Stream.value(const Duration(minutes: 2)),
        ),
      ],
      child: MaterialApp(
        theme: FccTheme.themeLight,
        home: body == null
            ? const PodcastEpisodeView(podcast: _podcast, episode: _episode)
            : Scaffold(body: body),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return player;
}

IconButton _transport(WidgetTester tester, String tooltip) =>
    tester.widget<IconButton>(
      find.widgetWithIcon(
        IconButton,
        tooltip == 'Rewind 10 seconds'
            ? Icons.replay_10_rounded
            : Icons.forward_30_rounded,
      ),
    );

void main() {
  testWidgets('active episode row keeps playback time and actions', (
    tester,
  ) async {
    final player = await _pumpPlayer(
      tester,
      width: 430,
      body: const PodcastEpisodeTile(podcast: _podcast, episode: _episode),
    );

    expect(find.text('8 min left'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsNothing);
    expect(find.byTooltip('Download episode'), findsOneWidget);
    expect(find.byTooltip('Episode options'), findsOneWidget);
    await tester.tap(find.byTooltip('Pause episode'));
    await tester.pumpAndSettle();
    expect(player.toggledIds, ['displayed']);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'another playing episode cannot be sought or have its speed changed',
    (tester) async {
      final player = await _pumpPlayer(tester, currentId: 'another-episode');

      expect(tester.widget<Slider>(find.byType(Slider)).onChanged, isNull);
      expect(_transport(tester, 'Rewind 10 seconds').onPressed, isNull);
      expect(_transport(tester, 'Forward 30 seconds').onPressed, isNull);
      expect(
        tester.widget<OutlinedButton>(find.byType(OutlinedButton)).onPressed,
        isNull,
      );

      // Starting the displayed episode remains available even though transport
      // controls for the other episode are deliberately unavailable.
      await tester.tap(find.byTooltip('Play episode'));
      await tester.pumpAndSettle();
      expect(player.toggledIds, ['displayed']);
      expect(tester.widget<Slider>(find.byType(Slider)).onChanged, isNotNull);
    },
  );

  testWidgets(
    'the loaded episode supports transport, seeking and speed selection',
    (tester) async {
      final player = await _pumpPlayer(tester);

      await tester.tap(find.byTooltip('Rewind 10 seconds'));
      await tester.tap(find.byTooltip('Forward 30 seconds'));
      expect(player._rewindCalls, 1);
      expect(player._forwardCalls, 1);

      final slider = tester.widget<Slider>(find.byType(Slider));
      slider.onChanged!(0.5);
      slider.onChangeEnd!(0.5);
      await tester.pump();
      expect(player.seekPositions, [const Duration(minutes: 5)]);

      await tester.tap(find.byType(OutlinedButton));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ChoiceChip, '1.5×'));
      await tester.pumpAndSettle();
      expect(player.speeds, [1.5]);
    },
  );

  testWidgets(
    'switching the audio source during a scrub cannot seek the new source',
    (tester) async {
      final player = await _pumpPlayer(tester);
      final slider = tester.widget<Slider>(find.byType(Slider));

      slider.onChanged!(0.5);
      player.selectEpisode('another-episode');
      // The pending gesture still holds the old callback until the next frame.
      slider.onChangeEnd!(0.5);
      await tester.pumpAndSettle();

      expect(player.seekPositions, isEmpty);
      expect(tester.widget<Slider>(find.byType(Slider)).onChanged, isNull);
    },
  );

  testWidgets(
    'switching the audio source while the speed sheet is open ignores its result',
    (tester) async {
      final player = await _pumpPlayer(tester);
      await tester.tap(find.byType(OutlinedButton));
      await tester.pumpAndSettle();
      expect(find.text('Playback speed'), findsOneWidget);

      player.selectEpisode('another-episode');
      await tester.pump();
      await tester.tap(find.widgetWithText(ChoiceChip, '1.5×'));
      await tester.pumpAndSettle();

      expect(player.speeds, isEmpty);
      expect(
        tester.widget<OutlinedButton>(find.byType(OutlinedButton)).onPressed,
        isNull,
      );
    },
  );
}

class _EmptyLibrary extends PodcastLibraryNotifier {
  @override
  Future<PodcastLibrary> build() async => (
    podcasts: <Podcast>[],
    episodesByPodcastId: <String, List<Episode>>{},
    artworkByPodcastId: <String, File>{},
  );
}

class _RecordingPlayer extends PodcastPlayerNotifier {
  _RecordingPlayer(this.initialEpisodeId);
  final String initialEpisodeId;
  int _rewindCalls = 0;
  int _forwardCalls = 0;
  final seekPositions = <Duration>[];
  final speeds = <double>[];
  final toggledIds = <String>[];

  @override
  PodcastPlayerState build() => PodcastPlayerState(
    episodeId: initialEpisodeId,
    isPlaying: true,
    duration: const Duration(minutes: 10),
  );

  void selectEpisode(String id) => state = state.copyWith(episodeId: id);

  @override
  Future<void> toggle(Podcast podcast, Episode episode) async {
    toggledIds.add(episode.id);
    selectEpisode(episode.id);
  }

  @override
  Future<void> rewind() async => _rewindCalls++;

  @override
  Future<void> fastForward() async => _forwardCalls++;

  @override
  Future<void> seek(Duration position) async => seekPositions.add(position);

  @override
  Future<void> setSpeed(double speed) async {
    speeds.add(speed);
    state = state.copyWith(speed: speed);
  }
}
