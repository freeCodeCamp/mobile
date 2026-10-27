import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:freecodecamp/auth/services/session_service.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_viewmodel.freezed.dart';
part 'login_viewmodel.g.dart';

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({
    @Default(false) bool showOtpField,
    @Default(false) bool incorrectOtp,
    @Default(false) bool isLoading,
  }) = _LoginState;
}

@riverpod
class LoginNotifier extends _$LoginNotifier {
  @override
  LoginState build() => const LoginState();

  void changeEmail() {
    if (!state.isLoading) state = const LoginState();
  }

  Future<String?> loginWithProvider(String connection) async {
    try {
      await _login(
        ref.read(authProvider.notifier).loginWithProvider(connection),
      );
      return null;
    } catch (e) {
      return e is WebAuthenticationException && e.isUserCancelledException
          ? 'Login cancelled'
          : 'Login failed. Please try again.';
    }
  }

  Future<String?> sendOtp(String email) async {
    state = state.copyWith(isLoading: true, incorrectOtp: false);

    try {
      await ref.read(authSessionServiceProvider).sendEmailOtp(email);
      if (ref.mounted) state = state.copyWith(showOtpField: true);
      return null;
    } catch (_) {
      return 'Could not send the sign in code. Please try again.';
    } finally {
      if (ref.mounted) state = state.copyWith(isLoading: false);
    }
  }

  // NOTE: A rejected code is shown on the field instead of returned.
  Future<String?> verifyOtp(String email, String otp) async {
    state = state.copyWith(incorrectOtp: false);

    try {
      await _login(
        ref.read(authProvider.notifier).loginWithEmailOtp(email, otp),
      );
      return null;
    } on InvalidOtpException {
      if (ref.mounted) state = state.copyWith(incorrectOtp: true);
      return null;
    } catch (_) {
      return 'Login failed. Please try again.';
    }
  }

  Future<void> _login(Future<void> login) async {
    state = state.copyWith(isLoading: true);

    try {
      await login;
    } finally {
      if (ref.mounted) state = state.copyWith(isLoading: false);
    }
  }
}
