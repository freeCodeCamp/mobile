import 'package:freecodecamp/core/locator.dart';
import 'package:freecodecamp/core/router_constants.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:freecodecamp/core/logger.dart';
import 'package:stacked_services/stacked_services.dart';

class ForumViewModel extends BaseViewModel {
  Logger log;
  NavigationService _navigationService = locator<NavigationService>();

  ForumViewModel() {
    this.log = getLogger(this.runtimeType.toString());
  }

  void navigateToTraining() {
    _navigationService.navigateTo(trainingViewRoute);
  }

  void navigateToNews() {
    _navigationService.navigateTo(newsViewRoute);
  }
}
