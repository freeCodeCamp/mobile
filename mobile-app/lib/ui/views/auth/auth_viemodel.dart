import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freecodecamp/service/authentication_service.dart';
import 'package:stacked/stacked.dart';
import 'package:freecodecamp/app/app.locator.dart';

// import 'dart:developer';
class AuthViewModel extends BaseViewModel {
  bool isAuthBusy = false;
  bool isLoggedIn = false;
  final _authenticationService = locator<AuthenticationService>();

  void initState() async {
    await dotenv.load(fileName: '.env');
    // await _authenticationService.init();
    isLoggedIn = _authenticationService.isLoggedIn;
    notifyListeners();
  }

  Future<void> loginAction() async {
    isAuthBusy = true;
    notifyListeners();
    await _authenticationService.login();
    isAuthBusy = false;
    isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logoutAction() async {
    isAuthBusy = true;
    notifyListeners();
    await _authenticationService.logout();
    isAuthBusy = false;
    isLoggedIn = false;
    notifyListeners();
  }

  Future<void> showKeys() async {
    await _authenticationService.showKeys();
  }
}
