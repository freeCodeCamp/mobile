import 'package:stacked/stacked.dart';

class EpisodeViewModel extends BaseViewModel {
  bool _viewMoreDescription = false;
  bool get viewMoreDescription => _viewMoreDescription;

  set setViewMoreDescription(bool state) {
    _viewMoreDescription = state;
    notifyListeners();
  }
}
