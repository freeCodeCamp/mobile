import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:stacked/stacked.dart';

class ChapterBlockViewmodel extends BaseViewModel {
  Map<String, bool> _blockOpenStates = {};
  Map<String, bool> get blockOpenStates => _blockOpenStates;
  final authenticationService = locator<AuthenticationService>();

  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  int _currentBlockIndex = 0;
  int get currentBlockIndex => _currentBlockIndex;

  List<Block> _blocks = [];
  List<Block> get blocks => _blocks;

  set blockOpenStates(Map<String, bool> openStates) {
    _blockOpenStates = openStates;
    notifyListeners();
  }

  void setBlocks(List<Block> blocks) {
    _blocks = blocks;
    notifyListeners();
  }

  void scrollToPrevious() {
    if (_currentBlockIndex > 0) {
      _currentBlockIndex--;
      _scrollToBlock(_currentBlockIndex);
      notifyListeners();
    }
  }

  void scrollToNext() {
    if (_currentBlockIndex < _blocks.length - 1) {
      _currentBlockIndex++;
      _scrollToBlock(_currentBlockIndex);
      notifyListeners();
    }
  }

  void _scrollToBlock(int index) {
    // Calculate approximate item height (this is an estimation)
    const double itemHeight = 120.0; // Approximate height of each block item
    final double targetPosition = index * itemHeight;
    
    _scrollController.animateTo(
      targetPosition,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  bool get hasPrevious => _currentBlockIndex > 0;
  bool get hasNext => _currentBlockIndex < _blocks.length - 1;

  setBlockOpenClosedState(List<Block> blocks, int block) {
    Map<String, bool> local = blockOpenStates;
    Block curr = blocks[block];

    if (local[curr.dashedName] != null) {
      local[curr.dashedName] = !local[curr.dashedName]!;
    }

    blockOpenStates = local;
  }

  void updateUserProgress() {
    if (AuthenticationService.staticIsloggedIn) {
      authenticationService.fetchUser();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
