class SceneAssets {
  final String domain;
  final String backgrounds;
  final String sounds;
  final List<String> availableBackgrounds;
  final List<String> availableAudios;
  final Map<String, CharacterAssets> characterAssets;

  SceneAssets({
    required this.domain,
    required this.backgrounds,
    required this.sounds,
    required this.availableBackgrounds,
    required this.availableAudios,
    required this.characterAssets,
  });

  factory SceneAssets.fromJson(Map<String, dynamic> json) {
    final characterAssetsMap = <String, CharacterAssets>{};
    final rawCharacterAssets = json['characterAssets'] as Map<String, dynamic>;

    for (final entry in rawCharacterAssets.entries) {
      characterAssetsMap[entry.key] = CharacterAssets.fromJson(entry.value);
    }

    return SceneAssets(
      domain: json['domain'],
      backgrounds: json['backgrounds'],
      sounds: json['sounds'],
      availableBackgrounds: List<String>.from(json['availableBackgrounds']),
      availableAudios: List<String>.from(json['availableAudios']),
      characterAssets: characterAssetsMap,
    );
  }
}

class CharacterAssets {
  final String base;
  final String brows;
  final String eyesClosed;
  final String eyesOpen;
  final String? glasses;
  final String mouthClosed;
  final String mouthOpen;

  CharacterAssets({
    required this.base,
    required this.brows,
    required this.eyesClosed,
    required this.eyesOpen,
    this.glasses,
    required this.mouthClosed,
    required this.mouthOpen,
  });

  factory CharacterAssets.fromJson(Map<String, dynamic> json) {
    return CharacterAssets(
      base: json['base'],
      brows: json['brows'],
      eyesClosed: json['eyesClosed'],
      eyesOpen: json['eyesOpen'],
      glasses: json['glasses'],
      mouthClosed: json['mouthClosed'],
      mouthOpen: json['mouthOpen'],
    );
  }
}
