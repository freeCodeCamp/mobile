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

  List<GlobalKey> _blockKeys = [];
  List<GlobalKey> get blockKeys => _blockKeys;

  bool _isAnimating = false;
  bool get isAnimating => _isAnimating;

  set blockOpenStates(Map<String, bool> openStates) {
    _blockOpenStates = openStates;
    notifyListeners();
  }

  void setBlocks(List<Block> blocks) {
    _blocks = blocks;
    // Create GlobalKeys for each block for accurate scrolling
    _blockKeys = List.generate(blocks.length, (index) => GlobalKey());
    notifyListeners();
  }

  void scrollToPrevious() {
    if (_currentBlockIndex > 0 && !_isAnimating) {
      _currentBlockIndex--;
      _scrollToBlock(_currentBlockIndex);
      notifyListeners();
    }
  }

  void scrollToNext() {
    if (_currentBlockIndex < _blocks.length - 1 && !_isAnimating) {
      _currentBlockIndex++;
      _scrollToBlock(_currentBlockIndex);
      notifyListeners();
    }
  }

  void _scrollToBlock(int index) async {
    if (index >= 0 && index < _blockKeys.length) {
      final context = _blockKeys[index].currentContext;
      if (context != null) {
        _isAnimating = true;
        notifyListeners();
        
        try {
          // Use ensureVisible to center the block in the viewport
          await Scrollable.ensureVisible(
            context,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            alignment: 0.5, // Center the block in the viewport
          );
        } finally {
          _isAnimating = false;
          notifyListeners();
        }
      }
    }
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
