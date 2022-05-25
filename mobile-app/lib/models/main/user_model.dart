import 'dart:developer';

import 'package:flutter/foundation.dart';

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

// TODO: Order the properties either by some logic or alphabetically.
class FccUserModel {
  final String id;
  final String email;

  final bool emailVerified;
  final bool? isBanned;
  final bool isCheater;
  final bool acceptedPrivacyTerms;
  final bool sendQuincyEmail;
  final bool isDonating;

  // I'm guessing below two properties are present if user uses "Email a code" for log in
  final String? emailAuthLinkTTL;
  final String? emailVerifyTTL;

  final String username;
  final String? about;
  final String name;
  final String picture;
  final String currentChallengeId;
  final String? location;
  final DateTime joinDate;
  final Streak streak;
  final int points; // May be null, confirm
  final bool sound;
  final Themes theme;
  final String githubProfile;
  final String linkedin;
  final String twitter;
  final String website;

  final bool isGithub;
  final bool isLinkedIn;
  final bool isTwitter;
  final bool isWebsite;

  final Map<DateTime, int> calendar;
  // Below member is used for heatmap, don't send back to server
  final Map<DateTime, int> heatMapCal;
  final List<CompletedChallenge> completedChallenges;
  final List<Portfolio> portfolio;
  final List<SavedChallenge> savedChallenges;
  final List<String> yearsTopContributor; // If number, parsing it to string

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
  final bool isEmailVerified;

  // We can add this in later after confirming it
  // final List? badges;
  final List<int>? progressTimestamps;

  final ProfileUI profileUI;

  FccUserModel({
    required this.id,
    required this.email,
    required this.emailVerified,
    this.isBanned,
    required this.isCheater,
    required this.acceptedPrivacyTerms,
    required this.sendQuincyEmail,
    required this.username,
    required this.about,
    required this.name,
    required this.picture,
    required this.currentChallengeId,
    this.location,
    required this.joinDate,
    required this.streak,
    required this.points,
    required this.sound,
    required this.theme,
    required this.githubProfile,
    required this.linkedin,
    required this.twitter,
    required this.website,
    required this.isGithub,
    required this.isLinkedIn,
    required this.isTwitter,
    required this.isWebsite,
    required this.calendar,
    required this.heatMapCal,
    required this.completedChallenges,
    required this.portfolio,
    required this.savedChallenges,
    required this.yearsTopContributor,
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
    required this.isEmailVerified,
    required this.profileUI,
    required this.isDonating,
    this.progressTimestamps,
    this.emailAuthLinkTTL,
    this.emailVerifyTTL,
  });

