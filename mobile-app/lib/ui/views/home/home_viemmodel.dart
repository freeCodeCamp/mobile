import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  int index = 1;

  final NavigationService _navigationService = locator<NavigationService>();

  void onTapped(int index) {
    this.index = index;
    notifyListeners();
  }

  void checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool shouldPushLoginScreen = prefs.getBool('isLoggedIn') ?? true;

    if (shouldPushLoginScreen) {
      _navigationService.navigateTo(Routes.fccLoginView);
    }
  }
}
