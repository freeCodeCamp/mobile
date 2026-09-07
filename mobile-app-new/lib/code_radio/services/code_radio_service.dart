import 'dart:convert';

import 'package:mobile_app_new/code_radio/models/code_radio_model.dart';
import 'package:mobile_app_new/code_radio/repositories/websocket_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'code_radio_service.g.dart';

@riverpod
CodeRadioService codeRadioService(Ref ref) {
  final repo = ref.watch(codeRadioWebsocketRepositoryProvider);
  return CodeRadioService(repo);
}

class CodeRadioService {
  final CodeRadioWebsocketRepository _repository;

  CodeRadioService(this._repository);

  Stream<CodeRadio> get nowPlaying => _repository
      .connect()
      .map((frame) => jsonDecode(frame) as Map<String, dynamic>)
      .where((frame) => frame.containsKey('pub'))
      .map(
        (frame) => CodeRadio.fromJson(
          frame['pub']['data']['np'] as Map<String, dynamic>,
        ),
      );
}
