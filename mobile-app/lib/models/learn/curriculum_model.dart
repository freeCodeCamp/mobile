import 'package:freecodecamp/ui/views/learn/utils/learn_globals.dart';

enum SuperBlocks {
  respWebDesignV9('responsive-web-design-v9'),
  javascriptV9('javascript-v9'),
  frontEndDevLibsV9('front-end-development-libraries-v9'),
  pythonV9('python-v9'),
  relationalDbV9('relational-databases-v9'),
  backEndDevApisV9('back-end-development-and-apis-v9'),
  respWebDesignNew('2022/responsive-web-design'),
  respWebDesign('responsive-web-design'),
  jsAlgoDataStruct('javascript-algorithms-and-data-structures'),
  jsAlgoDataStructNew('javascript-algorithms-and-data-structures-v8'),
  frontEndDevLibs('front-end-development-libraries'),
  dataVis('data-visualization'),
  relationalDb('relational-database'),
  backEndDevApis('back-end-development-and-apis'),
  qualityAssurance('quality-assurance'),
  sciCompPy('scientific-computing-with-python'),
  dataAnalysisPy('data-analysis-with-python'),
  infoSec('information-security'),
  machineLearningPy('machine-learning-with-python'),
  codingInterviewPrep('coding-interview-prep'),
  theOdinProject('the-odin-project'),
  projectEuler('project-euler'),
  collegeAlgebraPy('college-algebra-with-python'),
  foundationalCSharp('foundational-c-sharp-with-microsoft'),
  fullStackDeveloper('full-stack-developer'),
  a2English('a2-english-for-developers'),
  b1English('b1-english-for-developers'),
  a2Spanish('a2-professional-spanish'),
  a1Spanish('a1-professional-spanish'),
  a2Chinese('a2-professional-chinese'),
  rosettaCode('rosetta-code'),
  pythonForEverybody('python-for-everybody'),
  devPlayground('dev-playground');

  final String value;
  const SuperBlocks(this.value);

  static SuperBlocks fromValue(String value) {
    return SuperBlocks.values.firstWhere(
      (superBlock) => superBlock.value == value,
      orElse: () => throw ArgumentError('Invalid super block value: $value'),
    );
  }
}

class SuperBlock {
  final String dashedName;
  final String name;
  final List<Block>? blocks;
  final List<Chapter>? chapters;

  SuperBlock(
      {required this.dashedName,
      required this.name,
      this.blocks,
      this.chapters});

  factory SuperBlock.fromJson(
    Map<String, dynamic> data,
    String dashedName,
    String name,
  ) {
    if (chapterBasedSuperBlocks.contains(dashedName)) {
      return SuperBlock(
        dashedName: dashedName,
        name: name,
        chapters: (data[data.keys.first]['chapters']).map<Chapter>((chapter) {
          return Chapter(
            name: chapter['name'],
            dashedName: chapter['dashedName'],
            comingSoon: chapter['comingSoon'] ?? false,
            chapterType: chapter['chapterType'] != null
                ? ChapterType.fromValue(chapter['chapterType'])
                : null,
            modules: (chapter['modules']).map<Module>((module) {
              return Module(
                  name: module['name'] ?? 'No name',
                  dashedName: module['dashedName'],
                  comingSoon: module['comingSoon'] ?? false,
                  moduleType: module['moduleType'] != null
                      ? ModuleType.fromValue(module['moduleType'])
                      : null,
                  blocks: (module['blocks']).map<Block>((block) {
                    return Block.fromJson(
                      block['meta'],
                      block['intro'],
                      block['meta']['dashedName'],
                      dashedName,
                      name,
                    );
                  }).toList());
            }).toList(),
          );
        }).toList(),
      );
    }

    return SuperBlock(
      dashedName: dashedName,
      name: name,
      blocks: (data[data.keys.first]['blocks']).map<Block>((block) {
        return Block.fromJson(
          block['meta'],
          block['intro'],
          block['meta']['dashedName'],
          dashedName,
          name,
        );
      }).toList()
        ..sort(
          // `order` is guaranteed for block-based super blocks.
          (Block a, Block b) => a.order!.compareTo(b.order!),
        ),
    );
  }

  static Map<String, dynamic> toMap(SuperBlock superBlock) {
    return {
      'dashedName': superBlock.dashedName,
      'name': superBlock.name,
    };
  }
}

enum BlockLabel {
  lecture('lecture'),
  workshop('workshop'),
  lab('lab'),
  review('review'),
  quiz('quiz'),
  exam('exam'),
  warmup('warm-up'),
  learn('learn'),
  practice('practice'),
  legacy('legacy');

  final String value;
  const BlockLabel(this.value);

