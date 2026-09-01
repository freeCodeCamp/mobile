import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/service/dio_service.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

/// Thrown when `/mobile-login` answers successfully but without the session
/// cookies the app needs.
///
/// Treated as a failed login rather than ignored: carrying on would leave the
/// app looking signed in while every authenticated request behind it failed.
class MissingSessionCookiesException implements Exception {
  MissingSessionCookiesException(this.missing);

  /// Names of the cookies the response did not carry.
  final List<String> missing;

  @override
  String toString() =>
      'The login response was missing these cookies: ${missing.join(', ')}';
}

/// Thrown when the session cookies were created but could not be used to load
/// the signed-in user.
class SessionUserFetchException implements Exception {
  const SessionUserFetchException();

  @override
  String toString() => 'The signed-in user could not be loaded.';
}

class AuthenticationService {
  static final AuthenticationService _authenticationService =
      AuthenticationService._internal();

  SnackbarService snackbar = locator<SnackbarService>();
  final NavigationService _navigationService = locator<NavigationService>();

  final FlutterSecureStorage store = const FlutterSecureStorage();
  final Dio _dio = DioService.dio;
  late final Auth0 auth0;

  /// The session cookies the fCC API hands back, and the keys they are stored
  /// under. Every one of them is required for an authenticated request.
  static const List<String> _sessionTokenKeys = [
    'jwt_access_token',
    'csrf_token',
    'csrf',
  ];

  /// Cookie names in the `/mobile-login` response. Deliberately not the same
  /// strings as [_sessionTokenKeys] — the `_csrf` cookie is stored under the
  /// key `csrf`.
  static const List<String> _sessionCookieNames = [
    '_csrf',
    'csrf_token',
    'jwt_access_token',
  ];

  /// Callback scheme for debug builds, where App Links are unavailable because
  /// the app is signed with the debug key. Must match the `auth0Scheme`
  /// manifest placeholder in android/app/build.gradle.kts.
  static const String _debugCallbackScheme = 'org.freecodecamp';

  /// Requested on both login paths. offline_access is deliberately absent: the
  /// access token is exchanged for an fCC session immediately, so a refresh
  /// token would only be issued to be thrown away.
  static const Set<String> _scopes = {'openid', 'profile', 'email'};

  static const Color _dialogBackground = Color(0xFF2A2A40);
  static const Color _dialogButtonBackground = Color(0xFF0a0a23);
  static const RoundedRectangleBorder _dialogBorder = RoundedRectangleBorder();

  @visibleForTesting
  static bool Function()? isIOSOverride;

  static bool get _isIOS => isIOSOverride?.call() ?? Platform.isIOS;

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

  static const String supportEmail = 'mobile@freecodecamp.org';

  StreamController<bool> progress = StreamController.broadcast();

  final Stream<bool> _isLoggedIn = isLoggedInStream.stream;
  Stream<bool> get isLoggedIn => _isLoggedIn;
  static bool staticIsloggedIn = false;

  factory AuthenticationService() {
    return _authenticationService;
  }

  Future<bool> hasRequiredTokens() async {
    for (String requiredToken in _sessionTokenKeys) {
      // NOTE: read returns null for a missing key, so it covers containsKey too
      final value = await store.read(key: requiredToken);
      if (value == null || value.isEmpty) {
        log('message: Missing token: $requiredToken');
        return false;
      }
    }

    return true;
  }

  Future<void> writeTokensToStorage() async {
    await Future.wait([
      store.write(key: 'csrf', value: _csrf),
      store.write(key: 'csrf_token', value: _csrfToken),
      store.write(key: 'jwt_access_token', value: _jwtAccessToken),
    ]);
  }

  Future<void> setRequiredTokens() async {
    _csrf = await store.read(key: 'csrf') ?? '';
    _csrfToken = await store.read(key: 'csrf_token') ?? '';
    _jwtAccessToken = await store.read(key: 'jwt_access_token') ?? '';
  }

  /// Reads the fCC session cookies out of a `/mobile-login` response.
  ///
  /// Throws [MissingSessionCookiesException] when the response carries no
  /// `set-cookie` header, or carries one without every cookie the app needs.
  /// Nothing is assigned unless all of them are present, so a rejected
  /// response cannot half-replace a session that is already in place.
  void extractCookies(Response res) {
    final cookies = <String, String>{};

    for (final cookie
        in res.headers[HttpHeaders.setCookieHeader] ?? const <String>[]) {
      final parsedCookie = Cookie.fromSetCookieValue(cookie);
      cookies[parsedCookie.name] = parsedCookie.value;
    }

    final missing = _sessionCookieNames
        .where((name) => (cookies[name] ?? '').isEmpty)
        .toList();

    if (missing.isNotEmpty) {
      throw MissingSessionCookiesException(missing);
    }

    _csrf = cookies['_csrf']!;
    _csrfToken = cookies['csrf_token']!;
    _jwtAccessToken = cookies['jwt_access_token']!;
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

    if (await hasRequiredTokens()) {
      log('message: Tokens found in storage');
      await setRequiredTokens();
      await fetchUser();
    }
  }

