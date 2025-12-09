import 'package:freecodecamp/enums/theme_type.dart';
import 'package:freecodecamp/models/learn/completed_challenge_model.dart';
import 'package:freecodecamp/models/learn/saved_challenge_model.dart';
import 'package:freecodecamp/models/main/portfolio_model.dart';
import 'package:freecodecamp/models/main/profile_ui_model.dart';

class UserModel {
  final NewsUserModel newsUserModel;
  final ForumUserModel forumUserModel;
  final FccUserModel fccUserModel;

  UserModel(
      {required this.forumUserModel,
      required this.fccUserModel,
      required this.newsUserModel});
}

class NewsUserModel {}

class ForumUserModel {}

class FccUserModel {
  final String id;
  final String email;
  final String username;
  final String name;
  final String picture;
  final String currentChallengeId;

  final String? githubProfile;
  final String? linkedin;
  final String? twitter;
  final String? website;
  final String? location;
  final String? about;

  final bool emailVerified;
  final bool isEmailVerified;
  final bool? sendQuincyEmail;

  final bool isCheater;
  final bool isDonating;

  final bool isHonest;
  final bool isFrontEndCert;
  final bool isDataVisCert;
  final bool isBackEndCert;
  final bool isFullStackCert;
  final bool isRespWebDesignCert;
  final bool is2018DataVisCert;
  final bool isFrontEndLibsCert;
  final bool isJsAlgoDataStructCert;
  final bool isApisMicroservicesCert;
  final bool isInfosecQaCert;
  final bool isQaCertV7;
  final bool isInfosecCertV7;
  final bool? is2018FullStackCert;
  final bool isSciCompPyCertV7;
  final bool isDataAnalysisPyCertV7;
  final bool isMachineLearningPyCertV7;
  final bool isRelationalDatabaseCertV8;
  final bool isCollegeAlgebraPyCertV8;
  final bool isFoundationalCSharpCertV8;

  final bool? isBanned;

  final DateTime joinDate;

  final int points; // May be null, confirm

  final Map<DateTime, int> calendar;
  // Below member is used for heatmap, don't send back to server
  final Map<DateTime, int> heatMapCal;

  // We can add this in later after confirming it
  // final List? badges;
  final List<CompletedChallenge> completedChallenges;
  final List<CompletedDailyChallenge> completedDailyCodingChallenges;
  final List<SavedChallenge> savedChallenges;
  final List<Portfolio> portfolio;
  final List<String> yearsTopContributor; // If number, parsing it to string

  final Themes theme;
  final ProfileUI profileUI;

  FccUserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.name,
    required this.picture,
    required this.currentChallengeId,
    this.githubProfile,
    this.linkedin,
    this.twitter,
    this.website,
    this.location,
    this.about,
    required this.emailVerified,
    required this.isEmailVerified,
    this.sendQuincyEmail,
    required this.isCheater,
    required this.isDonating,
    required this.isHonest,
    required this.isFrontEndCert,
    required this.isDataVisCert,
    required this.isBackEndCert,
    required this.isFullStackCert,
    required this.isRespWebDesignCert,
    required this.is2018DataVisCert,
    required this.isFrontEndLibsCert,
    required this.isJsAlgoDataStructCert,
    required this.isApisMicroservicesCert,
    required this.isInfosecQaCert,
    required this.isQaCertV7,
    required this.isInfosecCertV7,
    this.is2018FullStackCert,
    required this.isSciCompPyCertV7,
    required this.isDataAnalysisPyCertV7,
    required this.isMachineLearningPyCertV7,
    required this.isRelationalDatabaseCertV8,
    required this.isCollegeAlgebraPyCertV8,
    required this.isFoundationalCSharpCertV8,
    this.isBanned,
    required this.joinDate,
    required this.points,
    required this.calendar,
    required this.heatMapCal,
    required this.completedDailyCodingChallenges,
    required this.completedChallenges,
    required this.savedChallenges,
    required this.portfolio,
    required this.yearsTopContributor,
    required this.theme,
    required this.profileUI,
  });

  factory FccUserModel.fromJson(Map<String, dynamic> data) {
    //data['user'][data['result']]
    return FccUserModel(
      id: data['id'],
      email: data['email'],
      username: data['username'],
      name: data['name'] ?? '',
      picture: data['picture'],
      currentChallengeId: data['currentChallengeId'],
      githubProfile: data['githubProfile'],
      linkedin: data['linkedin'],
      twitter: data['twitter'],
      website: data['website'],
      location: data['location'],
      about: data['about'],
      emailVerified: data['emailVerified'],
      isEmailVerified: data['isEmailVerified'],
      sendQuincyEmail: data['sendQuincyEmail'],
      isCheater: data['isCheater'],
      isDonating: data['isDonating'] ?? false,
      isHonest: data['isHonest'],
      isFrontEndCert: data['isFrontEndCert'],
      isDataVisCert: data['isDataVisCert'],
      isBackEndCert: data['isBackEndCert'],
      isFullStackCert: data['isFullStackCert'],
      isRespWebDesignCert: data['isRespWebDesignCert'],
      is2018DataVisCert: data['is2018DataVisCert'],
      isFrontEndLibsCert: data['isFrontEndLibsCert'],
      isJsAlgoDataStructCert: data['isJsAlgoDataStructCert'],
      isApisMicroservicesCert: data['isApisMicroservicesCert'],
      isInfosecQaCert: data['isInfosecQaCert'],
      isQaCertV7: data['isQaCertV7'],
      isInfosecCertV7: data['isInfosecCertV7'],
      is2018FullStackCert: data['is2018FullStackCert'],
      isSciCompPyCertV7: data['isSciCompPyCertV7'],
      isDataAnalysisPyCertV7: data['isDataAnalysisPyCertV7'],
      isMachineLearningPyCertV7: data['isMachineLearningPyCertV7'],
      isRelationalDatabaseCertV8: data['isRelationalDatabaseCertV8'],
      isCollegeAlgebraPyCertV8: data['isCollegeAlgebraPyCertV8'],
      isFoundationalCSharpCertV8: data['isFoundationalCSharpCertV8'],
      isBanned: data['isBanned'],
      joinDate: DateTime.parse(data['joinDate']),
      points: data['points'],
      calendar: parseCalendar(
          Map.castFrom<dynamic, dynamic, String, int>(data['calendar'])),
      heatMapCal: genHeatMapCal(
          Map.castFrom<dynamic, dynamic, String, int>(data['calendar'])),
      completedChallenges: (data['completedChallenges'] as List)
          .map<CompletedChallenge>(
              (challenge) => CompletedChallenge.fromJson(challenge))
          .toList(),
      completedDailyCodingChallenges:
          (data['completedDailyCodingChallenges'] as List)
              .map<CompletedDailyChallenge>(
                  (challenge) => CompletedDailyChallenge.fromJson(challenge))
              .toList(),
      savedChallenges: (data['savedChallenges'] as List)
          .map<SavedChallenge>(
              (challenge) => SavedChallenge.fromJson(challenge))
          .toList(),
      portfolio: (data['portfolio'] as List)
          .map<Portfolio>((portfolio) => Portfolio.fromJson(portfolio))
          .toList(),
      yearsTopContributor: (data['yearsTopContributor'] as List)
          .map<String>((year) => year.toString())
          .toList(),
      theme: parseThemes(data['theme']),
      profileUI: ProfileUI.fromJson(data['profileUI']),
    );
  }

  // IMPORTANT : When the user model, changes this Map has to be changed manually to match it.
  // when the user model changes on Main the same has to be done.

  static Future<Map<String, dynamic>> returnSchemaKeys() async {
    return {
      'id': '5bd30e0f1caf6ac3ddddddb5',
      'email': 'foo@bar.com',
      'emailVerified': true,
      'isBanned': false,
      'isCheater': false,
      'acceptedPrivacyTerms': false,
      'sendQuincyEmail': false,
      'username': 'username',
      'about': 'about',
      'name': 'name',
      'picture': 'picture',
      'currentChallengeId': 'currentChallengeId',
      'location': 'The Cloud',
      'joinDate': '2018-06-10T14:40:07.000Z',
      'points': 100,
      'isHonest': false,
      'isFrontEndCert': false,
      'isDataVisCert': false,
      'isBackEndCert': false,
      'isFullStackCert': false,
      'isRespWebDesignCert': false,
      'is2018DataVisCert': false,
      'isFrontEndLibsCert': false,
      'isJsAlgoDataStructCert': false,
      'isApisMicroservicesCert': false,
      'isInfosecQaCert': false,
      'isQaCertV7': false,
      'isInfosecCertV7': false,
      'is2018FullStackCert': false,
      'isSciCompPyCertV7': false,
      'isDataAnalysisPyCertV7': false,
      'isMachineLearningPyCertV7': false,
      'isRelationalDatabaseCertV8': false,
      'isEmailVerified': false,
      'profileUI': {
        'isLocked': false,
        'showAbout': false,
        'showCerts': false,
        'showDonation': false,
        'showHeatMap': false,
        'showLocation': false,
        'showName': false,
        'showPoints': false,
        'showPortfolio': false,
        'showTimeLine': false
      },
      'isDonating': false,
      'badges': [],
      'progressTimestamps': []
    };
  }
}

Map<DateTime, int> parseCalendar(Map<String, int> calendar) {
  calendar.remove('NaN');
  return calendar.map(
    (key, val) {
      return MapEntry(
        DateTime.fromMillisecondsSinceEpoch(int.parse(key) * 1000),
        val,
      );
    },
  );
}

Map<DateTime, int> genHeatMapCal(Map<String, int> calendar) {
  Map<DateTime, int> parsedCal = parseCalendar(calendar);
  Map<DateTime, int> heatMapCal = {};

  parsedCal.forEach((key, val) {
    DateTime newKey = DateTime(key.year, key.month, key.day);
    if (heatMapCal.containsKey(newKey)) {
      heatMapCal[newKey] = heatMapCal[newKey]! + val;
    } else {
      heatMapCal[newKey] = val;
    }
  });

  return heatMapCal;
}
