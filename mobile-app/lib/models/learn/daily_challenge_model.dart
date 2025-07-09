import 'package:freecodecamp/models/learn/challenge_model.dart';

class DailyChallengeOverview {
  final String id;
  final int challengeNumber;
  final DateTime date;
  final String title;

  DailyChallengeOverview({
    required this.id,
    required this.challengeNumber,
    required this.date,
    required this.title,
  });

  factory DailyChallengeOverview.fromJson(Map<String, dynamic> json) {
    return DailyChallengeOverview(
      id: json['_id'],
      challengeNumber: json['challengeNumber'],
      date: DateTime.parse(json['date']),
      title: json['title'],
    );
  }
}

class DailyChallenge {
  final String id;
  final int challengeNumber; // 1-based index
  final DateTime date;
  final String title;
  final String description;
  final DailyChallengeLang javascript;
  final DailyChallengeLang python;

  DailyChallenge({
    required this.id,
    required this.challengeNumber,
    required this.date,
    required this.title,
    required this.description,
    required this.javascript,
    required this.python,
  });

  factory DailyChallenge.fromJson(Map<String, dynamic> data) {
    print(data);
    return DailyChallenge(
      id: data['_id'],
      challengeNumber: data['challengeNumber'],
      date: DateTime.parse(data['date']),
      title: data['title'],
      description: data['description'],
      javascript: DailyChallengeLang.fromJson(data['javascript'], 'javascript'),
      python: DailyChallengeLang.fromJson(data['python'], 'python'),
    );
  }
}

class DailyChallengeLang {
  final List<ChallengeTest> tests;
  final List<ChallengeFile> challengeFiles;

  DailyChallengeLang({
    required this.tests,
    required this.challengeFiles,
  });

  factory DailyChallengeLang.fromJson(
      Map<String, dynamic> data, String language) {
    return DailyChallengeLang(
      tests: (data['tests'] ?? [])
          .map<ChallengeTest>((test) => ChallengeTest.fromJson(test))
          .toList(),
      challengeFiles: (data['challengeFiles'] ?? []).map<ChallengeFile>((file) {
        // Add ext and name based on language
        Map<String, dynamic> fileData = Map<String, dynamic>.from(file);
        if (language == 'javascript') {
          fileData['ext'] = 'js';
          fileData['name'] = 'script';
        } else if (language == 'python') {
          fileData['ext'] = 'py';
          fileData['name'] = 'main';
        }
        return ChallengeFile.fromJson(fileData);
      }).toList(),
    );
  }
}
