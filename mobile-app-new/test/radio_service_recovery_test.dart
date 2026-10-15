import 'dart:async';
import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_new/code_radio/models/code_radio_model.dart';
import 'package:mobile_app_new/code_radio/repositories/websocket_repository.dart';
import 'package:mobile_app_new/code_radio/services/code_radio_service.dart';
import 'package:mobile_app_new/code_radio/ui/player/player_viewmodel.dart';
import 'package:mobile_app_new/services/audio_service.dart';

import 'support/fake_audio_handler.dart';

class _Socket extends CodeRadioWebsocketRepository {
  final connections = <StreamController<String>>[];
  @override
  Stream<String> connect() {
    final connection = StreamController<String>();
    connections.add(connection);
    return connection.stream;
  }
}

class _Audio extends FakeAudioHandler {
  String? radioId;
  @override
  String? get codeRadioSongId => radioId;
  @override
  void updateCodeRadioSong(Song song) {
    radioId = song.id;
  }
}

String _frame(String id) => jsonEncode({
  'pub': {
    'data': {
      'np': {
        'station': {'listen_url': 'https://example.com/live'},
        'listeners': {'total': 10},
        'now_playing': {
          'duration': 100,
          'elapsed': 5,
          'song': {
            'id': id,
            'title': id,
            'artist': 'Artist',
            'album': '',
            'art': '',
          },
        },
        'playing_next': {
          'song': {
            'id': 'next',
            'title': 'Next',
            'artist': 'Artist',
            'album': '',
            'art': '',
          },
        },
      },
    },
  },
});
Future<void> _flush() => Future<void>.delayed(Duration.zero);
void main() {
  for (final withFrame in [false, true]) {
    test(
      'clean station close ${withFrame ? 'after data' : 'before first frame'} becomes retryable and retry reconnects',
      () async {
        final socket = _Socket();
        final container = ProviderContainer(
          overrides: [
            codeRadioWebsocketRepositoryProvider.overrideWithValue(socket),
            audioHandlerProvider.overrideWithValue(_Audio()),
          ],
        );
        addTearDown(container.dispose);
        final listener = container.listen(
          codeRadioNowPlayingProvider,
          (_, _) {},
        );
        addTearDown(listener.close);
        await _flush();
        expect(socket.connections, hasLength(1));
        if (withFrame) {
          socket.connections.first.add(_frame('original'));
          await _flush();
          expect(
            container
                .read(codeRadioNowPlayingProvider)
                .value
                ?.nowPlaying
                .song
                .id,
            'original',
          );
        }
        await socket.connections.first.close();
        await _flush();
        expect(container.read(codeRadioNowPlayingProvider).hasError, isTrue);
        expect(
          container.read(codeRadioNowPlayingProvider).error.toString(),
          contains('connection closed'),
        );
        container.invalidate(codeRadioNowPlayingProvider);
        await container.pump();
        expect(socket.connections, hasLength(2));
        expect(container.read(codeRadioNowPlayingProvider).isLoading, isTrue);
        socket.connections.last.add(_frame('fresh'));
        await _flush();
        expect(container.read(codeRadioNowPlayingProvider).hasError, isFalse);
        expect(
          container.read(codeRadioNowPlayingProvider).value?.nowPlaying.song.id,
          'fresh',
        );
      },
    );
  }
  test(
    'closing before the UI subscribes replays the connection failure',
    () async {
      final socket = _Socket();
      final service = CodeRadioService(socket, _Audio());
      addTearDown(service.dispose);
      service.start();
      await socket.connections.first.close();
      final error = Completer<Object>();
      final sub = service.updates.listen(
        (_) {},
        onError: (Object value) => error.complete(value),
      );
      addTearDown(sub.cancel);
      expect(await error.future, isA<StateError>());
    },
  );
  test(
    'audio source change cancels intentionally and retry starts fresh without false errors',
    () async {
      final socket = _Socket();
      final audio = _Audio()..radioId = 'original';
      final service = CodeRadioService(socket, audio);
      addTearDown(service.dispose);
      final errors = <Object>[];
      final values = <CodeRadio>[];
      final sub = service.updates.listen(values.add, onError: errors.add);
      addTearDown(sub.cancel);
      service.start();
      await _flush();
      socket.connections.first.add(_frame('original'));
      await _flush();
      audio.radioId = null;
      audio.playbackState.add(PlaybackState());
      await _flush();
      expect(socket.connections.first.hasListener, isFalse);
      await socket.connections.first.close();
      await _flush();
      expect(errors, isEmpty);
      service.start();
      socket.connections.last.add(_frame('fresh'));
      await _flush();
      expect(socket.connections, hasLength(2));
      expect(values.last.nowPlaying.song.id, 'fresh');
      expect(errors, isEmpty);
    },
  );
  test(
    'disposing an active connection does not publish a closure error',
    () async {
      final socket = _Socket();
      final service = CodeRadioService(socket, _Audio());
      final errors = <Object>[];
      final done = Completer<void>();
      service.updates.listen(
        (_) {},
        onError: errors.add,
        onDone: done.complete,
      );
      service.start();
      await _flush();
      service.dispose();
      await socket.connections.first.close();
      await done.future;
      expect(errors, isEmpty);
      service.start();
      expect(socket.connections, hasLength(1));
    },
  );
}
