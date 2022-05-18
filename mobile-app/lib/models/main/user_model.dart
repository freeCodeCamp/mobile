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

  final String? emailAuthLinkTTL; // Confirm
  final String? emailVerifyTTL; // Confirm

  final String username;
  final String? about;
  final String name;
  final String picture;
  final String currentChallengeId;
  final String? location;
  final DateTime joinDate;
  final int points; // May be null, confirm
  final bool sound;
  final String theme; // Replace with Themes
  final String githubProfile;
  final String linkedin;
  final String twitter;
  final String website;

  final bool isGithub;
  final bool isLinkedin;
  final bool isTwitter;
  final bool isWebsite;

  final Map<String, int> calendar;
  final completedChallenges;
  final List<Portfolio> portfolio;
  final List<SavedChallenge> savedChallenges;
  final List yearsTopContributor; // Confirm about type, number or string

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

  final List? badges; // Confirm
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
      this.location,
      required this.joinDate,
      required this.points,
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
        location: data['location'],
        joinDate: DateTime.parse(data['joinDate']),
        points: data['points'],
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

class Portfolio {
  final String id;
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

class SavedChallenge {
  final String id;
  final List<SavedChallengeFile> challengeFiles;

  SavedChallenge({
    required this.id,
    required this.challengeFiles,
  });

  factory SavedChallenge.fromJson(Map<String, dynamic> data) {
    return SavedChallenge(
      id: data['id'],
      challengeFiles: data['challengeFiles'],
    );
  }
}

class SavedChallengeFile {
  final String fileKey;
  final Ext ext;
  final String name;
  final List<String>? history;
  final String contents;

  SavedChallengeFile({
    required this.fileKey,
    required this.ext,
    required this.name,
    required this.history,
    required this.contents,
  });
}

// Parse this properly
enum Ext { js, html, css, jsx }
