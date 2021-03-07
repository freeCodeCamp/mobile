import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:freecodecamp/core/logger.dart';

class ForumViewModel extends BaseViewModel {
  Logger log;

  ForumViewModel() {
    this.log = getLogger(this.runtimeType.toString());
  }
}
