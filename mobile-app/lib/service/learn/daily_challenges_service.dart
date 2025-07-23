import 'package:dio/dio.dart';
import 'package:freecodecamp/models/learn/daily_challenge_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/dio_service.dart';

class DailyChallengesService {
  static final DailyChallengesService _instance =
      DailyChallengesService._internal();
  final Dio _dio = DioService.dio;

  factory DailyChallengesService() {
    return _instance;
  }

  DailyChallengesService._internal();

  Future<List<DailyChallengeOverview>> fetchAllDailyChallenges() async {
    final response = await _dio
        .get('${AuthenticationService.baseApiURL}/daily-coding-challenge/all');

    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List)
          .map((item) => DailyChallengeOverview.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to fetch daily challenges');
    }
  }

  Future<DailyChallenge> fetchChallengeByDate(String date) async {
    final response = await _dio.get(
        '${AuthenticationService.baseApiURL}/daily-coding-challenge/date/$date');

    if (response.statusCode == 200) {
      return DailyChallenge.fromJson(response.data);
    } else {
      throw Exception('Failed to fetch challenge.');
    }
  }

  Future<DailyChallenge> fetchTodayChallenge() async {
    final response = await _dio.get(
        '${AuthenticationService.baseApiURL}/daily-coding-challenge/today');

    if (response.statusCode == 200) {
      return DailyChallenge.fromJson(response.data);
    } else {
      throw Exception('Failed to fetch challenge.');
    }
  }

  Future<void> postChallengeCompleted({
    required String challengeId,
    required DailyChallengeLanguage language,
  }) async {
    final response = await _dio.post(
      '${AuthenticationService.baseApiURL}/daily-coding-challenge-completed',
      data: {'id': challengeId, 'language': language.toString()},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to post challenge.');
    }
  }
}
