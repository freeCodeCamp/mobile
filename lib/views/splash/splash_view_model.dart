import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:freecodecamp/core/logger.dart';

class SplashViewModel extends BaseViewModel {
  Logger log;

  SplashViewModel() {
    this.log = getLogger(this.runtimeType.toString());
  }
}
