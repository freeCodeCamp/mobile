import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/models/learn/daily_challenge_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/dio_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyChallengeService {
  static final DailyChallengeService _instance =
      DailyChallengeService._internal();
  final Dio _dio = DioService.dio;
  final _authenticationService = locator<AuthenticationService>();

  // Caching fields for getDailyChallenge method
  DailyChallenge? _cachedDailyChallenge;
  String? _cachedChallengeDate;

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
      log('Failed to fetch daily challenges - Status: ${response.statusCode}');
      throw Exception('Failed to fetch daily challenges');
    }
  }

  Future<DailyChallenge> fetchChallengeByDate(String date) async {
    final response = await _dio.get(
        '${AuthenticationService.baseApiURL}/daily-coding-challenge/date/$date');

    if (response.statusCode == 200) {
      return DailyChallenge.fromJson(response.data);
    } else {
      log('Failed to fetch challenge for date: $date - Status: ${response.statusCode}');
      throw Exception('Failed to fetch challenge.');
    }
  }

  Future<DailyChallenge> fetchTodayChallenge() async {
    final response = await _dio.get(
        '${AuthenticationService.baseApiURL}/daily-coding-challenge/today');

    if (response.statusCode == 200) {
      return DailyChallenge.fromJson(response.data);
    } else {
      log('Failed to fetch today\'s challenge - Status: ${response.statusCode}');
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
      log('Failed to post challenge completion for $challengeId - Status: ${response.statusCode}');
      throw Exception('Failed to post challenge.');
    }
  }

  /*
    Fetches daily challenge data and creates a Challenge object for the specified language.
    Uses caching to avoid redundant API calls when switching between languages for the same date.
    If no language is provided, uses the stored language preference.
  */
  Future<Challenge> getDailyChallenge(
    String date,
    Block block, {
    DailyChallengeLanguage? language,
  }) async {
    if (language == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? selectedLangStr =
          prefs.getString('selectedDailyChallengeLanguage');
      language = parseLanguageFromString(selectedLangStr);
    }

    if (_cachedDailyChallenge == null || _cachedChallengeDate != date) {
      // Temporarily cache the challenge data to avoid redundant API calls.
      // But not saving the cached data to SharedPreferences
      // so we can still get the up-to-date challenge.
      _cachedDailyChallenge = await fetchChallengeByDate(date);
      _cachedChallengeDate = date;
    }

    DailyChallenge dailyChallenge = _cachedDailyChallenge!;

    // Select language-specific data
    DailyChallengeLanguageData languageData;
    HelpCategory helpCategory;
    int challengeType;

    switch (language) {
      case DailyChallengeLanguage.python:
        languageData = dailyChallenge.python;
        helpCategory = HelpCategory.python;
        challengeType = 29;
        break;
      default:
        languageData = dailyChallenge.javascript;
        helpCategory = HelpCategory.javascript;
        challengeType = 28;
        break;
    }

    // Map the daily challenge to Challenge
    return Challenge(
      id: dailyChallenge.id,
      block: block.dashedName,
      title: dailyChallenge.title,
      description: dailyChallenge.description,
      instructions: '',
      dashedName: '',
      superBlock: block.superBlock.dashedName,
      videoId: null,
      challengeType: challengeType,
      tests: languageData.tests,
      files: languageData.challengeFiles,
      helpCategory: helpCategory,
      explanation: '',
      transcript: '',
      hooks: Hooks.fromJson({'beforeAll': ''}),
      fillInTheBlank: null,
      audio: null,
      scene: null,
      questions: null,
      assignments: null,
      quizzes: null,
    );
  }

  /// Helper method to parse DailyChallengeLanguage from string with fallback
  static DailyChallengeLanguage parseLanguageFromString(String? langStr) {
    if (langStr == null || langStr.isEmpty) {
      return DailyChallengeLanguage.javascript;
    }

    return DailyChallengeLanguage.values.firstWhere(
      (e) => e.name == langStr,
      orElse: () => DailyChallengeLanguage.javascript,
    );
  }
}
