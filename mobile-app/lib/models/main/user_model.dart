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
  final bool? isBanned;
  final bool isCheater;
  final bool acceptedPrivacyTerms;
  final bool sendQuincyEmail;
  final bool isDonating;

  final String? emailAuthLinkTTL;
  final String? emailVerifyTTL;

  final String username;
  final String? about;
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
  final bool? is2018FullStackCert;
  final bool isSciCompPyCertV7;
  final bool isDataAnalysisPyCertV7;
  final bool isMachineLearningPyCertV7;
  final bool isRelationalDatabaseCertV8;

  final List? badges;
  final List<int>? progressTimestamps;

  final ProfileUI profileUI;

  FccUserModel(
      {required this.id,
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
      required this.profileUI,
      required this.isDonating,
      this.badges,
      this.progressTimestamps,
      this.emailAuthLinkTTL,
      this.emailVerifyTTL});

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
        profileUI: ProfileUI.fromJson(data['profileUI']),
        isDonating: data['isDonating']);
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