  static BlockLabel fromValue(String value) {
    return BlockLabel.values.firstWhere(
      (blockLabel) => blockLabel.value == value,
      orElse: () => BlockLabel.legacy,
    );
  }
}

enum BlockLayout {
  challengeList,
  challengeGrid,
  challengeDialogue,
  challengeLink,
  project,
}

class Block {
  final String name;
  final String dashedName;
  final SuperBlock superBlock;
  final BlockLayout layout;
  final BlockLabel label;
  final List description;
  // Blocks in chapter-based super blocks don't have `order`.
  final int? order;

  final List<ChallengeOrder> challenges;
  final List<ChallengeListTile> challengeTiles;

  Block({
    required this.superBlock,
    required this.layout,
    required this.label,
    required this.name,
    required this.dashedName,
    required this.description,
    required this.challenges,
    required this.challengeTiles,
    this.order,
  });

  factory Block.fromJson(
    Map<String, dynamic> data,
    List description,
    String dashedName,
    String superBlockDashedName,
    String superBlockName,
  ) {
    // set challengeTiles as a custom field as there needs
    // to be a raw version (challenges).

    data['challengeTiles'] = [];

    BlockLayout handleLayout(String? layout) {
      switch (layout) {
        case 'project-list':
        case 'challenge-list':
        case 'legacy-challenge-list':
          return BlockLayout.challengeList;
        case 'dialogue-grid':
          return BlockLayout.challengeDialogue;
        case 'challenge-grid':
        case 'legacy-challenge-grid':
          return BlockLayout.challengeGrid;
        case 'link':
        case 'legacy-link':
          return BlockLayout.challengeLink;
        default:
          return BlockLayout.challengeGrid;
      }
    }

    BlockLabel blockLabelFromString(String type) {
      return BlockLabel.fromValue(type);
    }

    return Block(
      superBlock: SuperBlock(
        dashedName: superBlockDashedName,
        name: superBlockName,
      ),
      layout: handleLayout(data['blockLayout']),
      // Support both blockLabel and blockType for backward compatibility
      label: (data['blockLabel'] ?? data['blockType']) != null
          ? blockLabelFromString(data['blockLabel'] ?? data['blockType'])
          : BlockLabel.legacy,
      name: data['name'],
      dashedName: dashedName,
      description: description,
      order: data['order'],
      challenges: (data['challengeOrder'] as List)
          .map<ChallengeOrder>(
            (dynamic challenge) => ChallengeOrder(
              id: challenge[0] ?? challenge['id'],
              title: challenge[1] ?? challenge['title'],
            ),
          )
          .toList(),
      challengeTiles: (data['challengeOrder'] as List)
          .map<ChallengeListTile>(
            (dynamic challenge) => ChallengeListTile(
              id: challenge[0] ?? challenge['id'],
              name: challenge[1] ?? challenge['title'],
              dashedName: challenge[1] ??
                  challenge['title']
                      .toLowerCase()
                      .replaceAll(' ', '-')
                      .replaceAll(RegExp(r"[@':]"), ''),
            ),
          )
          .toList(),
    );
  }
}

class ChallengeListTile {
  final String id;
  final String name;
  final String dashedName;

  ChallengeListTile({
    required this.id,
    required this.name,
    required this.dashedName,
  });
}

class SuperBlockButtonData {
  final String path;
  final String name;
  final bool public;

  SuperBlockButtonData({
    required this.path,
    required this.name,
    required this.public,
  });
}

class ChallengeOrder {
  final String id;
  final String title;

  ChallengeOrder({
    required this.id,
    required this.title,
  });
}

enum ChapterType {
  exam('exam');

  static ChapterType fromValue(String value) {
    return ChapterType.values.firstWhere(
      (chapterType) => chapterType.value == value,
      orElse: () => throw ArgumentError('Invalid chapter type value: $value'),
    );
  }

  final String value;
  const ChapterType(this.value);
}

class Chapter {
  final String name;
  final String dashedName;
  final bool? comingSoon;
  final ChapterType? chapterType;
  final List<Module>? modules;

  Chapter({
    required this.name,
    required this.dashedName,
    this.comingSoon,
    this.chapterType,
    this.modules,
  });
}

enum ModuleType {
  review('review'),
  exam('exam'),
  certProject('cert-project');

  static ModuleType fromValue(String value) {
    return ModuleType.values.firstWhere(
      (moduleType) => moduleType.value == value,
      orElse: () => throw ArgumentError('Invalid module type value: $value'),
    );
  }

  final String value;
  const ModuleType(this.value);
}

class Module {
  final String name;
  final String dashedName;
  final bool? comingSoon;
  final ModuleType? moduleType;
  final List<Block>? blocks;

  Module({
    required this.name,
    required this.dashedName,
    this.comingSoon,
    this.moduleType,
    this.blocks,
  });
}
