class StringConstants {
  StringConstants._();
  static final StringConstants _instance = StringConstants._();
  factory StringConstants() => _instance;

  // Environment variables
  static const String developmentMode = 'DEVELOPMENTMODE';
  static const String hashnodePublicationId = 'HASHNODE_PUBLICATION_ID';
  static const String auth0Domain = 'AUTH0_DOMAIN';
  static const String auth0ClientId = 'AUTH0_CLIENT_ID';
  static const String algoliaAppId = 'ALGOLIAAPPID';
  static const String algoliaKey = 'ALGOLIAKEY';
  static const String showAllSb = 'SHOWALLSB';

  // Shared Preferences keys
  static const String locale = 'locale';
  static const String selectedDailyChallengeLanguage = 'selectedDailyChallengeLanguage';
  static const String dailyChallengeNotificationsEnabled = 'daily_challenge_notifications_enabled';
  static const String notificationScheduleStartDate = 'notification_schedule_start_date';
  static const String lastSongId = 'lastSongId';
  static const String position = 'position';

  // Remote Config keys
  static const String minAppVersion = 'min_app_version';

  // Dialog Keys
  static const String issueDescription = 'issueDescription';
  static const String blockName = 'blockName';
  static const String challengeName = 'challengeName';
  static const String readSearchAskChecked = 'readSearchAskChecked';
  static const String similarQuestionsChecked = 'similarQuestionsChecked';
}
