import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

mixin NavigationMixin<T> on BaseViewModel {
  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  List<T> _items = [];
  List<T> get items => _items;

  List<GlobalKey> _itemKeys = [];
  List<GlobalKey> get itemKeys => _itemKeys;

  bool _isAnimating = false;
  bool get isAnimating => _isAnimating;

  void setItems(List<T> items) {
    _items = items;
    _itemKeys = List.generate(items.length, (index) => GlobalKey());
    _currentIndex = findFirstAvailableIndex();
    notifyListeners();
  }

  void scrollToPrevious() {
    if (!_isAnimating) {
      int prevIndex = findPreviousAvailableIndex(_currentIndex);
      if (prevIndex != -1) {
        _currentIndex = prevIndex;
        _scrollToItem(_currentIndex);
        notifyListeners();
      }
    }
  }

  void scrollToNext() {
    if (!_isAnimating) {
      int nextIndex = findNextAvailableIndex(_currentIndex);
      if (nextIndex != -1) {
        _currentIndex = nextIndex;
        _scrollToItem(_currentIndex);
        notifyListeners();
      }
    }
  }

  void _scrollToItem(int index) {
    if (index >= 0 && index < _itemKeys.length) {
      final context = _itemKeys[index].currentContext;
      if (context != null) {
        _isAnimating = true;
        notifyListeners();

        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          alignment: getScrollAlignment(),
        ).then((_) {
          _isAnimating = false;
          notifyListeners();
        });
      }
    }
  }

  bool get hasPrevious => findPreviousAvailableIndex(_currentIndex) != -1;
  bool get hasNext => findNextAvailableIndex(_currentIndex) != -1;

  int findFirstAvailableIndex() => 0;
  int findPreviousAvailableIndex(int currentIndex) => currentIndex > 0 ? currentIndex - 1 : -1;
  int findNextAvailableIndex(int currentIndex) => currentIndex < _items.length - 1 ? currentIndex + 1 : -1;
  double getScrollAlignment() => 0.5;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}