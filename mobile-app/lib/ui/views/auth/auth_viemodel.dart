import 'dart:convert';
import 'dart:developer';

import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class AuthViewModel extends BaseViewModel {
  bool isAuthBusy = false;
  bool isLoggedIn = false;
  String errorMessage = '';
  late String name;
  late String picture;
  final FlutterAppAuth appAuth = FlutterAppAuth();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  void initState() async {
    await dotenv.load(fileName: '.env');
    final storedRefreshToken = await secureStorage.read(key: 'refreshToken');
    if (storedRefreshToken == null) return;

    isAuthBusy = true;
    final auth0Issuer = dotenv.get('AUTH0_ISSUER');
    final auth0ClientID = dotenv.get('AUTH0_CLIENT_ID');
    final auth0RedirectURI = dotenv.get('AUTH0_REDIRECT_URI');
    try {
      final response = await appAuth.token(
        TokenRequest(
          auth0ClientID,
          auth0RedirectURI,
          issuer: auth0Issuer,
          refreshToken: storedRefreshToken,
        ),
      );
      final idToken = parseIdToken(response!.idToken!);
      final profile = await getUserDetails(response.accessToken!);

      secureStorage.write(key: 'refresh_token', value: response.refreshToken);
      isAuthBusy = false;
      isLoggedIn = true;
    } catch (e, s) {
      log('error on refresh token: $e \n StackTrace: $s');
      await logoutAction();
    }
  }

  Map<String, dynamic> parseIdToken(String idToken) {
    final parts = idToken.split(r'.');
    assert(parts.length == 3);
    return jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
  }

  Future<Map<String, dynamic>> getUserDetails(String accessToken) async {
    final auth0Domain = dotenv.get('AUTH0_DOMAIN');
    final url = 'https://$auth0Domain/userinfo';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user details');
    }
  }

  Future<void> loginAction() async {
    isAuthBusy = true;
    notifyListeners();
    final auth0Domain = dotenv.get('AUTH0_DOMAIN');
    final auth0ClientID = dotenv.get('AUTH0_CLIENT_ID');
    final auth0RedirectURI = dotenv.get('AUTH0_REDIRECT_URI');
    final jwtSecret = dotenv.get('JWT_SECRET');
    final jwt = JWT({
      'returnTo': auth0RedirectURI,
      'origin': auth0RedirectURI,
      'pathPrefix': '',
    }).sign(SecretKey(jwtSecret));
    log(jwtSecret);
    log(jwt);
    log('JWT ${JWT.verify(jwt, SecretKey(jwtSecret)).payload.runtimeType}');
    try {
      final AuthorizationTokenResponse? result =
          await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          auth0ClientID,
          auth0RedirectURI,
          issuer: 'https://$auth0Domain',
          scopes: ['openid', 'profile', 'offline_access', 'email'],
          // additionalParameters: {
          //   'state': 'Testing',
          // },
        ),
      );
      final idToken = parseIdToken(result!.idToken!);
      final profile = await getUserDetails(result.accessToken!);
      await secureStorage.write(
          key: 'refresh_token', value: result.refreshToken);
      isAuthBusy = false;
      isLoggedIn = true;
      log(result.accessToken!);
      log(result.idToken!);
      log('ID TOKEN');
      idToken.forEach((key, value) => log('''$key: $value'''));
      log('PROFILE');
      profile.forEach((key, value) => log('''$key: $value'''));
      name = idToken['name'];
      picture = profile['picture'];
      notifyListeners();
    } catch (e, s) {
      log('Login error: $e \n StackTrace: $s');
      errorMessage = e.toString();
      isAuthBusy = false;
      isLoggedIn = false;
      notifyListeners();
    }
  }

  Future<void> logoutAction() async {
    await secureStorage.delete(key: 'refresh_token');
    isLoggedIn = false;
    isAuthBusy = false;
    notifyListeners();
  }
}
