import 'package:stacked/stacked.dart';

class NewsViewHandlerViewModel extends BaseViewModel {
  int index = 1;

  void onTapped(int index) {
    this.index = index;
    notifyListeners();
  }
}
