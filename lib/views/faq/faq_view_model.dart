import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:freecodecamp/core/logger.dart';

class FaqViewModel extends BaseViewModel {
  Logger log;

  FaqViewModel() {
    this.log = getLogger(this.runtimeType.toString());
  }
}
