import 'package:dio/dio.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
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
    // TODO: Change this to use AuthenticationService.baseURL
    // when the API is deployed.
    final response =
        await _dio.get('http://localhost:3000/api/daily-challenge/all');

    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List)
          .map((item) => DailyChallengeOverview.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to fetch daily challenges');
    }
  }

  Future<DailyChallenge> fetchChallengeById(String date) async {
    // TODO: Change this to use AuthenticationService.baseURL
    // when the API is deployed.
    final response =
        await _dio.get('http://localhost:3000/api/daily-challenge/date/$date');

    if (response.statusCode == 200) {
      return DailyChallenge.fromJson(response.data);
    } else {
      throw Exception('Failed to fetch daily challenges');
    }
  }

  Future<DailyChallenge> fetchNewestChallenge() async {
    // TODO: Change this to use AuthenticationService.baseURL
    // when the API is deployed.
    final response =
        await _dio.get('http://localhost:3000/api/daily-challenge/newest');

    if (response.statusCode == 200) {
      return DailyChallenge.fromJson(response.data);
    } else {
      throw Exception('Failed to fetch daily challenges');
    }
  }
}
