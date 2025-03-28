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

enum BlockType { lecture, workshop, lab, review, quiz, exam, legacy }

enum BlockLayout {
  challengeList,
  challengeGrid,
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
  final int order;

  final List<ChallengeOrder> challenges;
  final List<ChallengeListTile> challengeTiles;

  Block({
    required this.superBlock,
    required this.layout,
    required this.type,
    required this.name,
    required this.dashedName,
    required this.description,
    required this.order,
    required this.challenges,
    required this.challengeTiles,
  });

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

    BlockLayout handleLayout(String? layout) {
      switch (layout) {
        case 'project-list':
        case 'challenge-list':
        case 'legacy-challenge-list':
          return BlockLayout.challengeList;
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
      dashedName: key,
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
