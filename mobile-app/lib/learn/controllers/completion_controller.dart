import 'package:flutter/foundation.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'completion_controller.g.dart';

// Riverpod compares state with ==, which is identity for sets, so these
// notifiers compare contents to skip rebuilds when the ids are unchanged.

@riverpod
class CompletedChallengeIdsNotifier extends _$CompletedChallengeIdsNotifier {
  @override
  Set<String> build() => {
    ...?ref.watch(authProvider).value?.completedChallenges.map((c) => c.id),
  };

  @override
  bool updateShouldNotify(Set<String> previous, Set<String> next) =>
      !setEquals(previous, next);
}

@riverpod
class CompletedDailyChallengeIdsNotifier
    extends _$CompletedDailyChallengeIdsNotifier {
  @override
  Set<String> build() => {
    ...?ref
        .watch(authProvider)
        .value
        ?.completedDailyCodingChallenges
        .map((c) => c.id),
  };

  @override
  bool updateShouldNotify(Set<String> previous, Set<String> next) =>
      !setEquals(previous, next);
}
