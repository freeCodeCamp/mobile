import 'package:freecodecamp/models/learn/challenge_model.dart' show ChallengeFile;

class SavedChallenge {
  final String id;
  final List<ChallengeFile> files;

  SavedChallenge({
    required this.id,
    required this.files,
  });

  factory SavedChallenge.fromJson(Map<String, dynamic> data) {
    return SavedChallenge(
      id: data['id'],
      files: (data['files'] as List)
          .map<ChallengeFile>((file) => ChallengeFile.fromJson(file))
          .toList(),
    );
  }
}
