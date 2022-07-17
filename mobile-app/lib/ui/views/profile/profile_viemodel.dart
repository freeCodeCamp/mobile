import 'package:freecodecamp/app/app.locator.dart' show locator;
import 'package:freecodecamp/service/authentication_service.dart';
import 'package:stacked/stacked.dart';

// import 'dart:developer';
class ProfileViewModel extends BaseViewModel {
  final AuthenticationService auth = locator<AuthenticationService>();
}
