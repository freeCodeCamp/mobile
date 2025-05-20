const chapterBasedSuperBlocks = ['full-stack-developer'];

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
            dashedName: chapter['dashedName'],
            comingSoon: chapter['comingSoon'] ?? false,
            chapterType: ChapterType.fromValue(chapter['chapterType']),
            modules: (chapter['modules']).map<Module>((module) {
              return Module(
                  dashedName: module['dashedName'],
                  comingSoon: module['comingSoon'] ?? false,
                  moduleType: ModuleType.fromValue(module['moduleType']),
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

enum BlockType { lecture, workshop, lab, review, quiz, exam, legacy }

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
  final BlockType type;
  final List description;
  // Blocks in chapter-based super blocks don't have `order`.
  final int? order;

  final List<ChallengeOrder> challenges;
  final List<ChallengeListTile> challengeTiles;

  Block({
    required this.superBlock,
    required this.layout,
    required this.type,
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

    return Block(
      superBlock: SuperBlock(
        dashedName: superBlockDashedName,
        name: superBlockName,
      ),
      layout: handleLayout(data['blockLayout']),
      type: BlockType.legacy,
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
  final String dashedName;
  final bool? comingSoon;
  final ChapterType? chapterType;
  final List<Module>? modules;

  Chapter({
    required this.dashedName,
    this.comingSoon,
    this.chapterType,
    this.modules,
  });
}

enum ModuleType {
  review('review'),
  exam('exam');

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
  final String dashedName;
  final bool? comingSoon;
  final ModuleType? moduleType;
  final List<Block>? blocks;

  Module({
    required this.dashedName,
    this.comingSoon,
    this.moduleType,
    this.blocks,
  });
}
