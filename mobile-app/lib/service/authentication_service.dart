import 'dart:async';
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

  String _csrf = '';
  String _csrfToken = '';
  String _jwtAccessToken = '';
  final Dio _dio = Dio();

  Future<FccUserModel>? userModel;

  static StreamController<bool> isLoggedInStream =
      StreamController<bool>.broadcast();
  final Stream<bool> _isLoggedIn = isLoggedInStream.stream;

  Stream<bool> get isLoggedIn => _isLoggedIn;

  final String baseUrl = 'https://www.freecodecamp.dev';

  factory AuthenticationService() {
    return _authenticationService;
  }

  Future<bool> hasRequiredTokens() async {
    List<String> requiredTokens = ['jwt_access_token', 'csrf_token', 'csrf'];

    for (String requiredToken in requiredTokens) {
      if (await secureStorage.containsKey(key: requiredToken) == false) {
        return false;
      }
    }

    return true;
  }

  Future<void> init() async {
    _dio.options.baseUrl = 'https://api.freecodecamp.dev';
    // Below two interceptors are for debugging purposes only
    // They will be put behind a devMode flag later
    _dio.interceptors.add(PrettyDioLogger(responseBody: false));
    _dio.interceptors.add(CurlLoggerDioInterceptor());
    if (await hasRequiredTokens()) {
      _csrf = (await secureStorage.read(key: 'csrf'))!;
      _csrfToken = (await secureStorage.read(key: 'csrf_token'))!;
      _jwtAccessToken = (await secureStorage.read(key: 'jwt_access_token'))!;

      await fetchUser();
    }
  }

  Future<FccUserModel> fetchUserModel(Map<String, dynamic> data) async {
    return FccUserModel.fromJson(data);
  }

  Future<void> login() async {
    final browser = FlutterWebviewPlugin();
    browser.onUrlChanged.listen((String url) async {
      if (url ==
          '$baseUrl/learn/?messages=success%5B0%5D%3Dflash.signin-success') {
        isLoggedInStream.sink.add(true);
        Map<String, String> cookies = await browser.getCookies();
        // Do not question the weird keys below
        _csrf = cookies['"_csrf']!;
        _csrfToken = cookies[' csrf_token']!;
        _jwtAccessToken = cookies[' jwt_access_token']!;
        secureStorage.write(key: 'csrf', value: _csrf);
        secureStorage.write(key: 'csrf_token', value: _csrfToken);
        secureStorage.write(key: 'jwt_access_token', value: _jwtAccessToken);
        browser.close();
        fetchUser();
        browser.dispose();
      }
    });
    browser.launch(
      '$baseUrl/signin',
      clearCookies: true,
      debuggingEnabled: true,
      userAgent: 'random',
    );
  }

  Future<void> logout() async {
    isLoggedInStream.sink.add(false);
    await secureStorage.delete(key: 'csrf');
    await secureStorage.delete(key: 'csrf_token');
    await secureStorage.delete(key: 'jwt_access_token');
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

    userModel = fetchUserModel(res.data['user'][res.data['result']]);
  }

  AuthenticationService._internal();
}
