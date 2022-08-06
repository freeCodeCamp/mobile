import 'dart:developer';

import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/service/authentication_service.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class LearnService {
  static final LearnService _learnService = LearnService._internal();
  final _authenticationService = locator<AuthenticationService>();

  // TODO: make a Dio service instead of initialising it everywhere
  final Dio _dio = Dio();

  factory LearnService() {
    return _learnService;
  }

  void init() {
    _dio.interceptors.add(PrettyDioLogger(responseBody: false));
    _dio.interceptors.add(CurlLoggerDioInterceptor());
    _dio.options.baseUrl = AuthenticationService.baseApiURL;
  }

  Future<void> postChallengeCompleted(Challenge challenge) async {
    // NOTE: Assuming for now it's just HTML and JS challenges are being submitted
    // TODO: Update code after exposing challenge-types file

    String challengeId = challenge.id;
    int challengeType = challenge.challengeType;
    Map payload = {
      'challengeType': challengeType,
      'id': challengeId,
    };

    Response res = await _dio.post(
      '/modern-challenge-completed',
      data: payload,
      options: Options(
        headers: {
          'CSRF-Token': _authenticationService.csrfToken,
          'Cookie':
              'jwt_access_token=${_authenticationService.jwtAccessToken}; _csrf=${_authenticationService.csrf};',
        },
      ),
    );
    log(res.toString());
  }

  LearnService._internal();
}
