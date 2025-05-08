import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/dio_service.dart';
import 'package:freecodecamp/service/learn/learn_offline_service.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class SuperBlockViewModel extends BaseViewModel {
  final _learnOfflineService = locator<LearnOfflineService>();
  LearnOfflineService get learnOfflineService => _learnOfflineService;

  final _learnService = locator<LearnService>();
  LearnService get learnService => _learnService;

  final AuthenticationService _auth = locator<AuthenticationService>();
  AuthenticationService get auth => _auth;

  final _dio = DioService.dio;

  double getPaddingBetweenBlocks(Block block) {
    if (block.isStepBased) {
      return 3.0;
    }

    if (block.dashedName == 'es6') {
      return 0;
    }

    return 50.0;
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

  Future<bool> getBlockOpenState(Block block) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(block.name) ?? block.order == 0;
  }

  Future<SuperBlock> getSuperBlockData(
    String dashedName,
    String name,
    bool hasInternet,
  ) async {
    String baseUrl = LearnService.baseUrlV2;

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
