class SuperBlock {
  final String superblockName;
  final List<Block> blocks;

  SuperBlock({required this.superblockName, required this.blocks});

  factory SuperBlock.fromJson(
    Map<String, dynamic> data,
    String superblockName,
  ) {
    return SuperBlock(
      superblockName: superblockName,
      blocks: (data[data.keys.first]['blocks'] as Map)
          .map(
            (key, value) => MapEntry(
              key,
              Block.fromJson(
                value['challenges'],
                value['desc'],
                key,
              ),
            ),
          )
          .values
          .toList()
        ..sort(
          (Block a, Block b) => a.order.compareTo(b.order),
        ),
    );
  }
}

class Block {
  final String name;
  final String dashedName;
  final String superBlock;
  final List description;
  final bool isStepBased;
  final int order;

  final List<ChallengeListTile> challenges;

  Block({
    required this.superBlock,
    required this.name,
    required this.dashedName,
    required this.description,
    required this.isStepBased,
    required this.order,
    required this.challenges,
  });

  static bool checkIfStepBased(String superblock) {
    return superblock == '2022/responsive-web-design';
  }

  factory Block.fromJson(
    Map<String, dynamic> data,
    List description,
    String key,
  ) {
    return Block(
      superBlock: data['superBlock'],
      name: data['name'],
      dashedName: key,
      description: description,
      order: data['order'],
      isStepBased: checkIfStepBased(
        data['superBlock'],
      ),
      challenges: (data['challengeOrder'] as List)
          .map<ChallengeListTile>(
            (dynamic challenge) => ChallengeListTile(
              id: challenge[0],
              name: challenge[1],
              dashedName: challenge[1]
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
      'superBlock': block.superBlock,
      'name': block.name,
      'dashedName': block.dashedName,
      'description': block.description,
      'order': block.order,
      'isStepBased': block.isStepBased,
      'challenges': block.challenges,
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

class SuperBlockButton {
  final String path;
  final String name;
  final bool public;

  SuperBlockButton({
    required this.path,
    required this.name,
    required this.public,
  });
}
