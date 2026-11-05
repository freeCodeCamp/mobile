import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:freecodecamp/code_radio/models/code_radio_model.dart';
import 'package:freecodecamp/code_radio/repositories/websocket_repository.dart';
import 'package:freecodecamp/services/audio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'code_radio_service.g.dart';

@Riverpod(keepAlive: true)
CodeRadioService codeRadioService(Ref ref) {
  final service = CodeRadioService(
    ref.watch(codeRadioWebsocketRepositoryProvider),
    ref.watch(audioHandlerProvider),
  );

  ref.onDispose(service.dispose);

  return service;
}

class CodeRadioService {
  CodeRadioService(this._repository, this._handler);

  final CodeRadioWebsocketRepository _repository;
  final AudioPlayerHandler _handler;

  final StreamController<CodeRadio> _updates =
      StreamController<CodeRadio>.broadcast();

  StreamSubscription<CodeRadio>? _station;
  StreamSubscription<dynamic>? _playback;
  CodeRadio? _latest;

  bool _isLoaded = false;
  bool _disposed = false;
  int _connectionGeneration = 0;
  (Object, StackTrace)? _failure;

  Stream<CodeRadio> get updates => Stream.multi((controller) {
    // Subscribe before replaying the snapshot so a closure between connection
    // startup and the first UI subscription cannot leave the UI loading.
    final subscription = _updates.stream.listen(
      controller.add,
      onError: controller.addError,
      onDone: controller.close,
    );
    final failure = _failure;
    if (failure != null) {
      controller.addError(failure.$1, failure.$2);
    } else if (_latest != null) {
      controller.add(_latest!);
    }
    controller.onCancel = subscription.cancel;
  });

  void start() {
    if (_disposed) return;
    if (_station == null) {
      final generation = ++_connectionGeneration;
      _failure = null;
      _station = _repository
          .connect()
          .map((frame) => jsonDecode(frame) as Map<String, dynamic>)
          .where((frame) => frame.containsKey('pub'))
          .map(
            (frame) => CodeRadio.fromJson(
              frame['pub']['data']['np'] as Map<String, dynamic>,
            ),
          )
          .listen(
            (radio) {
              if (!_disposed && generation == _connectionGeneration) {
                _onFrame(radio);
              }
            },
            onError: (Object error, StackTrace stackTrace) =>
                _connectionFailed(generation, error, stackTrace),
            onDone: () => _connectionFailed(
              generation,
              StateError('The Code Radio connection closed. Please try again.'),
              StackTrace.current,
            ),
          );
    }

    _playback ??= _handler.playbackState.listen((_) {
      if (_handler.codeRadioSongId != null) {
        _isLoaded = true;
      } else if (_isLoaded) {
        _stop();
      }
    });
  }

  void _connectionFailed(int generation, Object error, StackTrace stackTrace) {
    // A cancelled connection may still have queued callbacks. Only unexpected
    // termination of the active connection should become a retryable error.
    if (_disposed || generation != _connectionGeneration) return;
    log('Error in CodeRadioService: $error');
    _dropStation();
    _failure = (error, stackTrace);
    _updates.addError(error, stackTrace);
  }

  void _stop() {
    _dropStation();
    _failure = null;
    _isLoaded = false;
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    log('Disposing CodeRadioService');
    _dropStation();
    _playback?.cancel();
    _updates.close();
  }

  void _onFrame(CodeRadio radio) {
    _latest = radio;
    _updates.add(radio);

    final song = radio.nowPlaying.song;

    if (_handler.codeRadioSongId != null &&
        _handler.codeRadioSongId != song.id) {
      _handler.updateCodeRadioSong(song);
    }
  }

  void _dropStation() {
    _connectionGeneration++;
    _station?.cancel();
    _station = null;
    _latest = null;
  }
}
