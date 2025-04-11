import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:stacked/stacked.dart';

class ProfileViewModel extends BaseViewModel {
  final AuthenticationService auth = locator<AuthenticationService>();
}
