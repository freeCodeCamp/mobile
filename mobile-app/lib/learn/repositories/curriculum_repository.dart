import 'package:dio/dio.dart';
import 'package:freecodecamp/auth/repositories/session_repository.dart';
import 'package:freecodecamp/learn/constants/curriculum.dart';
import 'package:freecodecamp/services/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'curriculum_repository.g.dart';

@riverpod
LearnCurriculumRepository learnCurriculumRepository(Ref ref) =>
    LearnCurriculumRepository(
      ref.watch(dioProvider),
      ref.watch(authSessionRepositoryProvider),
    );

class LearnCurriculumRepository {
  LearnCurriculumRepository(this._dio, this._session);

  final Dio _dio;
  final AuthSessionRepository _session;

  Future<Map<String, List<Map<String, dynamic>>>> getSuperBlockStages() async {
    final stages = (await _get('available-superblocks.json'))['superblocks'];

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
    final superBlock = (await _get('$dashedName.json')).values.firstOrNull;

    if (superBlock is! Map) {
      throw FormatException('No superblock in $dashedName.json');
    }
    return Map<String, dynamic>.from(superBlock);
  }

  Future<Map<String, dynamic>> getChallenge(
    String superBlock,
    String block,
    String challengeId,
  ) => _get('challenges/$superBlock/$block/$challengeId.json');

  Future<Map<String, dynamic>> getSubmitTypes() => _get('submit-types.json');

  Future<Map<String, dynamic>> getSceneAssets() => _get('scene-assets.json');

  Future<void> postModernChallengeCompleted(Map<String, dynamic> body) =>
      _post('/modern-challenge-completed', body);

  Future<void> postProjectCompleted(Map<String, dynamic> body) =>
      _post('/project-completed', body);

  Future<Map<String, dynamic>> _get(String path) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$curriculumDataUrl/$path',
    );
    return response.data!;
  }

  Future<void> _post(String path, Map<String, dynamic> body) =>
      _session.authenticated(
        (options) => _dio.post<void>(
          '${_session.apiUrl}$path',
          data: body,
          options: options,
        ),
      );
}
