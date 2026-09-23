import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'websocket_repository.g.dart';

const _url =
    'wss://coderadio-admin-v2.freecodecamp.org/api/live/nowplaying/websocket';

const _station = 'station:coderadio';

const _connectTimeout = Duration(seconds: 8);

@Riverpod(keepAlive: true)
CodeRadioWebsocketRepository codeRadioWebsocketRepository(Ref ref) {
  final repository = CodeRadioWebsocketRepository();
  ref.onDispose(repository.dispose);
  return repository;
}

class CodeRadioWebsocketRepository {
  WebSocketChannel? _channel;

  Stream<String> connect() async* {
    _discard(_channel);

    final channel = _channel = WebSocketChannel.connect(Uri.parse(_url));

    try {
      await channel.ready.timeout(_connectTimeout);
    } catch (_) {
      _discard(channel);
      if (identical(_channel, channel)) _channel = null;
      rethrow;
    }

    channel.sink.add(
      jsonEncode({
        'subs': {_station: <String, dynamic>{}},
      }),
    );

    yield* channel.stream.cast<String>();
  }

  void _discard(WebSocketChannel? channel) => channel?.sink.close().ignore();

  void dispose() {
    log('Disposing CodeRadioWebsocketRepository');
    _discard(_channel);
    _channel = null;
  }
}
