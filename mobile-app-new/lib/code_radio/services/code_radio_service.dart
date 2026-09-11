import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:mobile_app_new/code_radio/models/code_radio_model.dart';
import 'package:mobile_app_new/code_radio/repositories/websocket_repository.dart';
import 'package:mobile_app_new/services/audio_service.dart';
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

  Stream<CodeRadio> get updates async* {
    final latest = _latest;
    if (latest != null) yield latest;

    yield* _updates.stream;
  }

  void start() {
    _station ??= _repository
        .connect()
        .map((frame) => jsonDecode(frame) as Map<String, dynamic>)
        .where((frame) => frame.containsKey('pub'))
        .map(
          (frame) => CodeRadio.fromJson(
            frame['pub']['data']['np'] as Map<String, dynamic>,
          ),
        )
        .listen(
          _onFrame,
          onError: (Object error, StackTrace stackTrace) {
            log('Error in CodeRadioService: $error');
            _updates.addError(error, stackTrace);
            _dropStation();
          },
          onDone: _dropStation,
        );

    _playback ??= _handler.playbackState.listen((_) {
      if (_handler.codeRadioSongId != null) {
        _isLoaded = true;
      } else if (_isLoaded) {
        _stop();
      }
    });
  }

  void _stop() {
    _station?.cancel();
    _station = null;
    _isLoaded = false;
  }

  void dispose() {
    log('Disposing CodeRadioService');
    _station?.cancel();
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
    _station?.cancel();
    _station = null;
  }
}
