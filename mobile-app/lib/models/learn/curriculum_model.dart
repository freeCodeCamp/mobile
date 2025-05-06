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
        chapters: (data[data.keys.first]['chapters']).map((key, value) {
          return Chapter(
            dashedName: key,
            comingSoon: value['comingSoon'] ?? false,
            chapterType: value['chapterType'],
            modules: (value['modules']).map((key, value) {
              return Module(
                  dashedName: key,
                  comingSoon: value['comingSoon'] ?? false,
                  moduleType: value['moduleType'],
                  blocks: (value['blocks']).map((key, value) {
                    return Block.fromJson(
                      value['meta'],
                      value['intro'],
                      value['meta']['dashedName'],
                      dashedName,
                      name,
                    );
                  }).toList());
            }).toList(),
          );
        }).toList(),
      );
    }

    // final parsedBlocks = (data[data.keys.first]['blocks']).map((block) {
    //   return Block.fromJson(
    //     block['meta'],
    //     block['intro'],
    //     block['meta']['dashedName'],
    //     dashedName,
    //     name,
    //   );
    // }).toList()
    //   ..sort(
    //     (Block a, Block b) => (a.order == null && b.order == null)
    //         ? 0
    //         : a.order!.compareTo(b.order!),
    //   );

    // print('--- parsed blocks: $parsedBlocks');

    return SuperBlock(
      dashedName: dashedName,
      name: name,
      blocks: (data[data.keys.first]['blocks']).map((block) {
        return Block.fromJson(
          block['meta'],
          block['intro'],
          block['meta']['dashedName'],
          dashedName,
          name,
        );
      }).toList()
        ..sort(
          // `order` is always available in block-based super blocks.
          // The null check is only to adhere to the null safety standard.
          (Block a, Block b) => (a.order == null && b.order == null)
              ? 0
              : a.order!.compareTo(b.order!),
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

class Block {
  final String name;
  final String dashedName;
  final SuperBlock superBlock;
  final List description;
  final bool isStepBased;
  // Blocks in chapter-based super blocks don't have `order`.
  final int? order;

  final List<ChallengeOrder> challenges;
  final List<ChallengeListTile> challengeTiles;

  Block({
    required this.superBlock,
    required this.name,
    required this.dashedName,
    required this.description,
    required this.isStepBased,
    required this.order,
    required this.challenges,
    required this.challengeTiles,
  });

  static bool checkIfStepBased(String superblock) {
    List<String> stepbased = [
      '2022/responsive-web-design',
      'a2-english-for-developers',
      'b1-english-for-developers'
    ];

    return stepbased.contains(superblock);
  }

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

    return Block(
      superBlock: SuperBlock(
        dashedName: superBlockDashedName,
        name: superBlockName,
      ),
      name: data['name'],
      dashedName: dashedName,
      description: description,
      order: data['order'],
      isStepBased: checkIfStepBased(
        superBlockDashedName,
      ),
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

  static Map<String, dynamic> toCachedObject(Block block) {
    return {
      'superBlock': {
        'dashedName': block.superBlock.dashedName,
        'name': block.superBlock.name,
      },
      'name': block.name,
      'dashedName': block.dashedName,
      'description': block.description,
      'order': block.order,
      'isStepBased': block.isStepBased,
      'challengeOrder': block.challenges,
      'challengeTiles': block.challenges,
    };
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

class Chapter {
  final String dashedName;
  final bool? comingSoon;
  final String? chapterType;
  final List<Module>? modules;

  Chapter({
    required this.dashedName,
    this.comingSoon,
    this.chapterType,
    this.modules,
  });
}

class Module {
  final String dashedName;
  final bool? comingSoon;
  final String? moduleType;
  final List<Block>? blocks;

  Module({
    required this.dashedName,
    this.comingSoon,
    this.moduleType,
    this.blocks,
  });
}
