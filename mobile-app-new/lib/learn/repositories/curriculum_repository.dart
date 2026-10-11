import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_app_new/services/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'curriculum_repository.g.dart';

const _prodUrl = 'https://www.freecodecamp.org/curriculum-data/v2';
const _devUrl = 'https://www.freecodecamp.dev/curriculum-data/v2';

@riverpod
LearnCurriculumRepository learnCurriculumRepository(Ref ref) =>
    LearnCurriculumRepository(ref.watch(dioProvider));

class LearnCurriculumRepository {
  LearnCurriculumRepository(this._dio);

  final Dio _dio;

  String get _baseUrl =>
      dotenv.getBool('DEVELOPMENT_MODE', fallback: false) ? _devUrl : _prodUrl;

  Future<Map<String, List<Map<String, dynamic>>>> getSuperBlockStages() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$_baseUrl/available-superblocks.json',
    );
    final stages = response.data?['superblocks'];

    return {
      if (stages is Map)
        for (final MapEntry(:key, :value) in stages.entries)
          if (key is String && value is List)
            key: [
              for (final entry in value)
                if (entry is Map) Map<String, dynamic>.from(entry),
            ],
    };
  }

  Future<Map<String, dynamic>> getSuperBlock(String dashedName) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$_baseUrl/$dashedName.json',
    );
    final superBlock = response.data?.values.firstOrNull;

    if (superBlock is! Map) {
      throw FormatException('No superblock in $dashedName.json');
    }
    return Map<String, dynamic>.from(superBlock);
  }
}
