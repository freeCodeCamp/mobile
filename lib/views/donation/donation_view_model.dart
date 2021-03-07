import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:freecodecamp/core/logger.dart';

class DonationViewModel extends BaseViewModel {
  Logger log;

  DonationViewModel() {
    this.log = getLogger(this.runtimeType.toString());
  }
}
