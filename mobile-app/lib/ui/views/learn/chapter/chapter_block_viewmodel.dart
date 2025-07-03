import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/ui/mixins/navigation_mixin.dart';
import 'package:stacked/stacked.dart';

class ChapterBlockViewmodel extends BaseViewModel with NavigationMixin<Block> {
  Map<String, bool> _blockOpenStates = {};
  Map<String, bool> get blockOpenStates => _blockOpenStates;
  final authenticationService = locator<AuthenticationService>();

  List<Block> get blocks => items;
  List<GlobalKey> get blockKeys => itemKeys;

  set blockOpenStates(Map<String, bool> openStates) {
    _blockOpenStates = openStates;
    notifyListeners();
  }

  void setBlocks(List<Block> blocks) {
    setItems(blocks);
  }

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
}
