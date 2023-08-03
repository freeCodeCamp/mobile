import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/ui/views/auth/privacy_view.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:stacked_services/stacked_services.dart';

class AuthenticationService {
  static final AuthenticationService _authenticationService =
      AuthenticationService._internal();

  SnackbarService snackbar = locator<SnackbarService>();
  final NavigationService _navigationService = locator<NavigationService>();

  final FlutterSecureStorage store = const FlutterSecureStorage();
  final Dio _dio = Dio();
  late final Auth0 auth0;

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
      if (await store.containsKey(key: requiredToken) == false ||
          await store.read(key: requiredToken) == null ||
          await store.read(key: requiredToken) == '') {
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

  Future<void> setRequiredTokens() async {
    _csrf = await store.read(key: 'csrf') as String;
    _csrfToken = await store.read(key: 'csrf_token') as String;
    _jwtAccessToken = await store.read(key: 'jwt_access_token') as String;
  }

  void extractCookies(Response res) {
    for (var cookie in res.headers['set-cookie']!) {
      var parsedCookie = Cookie.fromSetCookieValue(cookie);
      if (parsedCookie.name == '_csrf') {
        _csrf = parsedCookie.value;
      }
      if (parsedCookie.name == 'csrf_token') {
        _csrfToken = parsedCookie.value;
      }
      if (parsedCookie.name == 'jwt_access_token') {
        _jwtAccessToken = parsedCookie.value;
      }
    }
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
    await dotenv.load();
    auth0 = Auth0(dotenv.get('AUTH0_DOMAIN'), dotenv.get('AUTH0_CLIENT_ID'));

    await setCurrentClientMode();

    _dio.options.baseUrl = baseApiURL;

    if (isDevMode) {
      _dio.interceptors.add(PrettyDioLogger(responseBody: false));
      _dio.interceptors.add(CurlLoggerDioInterceptor());
    }

    if (await hasRequiredTokens()) {
      log('message: Tokens found in storage');
      await setRequiredTokens();
      await fetchUser();
    }
  }

  Future<FccUserModel> parseUserModel(Map<String, dynamic> data) async {
    return FccUserModel.fromJson(data);
  }

  Future<bool> login(
    BuildContext context,
    String connectionType, {
    String? email,
    String? otp,
  }) async {
    late final Credentials creds;
    late final Response emailLoginRes;
    Response? res;

    showDialog(
      context: context,
      barrierDismissible: false,
      routeSettings: RouteSettings(
        name: 'Login View - $connectionType',
      ),
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: SimpleDialog(
            title: Text(context.t.login_load_message),
            contentPadding: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 24.0),
            backgroundColor: const Color(0xFF2A2A40),
            children: const [
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        );
      },
    );

    try {
      if (connectionType == 'email') {
        emailLoginRes = await _dio.post(
          'https://${dotenv.get('AUTH0_DOMAIN')}/oauth/token',
          data: {
            'client_id': dotenv.get('AUTH0_CLIENT_ID'),
            'grant_type': 'http://auth0.com/oauth/grant-type/passwordless/otp',
            'realm': 'email',
            'username': email,
            'otp': otp,
            'scope': 'openid profile email',
          },
        );
      } else {
        creds = await auth0
            .webAuthentication(scheme: 'fccapp')
            .login(parameters: {'connection': connectionType});
      }
    } on WebAuthenticationException {
      // NOTE: The most likely case is that the user canceled the login
      snackbar.showSnackbar(
        title: context.t.login_cancelled,
        message: '',
      );

      logout();
      Navigator.pop(context);

      return false;
    } on DioException catch (e) {
      log(e.toString());
      logout();
      Navigator.pop(context);
      return false;
    }

    try {
      String accessToken = connectionType == 'email'
          ? emailLoginRes.data['access_token']
          : creds.accessToken;
      res = await _dio.get(
        '/mobile-login',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      extractCookies(res);
      await writeTokensToStorage();
      await fetchUser();
    } on DioException catch (e) {
      Navigator.pop(context);
      if (e.response != null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          routeSettings: const RouteSettings(
            name: 'Login View - Error',
          ),
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF2A2A40),
            title: Text(context.t.error_two),
            content: Text(
              e.response!.data['message'],
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF0a0a23),
                ),
                onPressed: () {
                  logout();
                  Navigator.pop(context);
                },
                child: Text(context.t.close),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          barrierDismissible: false,
          routeSettings: const RouteSettings(
            name: 'Login View - Error',
          ),
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF2A2A40),
            title: Text(context.t.error_two),
            content: Text(context.t.error_three),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF0a0a23),
                ),
                onPressed: () {
                  logout();
                  Navigator.pop(context);
                },
                child: Text(context.t.close),
              ),
            ],
          ),
        );
      }
    }

    final user = await userModel;

    if (user != null && user.acceptedPrivacyTerms == false) {
      bool? quincyEmails = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PrivacyView(),
          settings: const RouteSettings(
            name: 'New User Accept Privacy View',
          ),
        ),
      );

      await _dio.put(
        '/update-privacy-terms',
        data: {
          'quincyEmails': quincyEmails ?? false,
        },
        options: Options(
          headers: {
            'CSRF-Token': _csrfToken,
            'Cookie': 'jwt_access_token=$_jwtAccessToken; _csrf=$_csrf',
          },
        ),
      );
    }

    await auth0.credentialsManager.clearCredentials();
    if (res != null) {
      Navigator.pop(context);
      Navigator.pop(context);
    }
    return true;
  }

  Future<void> logout() async {
    staticIsloggedIn = false;
    isLoggedInStream.sink.add(false);
    await store.delete(key: 'csrf');
    await store.delete(key: 'csrf_token');
    await store.delete(key: 'jwt_access_token');
    userModel = null;
  }

  Future<void> fetchUser() async {
    late final Response res;
    try {
      res = await _dio.get(
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
        await logout();
      }
    } on DioException {
      staticIsloggedIn = false;
      isLoggedInStream.sink.add(false);
      await logout();
    }
  }

  void routeToLogin([bool fromButton = false]) {
    _navigationService.navigateTo(
      Routes.nativeLoginView,
      arguments: NativeLoginViewArguments(
        fromButton: fromButton,
      ),
    );
  }

  AuthenticationService._internal();
}
