import 'dart:async';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/service/authentication_service.dart';
import 'package:stacked/stacked.dart';
import 'package:freecodecamp/app/app.locator.dart';

// import 'dart:developer';
class ProfileViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  late FccUserModel user;

  void initState() async {
    user = _authenticationService.userModel!;
    log(user.toString());
    notifyListeners();
  }
}
