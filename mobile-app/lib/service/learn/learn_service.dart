import 'dart:developer';

import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
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
  }

  Future<void> postChallengeCompleted(
      Challenge challenge, List challengeFiles) async {
    // NOTE: Assuming for now it's just HTML and JS challenges are being submitted

    String challengeId = challenge.id;
    int challengeType = challenge.challengeType;

    Response submitTypesRes = await _dio.get(
        '${AuthenticationService.baseURL}/curriculum-data/submit-types.json');
    Map<String, dynamic> submitTypes = submitTypesRes.data;

    switch (submitTypes[challengeType.toString()]) {
      case 'tests':
        late Map payload;
        if (challengeType == 14 ||
            challenge.block ==
                'javascript-algorithms-and-data-structures-projects') {
          payload = {
            'id': challengeId,
            'challengeType': challengeType,
            'files': challengeFiles,
          };
        } else {
          payload = {
            'id': challengeId,
            'challengeType': challengeType,
          };
        }
        Response res = await _dio.post(
          '${AuthenticationService.baseApiURL}/modern-challenge-completed',
          data: payload,
          options: Options(
            headers: {
              'CSRF-Token': _authenticationService.csrfToken,
              'Cookie':
                  'jwt_access_token=${_authenticationService.jwtAccessToken}; _csrf=${_authenticationService.csrf};',
            },
          ),
        );
        await _authenticationService.fetchUser();
        log(res.toString());
        break;
      case 'backend':
        break;
      case 'project.backEnd':
        break;
      case 'project.frontEnd':
        break;
    }
  }

  Future<String> getBaseUrl([String? endpoint]) async {
    await dotenv.load();

    String devmodeValue = dotenv.get('DEVELOPMENTMODE', fallback: 'false');

    bool devmodeEnabled = devmodeValue.toLowerCase() == 'true';

    String domain = devmodeEnabled ? '.dev' : '.org';

    return 'https://freecodecamp$domain${endpoint ?? ''}';
  }

  LearnService._internal();
}
