import 'dart:async';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freecodecamp/service/new_auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:freecodecamp/app/app.locator.dart';

class AuthViewModel extends BaseViewModel {
  final _auth = locator<NewAuthService>().auth0;

  bool isAuthBusy = false;
  bool isLoggedIn = false;
  String? user;

  void initState() async {
    await dotenv.load(fileName: '.env');

    // _auth.isLoggedIn.listen(
    //   (loggedIn) {
    //     isLoggedIn = loggedIn;
    //   },
    // );

    notifyListeners();
  }

  Future<void> loginAction() async {
    isAuthBusy = true;
    notifyListeners();
    final creds = await _auth.webAuthentication(scheme: 'fccapp').login();
    log('AccessToken: ${creds.accessToken}');
    log('IdToken: ${creds.idToken}');
    log('Refreshtoken: ${creds.refreshToken}');
    log('Scopes: ${creds.scopes}');
    log('TokenType: ${creds.tokenType}');
    log('User: ${creds.user.email} ${creds.user.sub}');
    isAuthBusy = false;
    isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logoutAction() async {
    isAuthBusy = true;
    notifyListeners();
    await _auth.webAuthentication(scheme: 'fccapp').logout();
    isAuthBusy = false;
    isLoggedIn = false;
    notifyListeners();
  }

  Future<void> fetchUser() async {
    // user = _auth.fetchUser().toString();
    notifyListeners();
  }
}
