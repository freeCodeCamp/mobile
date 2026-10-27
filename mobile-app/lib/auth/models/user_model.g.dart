// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Portfolio _$PortfolioFromJson(Map<String, dynamic> json) => _Portfolio(
  id: json['id'] as String,
  title: json['title'] as String?,
  url: json['url'] as String?,
  image: json['image'] as String?,
  description: json['description'] as String?,
);

Map<String, dynamic> _$PortfolioToJson(_Portfolio instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'url': instance.url,
      'image': instance.image,
      'description': instance.description,
    };

_Experience _$ExperienceFromJson(Map<String, dynamic> json) => _Experience(
  id: json['id'] as String,
  title: json['title'] as String,
  company: json['company'] as String,
  startDate: json['startDate'] as String,
  description: json['description'] as String,
  location: json['location'] as String? ?? '',
  endDate: json['endDate'] as String? ?? '',
);

Map<String, dynamic> _$ExperienceToJson(_Experience instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'company': instance.company,
      'startDate': instance.startDate,
      'description': instance.description,
      'location': instance.location,
      'endDate': instance.endDate,
    };

_ProfileUI _$ProfileUIFromJson(Map<String, dynamic> json) => _ProfileUI(
  isLocked: json['isLocked'] as bool? ?? true,
  showAbout: json['showAbout'] as bool? ?? false,
  showCerts: json['showCerts'] as bool? ?? false,
  showDonation: json['showDonation'] as bool? ?? false,
  showHeatMap: json['showHeatMap'] as bool? ?? false,
  showLocation: json['showLocation'] as bool? ?? false,
  showName: json['showName'] as bool? ?? false,
  showPoints: json['showPoints'] as bool? ?? false,
  showPortfolio: json['showPortfolio'] as bool? ?? false,
  showExperience: json['showExperience'] as bool? ?? false,
  showTimeLine: json['showTimeLine'] as bool? ?? false,
);

Map<String, dynamic> _$ProfileUIToJson(_ProfileUI instance) =>
    <String, dynamic>{
      'isLocked': instance.isLocked,
      'showAbout': instance.showAbout,
      'showCerts': instance.showCerts,
      'showDonation': instance.showDonation,
      'showHeatMap': instance.showHeatMap,
      'showLocation': instance.showLocation,
      'showName': instance.showName,
      'showPoints': instance.showPoints,
      'showPortfolio': instance.showPortfolio,
      'showExperience': instance.showExperience,
      'showTimeLine': instance.showTimeLine,
    };

