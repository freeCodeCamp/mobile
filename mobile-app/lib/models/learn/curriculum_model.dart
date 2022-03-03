class SuperBlock {
  final String superblockName;
  final List<Block> blocks;

  SuperBlock({required this.superblockName, required this.blocks});

  static String getSuperBlockNameFromKey(Map<String, dynamic> data) {
    List superBlockNameToList = data.keys.first.split('-');

    superBlockNameToList.removeAt(0);

    String superBlockName = superBlockNameToList.asMap().values.join(' ');

    return superBlockName;
  }

  static String getSuperBlockName(String name) {
    List superBlockNameToList = name.split('-');

    superBlockNameToList.removeAt(0);

    String superBlockName = superBlockNameToList.asMap().values.join(' ');

    return superBlockName;
  }

  static List<Block> getBlocks(Map<String, dynamic> data) {
    List<Block> blocks = [];

    for (int i = 0; i < data.length; i++) {
      blocks.add(Block.fromJson(data[data.keys.elementAt(i)]['challenges']));
    }

    return blocks;
  }

  factory SuperBlock.fromJson(Map<String, dynamic> data) {
    return SuperBlock(
        superblockName: getSuperBlockNameFromKey(data),
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
