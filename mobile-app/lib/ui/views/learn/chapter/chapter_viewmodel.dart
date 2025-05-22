import 'package:dio/dio.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/completed_challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/dio_service.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:stacked/stacked.dart';

class ChapterViewModel extends BaseViewModel {
  final _dio = DioService.dio;
  final AuthenticationService _auth = locator<AuthenticationService>();

  Future<SuperBlock?>? superBlockFuture;
  FccUserModel? user;

  void init() async {
    superBlockFuture = requestChapters();
    user = await _auth.userModel;
  }

  String calculateProgress(Module module) {
    int steps = 0;
    num completedCount = 0;

    for (int i = 0; i < module.blocks!.length; i++) {
      steps += module.blocks![i].challenges.length;

      for (int j = 0; j < module.blocks![i].challenges.length; j++) {
        completedCount +=
            completedChallenge(module.blocks![i].challenges[j].id) ? 1 : 0;
      }
    }

    return '$completedCount/$steps';
  }

  bool completedChallenge(String incomingId) {
    if (user != null) {
      for (CompletedChallenge challenge in user!.completedChallenges) {
        if (challenge.id == incomingId) {
          return true;
        }
      }
    }

    return false;
  }

  Future<SuperBlock?> requestChapters() async {
    String baseUrl = LearnService.baseUrlV2;

    final Response res = await _dio.get('$baseUrl/full-stack-developer.json');
    if (res.statusCode == 200) {
      return SuperBlock.fromJson(
        res.data,
        'full-stack-developer',
        'Certified Full Stack Developer Curriculum',
      );
    }

    return null;
  }
}
