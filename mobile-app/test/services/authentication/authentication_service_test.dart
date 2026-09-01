import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/l10n/app_localizations.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/dio_service.dart';
import 'package:mockito/mockito.dart';
import 'package:stacked_services/stacked_services.dart';

const _authChannel = MethodChannel('auth0.com/auth0_flutter/auth');
const _webAuthChannel = MethodChannel('auth0.com/auth0_flutter/web_auth');
const _credentialsManagerChannel =
    MethodChannel('auth0.com/auth0_flutter/credentials_manager');

class _MockSnackbarService extends Mock implements SnackbarService {}

class _QueuedHttpClientAdapter implements HttpClientAdapter {
  _QueuedHttpClientAdapter(this.responses);

  final List<ResponseBody> responses;
  final List<Uri> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options.uri);
    if (responses.isEmpty) {
      throw StateError('Unexpected request: ${options.uri}');
    }
    return responses.removeAt(0);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthenticationService authenticationService;
  late Map<String, String> storage;
  late _QueuedHttpClientAdapter adapter;
  PlatformException? authenticationError;
  var webAuthLoginCalls = 0;
  var webAuthCancelCalls = 0;
  var webAuthLogoutCalls = 0;

  setUpAll(() {
    locator.reset();
    locator.registerSingleton<NavigationService>(NavigationService());
    locator.registerSingleton<SnackbarService>(_MockSnackbarService());

    authenticationService = AuthenticationService();
    authenticationService.auth0 = Auth0('example.auth0.com', 'client-id');
    AuthenticationService.baseApiURL = 'https://api.example.test';
  });

  setUp(() {
    storage = <String, String>{};
    FlutterSecureStorage.setMockInitialValues(storage);
    adapter = _QueuedHttpClientAdapter(<ResponseBody>[]);
    DioService.dio.interceptors.clear();
    DioService.dio.httpClientAdapter = adapter;
    AuthenticationService.isIOSOverride = null;
    AuthenticationService.staticIsloggedIn = false;
    authenticationError = null;
    webAuthLoginCalls = 0;
    webAuthCancelCalls = 0;
    webAuthLogoutCalls = 0;

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_authChannel, (call) async {
      if (call.method != 'auth#loginWithEmail') {
        throw UnsupportedError('Unexpected Auth0 API method: ${call.method}');
      }
      if (authenticationError != null) {
        throw authenticationError!;
      }
      return _credentials();
    });
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_webAuthChannel, (call) async {
      switch (call.method) {
        case 'webAuth#login':
          webAuthLoginCalls++;
          if (webAuthLoginCalls == 1 &&
              AuthenticationService.isIOSOverride != null) {
            throw PlatformException(
              code: 'TRANSACTION_ACTIVE_ALREADY',
              message: 'A web authentication transaction is already active.',
            );
          }
          return _credentials();
        case 'webAuth#cancel':
          webAuthCancelCalls++;
          return null;
        case 'webAuth#logout':
          webAuthLogoutCalls++;
          return null;
        default:
          throw UnsupportedError('Unexpected web auth method: ${call.method}');
      }
    });
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_credentialsManagerChannel, (call) async {
      if (call.method != 'credentialsManager#clearCredentials') {
        throw UnsupportedError(
            'Unexpected credentials manager method: ${call.method}');
      }
      return true;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_authChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_webAuthChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_credentialsManagerChannel, null);
    AuthenticationService.isIOSOverride = null;
  });

  Future<BuildContext> buildContext(WidgetTester tester) async {
    late BuildContext context;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (buildContext) {
            context = buildContext;
            return const SizedBox();
          },
        ),
      ),
    );
    await tester.pump();

    return context;
  }

  Future<void> closeSessionError(WidgetTester tester) async {
    await tester.pumpAndSettle();
    final dialog = find.byType(AlertDialog);
    expect(dialog, findsOneWidget);
    await tester.tap(
      find.descendant(of: dialog, matching: find.byType(TextButton)).last,
    );
    await tester.pumpAndSettle();
  }

  testWidgets('returns true after exchanging credentials for a user session',
      (tester) async {
    adapter.responses.addAll([
      sessionResponse(cookies: allSessionCookies),
      jsonResponse(sessionUserResponse, 200),
    ]);
    final context = await buildContext(tester);

    final login = authenticationService.login(
      context,
      'email',
      email: 'camper@example.com',
      otp: '123456',
    );

    await tester.pumpAndSettle();

    expect(await login, isTrue);
    expect(AuthenticationService.staticIsloggedIn, isTrue);
    expect(storage, <String, String>{
      'csrf': 'csrf',
      'csrf_token': 'csrf-token',
      'jwt_access_token': 'access-token',
    });
    expect(authenticationService.userModel, isNotNull);
    expect(adapter.requests, hasLength(2));
  });

  testWidgets('returns false when the user-session request fails',
      (tester) async {
    adapter.responses.addAll([
      sessionResponse(cookies: allSessionCookies),
      jsonResponse(<String, dynamic>{'message': 'Session unavailable'}, 401),
    ]);
    final context = await buildContext(tester);

    final login = authenticationService.login(
      context,
      'email',
      email: 'camper@example.com',
      otp: '123456',
    );
    await closeSessionError(tester);

    expect(await login, isFalse);
    expect(AuthenticationService.staticIsloggedIn, isFalse);
    expect(storage, isEmpty);
    expect(adapter.requests, hasLength(2));
  });

  testWidgets('rejects a mobile-login response without every session cookie',
      (tester) async {
    adapter.responses.add(
      sessionResponse(cookies: <String>[allSessionCookies.last]),
    );
    final context = await buildContext(tester);

    final login = authenticationService.login(
      context,
      'email',
      email: 'camper@example.com',
      otp: '123456',
    );
    await closeSessionError(tester);

    expect(await login, isFalse);
    expect(storage, isEmpty);
    expect(adapter.requests, hasLength(1));
  });

  testWidgets('rejects a mobile-login response with an empty session cookie',
      (tester) async {
    adapter.responses.add(
      sessionResponse(cookies: <String>[
        '_csrf=; Path=/',
        allSessionCookies[1],
        allSessionCookies[2],
      ]),
    );
    final context = await buildContext(tester);

    final login = authenticationService.login(
      context,
      'email',
      email: 'camper@example.com',
      otp: '123456',
    );
    await closeSessionError(tester);

    expect(await login, isFalse);
    expect(storage, isEmpty);
    expect(adapter.requests, hasLength(1));
  });

  testWidgets('returns false for an expired or invalid email code',
      (tester) async {
    authenticationError = PlatformException(
      code: 'invalid_grant',
      message: 'The verification code is invalid or has expired.',
    );
    final context = await buildContext(tester);

    final login = authenticationService.login(
      context,
      'email',
      email: 'camper@example.com',
      otp: '123456',
    );
    await tester.pumpAndSettle();

    expect(await login, isFalse);
    expect(adapter.requests, isEmpty);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('cancels and retries a stale web-auth transaction on iOS',
      (tester) async {
    AuthenticationService.isIOSOverride = () => true;
    adapter.responses.add(
      sessionResponse(cookies: <String>[allSessionCookies.last]),
    );
    final context = await buildContext(tester);

    final login = authenticationService.login(context, 'google-oauth2');
    await closeSessionError(tester);

    expect(await login, isFalse);
    expect(webAuthLoginCalls, 2);
    expect(webAuthCancelCalls, 1);
  });

  test('uses Auth0 logout and clears the local session', () async {
    storage.addAll(<String, String>{
      'csrf': 'csrf',
      'csrf_token': 'csrf-token',
      'jwt_access_token': 'access-token',
    });

    await authenticationService.logout();

    expect(webAuthLogoutCalls, 1);
    expect(storage, isEmpty);
    expect(AuthenticationService.staticIsloggedIn, isFalse);
  });
}

const allSessionCookies = <String>[
  '_csrf=csrf; Path=/',
  'csrf_token=csrf-token; Path=/',
  'jwt_access_token=access-token; Path=/',
];

final sessionUserResponse = <String, dynamic>{
  'result': 'camper',
  'user': <String, dynamic>{
    'camper': <String, dynamic>{
      'id': 'camper-id',
      'email': 'camper@example.com',
      'username': 'camper',
      'name': 'Camper',
      'picture': '',
      'currentChallengeId': '',
      'emailVerified': true,
      'isEmailVerified': true,
      'isCheater': false,
      'isDonating': false,
      'isHonest': true,
      'isFrontEndCert': false,
      'isDataVisCert': false,
      'isBackEndCert': false,
      'isFullStackCert': false,
      'isRespWebDesignCert': false,
      'is2018DataVisCert': false,
      'isFrontEndLibsCert': false,
      'isJsAlgoDataStructCert': false,
      'isApisMicroservicesCert': false,
      'isInfosecQaCert': false,
      'isQaCertV7': false,
      'isInfosecCertV7': false,
      'isSciCompPyCertV7': false,
      'isDataAnalysisPyCertV7': false,
      'isMachineLearningPyCertV7': false,
      'isRelationalDatabaseCertV8': false,
      'isCollegeAlgebraPyCertV8': false,
      'isFoundationalCSharpCertV8': false,
      'joinDate': '2025-01-01T00:00:00.000Z',
      'points': 0,
      'calendar': <String, int>{},
      'completedChallenges': <Object>[],
      'completedDailyCodingChallenges': <Object>[],
      'savedChallenges': <Object>[],
      'portfolio': <Object>[],
      'yearsTopContributor': <Object>[],
      'theme': 'default',
      'profileUI': <String, bool>{
        'isLocked': false,
        'showAbout': false,
        'showCerts': false,
        'showDonation': false,
        'showHeatMap': false,
        'showLocation': false,
        'showName': false,
        'showPoints': false,
        'showPortfolio': false,
        'showTimeLine': false,
      },
    },
  },
};

ResponseBody sessionResponse({required List<String> cookies}) =>
    jsonResponse(<String, dynamic>{}, 200, cookies: cookies);

ResponseBody jsonResponse(
  Map<String, dynamic> body,
  int statusCode, {
  List<String> cookies = const <String>[],
}) =>
    ResponseBody.fromString(
      jsonEncode(body),
      statusCode,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>['application/json'],
        if (cookies.isNotEmpty) HttpHeaders.setCookieHeader: cookies,
      },
    );

Map<String, dynamic> _credentials() => <String, dynamic>{
      'idToken': 'id-token',
      'accessToken': 'access-token',
      'refreshToken': null,
      'expiresAt': DateTime.utc(2030).toIso8601String(),
      'scopes': <String>['openid', 'profile', 'email'],
      'userProfile': <String, dynamic>{'sub': 'auth0|camper'},
      'tokenType': 'Bearer',
    };
