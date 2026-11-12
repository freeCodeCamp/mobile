import 'package:freecodecamp/code_radio/models/code_radio_model.dart';
import 'package:freecodecamp/code_radio/services/code_radio_service.dart';
import 'package:freecodecamp/utils/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'player_controller.g.dart';

@Riverpod(retry: noRetry)
Stream<CodeRadio> codeRadioNowPlaying(Ref ref) {
  final service = ref.watch(codeRadioServiceProvider);

  service.start();

  return service.updates;
}

// The station only pushes on an event, so the seconds in between are counted
// locally. Every push resyncs the count to the server's elapsed.
@riverpod
Stream<int> codeRadioElapsed(Ref ref) async* {
  final radio = await ref.watch(codeRadioNowPlayingProvider.future);

  yield radio.nowPlaying.elapsed;

  yield* Stream.periodic(
    const Duration(seconds: 1),
    (tick) => radio.nowPlaying.elapsed + tick + 1,
  ).takeWhile((elapsed) => elapsed <= radio.nowPlaying.duration);
}
