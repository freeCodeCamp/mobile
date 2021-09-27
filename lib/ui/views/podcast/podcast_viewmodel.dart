import 'package:stacked/stacked.dart';

// Business logic and view state

class PodcastViewModel extends BaseViewModel {
  String title = '';

  void doSomething() {
    title += 'updated ';
    notifyListeners();
  }
}
