import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NewAuthService {
  static final NewAuthService _newAuthService = NewAuthService._internal();

  late final Auth0 auth0;

  factory NewAuthService() {
    return _newAuthService;
  }

  Future<void> init() async {
    await dotenv.load();
    auth0 = Auth0(dotenv.get('AUTH0_DOMAIN'), dotenv.get('AUTH0_CLIENT_ID'));
  }

  NewAuthService._internal();
}
