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

class CompletedDailyChallenge {
  final String id;
  final DateTime completedDate;
  final List<String> languages;

  CompletedDailyChallenge({
    required this.id,
    required this.completedDate,
    required this.languages,
  });

  factory CompletedDailyChallenge.fromJson(Map<String, dynamic> data) {
    return CompletedDailyChallenge(
      id: data['id'],
      completedDate: DateTime.fromMillisecondsSinceEpoch(data['completedDate']),
      languages: List<String>.from(data['languages']),
    );
  }
}
