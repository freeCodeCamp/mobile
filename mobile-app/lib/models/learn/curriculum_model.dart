class SuperBlock {
  final String dashedName;
  final String name;
  final List<Block>? blocks;

  SuperBlock({
    required this.dashedName,
    required this.name,
    this.blocks,
  });

  factory SuperBlock.fromJson(
    Map<String, dynamic> data,
    String dashedName,
    String name,
  ) {
    return SuperBlock(
      dashedName: dashedName,
      name: name,
      blocks: (data[data.keys.first]['blocks'] as Map)
          .map((key, value) {
            return MapEntry(
              key,
              Block.fromJson(
                value['challenges'],
                value['desc'],
                key,
                dashedName,
                name,
              ),
            );
          })
          .values
          .toList()
        ..sort(
          (Block a, Block b) => a.order.compareTo(b.order),
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
  final int order;

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
    List<String> stepBasedSuperBlocks = [
      '2022/responsive-web-design',
      'javascript-algorithms-and-data-structures-v8'
    ];

    return stepBasedSuperBlocks.contains(superblock);
  }

  factory Block.fromJson(
    Map<String, dynamic> data,
    List description,
    String key,
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
      dashedName: key,
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
