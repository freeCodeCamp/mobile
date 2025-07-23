import 'package:dio/dio.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/daily_challenge_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/dio_service.dart';

class DailyChallengeService {
  static final DailyChallengeService _instance =
      DailyChallengeService._internal();
  final Dio _dio = DioService.dio;
  final _authenticationService = locator<AuthenticationService>();

  factory DailyChallengeService() {
    return _instance;
  }

  DailyChallengeService._internal();

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
      options: Options(
        headers: {
          'CSRF-Token': _authenticationService.csrfToken,
          'Cookie':
              'jwt_access_token=${_authenticationService.jwtAccessToken}; _csrf=${_authenticationService.csrf};',
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to post challenge.');
    }
  }
}
