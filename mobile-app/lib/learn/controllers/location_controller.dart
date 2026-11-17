import 'package:freecodecamp/learn/models/location_model.dart';
import 'package:freecodecamp/learn/services/location_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_controller.g.dart';

@riverpod
class LearningLocationNotifier extends _$LearningLocationNotifier {
  @override
  Future<LearnLocation?> build(String userId) async {
    final service = ref.watch(learnLocationServiceProvider);
    await service.load(userId);
    return service.current(userId);
  }

  int beginVisit() => ref.read(learnLocationServiceProvider).beginVisit(userId);

  Future<void> remember(LearnLocation location, {int? visitToken}) {
    final service = ref.read(learnLocationServiceProvider);
    return _update(
      service,
      service.remember(userId, location, visitToken: visitToken),
    );
  }

  Future<void> rememberIfUnchanged(
    LearnLocation location,
    LearnLocation? previous,
  ) {
    final service = ref.read(learnLocationServiceProvider);
    return _update(
      service,
      service.rememberIfUnchanged(userId, location, previous),
    );
  }

  Future<void> _update(
    LearnLocationService service,
    Future<void> pending,
  ) async {
    final link = ref.keepAlive();
    final location = service.current(userId);
    if (location != null && (state.isLoading || state.value != location)) {
      state = AsyncData(location);
    }
    try {
      await pending;
    } finally {
      link.close();
    }
  }
}
