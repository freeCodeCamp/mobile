import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:freecodecamp/core/logger.dart';

class RadioViewModel extends BaseViewModel {
  Logger log;

  RadioViewModel() {
    this.log = getLogger(this.runtimeType.toString());
  }
}
