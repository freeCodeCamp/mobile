import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/mixins/navigation_mixin.dart';
import 'package:stacked/stacked.dart';

mixin ChapterNavigationMixin on BaseViewModel, FloatingNavigationMixin<Chapter> {
  @override
  int findFirstAvailableIndex() {
    for (int i = 0; i < items.length; i++) {
      if (items[i].comingSoon != true) {
        return i;
      }
    }
    return 0;
  }

  @override
  int findPreviousAvailableIndex(int currentIndex) {
    for (int i = currentIndex - 1; i >= 0; i--) {
      if (items[i].comingSoon != true) {
        return i;
      }
    }
    return -1;
  }

  @override
  int findNextAvailableIndex(int currentIndex) {
    for (int i = currentIndex + 1; i < items.length; i++) {
      if (items[i].comingSoon != true) {
        return i;
      }
    }
    return -1;
  }

  @override
  int findNearestAvailableIndex(int index) {
    if (index < 0 || index >= items.length) {
      return findFirstAvailableIndex();
    }
    
    if (items[index].comingSoon != true) {
      return index;
    }
    
    // Find the nearest available index
    int forward = findNextAvailableIndex(index - 1);
    int backward = findPreviousAvailableIndex(index + 1);
    
    if (forward == -1 && backward == -1) {
      return findFirstAvailableIndex();
    } else if (forward == -1) {
      return backward;
    } else if (backward == -1) {
      return forward;
    } else {
      // Return the closer one
      return (index - backward) <= (forward - index) ? backward : forward;
    }
  }

  @override
  double getScrollAlignment() => 0.0;
}