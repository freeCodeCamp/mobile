import 'package:flutter/cupertino.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:stacked/stacked.dart';

class NativeLoginViewModel extends BaseViewModel {
  TextEditingController controller = TextEditingController();

  final AuthenticationService auth = locator<AuthenticationService>();

  bool _emailFieldIsValid = false;
  bool get emailFieldIsValid => _emailFieldIsValid;

  set emailFieldIsValid(bool value) {
    _emailFieldIsValid = value;
    notifyListeners();
  }

  void init() {
    bool isEmail(String em) {
      String p =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

      RegExp regExp = RegExp(p);

      return regExp.hasMatch(em);
    }

    controller.addListener(() {
      if (isEmail(controller.text)) {
        emailFieldIsValid = true;
      } else if (emailFieldIsValid) {
        emailFieldIsValid = false;
      }
    });
  }
}
