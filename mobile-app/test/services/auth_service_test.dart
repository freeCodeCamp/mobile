import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/auth/models/user_model.dart';
import 'package:freecodecamp/auth/services/session_service.dart';
import 'package:freecodecamp/services/analytics_service.dart';
import 'package:freecodecamp/services/auth_service.dart';

import '../helpers/fake_analytics.dart';

class _FakeUser extends Fake implements FccUserModel {}

class _FakeSession extends Fake implements AuthSessionService {
  @override
  Stream<void> get sessionExpired => const Stream.empty();

  @override
  Future<FccUserModel?> restoreSession() async => null;

  @override
  Future<FccUserModel> loginWithProvider(String connection) async =>
      _FakeUser();

  @override
  Future<FccUserModel> loginWithEmailOtp(String email, String otp) async =>
      _FakeUser();

  @override
  Future<void> logout() async {}

  @override
  Future<void> deleteAccount() async {}
}

void main() {
  late FakeAnalyticsSink sink;
  late ProviderContainer container;

  setUp(() async {
    sink = FakeAnalyticsSink();
    container = ProviderContainer(
      overrides: [
        analyticsProvider.overrideWithValue(AnalyticsService(sink)),
        authSessionServiceProvider.overrideWithValue(_FakeSession()),
      ],
    );
    addTearDown(container.dispose);
    await container.read(authProvider.future);
  });

  test('a provider login logs login with the method', () async {
    await container.read(authProvider.notifier).loginWithProvider('github');
    expect(sink.logged, [
      [
        'login',
        {'method': 'github'},
      ],
    ]);
  });

  test('an email login logs login with method email', () async {
    await container
        .read(authProvider.notifier)
        .loginWithEmailOtp('camper@example.com', '123456');
    expect(sink.logged, [
      [
        'login',
        {'method': 'email'},
      ],
    ]);
  });

  test('signing out logs logout', () async {
    await container.read(authProvider.notifier).signOut();
    expect(sink.events.single.name, 'logout');
  });

  test('deleting the account logs account_deleted', () async {
    await container.read(authProvider.notifier).deleteAccount();
    expect(sink.events.single.name, 'account_deleted');
  });
}
