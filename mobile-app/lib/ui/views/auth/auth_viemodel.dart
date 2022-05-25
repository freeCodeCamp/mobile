import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freecodecamp/service/authentication_service.dart';
import 'package:stacked/stacked.dart';
import 'package:freecodecamp/app/app.locator.dart';

// import 'dart:developer';
class AuthViewModel extends BaseViewModel {
  final AuthenticationService _auth = locator<AuthenticationService>();

  bool isAuthBusy = false;
  bool isLoggedIn = false;
  String? user;

  void initState() async {
    await dotenv.load(fileName: '.env');

    _auth.isLoggedIn.listen(
      (loggedIn) {
        isLoggedIn = loggedIn;
      },
    );

    notifyListeners();
  }

  Future<void> loginAction() async {
    isAuthBusy = true;
    notifyListeners();
    await _auth.login();
    isAuthBusy = false;
    isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logoutAction() async {
    isAuthBusy = true;
    notifyListeners();
    await _auth.logout();
    isAuthBusy = false;
    isLoggedIn = false;
    notifyListeners();
  }

  Future<void> fetchUser() async {
    user = _auth.fetchUser().toString();
    notifyListeners();
  }
}