  Future<FccUserModel> parseUserModel(Map<String, dynamic> data) async {
    return FccUserModel.fromJson(data);
  }

  /// Opens Universal Login for [connectionType].
  ///
  /// Backgrounding the app while the login sheet is open can leave a web auth
  /// transaction active, and every later attempt then fails with
  /// `TRANSACTION_ACTIVE_ALREADY` until the app is restarted. Clearing the
  /// stale transaction and retrying once keeps the user from getting stuck.
  Future<Credentials> _webAuthLogin(String connectionType) async {
    final webAuth = auth0.webAuthentication(
      scheme: kReleaseMode ? null : _debugCallbackScheme,
      // NOTE: the access token is exchanged for an fCC session right away and
      // never read back, so storing it would only leave Auth0 tokens behind on
      // the device whenever that exchange fails
      useCredentialsManager: false,
    );

    final parameters = {'connection': connectionType};

    try {
      return await webAuth.login(
        useHTTPS: true,
        scopes: _scopes,
        parameters: parameters,
      );
    } on WebAuthenticationException catch (e) {
      // Auth0 exposes cancel as an iOS-only API. On every other platform,
      // surface the original exception instead of attempting an unsupported
      // recovery.
      if (e.code != 'TRANSACTION_ACTIVE_ALREADY' || !_isIOS) rethrow;

      log('message: clearing a stale web auth transaction');
      WebAuthentication.cancel();

      return webAuth.login(
        useHTTPS: true,
        scopes: _scopes,
        parameters: parameters,
      );
    }
  }

  /// Authenticates with Auth0 and returns the credentials to exchange for an
  /// fCC session. Email uses a one-time code; everything else is a social
  /// connection through Universal Login.
  Future<Credentials> _authenticate(
    String connectionType, {
    String? email,
    String? otp,
  }) {
    if (connectionType != 'email') {
      return _webAuthLogin(connectionType);
    }

    return auth0.api.loginWithEmailCode(
      email: email!,
      verificationCode: otp!,
      scopes: _scopes,
    );
  }

  /// Trades an Auth0 access token for the fCC session cookies and loads the
  /// user behind them.
  Future<void> _exchangeForSession(String accessToken) async {
    final res = await _dio.get(
      '$baseApiURL/mobile-login',
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );

    extractCookies(res);
    await writeTokensToStorage();
    if (!await _loadUserSession()) {
      throw const SessionUserFetchException();
    }
  }

  Future<bool> login(
    BuildContext context,
    String connectionType, {
    String? email,
    String? otp,
  }) async {
    late final Credentials creds;

    _showLoadingDialog(context, connectionType);

    try {
      creds = await _authenticate(connectionType, email: email, otp: otp);
    } on WebAuthenticationException catch (e) {
      log('message: WebAuthenticationException: ${e.message}, '
          'code: ${e.code}, retryable: ${e.isRetryable}');

      snackbar.showSnackbar(
        title: e.isUserCancelledException
            ? context.t.login_cancelled
            : context.t.error_two,
        message: e.isUserCancelledException ? '' : e.message,
      );

      await _abandonLogin(context);
      return false;
    } on ApiException catch (e) {
      // NOTE: the most likely case is a wrong or expired OTP, which the login
      // view reports through its own error text
      log('message: ApiException: ${e.message}');

      await _abandonLogin(context);
      return false;
    }

    try {
      await _exchangeForSession(creds.accessToken);
    } on DioException catch (err, st) {
      await _reportSessionFailure(
        context,
        details: err.response?.data.toString() ?? err.toString(),
        stackTrace: st,
      );
      return false;
    } on MissingSessionCookiesException catch (err, st) {
      await _reportSessionFailure(
        context,
        details: err.toString(),
        stackTrace: st,
      );
      return false;
    } on SessionUserFetchException catch (err, st) {
      await _reportSessionFailure(
        context,
        details: err.toString(),
        stackTrace: st,
      );
      return false;
    }

    if (context.mounted) {
      // NOTE: closes the loading dialog, then the login view behind it
      Navigator.pop(context);
      Navigator.pop(context);
    }

    return true;
  }

