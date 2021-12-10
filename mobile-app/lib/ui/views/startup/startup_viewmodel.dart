import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  Future init() async {
    await Future.delayed(
      const Duration(seconds: 3),
      () => _navigationService.navigateTo(Routes.websiteView),
    );
  }
}