  factory FccUserModel.fromJson(Map<String, dynamic> data) {
    //data['user'][data['result']]
    return FccUserModel(
      id: data['id'],
      email: data['email'],
      emailVerified: data['emailVerified'],
      isCheater: data['isCheater'],
      acceptedPrivacyTerms: data['acceptedPrivacyTerms'],
      sendQuincyEmail: data['sendQuincyEmail'],
      username: data['username'],
      about: data['about'],
      name: data['name'],
      picture: data['picture'],
      currentChallengeId: data['currentChallengeId'],
      location: data['location'],
      joinDate: DateTime.parse(data['joinDate']),
      streak: Streak.fromJson(data['streak']),
      points: data['points'],
      sound: data['sound'],
      theme: parseThemes(data['theme']),
      githubProfile: data['githubProfile'],
      linkedin: data['linkedin'],
      twitter: data['twitter'],
      website: data['website'],
      isGithub: data['isGithub'],
      isLinkedIn: data['isLinkedIn'],
      isTwitter: data['isTwitter'],
      isWebsite: data['isWebsite'],
      calendar: parseCalendar(
          Map.castFrom<dynamic, dynamic, String, int>(data['calendar'])),
      heatMapCal: genHeatMapCal(
          Map.castFrom<dynamic, dynamic, String, int>(data['calendar'])),
      completedChallenges: (data['completedChallenges'] as List)
          .map<CompletedChallenge>(
              (challenge) => CompletedChallenge.fromJson(challenge))
          .toList(),
      portfolio: (data['portfolio'] as List)
          .map<Portfolio>((portfolio) => Portfolio.fromJson(portfolio))
          .toList(),
      savedChallenges: (data['savedChallenges'] as List)
          .map<SavedChallenge>(
              (challenge) => SavedChallenge.fromJson(challenge))
          .toList(),
      yearsTopContributor: (data['yearsTopContributor'] as List)
          .map<String>((year) => year.toString())
          .toList(),
      isHonest: data['isHonest'],
      isFrontEndCert: data['isFrontEndCert'],
      isDataVisCert: data['isDataVisCert'],
      isBackEndCert: data['isBackEndCert'],
      isFullStackCert: data['isFullStackCert'],
      isRespWebDesignCert: data['isFullStackCert'],
      is2018DataVisCert: data['is2018DataVisCert'],
      isFrontEndLibsCert: data['isFrontEndLibsCert'],
      isJsAlgoDataStructCert: data['isJsAlgoDataStructCert'],
      isApisMicroservicesCert: data['isApisMicroservicesCert'],
      isInfosecQaCert: data['isInfosecQaCert'],
      isQaCertV7: data['isQaCertV7'],
      isInfosecCertV7: data['isInfosecCertV7'],
      isSciCompPyCertV7: data['isSciCompPyCertV7'],
      isDataAnalysisPyCertV7: data['isDataAnalysisPyCertV7'],
      isMachineLearningPyCertV7: data['isMachineLearningPyCertV7'],
      isRelationalDatabaseCertV8: data['isRelationalDatabaseCertV8'],
      isEmailVerified: data['isEmailVerified'],
      progressTimestamps: data['progressTimestamps'],
      profileUI: ProfileUI.fromJson(data['profileUI']),
      isDonating: data['isDonating'] ?? false,
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

class ProfileUI {
  final bool isLocked;
  final bool showAbout;
  final bool showCerts;
  final bool showDonation;
  final bool showHeatMap;
  final bool showLocation;
  final bool showName;
  final bool showPoints;
  final bool showPortfolio;
  final bool showTimeLine;

  ProfileUI(
      {required this.isLocked,
      required this.showAbout,
      required this.showCerts,
      required this.showDonation,
      required this.showHeatMap,
      required this.showLocation,
      required this.showName,
      required this.showPoints,
      required this.showPortfolio,
      required this.showTimeLine});

  factory ProfileUI.fromJson(Map<String, dynamic> data) {
    return ProfileUI(
        isLocked: data['isLocked'],
        showAbout: data['showAbout'],
        showCerts: data['showCerts'],
        showDonation: data['showDonation'],
        showHeatMap: data['showHeatMap'],
        showLocation: data['showLocation'],
        showName: data['showName'],
        showPoints: data['showPoints'],
        showPortfolio: data['showPortfolio'],
        showTimeLine: data['showTimeLine']);
  }
}

class Streak {
  final int longest;
  final int current;

  Streak({required this.longest, required this.current});

  factory Streak.fromJson(Map<String, dynamic> data) {
    return Streak(longest: data['longest'] ?? 0, current: data['current'] ?? 0);
  }
}

class Portfolio {
  final String id;
  // Below properties may be empty string instead of null, CONFIRM
  final String? title;
  final String? url;
  final String? image;
  final String? description;

  Portfolio({
    required this.id,
    this.title,
    this.url,
    this.image,
    this.description,
  });

  factory Portfolio.fromJson(Map<String, dynamic> data) {
    return Portfolio(
        id: data['id'],
        title: data['title'],
        url: data['url'],
        image: data['image'],
        description: data['description']);
  }
}

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

class ChallengeFile {
  final String key;
  final Ext ext;
  final String name;
  final String contents;

  ChallengeFile({
    required this.key,
    required this.ext,
    required this.name,
    required this.contents,
  });

  factory ChallengeFile.fromJson(Map<String, dynamic> data) {
    return ChallengeFile(
      key: data['key'],
      ext: parseExt(data['ext']),
      name: data['name'],
      contents: data['contents'],
    );
  }
}

class SavedChallenge {
  final String id;
  final List<SavedChallengeFile> files;

  SavedChallenge({
    required this.id,
    required this.files,
  });

  factory SavedChallenge.fromJson(Map<String, dynamic> data) {
    return SavedChallenge(
      id: data['id'],
      files: (data['files'] as List)
          .map<SavedChallengeFile>((file) => SavedChallengeFile.fromJson(file))
          .toList(),
    );
  }
}

class SavedChallengeFile {
  final String key;
  final Ext ext;
  final String name;
  final List<String> history;
  final String contents;

  SavedChallengeFile({
    required this.key,
    required this.ext,
    required this.name,
    required this.history,
    required this.contents,
  });

  factory SavedChallengeFile.fromJson(Map<String, dynamic> data) {
    return SavedChallengeFile(
      key: data['key'],
      ext: parseExt(data['ext']),
      name: data['name'],
      history: data['history'].cast<String>(),
      contents: data['contents'],
    );
  }
}

enum Ext { js, html, css, jsx }

parseExt(String ext) {
  switch (ext) {
    case 'js':
      return Ext.js;
    case 'html':
      return Ext.html;
    case 'css':
      return Ext.css;
    case 'jsx':
      return Ext.jsx;
    default:
      return 'html';
  }
}

extension ExtValue on Ext {
  String get value => describeEnum(this);
}

// default can't be used as a value for an enum so suffixing with Theme
enum Themes { nightTheme, defaultTheme }

parseThemes(String theme) {
  switch (theme) {
    case 'night':
      return Themes.nightTheme;
    case 'default':
      return Themes.defaultTheme;
    default:
      return Themes.defaultTheme;
  }
}

extension ThemesValue on Themes {
  String get value => describeEnum(this).replaceFirst('Theme', '');
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
