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
}
