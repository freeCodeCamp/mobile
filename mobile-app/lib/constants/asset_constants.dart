class AssetConstants {
  AssetConstants._();
  static final AssetConstants _instance = AssetConstants._();
  factory AssetConstants() => _instance;

  // Images
  static const String placeholderProfileImg = 'assets/images/placeholder-profile-img.png';
  static const String fccBanner = 'assets/images/freecodecamp-banner.png';
  static const String googleLogo = 'assets/images/google-logo.png';
  static const String githubLogo = 'assets/images/github-logo.png';
  static const String appleLogo = 'assets/images/apple-logo.png';
  static const String logo = 'assets/images/logo.png';

  // Test Data / Runner
  static const String newsPostTestData = 'assets/test_data/news_post.json';
  static const String newsFeedTestData = 'assets/test_data/news_feed.json';
  static const String testRunnerDir = 'assets/test_runner';
  static const String babelMinJs = 'assets/test_runner/babel/babel.min.js';

  // Learn
  static const String motivationalQuotes = 'assets/learn/motivational-quotes.json';
  static const String learnAssetsPath = 'assets/learn';
}
