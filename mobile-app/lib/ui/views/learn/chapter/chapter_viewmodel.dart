import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/models/learn/completed_challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/dio_service.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ChapterViewModel extends BaseViewModel {
  final _dio = DioService.dio;
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthenticationService auth = locator<AuthenticationService>();

  bool _isDev = false;
  bool get isDev => _isDev;

  Future<SuperBlock?>? superBlockFuture;

  set setIsDev(bool value) {
    _isDev = value;
    notifyListeners();
  }

  void init(String superBlockDashedName, superBlockName) async {
    superBlockFuture = requestChapters(superBlockDashedName, superBlockName);
    developmentMode();
  }

  Future<String> calculateProgress(Module module) async {
    int steps = 0;
    num completedCount = 0;

    for (int i = 0; i < module.blocks!.length; i++) {
      steps += module.blocks![i].challenges.length;

      for (int j = 0; j < module.blocks![i].challenges.length; j++) {
        completedCount +=
            await completedChallenge(module.blocks![i].challenges[j].id)
                ? 1
                : 0;
      }
    }

    return '$completedCount/$steps';
  }

  Future<bool> completedChallenge(String incomingId) async {
    FccUserModel? user = await auth.userModel;

    if (user != null) {
      for (CompletedChallenge challenge in user.completedChallenges) {
        if (challenge.id == incomingId) {
          return true;
        }
      }
    }

    return false;
  }

  Future<SuperBlock?> requestChapters(
      String superBlockDashedName, String superBlockName) async {
    String baseUrl = LearnService.baseUrl;

    final Response res = await _dio.get(
      '$baseUrl/$superBlockDashedName.json',
    );
    if (res.statusCode == 200) {
      return SuperBlock.fromJson(
        res.data,
        superBlockDashedName,
        superBlockName,
      );
    }

    return null;
  }

  void developmentMode() async {
    await dotenv.load();
    setIsDev = dotenv.env['DEVELOPMENTMODE'] == 'TRUE';
  }

  void routeToBlockView(
    List<Block> blocks,
    String moduleName,
  ) {
    _navigationService.navigateTo(
      Routes.chapterBlockView,
      arguments: ChapterBlockViewArguments(
        blocks: blocks,
        moduleName: moduleName,
      ),
    );
  }
}
