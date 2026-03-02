import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/core/providers/service_providers.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';

class ChapterBlockViewmodel extends ChangeNotifier {
  ChapterBlockViewmodel({
    required AuthenticationService authenticationService,
  }) : _authenticationService = authenticationService;

  Map<String, bool> _blockOpenStates = {};
  Map<String, bool> get blockOpenStates => _blockOpenStates;

  final AuthenticationService _authenticationService;

  set blockOpenStates(Map<String, bool> openStates) {
    _blockOpenStates = openStates;
    notifyListeners();
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
      _authenticationService.fetchUser();
    }
  }
}

final chapterBlockViewModelProvider =
    ChangeNotifierProvider.autoDispose<ChapterBlockViewmodel>(
  (ref) => ChapterBlockViewmodel(
    authenticationService: ref.read(authenticationServiceProvider),
  ),
);
