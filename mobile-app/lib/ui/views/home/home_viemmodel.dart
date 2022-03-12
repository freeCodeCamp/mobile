import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/service/fcc_service.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  int index = 1;

  final FccService _fccService = locator<FccService>();

  FccService get fccService => _fccService;

  void onTapped(int index) {
    this.index = index;
    notifyListeners();
  }
}
