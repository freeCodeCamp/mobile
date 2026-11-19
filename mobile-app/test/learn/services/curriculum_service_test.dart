import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/learn/models/curriculum_model.dart';
import 'package:freecodecamp/learn/repositories/curriculum_repository.dart';
import 'package:freecodecamp/learn/services/curriculum_service.dart';
import 'package:freecodecamp/services/remote_config_service.dart';

class FakeCurriculumRepository implements LearnCurriculumRepository {
  FakeCurriculumRepository(this.superBlockData);

  final Map<String, dynamic> superBlockData;

  @override
  Future<Map<String, dynamic>> getSuperBlock(String dashedName) async {
    return superBlockData;
  }

  @override
  Future<Map<String, List<Map<String, dynamic>>>> getSuperBlockStages() {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getChallenge(
    String superBlock,
    String block,
    String challengeId,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getSubmitTypes() {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getSceneAssets() {
    throw UnimplementedError();
  }

  @override
  Future<void> postModernChallengeCompleted(Map<String, dynamic> body) {
    throw UnimplementedError();
  }

  @override
  Future<void> postProjectCompleted(Map<String, dynamic> body) {
    throw UnimplementedError();
  }
}

void main() {
  const remoteConfig = RemoteConfig(
    activationOverrides: {},
    minAppVersion: '1.0.0',
  );

  group('LearnCurriculumService', () {
    test('removes duplicate challenge IDs while preserving order', () async {
      final repository = FakeCurriculumRepository({
        'blocks': [
          {
            'meta': {
              'order': 1,
              'dashedName': 'test-workshop',
              'name': 'Test Workshop',
              'blockLayout': 'challenge-list',
              'blockLabel': 'workshop',
              'challengeOrder': [
                {'id': 'challenge-1', 'title': 'First challenge'},
                {'id': 'challenge-2', 'title': 'Second challenge'},
                {'id': 'challenge-1', 'title': 'Duplicate challenge'},
                {'title': 'Challenge without an ID'},
                {'id': 123, 'title': 'Challenge with non-string ID'},
                {'id': null, 'title': 'Challenge with null ID'},
              ],
            },
          },
        ],
      });

      final service = LearnCurriculumService(repository);

      final result = await service.getSuperBlock(
        'test-superblock',
        remoteConfig,
      );

      final blocks = result.when(
        blocks: (blocks) => blocks,
        chapters: (_) => <Block>[],
      );

      expect(blocks, hasLength(1));
      expect(
        blocks.first.challenges.map((challenge) => challenge.id).toList(),
        ['challenge-1', 'challenge-2'],
      );
      expect(
        blocks.first.challenges.map((challenge) => challenge.title).toList(),
        ['First challenge', 'Second challenge'],
      );
    });

    test('handles a block with no challenges', () async {
      final repository = FakeCurriculumRepository({
        'blocks': [
          {
            'meta': {
              'order': 1,
              'dashedName': 'empty-workshop',
              'name': 'Empty Workshop',
              'blockLayout': 'challenge-list',
              'blockLabel': 'workshop',
              'challengeOrder': [],
            },
          },
        ],
      });

      final service = LearnCurriculumService(repository);

      final result = await service.getSuperBlock(
        'test-superblock',
        remoteConfig,
      );

      final blocks = result.when(
        blocks: (blocks) => blocks,
        chapters: (_) => <Block>[],
      );

      expect(blocks, hasLength(1));
      expect(blocks.first.challenges, isEmpty);
    });
  });
}
