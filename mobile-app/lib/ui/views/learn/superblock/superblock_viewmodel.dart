import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/core/providers/service_providers.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/dio_service.dart';
import 'package:freecodecamp/service/learn/learn_offline_service.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';

class SuperBlockViewModel extends ChangeNotifier {
  late final LearnOfflineService _learnOfflineService;
  LearnOfflineService get learnOfflineService => _learnOfflineService;

  late final LearnService _learnService;
  LearnService get learnService => _learnService;

  late final AuthenticationService _auth;
  AuthenticationService get auth => _auth;

  final _dio = DioService.dio;

  Map<String, bool> _blockOpenStates = {};
  Map<String, bool> get blockOpenStates => _blockOpenStates;

  Future<SuperBlock>? _superBlockData;
  Future<SuperBlock>? get superBlockData => _superBlockData;

  void init(WidgetRef ref) {
    _learnOfflineService = ref.read(learnOfflineServiceProvider);
    _learnService = ref.read(learnServiceProvider);
    _auth = ref.read(authenticationServiceProvider);
  }

  set setSuperBlockData(Future<SuperBlock>? superBlockData) {
    _superBlockData = superBlockData;
    notifyListeners();
  }

  set blockOpenStates(Map<String, bool> openStates) {
    _blockOpenStates = openStates;
    notifyListeners();
  }

  EdgeInsets getPaddingBeginAndEnd(int index, int challenges) {
    if (index == 0) {
      return const EdgeInsets.only(top: 16);
    } else if (challenges == 1) {
      return const EdgeInsets.only(bottom: 32);
    } else {
      return const EdgeInsets.all(0);
    }
  }

  setBlockOpenClosedState(SuperBlock superBlock, int block) {
    Map<String, bool> local = blockOpenStates;
    Block curr = superBlock.blocks![block];

    if (local[curr.dashedName] != null) {
      local[curr.dashedName] = !local[curr.dashedName]!;
    }

    blockOpenStates = local;
  }

  Future<SuperBlock> getSuperBlockData(
    String dashedName,
    String name,
    bool hasInternet,
  ) async {
    String baseUrl = LearnService.baseUrl;

    if (!hasInternet) {
      return SuperBlock(
        dashedName: dashedName,
        name: name,
        blocks: await _learnOfflineService.getCachedBlocks(
          dashedName,
        ),
      );
    }

    final Response res = await _dio.get('$baseUrl/$dashedName.json');

    if (res.statusCode == 200) {
      return SuperBlock.fromJson(
        res.data,
        dashedName,
        name,
      );
    } else {
      throw Exception(res.data);
    }
  }
}

final superBlockViewModelProvider =
    ChangeNotifierProvider.autoDispose<SuperBlockViewModel>(
  (ref) => SuperBlockViewModel(),
);
