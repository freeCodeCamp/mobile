import 'dart:io';

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:dio/dio.dart';
import 'package:freecodecamp/auth/models/user_model.dart';
import 'package:freecodecamp/auth/repositories/session_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_service.g.dart';

@Riverpod(keepAlive: true)
AuthSessionService authSessionService(Ref ref) {
  return AuthSessionService(ref.watch(authSessionRepositoryProvider));
}

class InvalidOtpException implements Exception {}

class AuthSessionService {
  AuthSessionService(this._repo);

  final AuthSessionRepository _repo;

  Stream<void> get sessionExpired => _repo.sessionExpired;

  // NOTE: Only a 401/403 clears the stored tokens; any other failure rethrows and keeps them.
  Future<FccUserModel?> restoreSession() async {
    if (await _repo.readTokens() == null) return null;

    Map<String, dynamic>? json;
    try {
      json = await _repo.fetchSessionUser();
    } on SessionExpiredException {
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode != 403) rethrow;
    }

    if (json == null) {
      await _repo.clearTokens();
      return null;
    }

    return FccUserModel.fromJson(json);
  }

  Future<FccUserModel> loginWithProvider(String connection) async {
    return _completeLogin(await _repo.webAuthLogin(connection));
  }

  Future<void> sendEmailOtp(String email) => _repo.emailOtpStart(email);

  Future<FccUserModel> loginWithEmailOtp(String email, String otp) async {
    final String accessToken;
    try {
      accessToken = await _repo.emailOtpExchange(email, otp);
    } on ApiException catch (e) {
      final rejected = e.statusCode >= 400 && e.statusCode < 500;
      if (rejected && !e.isNetworkError) throw InvalidOtpException();
      rethrow;
    }
    return _completeLogin(accessToken);
  }

  Future<void> logout() => _repo.clearTokens();

  Future<void> deleteAccount() async {
    await _repo.deleteAccount();
    await _repo.clearTokens();
  }

  Future<FccUserModel> _completeLogin(String accessToken) async {
    try {
      final tokens = _extractTokens(await _repo.mobileLogin(accessToken));
      await _repo.writeTokens(tokens);

      final json = await _repo.fetchSessionUser();
      if (json == null) throw StateError('Session user missing after login');

      return FccUserModel.fromJson(json);
    } catch (_) {
      await _repo.clearTokens();
      rethrow;
    }
  }

  AuthTokens _extractTokens(Response<void> res) {
    final headers = res.headers['set-cookie'] ?? const <String>[];
    final cookies = {
      for (final cookie in headers.map(Cookie.fromSetCookieValue))
        cookie.name: cookie.value,
    };

    final csrf = cookies['_csrf'];
    final csrfToken = cookies['csrf_token'];
    final jwt = cookies['jwt_access_token'];

    if (csrf == null || csrfToken == null || jwt == null) {
      throw StateError('mobile-login did not set the session cookies');
    }

    return (csrf: csrf, csrfToken: csrfToken, jwtAccessToken: jwt);
  }
}