  /// Closes the loading dialog and reports a failed session exchange.
  Future<void> _reportSessionFailure(
    BuildContext context, {
    required String details,
    required StackTrace stackTrace,
  }) async {
    log('message: session exchange failed: $details');

    if (!context.mounted) {
      return;
    }

    Navigator.pop(context);
    await _showSessionErrorDialog(
      context,
      details: details,
      stackTrace: stackTrace.toString(),
    );
  }

  /// Drops the half-finished session and closes the loading dialog.
  Future<void> _abandonLogin(BuildContext context) async {
    await _clearLocalSession();

    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  void _showLoadingDialog(BuildContext context, String connectionType) {
    // NOTE: deliberately not awaited; the dialog is dismissed by popping it
    showDialog(
      context: context,
      barrierDismissible: false,
      routeSettings: RouteSettings(
        name: '/login/$connectionType',
      ),
      builder: (context) {
        return PopScope(
          canPop: false,
          child: SimpleDialog(
            title: Text(context.t.login_load_message),
            contentPadding: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 24.0),
            backgroundColor: _dialogBackground,
            shape: _dialogBorder,
            children: const [
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Reports a failed session exchange, offering to mail the details to
  /// support. The same text is shown on screen and used as the mail body.
  Future<void> _showSessionErrorDialog(
    BuildContext context, {
    required String details,
    required String stackTrace,
  }) {
    final message = context.t.login_email_error_message(
      supportEmail,
      details,
      stackTrace,
    );
    final subject = Uri.encodeComponent(context.t.login_email_error_subject);
    final body = Uri.encodeComponent(message);

    return showDialog(
      context: context,
      barrierDismissible: false,
      routeSettings: const RouteSettings(
        name: '/login/error',
      ),
      builder: (context) => AlertDialog(
        backgroundColor: _dialogBackground,
        shape: _dialogBorder,
        title: Text(context.t.error_two),
        content: SingleChildScrollView(
          child: SelectionArea(
            child: Text(message),
          ),
        ),
        actions: [
          _dialogAction(
            label: context.t.email_error,
            onPressed: () async {
              await _clearLocalSession();
              await launchUrl(Uri.parse(
                  'mailto:$supportEmail?subject=$subject&body=$body'));

              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
          _dialogAction(
            label: context.t.close,
            onPressed: () async {
              await _clearLocalSession();

              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _dialogAction({
    required String label,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: _dialogButtonBackground,
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }

  /// Clears the Auth0 session cookie, then drops the local session.
  ///
  /// Clearing the cookie is what actually signs the user out of the device:
  /// without it a valid Auth0 session survives on a shared phone, and the next
  /// login can reuse it. It opens a browser tab, so this belongs on
  /// user-initiated logouts only — everywhere else use [_clearLocalSession].
  Future<void> logout() async {
    try {
      // NOTE: unlike login this keeps the credentials manager, so that any
      // tokens stored by an older build get cleared on the next logout
      await auth0
          .webAuthentication(scheme: kReleaseMode ? null : _debugCallbackScheme)
          .logout(useHTTPS: true);
    } on WebAuthenticationException catch (e) {
      // NOTE: a failed Auth0 logout must never strand the local session
      log('message: WebAuthenticationException on logout: ${e.message}');
    }

    await _clearLocalSession();
  }

  Future<void> _clearLocalSession() async {
    staticIsloggedIn = false;
    isLoggedInStream.sink.add(false);

    _csrf = '';
    _csrfToken = '';
    _jwtAccessToken = '';
    userModel = null;

    await Future.wait(
      _sessionTokenKeys.map((key) => store.delete(key: key)),
    );
  }

  Future<void> fetchUser() async {
    await _loadUserSession();
  }

  /// Loads the user for the current session and reports whether it succeeded.
  ///
  /// Public callers only need the side effects from [fetchUser], but login
  /// must use this result to avoid reporting success for a cleared session.
  Future<bool> _loadUserSession() async {
    try {
      final res = await _dio.get(
        '$baseApiURL/user/session-user',
        options: Options(
          headers: {
            'CSRF-Token': _csrfToken,
            'Cookie': 'jwt_access_token=$_jwtAccessToken; _csrf=$_csrf',
          },
        ),
      );

      if (res.statusCode == 200 && res.data['result'] != '') {
        userModel = parseUserModel(res.data['user'][res.data['result']]);
        staticIsloggedIn = true;
        isLoggedInStream.sink.add(true);
        progress.add(true);
        return true;
      } else {
        await _clearLocalSession();
        return false;
      }
    } on DioException {
      await _clearLocalSession();
      return false;
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
