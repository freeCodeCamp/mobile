import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_services/stacked_services.dart';

class FccService {
  final NavigationService _navigationService = locator<NavigationService>();

  void checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool shouldPushLoginScreen = prefs.getBool('isLoggedIn') ?? true;

    if (shouldPushLoginScreen) {
      _navigationService.navigateTo(Routes.fccLoginView);
    }
  }
}