_CompletedChallenge _$CompletedChallengeFromJson(Map<String, dynamic> json) =>
    _CompletedChallenge(
      id: json['id'] as String,
      solution: json['solution'] as String?,
      githubLink: json['githubLink'] as String?,
      challengeType: (json['challengeType'] as num?)?.toInt(),
      completedDate: _fromEpochMs((json['completedDate'] as num).toInt()),
      files:
          (json['files'] as List<dynamic>?)
              ?.map((e) => ChallengeFile.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CompletedChallengeToJson(_CompletedChallenge instance) =>
    <String, dynamic>{
      'id': instance.id,
      'solution': instance.solution,
      'githubLink': instance.githubLink,
      'challengeType': instance.challengeType,
      'completedDate': _toEpochMs(instance.completedDate),
      'files': instance.files,
    };

_CompletedDailyChallenge _$CompletedDailyChallengeFromJson(
  Map<String, dynamic> json,
) => _CompletedDailyChallenge(
  id: json['id'] as String,
  completedDate: _fromEpochMs((json['completedDate'] as num).toInt()),
  languages:
      (json['languages'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$CompletedDailyChallengeToJson(
  _CompletedDailyChallenge instance,
) => <String, dynamic>{
  'id': instance.id,
  'completedDate': _toEpochMs(instance.completedDate),
  'languages': instance.languages,
};

_SavedChallenge _$SavedChallengeFromJson(Map<String, dynamic> json) =>
    _SavedChallenge(
      id: json['id'] as String,
      files:
          (json['files'] as List<dynamic>?)
              ?.map((e) => ChallengeFile.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SavedChallengeToJson(_SavedChallenge instance) =>
    <String, dynamic>{'id': instance.id, 'files': instance.files};

_FccUserModel _$FccUserModelFromJson(
  Map<String, dynamic> json,
) => _FccUserModel(
  id: json['id'] as String,
  email: json['email'] as String,
  username: json['username'] as String,
  name: json['name'] as String? ?? '',
  picture: json['picture'] as String? ?? '',
  currentChallengeId: json['currentChallengeId'] as String?,
  githubProfile: json['githubProfile'] as String?,
  linkedin: json['linkedin'] as String?,
  twitter: json['twitter'] as String?,
  bluesky: json['bluesky'] as String?,
  website: json['website'] as String?,
  location: json['location'] as String?,
  about: json['about'] as String?,
  emailVerified: json['emailVerified'] as bool? ?? false,
  isEmailVerified: json['isEmailVerified'] as bool? ?? false,
  isCheater: json['isCheater'] as bool? ?? false,
  isDonating: json['isDonating'] as bool? ?? false,
  isHonest: json['isHonest'] as bool? ?? false,
  isBanned: json['isBanned'] as bool? ?? false,
  isFrontEndCert: json['isFrontEndCert'] as bool? ?? false,
  isDataVisCert: json['isDataVisCert'] as bool? ?? false,
  isBackEndCert: json['isBackEndCert'] as bool? ?? false,
  isFullStackCert: json['isFullStackCert'] as bool? ?? false,
  isRespWebDesignCert: json['isRespWebDesignCert'] as bool? ?? false,
  is2018DataVisCert: json['is2018DataVisCert'] as bool? ?? false,
  isFrontEndLibsCert: json['isFrontEndLibsCert'] as bool? ?? false,
  isJsAlgoDataStructCert: json['isJsAlgoDataStructCert'] as bool? ?? false,
  isApisMicroservicesCert: json['isApisMicroservicesCert'] as bool? ?? false,
  isInfosecQaCert: json['isInfosecQaCert'] as bool? ?? false,
  isQaCertV7: json['isQaCertV7'] as bool? ?? false,
  isInfosecCertV7: json['isInfosecCertV7'] as bool? ?? false,
  is2018FullStackCert: json['is2018FullStackCert'] as bool? ?? false,
  isSciCompPyCertV7: json['isSciCompPyCertV7'] as bool? ?? false,
  isDataAnalysisPyCertV7: json['isDataAnalysisPyCertV7'] as bool? ?? false,
  isMachineLearningPyCertV7:
      json['isMachineLearningPyCertV7'] as bool? ?? false,
  isRelationalDatabaseCertV8:
      json['isRelationalDatabaseCertV8'] as bool? ?? false,
  isCollegeAlgebraPyCertV8: json['isCollegeAlgebraPyCertV8'] as bool? ?? false,
  isFoundationalCSharpCertV8:
      json['isFoundationalCSharpCertV8'] as bool? ?? false,
  joinDate: DateTime.parse(json['joinDate'] as String),
  points: (json['points'] as num?)?.toInt() ?? 0,
  calendar:
      (json['calendar'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ) ??
      const {},
  completedChallenges:
      (json['completedChallenges'] as List<dynamic>?)
          ?.map((e) => CompletedChallenge.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  completedDailyCodingChallenges:
      (json['completedDailyCodingChallenges'] as List<dynamic>?)
          ?.map(
            (e) => CompletedDailyChallenge.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  savedChallenges:
      (json['savedChallenges'] as List<dynamic>?)
          ?.map((e) => SavedChallenge.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  portfolio:
      (json['portfolio'] as List<dynamic>?)
          ?.map((e) => Portfolio.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  experience:
      (json['experience'] as List<dynamic>?)
          ?.map((e) => Experience.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  profileUI: json['profileUI'] == null
      ? const ProfileUI()
      : ProfileUI.fromJson(json['profileUI'] as Map<String, dynamic>),
  yearsTopContributor: json['yearsTopContributor'] == null
      ? const []
      : _yearsToStrings(json['yearsTopContributor'] as List),
);

Map<String, dynamic> _$FccUserModelToJson(_FccUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'name': instance.name,
      'picture': instance.picture,
      'currentChallengeId': instance.currentChallengeId,
      'githubProfile': instance.githubProfile,
      'linkedin': instance.linkedin,
      'twitter': instance.twitter,
      'bluesky': instance.bluesky,
      'website': instance.website,
      'location': instance.location,
      'about': instance.about,
      'emailVerified': instance.emailVerified,
      'isEmailVerified': instance.isEmailVerified,
      'isCheater': instance.isCheater,
      'isDonating': instance.isDonating,
      'isHonest': instance.isHonest,
      'isBanned': instance.isBanned,
      'isFrontEndCert': instance.isFrontEndCert,
      'isDataVisCert': instance.isDataVisCert,
      'isBackEndCert': instance.isBackEndCert,
      'isFullStackCert': instance.isFullStackCert,
      'isRespWebDesignCert': instance.isRespWebDesignCert,
      'is2018DataVisCert': instance.is2018DataVisCert,
      'isFrontEndLibsCert': instance.isFrontEndLibsCert,
      'isJsAlgoDataStructCert': instance.isJsAlgoDataStructCert,
      'isApisMicroservicesCert': instance.isApisMicroservicesCert,
      'isInfosecQaCert': instance.isInfosecQaCert,
      'isQaCertV7': instance.isQaCertV7,
      'isInfosecCertV7': instance.isInfosecCertV7,
      'is2018FullStackCert': instance.is2018FullStackCert,
      'isSciCompPyCertV7': instance.isSciCompPyCertV7,
      'isDataAnalysisPyCertV7': instance.isDataAnalysisPyCertV7,
      'isMachineLearningPyCertV7': instance.isMachineLearningPyCertV7,
      'isRelationalDatabaseCertV8': instance.isRelationalDatabaseCertV8,
      'isCollegeAlgebraPyCertV8': instance.isCollegeAlgebraPyCertV8,
      'isFoundationalCSharpCertV8': instance.isFoundationalCSharpCertV8,
      'joinDate': instance.joinDate.toIso8601String(),
      'points': instance.points,
      'calendar': instance.calendar,
      'completedChallenges': instance.completedChallenges,
      'completedDailyCodingChallenges': instance.completedDailyCodingChallenges,
      'savedChallenges': instance.savedChallenges,
      'portfolio': instance.portfolio,
      'experience': instance.experience,
      'profileUI': instance.profileUI,
      'yearsTopContributor': instance.yearsTopContributor,
    };
