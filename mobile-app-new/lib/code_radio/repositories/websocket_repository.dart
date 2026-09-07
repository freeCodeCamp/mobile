import 'dart:convert';
import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'websocket_repository.g.dart';

const _url =
    'wss://coderadio-admin-v2.freecodecamp.org/api/live/nowplaying/websocket';

const _station = 'station:coderadio';

@riverpod
CodeRadioWebsocketRepository codeRadioWebsocketRepository(Ref ref) {
  final repository = CodeRadioWebsocketRepository();
  ref.onDispose(repository.dispose);
  return repository;
}

class CodeRadioWebsocketRepository {
  WebSocketChannel? _channel;

  Stream<String> connect() async* {
    await _channel?.sink.close();

    final channel = _channel = WebSocketChannel.connect(Uri.parse(_url));

    await channel.ready;

    channel.sink.add(
      jsonEncode({
        'subs': {_station: <String, dynamic>{}},
      }),
    );

    yield* channel.stream.cast<String>();
  }

  void dispose() {
    log('Disposing CodeRadioWebsocketRepository');
    _channel?.sink.close();
  }
}
