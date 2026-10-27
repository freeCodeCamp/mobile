import 'package:dio/dio.dart';
import 'package:freecodecamp/auth/repositories/session_repository.dart';
import 'package:freecodecamp/services/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_repository.g.dart';

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) => ProfileRepository(
  ref.watch(dioProvider),
  ref.watch(authSessionRepositoryProvider),
);

class ProfileRepository {
  ProfileRepository(this._dio, this._session);

  final Dio _dio;
  final AuthSessionRepository _session;

  Future<AuthTokens> captureSession() async {
    final tokens = await _session.readTokens();
    if (tokens == null) throw SessionExpiredException();
    return tokens;
  }

  Future<Map<String, dynamic>?> currentUser({AuthTokens? expectedTokens}) =>
      _session.fetchSessionUser(expectedTokens: expectedTokens);

  Future<bool> usernameExists(String username) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${_session.apiUrl}/users/exists',
      queryParameters: {'username': username},
      options: Options(headers: {'Accept': 'application/json'}),
    );
    final exists = response.data?['exists'];
    if (exists is! bool) {
      throw const FormatException('Invalid username availability response');
    }
    return exists;
  }

  Future<Map<String, dynamic>> update(
    String path,
    Map<String, Object?> body, {
    required AuthTokens expectedTokens,
  }) async {
    final response = await _session.authenticated(
      (options) => _dio.put<Map<String, dynamic>>(
        '${_session.apiUrl}$path',
        data: body,
        options: options.copyWith(
          headers: {...?options.headers, 'Accept': 'application/json'},
        ),
      ),
      expectedTokens: expectedTokens,
    );
    return response.data ?? const {};
  }
}
