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

  final bool emailVerified;
  final bool isBanned;
  final bool isCheater;
  final bool acceptedPrivacyTerms;
  final bool sendQuincyEmail;
  final bool isDonating;

  final String? emailAuthLinkTTL;
  final String? emailVerifyTTL;

  final String username;
  final String about;
  final String name;
  final String picture;
  final String currentChallengeId;

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
  final bool is2018FullStackCert;
  final bool isSciCompPyCertV7;
  final bool isDataAnalysisPyCertV7;
  final bool isMachineLearningPyCertV7;
  final bool isRelationalDatabaseCertV8;

  final List badges;
  final List<int> progressTimestamps;

  final ProfileUI profileUI;

  FccUserModel(
      {required this.id,
      required this.email,
      required this.emailVerified,
      required this.isBanned,
      required this.isCheater,
      required this.acceptedPrivacyTerms,
      required this.sendQuincyEmail,
      required this.username,
      required this.about,
      required this.name,
      required this.picture,
      required this.currentChallengeId,
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
      required this.is2018FullStackCert,
      required this.isSciCompPyCertV7,
      required this.isDataAnalysisPyCertV7,
      required this.isMachineLearningPyCertV7,
      required this.isRelationalDatabaseCertV8,
      required this.profileUI,
      required this.isDonating,
      required this.badges,
      required this.progressTimestamps,
      this.emailAuthLinkTTL,
      this.emailVerifyTTL});

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
}
