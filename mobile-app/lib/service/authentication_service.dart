import 'dart:async';
import 'dart:developer';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:freecodecamp/ui/widgets/login_webview_widget/login_webview_view.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

class AuthenticationService {
  static final AuthenticationService _authenticationService =
      AuthenticationService._internal();

  final FlutterSecureStorage store = const FlutterSecureStorage();
  final Dio _dio = Dio();

  String _csrf = '';
  String _csrfToken = '';
  String _jwtAccessToken = '';

  String get csrf => _csrf;
  String get csrfToken => _csrfToken;
  String get jwtAccessToken => _jwtAccessToken;

  static String baseURL = '';
  static String baseApiURL = '';
  Future<FccUserModel>? userModel;

  bool isDevMode = false;

  static StreamController<bool> isLoggedInStream =
      StreamController<bool>.broadcast();

  final Stream<bool> _isLoggedIn = isLoggedInStream.stream;
  Stream<bool> get isLoggedIn => _isLoggedIn;
  static bool staticIsloggedIn = false;

  factory AuthenticationService() {
    return _authenticationService;
  }

  Future<bool> hasRequiredTokens() async {
    List<String> requiredTokens = ['jwt_access_token', 'csrf_token', 'csrf'];

    for (String requiredToken in requiredTokens) {
      if (await store.containsKey(key: requiredToken) == false) {
        log('message: Missing token: $requiredToken');
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

  Future<bool> extractCookies() async {
    await WebviewCookieManager().getCookies(baseURL).then(
      (cookies) {
        for (var cookie in cookies) {
          if (cookie.name == '_csrf') {
            _csrf = cookie.value;
          }
          if (cookie.name == 'csrf_token') {
            _csrfToken = cookie.value;
          }
          if (cookie.name == 'jwt_access_token') {
            _jwtAccessToken = cookie.value;
          }
        }
      },
    );

    if (_csrf.isNotEmpty &&
        _csrfToken.isNotEmpty &&
        _jwtAccessToken.isNotEmpty) {
      return true;
    }

    return false;
  }

  Future<void> setCurrentClientMode() async {
    await dotenv.load();

    isDevMode = true;
    // isDevMode =
    //     dotenv.get('DEVELOPMENTMODE', fallback: '').toLowerCase() == 'true';
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

    if (await hasRequiredTokens()) {
      log('message: Tokens found in storage');
      await setRequiredTokes();
      // await fetchUser();
    }
  }

  Future<FccUserModel> parseUserModel(Map<String, dynamic> data) async {
    return FccUserModel.fromJson(data);
  }

  Future<void> login(BuildContext context) async {
    var navRes = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginWebView(),
      ),
    );
    log('AUTH SERVICE NAV RES: $navRes');
    await writeTokensToStorage();
    await fetchUser();
  }

  Future<void> logout() async {
    staticIsloggedIn = false;
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

    if (res.statusCode == 200) {
      userModel = parseUserModel(res.data['user'][res.data['result']]);
      staticIsloggedIn = true;
      isLoggedInStream.sink.add(true);
    } else {
      staticIsloggedIn = false;
      isLoggedInStream.sink.add(false);
      logout();
    }
  }

  AuthenticationService._internal();
}
