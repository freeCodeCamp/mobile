import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/podcasts/controllers/library_controller.dart';
import 'package:freecodecamp/podcasts/controllers/player_controller.dart';
import 'package:freecodecamp/podcasts/models/episode_model.dart';
import 'package:freecodecamp/podcasts/models/podcast_model.dart';
import 'package:freecodecamp/podcasts/services/library_service.dart';
import 'package:freecodecamp/podcasts/ui/downloads/downloads_view.dart';

const _podcast = Podcast(
  id: 'show',
  feedUrl: '',
  podcastLink: '',
  title: 'The freeCodeCamp Podcast',
  imageLink: '',
);
const _episode = Episode(
  id: 'saved',
  podcastId: 'show',
  title: 'Building a project',
  audioUrl: 'https://example.com/episode.mp3',
  duration: Duration(minutes: 53),
);

Future<void> _pump(
  WidgetTester tester,
  _Library library, {
  bool dark = false,
  double scale = 1,
  bool offline = false,
  VoidCallback? onRetry,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(scale == 1 ? 390 : 320, 844);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        podcastLibraryProvider.overrideWith(() => library),
        podcastPlayerProvider.overrideWith(_Player.new),
      ],
      child: MaterialApp(
        theme: dark ? FccTheme.themeDark : FccTheme.themeLight,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        ),
        home: Scaffold(
          body: PodcastDownloadsView(offline: offline, onRetry: onRetry),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final lato = FontLoader('Lato');
    for (final weight in ['Regular', 'Bold', 'ExtraBold', 'Black']) {
      lato.addFont(rootBundle.load('assets/fonts/Lato-$weight.ttf'));
    }
    await lato.load();
  });

  for (final dark in [false, true]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('downloads management works in dark=$dark scale=$scale', (
        tester,
      ) async {
        final library = _Library();
        await _pump(tester, library, dark: dark, scale: scale);

        expect(find.text('53 min'), findsOneWidget);
        expect(find.textContaining('Downloaded'), findsNothing);
        expect(find.textContaining('on this device'), findsNothing);
        expect(find.byTooltip('Play episode'), findsOneWidget);
        await tester.tap(find.text('Manage'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Select all'));
        await tester.pumpAndSettle();
        expect(find.text('Remove (1)'), findsOneWidget);
        await tester.tap(find.text('Deselect all'));
        await tester.pumpAndSettle();
        expect(find.text('Remove (0)'), findsOneWidget);
        await tester.tap(find.text('Done'));
        await tester.pumpAndSettle();
        expect(find.byType(Checkbox), findsNothing);

        await tester.tap(find.text('Manage'));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(Checkbox));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Remove (1)'));
        await tester.pumpAndSettle();
        expect(library.removed, ['saved']);
        expect(find.text('No downloaded episodes'), findsOneWidget);
        expect(find.text('Manage'), findsNothing);
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('failed removal retains selection for retry', (tester) async {
    final library = _Library().._failRemoval = true;
    await _pump(tester, library);
    await tester.tap(find.text('Manage'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Select all'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove (1)'));
    await tester.pumpAndSettle();
    expect(
      find.text('Unable to remove some downloads. Please try again.'),
      findsOneWidget,
    );
    expect(find.text(_episode.title), findsOneWidget);
    expect(find.text('Remove (1)'), findsOneWidget);
    library._failRemoval = false;
    await tester.tap(find.text('Remove (1)'));
    await tester.pumpAndSettle();
    expect(library.removed, ['saved']);
    expect(find.text('No downloaded episodes'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('offline recovery keeps downloaded playback and retry', (
    tester,
  ) async {
    var retries = 0;
    await _pump(tester, _Library(), offline: true, onRetry: () => retries++);
    expect(find.text("Can't load podcasts"), findsOneWidget);
    expect(find.text('Available offline'), findsOneWidget);
    expect(find.text('53 min'), findsOneWidget);
    expect(find.byTooltip('Play episode'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    expect(retries, 1);
    expect(tester.takeException(), isNull);
  });
}

class _Library extends PodcastLibraryNotifier {
  bool _failRemoval = false;
  final removed = <String>[];

  PodcastLibrary get _library => (
    podcasts: [_podcast],
    episodesByPodcastId: {
      'show': removed.isEmpty ? [_episode] : <Episode>[],
    },
    artworkByPodcastId: <String, File>{},
  );

  @override
  Future<PodcastLibrary> build() async => _library;

  @override
  Future<void> remove(String podcastId, String episodeId) async {
    if (_failRemoval) throw StateError('Could not remove download');
    removed.add(episodeId);
    state = AsyncData(_library);
  }
}

class _Player extends PodcastPlayerNotifier {
  @override
  PodcastPlayerState build() => const PodcastPlayerState();
}
