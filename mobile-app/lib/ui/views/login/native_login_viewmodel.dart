import 'dart:developer';

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/developer_service.dart';
import 'package:stacked/stacked.dart';

class NativeLoginViewModel extends BaseViewModel {
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  bool showOTPfield = false;
  bool incorrectOTP = false;

  final AuthenticationService auth = locator<AuthenticationService>();
  final DeveloperService developerService = locator<DeveloperService>();

  bool _emailFieldIsValid = false;
  bool get emailFieldIsValid => _emailFieldIsValid;

  bool _otpFieldIsValid = false;
  bool get otpFieldIsValid => _otpFieldIsValid;

  set emailFieldIsValid(bool value) {
    _emailFieldIsValid = value;
    notifyListeners();
  }

  set otpFieldIsValid(bool value) {
    _otpFieldIsValid = value;
    notifyListeners();
  }

  void init() async {
    bool isEmail(String em) {
      String p =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

      RegExp regExp = RegExp(p);

      return regExp.hasMatch(em);
    }

    emailController.addListener(() {
      if (isEmail(emailController.text)) {
        emailFieldIsValid = true;
      } else if (emailFieldIsValid) {
        emailFieldIsValid = false;
      }
    });

    otpController.addListener(() {
      if (RegExp(r'^[0-9]{6}$').hasMatch(otpController.text)) {
        otpFieldIsValid = true;
      } else if (emailFieldIsValid) {
        otpFieldIsValid = false;
      }
    });
  }

  Future<void> sendOTPtoEmail(BuildContext context) async {
    showOTPfield = true;
    notifyListeners();
    try {
      await auth.auth0.api.startPasswordlessWithEmail(
        email: emailController.text,
        passwordlessType: PasswordlessType.code,
      );
    } on ApiException catch (e) {
      // NOTE: without a code on its way, leaving the OTP field up would strand
      // the user, so send them back to the email step to retry
      log('message: ApiException on passwordless start: ${e.message}');
      showOTPfield = false;
      notifyListeners();
      auth.snackbar.showSnackbar(
        title: context.t.error_two,
        message: context.t.email_code_not_sent,
      );
    }
  }

  void verifyOTP(BuildContext context) async {
    bool isSuccess = await auth.login(
      context,
      'email',
      email: emailController.text,
      otp: otpController.text,
    );
    if (isSuccess) {
      incorrectOTP = false;
    } else {
      incorrectOTP = true;
    }
    notifyListeners();
  }
}
