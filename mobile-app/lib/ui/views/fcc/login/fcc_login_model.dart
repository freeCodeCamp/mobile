import 'package:freecodecamp/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class FccLoginModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();

  void cancelLogin() {
    _navigationService.back();
  }
}
