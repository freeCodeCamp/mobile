import 'package:dio/dio.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/service/dio_service.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:stacked/stacked.dart';

class ChapterViewModel extends BaseViewModel {
  final _dio = DioService.dio;

  Future<SuperBlock?>? superBlock;

  void init() {
    superBlock = requestChapters();
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
