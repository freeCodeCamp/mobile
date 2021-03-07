import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:freecodecamp/core/logger.dart';

class NewsViewModel extends BaseViewModel {
  Logger log;

  NewsViewModel() {
    this.log = getLogger(this.runtimeType.toString());
  }
}
