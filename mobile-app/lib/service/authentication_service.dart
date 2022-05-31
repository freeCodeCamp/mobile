import 'dart:async';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class AuthenticationService {
  static final AuthenticationService _authenticationService =
      AuthenticationService._internal();

  final FlutterSecureStorage store = const FlutterSecureStorage();
  final Dio _dio = Dio();
  final browser = FlutterWebviewPlugin();

  String _csrf = '';
  String _csrfToken = '';
  String _jwtAccessToken = '';

  String baseURL = '';
  String baseApiURL = '';
  Future<FccUserModel>? userModel;

  bool isDevMode = false;

  static StreamController<bool> isLoggedInStream =
      StreamController<bool>.broadcast();

  final Stream<bool> _isLoggedIn = isLoggedInStream.stream;
  Stream<bool> get isLoggedIn => _isLoggedIn;

  factory AuthenticationService() {
    return _authenticationService;
  }

  Future<bool> hasRequiredTokens() async {
    List<String> requiredTokens = ['jwt_access_token', 'csrf_token', 'csrf'];

    for (String requiredToken in requiredTokens) {
      if (await store.containsKey(key: requiredToken) == false) {
        return false;
      }
    }

    return true;
  }

  Future<void> writeTokensToStorage() async {
    store.write(key: 'csrf', value: _csrf);
    store.write(key: 'csrf_token', value: _csrfToken);
    store.write(key: 'jwt_access_token', value: _jwtAccessToken);
  }

  Future<void> setRequiredTokes() async {
    _csrf = await store.read(key: 'csrf') as String;
    _csrfToken = await store.read(key: 'csrf_token') as String;
    _jwtAccessToken = await store.read(key: 'jwt_access_token') as String;
  }

  Future<void> setCurrentClientMode() async {
    await dotenv.load();

    isDevMode =
        dotenv.get('DEVELOPMENTMODE', fallback: '').toLowerCase() == 'true';
    baseURL = isDevMode
        ? 'https://www.freecodecamp.dev'
        : 'https://www.freecodecamp.org';
    baseApiURL = isDevMode
        ? 'https://api.freecodecamp.dev'
        : 'https://api.freecodecamp.org';
  }

  Future<void> init() async {
    await setCurrentClientMode();

    _dio.options.baseUrl = baseApiURL;

    if (isDevMode) {
      _dio.interceptors.add(PrettyDioLogger(responseBody: false));
      _dio.interceptors.add(CurlLoggerDioInterceptor());
    }

    await login();
  }

  Future<FccUserModel> parseUserModel(Map<String, dynamic> data) async {
    return FccUserModel.fromJson(data);
  }

  Future<void> login() async {
    String path = '/learn/?messages=success%5B0%5D%3Dflash.signin-success';

    if (await hasRequiredTokens()) {
      await setRequiredTokes();
      await fetchUser();
      return;
    }

    browser.onUrlChanged.listen((String url) async {
      if (url == '$baseURL$path') {
        Map<String, String> cookies = await browser.getCookies();

        _csrf = cookies['"_csrf']!;
        _csrfToken = cookies[' csrf_token']!;
        _jwtAccessToken = cookies[' jwt_access_token']!;
        await writeTokensToStorage();

        await fetchUser();

        browser.close();
        browser.dispose();
      }
    });
    browser.launch(
      '$baseApiURL/signin',
      clearCookies: true,
      debuggingEnabled: true,
      userAgent: 'random',
    );
  }

  Future<void> logout() async {
    isLoggedInStream.sink.add(false);
    await store.delete(key: 'csrf');
    await store.delete(key: 'csrf_token');
    await store.delete(key: 'jwt_access_token');
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

    isLoggedInStream.sink.add(true);
    userModel = parseUserModel(res.data['user'][res.data['result']]);
  }

  AuthenticationService._internal();
}
