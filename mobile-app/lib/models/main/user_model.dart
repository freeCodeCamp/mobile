class UserModel {
  final NewsUserModel newsUserModel;
  final ForumUserModel forumUserModel;
  final FccUserModel fccUserModel;

  UserModel(this.forumUserModel, this.fccUserModel, this.newsUserModel);
}

class NewsUserModel {}

class ForumUserModel {}

class FccUserModel {
  final String _id;
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

  final ProfileUI profileUI;

  FccUserModel(
      this._id,
      this.email,
      this.emailVerified,
      this.isBanned,
      this.isCheater,
      this.acceptedPrivacyTerms,
      this.sendQuincyEmail,
      this.username,
      this.about,
      this.name,
      this.picture,
      this.currentChallengeId,
      this.isHonest,
      this.isFrontEndCert,
      this.isDataVisCert,
      this.isBackEndCert,
      this.isFullStackCert,
      this.isRespWebDesignCert,
      this.is2018DataVisCert,
      this.isFrontEndLibsCert,
      this.isJsAlgoDataStructCert,
      this.isApisMicroservicesCert,
      this.isInfosecQaCert,
      this.isQaCertV7,
      this.isInfosecCertV7,
      this.is2018FullStackCert,
      this.isSciCompPyCertV7,
      this.isDataAnalysisPyCertV7,
      this.isMachineLearningPyCertV7,
      this.isRelationalDatabaseCertV8,
      this.profileUI,
      this.isDonating,
      this.badges,
      this.emailAuthLinkTTL,
      this.emailVerifyTTL);
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
      this.isLocked,
      this.showAbout,
      this.showCerts,
      this.showDonation,
      this.showHeatMap,
      this.showLocation,
      this.showName,
      this.showPoints,
      this.showPortfolio,
      this.showTimeLine);
}
