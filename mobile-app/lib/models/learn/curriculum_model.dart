class SuperBlock {
  final String superblockName;
  final List<Block> blocks;

  SuperBlock({required this.superblockName, required this.blocks});
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
}

class Challenge {
  final String id;
  final String name;

  Challenge({required this.id, required this.name});
}
