import 'package:stacked/stacked.dart';

class BlockBuilderModel extends BaseViewModel {
  bool _isOpen = false;
  bool get isOpen => _isOpen;

  set setIsOpen(bool widgetIsOpened) {
    _isOpen = widgetIsOpened;
    notifyListeners();
  }
}
