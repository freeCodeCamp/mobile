class SuperBlock {
  final String superblockName;
  final List<Block> blocks;

  SuperBlock({required this.superblockName, required this.blocks});

  static String getSuperBlockNameFromKey(Map<String, dynamic> data) {
    List superBlockNameToList = data.keys.first.split('-');

    // Why is the first word removed??
    superBlockNameToList.removeAt(0);

    String superBlockName = superBlockNameToList.join(' ');

    return superBlockName;
  }

  factory SuperBlock.fromJson(Map<String, dynamic> data) {
    return SuperBlock(
      superblockName: getSuperBlockNameFromKey(data),
      blocks: (data[data.keys.first]['blocks'] as Map)
          .map((key, value) => MapEntry(
                key,
                Block.fromJson(value['challenges'], value['desc'], key),
              ))
          .values
          .toList()
        ..sort((Block a, Block b) => a.order.compareTo(b.order)),
    );
  }
}

class Block {
  final String blockName;
  final String? dashedName;
  final String? superBlock;
  final List description;
  final bool isStepBased;
  final int order;

  final List<ChallengeListTile> challenges;

  Block(
      {required this.blockName,
      required this.description,
      required this.isStepBased,
      this.dashedName = '',
      this.superBlock = '',
      required this.challenges,
      required this.order});

  static bool checkIfStepBased(String superblock) {
    return superblock == '2022/responsive-web-design';
  }

  factory Block.fromJson(
      Map<String, dynamic> data, List description, String key) {
    return Block(
        blockName: data['name'],
        description: description,
        dashedName: data['dashedName'] ?? key,
        superBlock: data['superBlock'],
        order: data['order'],
        challenges: (data['challengeOrder'] as List)
            .map<ChallengeListTile>((dynamic challenge) =>
                ChallengeListTile(id: challenge[0], name: challenge[1]))
            .toList(),
        isStepBased: checkIfStepBased(data['superBlock']));
  }
}

class ChallengeListTile {
  final String id;
  final String name;

  ChallengeListTile({required this.id, required this.name});
}

class SuperBlockButton {
  final String path;
  final String name;
  final bool public;

  SuperBlockButton(
      {required this.path, required this.name, required this.public});
}
