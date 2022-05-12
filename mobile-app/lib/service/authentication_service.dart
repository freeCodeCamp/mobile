import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class AuthenticationService {
  static final AuthenticationService _authenticationService =
      AuthenticationService._internal();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final browser = FlutterWebviewPlugin();
  bool isLoggedIn = false;
  String _csrf = '';
  String _csrfToken = '';
  String _jwtAccessToken = '';
  Dio dio = Dio();

  factory AuthenticationService() {
    return _authenticationService;
  }

  Future<void> init() async {
    if ((await secureStorage.containsKey(key: 'jwt_access_token')) == true &&
        (await secureStorage.containsKey(key: 'csrf_token')) == true &&
        (await secureStorage.containsKey(key: 'csrf')) == true) {
      _csrf = (await secureStorage.read(key: 'csrf'))!;
      _csrfToken = (await secureStorage.read(key: 'csrf_token'))!;
      _jwtAccessToken = (await secureStorage.read(key: 'jwt_access_token'))!;
      isLoggedIn = true;
    }
    dio.options.baseUrl = 'https://api.freecodecamp.dev';
  }

  Future<void> login() async {
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
        log('_csrf: $_csrf');
        log('_csrfToken: $_csrfToken');
        log('_jwtAccessToken: $_jwtAccessToken');
        secureStorage.write(key: 'csrf', value: _csrf);
        secureStorage.write(key: 'csrf_token', value: _csrfToken);
        secureStorage.write(key: 'jwt_access_token', value: _jwtAccessToken);
        log('LOGGED IN');
        browser.close();
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

  Future<String> fetchUser() async {
    Response res = await dio.get(
      '/user/get-session-user',
      options: Options(
        headers: {
          'CSRF-Token': _csrfToken,
          'Cookie': 'jwt_access_token=$_jwtAccessToken; _csrf=$_csrf',
        },
      ),
    );
    return res.data.toString();
  }

  AuthenticationService._internal();
}
