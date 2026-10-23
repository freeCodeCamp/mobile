import 'package:dio/dio.dart';
import 'package:freecodecamp/auth/repositories/session_repository.dart';
import 'package:freecodecamp/services/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'daily_challenge_repository.g.dart';

@riverpod
LearnDailyChallengeRepository learnDailyChallengeRepository(Ref ref) =>
    LearnDailyChallengeRepository(
      ref.watch(dioProvider),
      ref.watch(authSessionRepositoryProvider),
    );

class LearnDailyChallengeRepository {
  LearnDailyChallengeRepository(this._dio, this._session);

  final Dio _dio;
  final AuthSessionRepository _session;

  String get _baseUrl => '${_session.apiUrl}/daily-coding-challenge';

  Future<Map<String, dynamic>> getToday() async {
    final response = await _dio.get<Map<String, dynamic>>('$_baseUrl/today');
    return response.data ?? <String, dynamic>{};
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    final response = await _dio.get<List<dynamic>>('$_baseUrl/all');

    return [
      for (final entry in response.data ?? const [])
        if (entry is Map) Map<String, dynamic>.from(entry),
    ];
  }

  Future<Map<String, dynamic>> getDay(String monthDay) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$_baseUrl/day/$monthDay',
    );
    return response.data!;
  }

  Future<void> postCompleted(Map<String, dynamic> body) =>
      _session.authenticated(
        (options) => _dio.post<void>(
          '${_session.apiUrl}/daily-coding-challenge-completed',
          data: body,
          options: options,
        ),
      );
}
