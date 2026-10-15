import 'dart:async';

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app_new/services/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_repository.g.dart';

typedef AuthTokens = ({String csrf, String csrfToken, String jwtAccessToken});

// NOTE: The API rejected the stored session (401), or there is none.
class SessionExpiredException implements Exception {}

const _scopes = {'openid', 'profile', 'email'};

// v7's secure storage keys.
const _csrfKey = 'csrf';
const _csrfTokenKey = 'csrf_token';
const _jwtKey = 'jwt_access_token';

@Riverpod(keepAlive: true)
AuthSessionRepository authSessionRepository(Ref ref) {
  return AuthSessionRepository(ref.watch(dioProvider));
}

class AuthSessionRepository {
  AuthSessionRepository(this._dio);

  final Dio _dio;
  final _store = const FlutterSecureStorage();

  final _auth0 = Auth0(
    dotenv.get('AUTH0_DOMAIN'),
    dotenv.get('AUTH0_CLIENT_ID'),
  );

  AuthTokens? _tokens;
  bool _tokensLoaded = false;

  final _sessionExpired = StreamController<void>.broadcast();

  Stream<void> get sessionExpired => _sessionExpired.stream;

  String get apiUrl => dotenv.getBool('DEVELOPMENT_MODE', fallback: false)
      ? 'https://api.freecodecamp.dev'
      : 'https://api.freecodecamp.org';

  Future<AuthTokens?> readTokens() async {
    if (_tokensLoaded) return _tokens;

    final csrf = await _store.read(key: _csrfKey);
    final csrfToken = await _store.read(key: _csrfTokenKey);
    final jwt = await _store.read(key: _jwtKey);
    _tokensLoaded = true;

    if (csrf == null || csrf.isEmpty) return null;
    if (csrfToken == null || csrfToken.isEmpty) return null;
    if (jwt == null || jwt.isEmpty) return null;

    _tokens = (csrf: csrf, csrfToken: csrfToken, jwtAccessToken: jwt);

    return _tokens;
  }

  Future<void> writeTokens(AuthTokens tokens) async {
    await _store.write(key: _csrfKey, value: tokens.csrf);
    await _store.write(key: _csrfTokenKey, value: tokens.csrfToken);
    await _store.write(key: _jwtKey, value: tokens.jwtAccessToken);
    _tokens = tokens;
    _tokensLoaded = true;
  }

  Future<void> clearTokens() async {
    await _store.delete(key: _csrfKey);
    await _store.delete(key: _csrfTokenKey);
    await _store.delete(key: _jwtKey);
    _tokens = null;
    _tokensLoaded = true;
  }

  Future<String> webAuthLogin(String connection) async {
    // NOTE: The scheme is only needed for Android debug builds, whose callback URL differs.
    final credentials = await _auth0
        .webAuthentication(
          scheme: kReleaseMode ? null : 'org.freecodecamp',
          useCredentialsManager: false,
        )
        .login(
          useHTTPS: true,
          scopes: _scopes,
          // NOTE: prompt=login ignores Auth0's remembered session, so logging out sticks.
          parameters: {'connection': connection, 'prompt': 'login'},
        );

    return credentials.accessToken;
  }

  Future<void> emailOtpStart(String email) {
    return _auth0.api.startPasswordlessWithEmail(
      email: email,
      passwordlessType: PasswordlessType.code,
    );
  }

  Future<String> emailOtpExchange(String email, String otp) async {
    final credentials = await _auth0.api.loginWithEmailCode(
      email: email,
      verificationCode: otp,
      scopes: _scopes,
    );

    return credentials.accessToken;
  }

  Future<Response<void>> mobileLogin(String accessToken) {
    return _dio.get<void>(
      '$apiUrl/mobile-login',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
  }

  Future<Map<String, dynamic>?> fetchSessionUser() async {
    final res = await authenticated(
      (options) => _dio.get<Map<String, dynamic>>(
        '$apiUrl/user/session-user',
        options: options,
      ),
    );

    final data = res.data;
    final result = data?['result'];
    if (result is! String || result.isEmpty) return null;

    return (data!['user'] as Map<String, dynamic>)[result]
        as Map<String, dynamic>;
  }

  Future<void> deleteAccount() async {
    await authenticated(
      (options) => _dio.post<void>('$apiUrl/account/delete', options: options),
    );
  }

  // NOTE: Every call carrying the session goes through here, so any 401 signs the user out.
  Future<T> authenticated<T>(Future<T> Function(Options) request) async {
    final tokens = await readTokens();
    if (tokens == null) throw SessionExpiredException();

    try {
      return await request(
        Options(
          headers: {
            'CSRF-Token': tokens.csrfToken,
            'Cookie':
                'jwt_access_token=${tokens.jwtAccessToken}; _csrf=${tokens.csrf}',
          },
        ),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode != 401) rethrow;

      await clearTokens();
      _sessionExpired.add(null);
      throw SessionExpiredException();
    }
  }
}
