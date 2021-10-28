import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SettingsViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  void goToForumSettings() {
    _navigationService.navigateTo(Routes.forumSettingsView);
  }

  void gotoPodastSettings() {
    _navigationService.navigateTo(Routes.podcastSettingsView);
  }
}
