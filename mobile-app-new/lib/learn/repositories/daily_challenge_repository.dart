import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_app_new/services/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'daily_challenge_repository.g.dart';

const _prodUrl = 'https://api.freecodecamp.org/daily-coding-challenge';
const _devUrl = 'https://api.freecodecamp.dev/daily-coding-challenge';

@riverpod
LearnDailyChallengeRepository learnDailyChallengeRepository(Ref ref) =>
    LearnDailyChallengeRepository(ref.watch(dioProvider));

class LearnDailyChallengeRepository {
  LearnDailyChallengeRepository(this._dio);

  final Dio _dio;

  String get _baseUrl =>
      dotenv.getBool('DEVELOPMENT_MODE', fallback: false) ? _devUrl : _prodUrl;

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
}
