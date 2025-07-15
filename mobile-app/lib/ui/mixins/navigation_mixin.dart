import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

mixin FloatingNavigationMixin<T> on BaseViewModel {
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

  bool _isScrollListenerAttached = false;

  void setItems(List<T> items) {
    _items = items;
    _itemKeys = List.generate(items.length, (index) => GlobalKey());
    _currentIndex = findFirstAvailableIndex();
    notifyListeners();
  }

  void initializeScrollListener() {
    if (!_isScrollListenerAttached) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _attachScrollListener();
      });
    }
  }

  void _attachScrollListener() {
    if (!_isScrollListenerAttached && _scrollController.hasClients) {
      _scrollController.addListener(_onScroll);
      _isScrollListenerAttached = true;
    }
  }

  void _onScroll() {
    if (!_isAnimating) {
      _updateCurrentIndexFromScroll();
    }
  }

  void _updateCurrentIndexFromScroll() {
    if (_itemKeys.isEmpty || !_scrollController.hasClients) return;

    // Get the current scroll position
    final scrollOffset = _scrollController.offset;
    int newIndex = 0;
    
    // Simple approximation: if we can estimate item heights, we can determine which item is visible
    // For now, we'll use a simple approach based on scroll position relative to total scrollable height
    if (_scrollController.position.maxScrollExtent > 0) {
      final scrollRatio = scrollOffset / _scrollController.position.maxScrollExtent;
      newIndex = (scrollRatio * (_items.length - 1)).round();
      newIndex = newIndex.clamp(0, _items.length - 1);
    }

    // Find the nearest available index
    int availableIndex = findNearestAvailableIndex(newIndex);
    if (availableIndex != _currentIndex) {
      _currentIndex = availableIndex;
      notifyListeners();
    }
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
  int findNearestAvailableIndex(int index) => index;
  double getScrollAlignment() => 0.5;

  @override
  void dispose() {
    if (_isScrollListenerAttached) {
      _scrollController.removeListener(_onScroll);
    }
    _scrollController.dispose();
    super.dispose();
  }
}