import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthenticationService {
  static final AuthenticationService _authenticationService =
      AuthenticationService._internal();

  Future authenticate() async {
    await dotenv.load(fileName: '.env');

    String domain = dotenv.get('AUTH0_DOMAIN');
    String clientId = dotenv.get('AUTH0_CLIENT_ID');

    final auth0 = Auth0(domain, clientId);
    await auth0.webAuthentication().login();
  }

  Future init() async {}

  factory AuthenticationService() {
    return _authenticationService;
  }

  AuthenticationService._internal();
}
