import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/auth/models/user_model.dart';
import 'package:freecodecamp/learn/controllers/completion_controller.dart';
import 'package:freecodecamp/services/auth_service.dart';

final _user = FccUserModel(
  id: 'user',
  email: 'camper@example.com',
  username: 'camper',
  joinDate: DateTime(2026),
  completedChallenges: [
    CompletedChallenge(id: 'a', completedDate: DateTime(2026)),
  ],
);

class _Auth extends AuthNotifier {
  @override
  Future<FccUserModel?> build() async => _user;

  void emit(FccUserModel user) => state = AsyncData(user);
}

void main() {
  late ProviderContainer container;
  late List<Set<String>> updates;

  setUp(() async {
    container = ProviderContainer(
      overrides: [authProvider.overrideWith(_Auth.new)],
    );
    addTearDown(container.dispose);
    await container.read(authProvider.future);
    updates = [];
    container.listen(
      completedChallengeIdsProvider,
      (_, next) => updates.add(next),
    );
  });

  _Auth auth() => container.read(authProvider.notifier) as _Auth;

  test('exposes the ids of completed challenges', () {
    expect(container.read(completedChallengeIdsProvider), {'a'});
  });

  test('stays quiet when the user changes but completions do not', () {
    auth().emit(_user.copyWith(currentChallengeId: 'b'));
    container.read(completedChallengeIdsProvider);
    expect(updates, isEmpty);
  });

  test('notifies when a challenge is completed', () {
    auth().emit(
      _user.copyWith(
        completedChallenges: [
          ..._user.completedChallenges,
          CompletedChallenge(id: 'b', completedDate: DateTime(2026)),
        ],
      ),
    );
    container.read(completedChallengeIdsProvider);
    expect(updates, [
      {'a', 'b'},
    ]);
  });
}
