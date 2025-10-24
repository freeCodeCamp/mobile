import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';

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
      id: json['id'],
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
  final DailyChallengeLanguageData javascript;
  final DailyChallengeLanguageData python;

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
    return DailyChallenge(
      id: data['id'],
      challengeNumber: data['challengeNumber'],
      date: DateTime.parse(data['date']),
      title: data['title'],
      description: data['description'],
      javascript:
          DailyChallengeLanguageData.fromJson(data['javascript'], 'javascript'),
      python: DailyChallengeLanguageData.fromJson(data['python'], 'python'),
    );
  }
}

class DailyChallengeLanguageData {
  final List<ChallengeTest> tests;
  final List<ChallengeFile> challengeFiles;

  DailyChallengeLanguageData({
    required this.tests,
    required this.challengeFiles,
  });

  factory DailyChallengeLanguageData.fromJson(
      Map<String, dynamic> data, String language) {
    return DailyChallengeLanguageData(
      tests: (data['tests'] ?? [])
          .map<ChallengeTest>((test) => ChallengeTest.fromJson(test))
          .toList(),
      challengeFiles: (data['challengeFiles'] ?? []).map<ChallengeFile>((file) {
        // Add ext and name based on language
        Map<String, dynamic> fileData = Map<String, dynamic>.from(file);
        if (language == DailyChallengeLanguage.javascript.value) {
          fileData['ext'] = 'js';
          fileData['name'] = 'script';
        } else if (language == DailyChallengeLanguage.python.value) {
          fileData['ext'] = 'py';
          fileData['name'] = 'main';
        }
        return ChallengeFile.fromJson(fileData);
      }).toList(),
    );
  }
}

/// Model representing a block of daily challenges for a specific month
class DailyChallengeBlock {
  final String monthYear; // e.g., "January 2025"
  final List<DailyChallengeOverview> challenges;
  final String description;

  DailyChallengeBlock({
    required this.monthYear,
    required this.challenges,
    required this.description,
  });

  // Daily challenges don't have a block or a super block.
  // Return a `Block` here to allow daily challenges
  // to reuse the code for standard challenges.
  Block toCurriculumBlock() {
    final blockName = 'Daily Challenges $monthYear';
    final blockDashedName =
        'daily-challenges-${monthYear.toLowerCase().replaceAll(' ', '-')}';
    return Block(
      name: blockName,
      dashedName: blockDashedName,
      superBlock: SuperBlock(
        dashedName: 'daily-challenges',
        name: 'Daily Challenges',
      ),
      layout: BlockLayout.challengeGrid,
      label: BlockLabel.legacy,
      description: [description],
      challenges: challenges
          .map((overview) => ChallengeOrder(
                id: overview.id,
                title: overview.title,
              ))
          .toList(),
      challengeTiles: challenges
          .map((overview) => ChallengeListTile(
                id: overview.id,
                name: overview.title,
                dashedName: overview.title.toLowerCase().replaceAll(' ', '-'),
              ))
          .toList(),
    );
  }
}

enum DailyChallengeLanguage {
  javascript('javascript'),
  python('python');

  final String value;
  const DailyChallengeLanguage(this.value);

  @override
  String toString() => value;

  static DailyChallengeLanguage fromString(String value) {
    return DailyChallengeLanguage.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid language: $value'),
    );
  }
}
