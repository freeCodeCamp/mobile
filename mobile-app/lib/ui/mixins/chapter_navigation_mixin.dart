import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/mixins/navigation_mixin.dart';
import 'package:stacked/stacked.dart';

mixin ChapterNavigationMixin on BaseViewModel, NavigationMixin<Chapter> {
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
  double getScrollAlignment() => 0.0;
}