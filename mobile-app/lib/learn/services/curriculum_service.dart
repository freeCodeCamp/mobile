import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freecodecamp/learn/constants/curriculum.dart';
import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/learn/models/curriculum_model.dart';
import 'package:freecodecamp/learn/models/scene_assets_model.dart';
import 'package:freecodecamp/learn/repositories/curriculum_repository.dart';
import 'package:freecodecamp/services/remote_config_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'curriculum_service.g.dart';

typedef CurriculumStage = ({
  String key,
  String title,
  List<SuperBlockSummary> superBlocks,
});

@riverpod
LearnCurriculumService learnCurriculumService(Ref ref) =>
    LearnCurriculumService(ref.watch(learnCurriculumRepositoryProvider));

class LearnCurriculumService {
  LearnCurriculumService(this._repo);

  final LearnCurriculumRepository _repo;

  Future<List<CurriculumStage>> getStages(RemoteConfig remoteConfig) async {
    final stages = await _repo.getSuperBlockStages();
    final showAll = dotenv.getBool('SHOW_ALL_SB', fallback: false);

    return [
      for (final MapEntry(key: stage, value: title) in stageTitles.entries)
        if (stages[stage] case final entries?)
          (
            key: stage,
            title: title,
            superBlocks: [
              for (final entry in entries)
                if (!(entry['dashedName'] as String).contains('full-stack'))
                  _toSummary(entry, remoteConfig, showAll),
            ],
          ),
    ];
  }

  SuperBlockSummary _toSummary(
    Map<String, dynamic> raw,
    RemoteConfig remoteConfig,
    bool showAll,
  ) {
    final dashedName = raw['dashedName'] as String;
    final override = remoteConfig.activationOverride(dashedName);

    return SuperBlockSummary(
      dashedName: dashedName,
      title: raw['title'] as String,
      isPublic: override ?? (showAll || raw['public'] == true),
      isDisabledByOverride: override == false,
    );
  }

  Future<SuperBlock> getSuperBlock(
    String dashedName,
    RemoteConfig remoteConfig,
  ) async {
    final raw = await _repo.getSuperBlock(dashedName);

    bool isActive(Map<String, dynamic> block) =>
        remoteConfig.activationOverride(
          dashedName,
          _meta(block)['dashedName'] as String,
        ) !=
        false;

    if (!chapterBasedSuperBlocks.contains(dashedName)) {
      final blocks = (raw['blocks'] as List).cast<Map<String, dynamic>>()
        ..sort((a, b) => _order(a).compareTo(_order(b)));

      return SuperBlock.blocks([
        for (final block in blocks)
          _toBlock(block, dashedName, isDisabled: !isActive(block)),
      ]);
    }

    // NOTE: Unlike the flat path, disabled blocks are removed here, along with
    // any module or chapter they leave empty.
    return SuperBlock.chapters([
      for (final chapter
          in (raw['chapters'] as List).cast<Map<String, dynamic>>())
        if (_toChapter(chapter, dashedName, isActive) case final chapter
            when chapter.modules.isNotEmpty)
          chapter,
    ]);
  }

  Chapter _toChapter(
    Map<String, dynamic> raw,
    String superBlock,
    bool Function(Map<String, dynamic>) isActive,
  ) {
    final modules = (raw['modules'] as List).cast<Map<String, dynamic>>();

    return Chapter(
      dashedName: raw['dashedName'] as String,
      name: raw['name'] as String,
      comingSoon: raw['comingSoon'] == true,
      modules: [
        for (final module in modules)
          if (_toModule(module, superBlock, isActive) case final module
              when module.blocks.isNotEmpty)
            module,
      ],
    );
  }

  Module _toModule(
    Map<String, dynamic> raw,
    String superBlock,
    bool Function(Map<String, dynamic>) isActive,
  ) {
    final blocks = (raw['blocks'] as List).cast<Map<String, dynamic>>();

    return Module(
      dashedName: raw['dashedName'] as String,
      name: raw['name'] as String? ?? 'No name',
      comingSoon: raw['comingSoon'] == true,
      moduleType: ModuleType.fromValue(raw['moduleType']),
      blocks: [
        for (final block in blocks)
          if (isActive(block)) _toBlock(block, superBlock),
      ],
    );
  }

  Block _toBlock(
    Map<String, dynamic> raw,
    String superBlock, {
    bool isDisabled = false,
  }) {
    final meta = _meta(raw);
    final description = [
      for (final paragraph in raw['intro'] as List? ?? const [])
        if (paragraph is String && paragraph.trim().isNotEmpty) paragraph,
    ];

    return Block(
      superBlock: superBlock,
      dashedName: meta['dashedName'] as String,
      name: meta['name'] as String,
      layout: BlockLayout.fromValue(meta['blockLayout']),
      // NOTE: `blockType` is the older name for `blockLabel`.
      label: BlockLabel.fromValue(meta['blockLabel'] ?? meta['blockType']),
      description: description.isEmpty
          ? const ['Continue to improve your skills']
          : description,
      challenges: [
        for (final challenge in meta['challengeOrder'] as List)
          ChallengeOrder.fromJson(challenge as Map<String, dynamic>),
      ],
      isDisabledByOverride: isDisabled,
    );
  }

  Map<String, dynamic> _meta(Map<String, dynamic> block) =>
      block['meta'] as Map<String, dynamic>;

  int _order(Map<String, dynamic> block) => _meta(block)['order'] as int? ?? 0;

  Future<Challenge> getChallenge(
    String superBlock,
    String block,
    String challengeId,
  ) async => Challenge.fromJson(
    await _repo.getChallenge(superBlock, block, challengeId),
  );

  Future<SceneAssets> getSceneAssets() async =>
      SceneAssets.fromJson(await _repo.getSceneAssets());

  Future<void> submit(
    Challenge challenge, {
    String? solution,
    List<Map<String, dynamic>>? files,
  }) async {
    final submitTypes = await _repo.getSubmitTypes();
    final body = {'id': challenge.id, 'challengeType': challenge.challengeType};

    switch (submitTypes['${challenge.challengeType}']) {
      case 'tests':
        await _repo.postModernChallengeCompleted({
          ...body,
          if (challenge.challengeType == 14 ||
              challenge.block ==
                  'javascript-algorithms-and-data-structures-projects')
            'files': files,
        });
      case 'project.backEnd':
        await _repo.postProjectCompleted({...body, 'solution': solution});
    }
  }
}
