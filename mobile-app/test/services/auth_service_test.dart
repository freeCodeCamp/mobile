import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/auth/models/user_model.dart';
import 'package:freecodecamp/auth/services/session_service.dart';
import 'package:freecodecamp/services/auth_service.dart';

final _user = FccUserModel(
  id: 'learner',
  email: 'learner@example.invalid',
  username: 'learner',
  joinDate: DateTime(2026),
);

class _SessionService extends Fake implements AuthSessionService {
  _SessionService(this.initialUser);

  final FccUserModel? initialUser;
  final pending = Completer<void>();

  @override
  Stream<void> get sessionExpired => const Stream.empty();

  @override
  Future<FccUserModel?> restoreSession() async => initialUser;

  @override
  Future<FccUserModel> loginWithProvider(String connection) async {
    await pending.future;
    return _user;
  }

  @override
  Future<FccUserModel> loginWithEmailOtp(String email, String otp) async {
    await pending.future;
    return _user;
  }

  @override
  Future<void> logout() => pending.future;

  @override
  Future<void> deleteAccount() => pending.future;
}

void main() {
  final operations =
      <({String name, Future<void> Function(AuthNotifier) run, bool logsIn})>[
        (
          name: 'provider login',
          run: (auth) => auth.loginWithProvider('github'),
          logsIn: true,
        ),
        (
          name: 'email login',
          run: (auth) =>
              auth.loginWithEmailOtp('learner@example.invalid', '123456'),
          logsIn: true,
        ),
        (name: 'sign out', run: (auth) => auth.signOut(), logsIn: false),
        (
          name: 'delete account',
          run: (auth) => auth.deleteAccount(),
          logsIn: false,
        ),
      ];

  for (final operation in operations) {
    test(
      '${operation.name} can finish after the auth provider is disposed',
      () async {
        final session = _SessionService(operation.logsIn ? null : _user);
        final container = ProviderContainer(
          overrides: [authSessionServiceProvider.overrideWithValue(session)],
        );
        await container.read(authProvider.future);

        final pending = operation.run(container.read(authProvider.notifier));
        final completed = expectLater(pending, completes);
        container.dispose();
        session.pending.complete();

        await completed;
      },
    );

    test('${operation.name} still updates an active auth provider', () async {
      final session = _SessionService(operation.logsIn ? null : _user);
      final container = ProviderContainer(
        overrides: [authSessionServiceProvider.overrideWithValue(session)],
      );
      addTearDown(container.dispose);
      await container.read(authProvider.future);

      final pending = operation.run(container.read(authProvider.notifier));
      session.pending.complete();
      await pending;

      expect(
        container.read(authProvider).value,
        operation.logsIn ? _user : null,
      );
    });
  }
}
