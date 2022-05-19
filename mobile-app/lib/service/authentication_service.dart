import 'dart:convert';
import 'dart:developer';

import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class AuthenticationService {
  static final AuthenticationService _authenticationService =
      AuthenticationService._internal();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  bool isLoggedIn = false;
  String _csrf = '';
  String _csrfToken = '';
  String _jwtAccessToken = '';
  final Dio _dio = Dio();

  Future<FccUserModel>? userModel;

  factory AuthenticationService() {
    return _authenticationService;
  }

  Future<void> init() async {
    _dio.options.baseUrl = 'https://api.freecodecamp.dev';
    // Below two interceptors are for debugging purposes only
    // They will be put behind a devMode flag later
    _dio.interceptors.add(PrettyDioLogger(responseBody: false));
    _dio.interceptors.add(CurlLoggerDioInterceptor());
    if ((await secureStorage.containsKey(key: 'jwt_access_token')) == true &&
        (await secureStorage.containsKey(key: 'csrf_token')) == true &&
        (await secureStorage.containsKey(key: 'csrf')) == true) {
      _csrf = (await secureStorage.read(key: 'csrf'))!;
      _csrfToken = (await secureStorage.read(key: 'csrf_token'))!;
      _jwtAccessToken = (await secureStorage.read(key: 'jwt_access_token'))!;
      isLoggedIn = true;
      fetchUser();
    }
  }

  Future<FccUserModel> fetchUserModel(Map<String, dynamic> data) async {
    return FccUserModel.fromJson(data);
  }

  Future<void> login() async {
    final browser = FlutterWebviewPlugin();
    browser.onUrlChanged.listen((String url) async {
      log('onUrlChanged: $url');
      if (url ==
          'https://www.freecodecamp.dev/learn/?messages=success%5B0%5D%3Dflash.signin-success') {
        isLoggedIn = true;
        Map<String, String> cookies = await browser.getCookies();
        // Do not question the weird keys below
        _csrf = cookies['"_csrf']!;
        _csrfToken = cookies[' csrf_token']!;
        _jwtAccessToken = cookies[' jwt_access_token']!;
        secureStorage.write(key: 'csrf', value: _csrf);
        secureStorage.write(key: 'csrf_token', value: _csrfToken);
        secureStorage.write(key: 'jwt_access_token', value: _jwtAccessToken);
        log('LOGGED IN');
        browser.close();
        fetchUser();
        browser.dispose();
      }
    });
    browser.launch(
      'https://api.freecodecamp.dev/signin',
      clearCookies: true,
      debuggingEnabled: true,
      userAgent: 'random',
    );
  }

  Future<void> logout() async {
    isLoggedIn = false;
    await secureStorage.delete(key: 'csrf');
    await secureStorage.delete(key: 'csrf_token');
    await secureStorage.delete(key: 'jwt_access_token');
  }

  Future<void> showKeys() async {
    log('_csrf: $_csrf');
    log('_csrfToken: $_csrfToken');
    log('_jwtAccessToken: $_jwtAccessToken');
  }

  Future<void> fetchUser() async {
    Response res = await _dio.get(
      '/user/get-session-user',
      options: Options(
        headers: {
          'CSRF-Token': _csrfToken,
          'Cookie': 'jwt_access_token=$_jwtAccessToken; _csrf=$_csrf',
        },
      ),
    );
    log(jsonEncode(res.data['user']).toString());
    userModel = fetchUserModel(res.data['user'][res.data['result']]);

    return res.data['user'][res.data['result']];
  }

  AuthenticationService._internal();
}
