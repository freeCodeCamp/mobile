class SuperBlock {
  final String superblockName;
  final List<Block> blocks;

  SuperBlock({required this.superblockName, required this.blocks});

  static String getSuperBlockName(Map<String, dynamic> data) {
    List superblockNameToList = data.keys.first.split('-');

    superblockNameToList.removeAt(0);

    String superblockName = superblockNameToList.asMap().values.join(' ');

    return superblockName;
  }

  static List<Block> getBlocks(Map<String, dynamic> data) {
    List<Block> blocks = [];

    blocks.add(Block.fromJson(data));

    return blocks;
  }

  factory SuperBlock.fromJson(Map<String, dynamic> data) {
    return SuperBlock(
        superblockName: getSuperBlockName(data),
        blocks: getBlocks(data[data.keys.first]['blocks']));
  }
}

class Block {
  final String blockName;
  final String dashedName;
  final String superBlock;

  final List<Challenge> challenges;

  Block(
      {required this.blockName,
      required this.dashedName,
      required this.superBlock,
      required this.challenges});

  static List<Challenge> getChallenges(List challengeOrder) {
    List<Challenge> challenges = [];

    for (int i = 0; i < challengeOrder.length; i++) {
      challenges
          .add(Challenge(id: challengeOrder[i][0], name: challengeOrder[i][1]));
    }

    return challenges;
  }

  factory Block.fromJson(Map<String, dynamic> data) {
    return Block(
        blockName: data['name'],
        dashedName: data['dashedName'],
        superBlock: data['superBlock'],
        challenges: getChallenges(data['challengeOrder']));
  }
}

class Challenge {
  final String id;
  final String name;

  Challenge({required this.id, required this.name});
}
