import 'package:freecodecamp/core/locator.dart';
import 'package:freecodecamp/core/router_constants.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:freecodecamp/core/logger.dart';
import 'package:stacked_services/stacked_services.dart';

class DrawerListViewModel extends BaseViewModel {
  Logger log;
  NavigationService _navigationService = locator<NavigationService>();

  DrawerListViewModel() {
    this.log = getLogger(this.runtimeType.toString());
  }

  void navigateToTraining() {
    _navigationService.navigateTo(trainingViewRoute);
  }

  void navigateToForum() {
    _navigationService.navigateTo(forumViewRoute);
  }

  void navigateToNews() {
    _navigationService.navigateTo(newsViewRoute);
  }

  void navigateToRagio() {
    _navigationService.navigateTo(radioViewRoute);
  }

  void navigateToFAQ() {
    _navigationService.navigateTo(faqViewRoute);
  }

  void navigateToDonation() {
    _navigationService.navigateTo(donationViewRoute);
  }
}
