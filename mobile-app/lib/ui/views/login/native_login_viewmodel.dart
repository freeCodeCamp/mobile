import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/developer_service.dart';
import 'package:stacked/stacked.dart';

class NativeLoginViewModel extends BaseViewModel {
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  bool showOTPfield = false;
  bool incorrectOTP = false;
  final Dio _dio = Dio();

  final AuthenticationService auth = locator<AuthenticationService>();
  final DeveloperService developerService = locator<DeveloperService>();

  bool _isDeveloper = false;
  bool get isDeveloper => _isDeveloper;

  bool _emailFieldIsValid = false;
  bool get emailFieldIsValid => _emailFieldIsValid;

  bool _otpFieldIsValid = false;
  bool get otpFieldIsValid => _otpFieldIsValid;

  set emailFieldIsValid(bool value) {
    _emailFieldIsValid = value;
    notifyListeners();
  }

  set setIsDeveloper(bool value) {
    _isDeveloper = value;
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

    setIsDeveloper = await developerService.developmentMode();
  }

  void sendOTPtoEmail() async {
    showOTPfield = true;
    notifyListeners();
    await dotenv.load();
    await _dio.post(
      'https://${dotenv.get('AUTH0_DOMAIN')}/passwordless/start',
      data: {
        'client_id': dotenv.get('AUTH0_CLIENT_ID'),
        'connection': 'email',
        'email': emailController.text,
        'send': 'code',
      },
    );
  }

  void verifyOTP(BuildContext context) async {
    await dotenv.load();
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
