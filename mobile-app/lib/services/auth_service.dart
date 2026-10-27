import 'package:freecodecamp/auth/models/user_model.dart';
import 'package:freecodecamp/auth/services/profile_service.dart';
import 'package:freecodecamp/auth/services/session_service.dart';
import 'package:freecodecamp/utils/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_service.g.dart';

extension AuthStatus on AsyncValue<FccUserModel?> {
  bool get isLoggedIn => value != null;
}

// NOTE: The signed-in user, or null when signed out. The only place auth state changes.
@Riverpod(keepAlive: true, retry: noRetry)
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<FccUserModel?> build() {
    final session = ref.watch(authSessionServiceProvider);

    // NOTE: Any authenticated call rejected with a 401 signs the user out everywhere.
    final sub = session.sessionExpired.listen((_) {
      state = const AsyncData(null);
    });
    ref.onDispose(sub.cancel);

    return session.restoreSession();
  }

  AuthSessionService get _session => ref.read(authSessionServiceProvider);

  Future<void> loginWithProvider(String connection) async {
    state = AsyncData(await _session.loginWithProvider(connection));
  }

  Future<void> loginWithEmailOtp(String email, String otp) async {
    state = AsyncData(await _session.loginWithEmailOtp(email, otp));
  }

  Future<void> refresh() async {
    if (state.hasError) {
      ref.invalidateSelf();
      return;
    }
    final userId = state.value?.id;
    if (userId == null) return;

    final user = await _session.restoreSession();
    if (ref.mounted &&
        state.value?.id == userId &&
        (user == null || user.id == userId)) {
      state = AsyncData(user);
    }
  }

  Future<void> signOut() async {
    await _session.logout();
    state = const AsyncData(null);
  }

  Future<ProfileSaveResult> saveProfile({
    required FccUserModel original,
    required FccUserModel draft,
  }) async {
    final result = await ref
        .read(profileServiceProvider)
        .save(
          original: original,
          draft: draft,
          isCurrentUser: () => ref.mounted && state.value?.id == original.id,
        );
    final user = result.user;
    if (ref.mounted &&
        user != null &&
        user.id == original.id &&
        state.value?.id == original.id) {
      state = AsyncData(user);
    }
    return result;
  }

  Future<void> deleteAccount() async {
    await _session.deleteAccount();
    state = const AsyncData(null);
  }
}
