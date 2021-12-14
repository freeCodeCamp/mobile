import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  int index = 1;

  void onTapped(int index) {
    this.index = index;
    notifyListeners();
  }
}
