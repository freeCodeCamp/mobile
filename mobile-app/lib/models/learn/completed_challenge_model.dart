import 'package:freecodecamp/models/learn/challenge_model.dart';

class CompletedChallenge {
  final String id;
  final String? solution;
  final String? githubLink;
  final int? challengeType;
  final DateTime completedDate;
  final List<ChallengeFile> files;

  CompletedChallenge({
    required this.id,
    this.solution,
    this.githubLink,
    this.challengeType,
    required this.completedDate,
    required this.files,
  });

  factory CompletedChallenge.fromJson(Map<String, dynamic> data) {
    return CompletedChallenge(
      id: data['id'],
      solution: data['solution'],
      githubLink: data['githubLink'],
      challengeType: data['challengeType'],
      completedDate: DateTime.fromMillisecondsSinceEpoch(data['completedDate']),
      files: (data['files'] as List)
          .map<ChallengeFile>((file) => ChallengeFile.fromJson(file))
          .toList(),
    );
  }
}
