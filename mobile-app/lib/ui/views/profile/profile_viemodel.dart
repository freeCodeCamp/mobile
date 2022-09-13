import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/service/authentication_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

// import 'dart:developer';
class ProfileViewModel extends BaseViewModel {
  final AuthenticationService auth = locator<AuthenticationService>();
  final NavigationService navigationService = locator<NavigationService>();

  void gotoSettings(FccUserModel user) {
    navigationService.pushNamedAndRemoveUntil(
      Routes.settingsView,
    );
  }
}
