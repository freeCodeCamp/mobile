import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt')
  ];

  /// in drawer (hamburger menu)
  ///
  /// In en, this message translates to:
  /// **'TUTORIALS'**
  String get tutorials;

  /// in drawer (hamburger menu)
  ///
  /// In en, this message translates to:
  /// **'PODCASTS'**
  String get podcasts;

  /// in drawer (hamburger menu)
  ///
  /// In en, this message translates to:
  /// **'DONATE'**
  String get donate;

  /// in drawer (hamburger menu)
  ///
  /// In en, this message translates to:
  /// **'LEARN'**
  String get learn;

  /// in drawer (hamburger menu)
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get settings;

  /// in drawer (hamburger menu when logged in)
  ///
  /// In en, this message translates to:
  /// **'PROFILE'**
  String get profile;

  /// in drawer (hamburger menu when logged in)
  ///
  /// In en, this message translates to:
  /// **'LOG OUT'**
  String get logout;

  /// in drawer (hamburger menu when logged out)
  ///
  /// In en, this message translates to:
  /// **'LOG IN'**
  String get login;

  /// login view
  ///
  /// In en, this message translates to:
  /// **'LOGIN'**
  String get login_title;

  /// in drawer (hamburger menu when logged out)
  ///
  /// In en, this message translates to:
  /// **'Anonymous User'**
  String get anonymous_user;

  /// in drawer (hamburger menu when logged in)
  ///
  /// In en, this message translates to:
  /// **'Our coolest Camper'**
  String get coolest_camper;

  /// login view
  ///
  /// In en, this message translates to:
  /// **'Sign in to save your progress'**
  String get login_save_progress;

  /// login view
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get login_with_google;

  /// login view
  ///
  /// In en, this message translates to:
  /// **'Continue with GitHub'**
  String get login_with_github;

  /// login view
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get login_with_apple;

  /// login view
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// login view
  ///
  /// In en, this message translates to:
  /// **'Enter sign in code'**
  String get email_enter_sign_in_code;

  /// login view
  ///
  /// In en, this message translates to:
  /// **'Submit and sign in to freeCodeCamp'**
  String get email_submit_code;

  /// login view (when failing to login with email)
  ///
  /// In en, this message translates to:
  /// **'The code you entered is not valid. Please check the last OTP you received and try again.'**
  String get email_invalid_code;

  /// login view
  ///
  /// In en, this message translates to:
  /// **'freeCodeCamp is free and your account is private by default. We use your email address to connect you to your account.'**
  String get login_data_message;

  /// No description provided for @login_load_message.
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get login_load_message;

  /// No description provided for @login_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Login canceled'**
  String get login_cancelled;

  /// login view
  ///
  /// In en, this message translates to:
  /// **'You must be at least 13 years old to create an account on freeCodeCamp.'**
  String get login_age_message;

  /// learn view
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {username}'**
  String login_welcome_back(String username);

  /// No description provided for @challenge_download.
  ///
  /// In en, this message translates to:
  /// **'Download All Challenges'**
  String get challenge_download;

  /// No description provided for @challenge_download_starting.
  ///
  /// In en, this message translates to:
  /// **'Starting Download...'**
  String get challenge_download_starting;

  /// No description provided for @challenge_download_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel Downloading Challenges'**
  String get challenge_download_cancel;

  /// No description provided for @challenge_download_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete Downloaded Challenges'**
  String get challenge_download_delete;

  /// learn > block
  ///
  /// In en, this message translates to:
  /// **'Certification Project'**
  String get certification_project;

  /// learn > block > challenge
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get instructions;

  /// learn > block > challenge
  ///
  /// In en, this message translates to:
  /// **'Editor'**
  String get editor;

  /// learn > block > challenge (eye icon)
  ///
  /// In en, this message translates to:
  /// **'PREVIEW'**
  String get preview;

  /// learn > block > challenge (eye icon)
  ///
  /// In en, this message translates to:
  /// **'CONSOLE'**
  String get console;

  /// learn > block > challenge > instructions panel
  ///
  /// In en, this message translates to:
  /// **'Step {stepNumber} of {totalSteps}'**
  String step_count(String stepNumber, String totalSteps);

  /// learn > block > challenge > *complete challenge* > pass panel
  ///
  /// In en, this message translates to:
  /// **'{percent}% Completed'**
  String completed_percent(String percent);

  /// learn > block > challenge > *complete challenge* > pass panel
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @next_challenge.
  ///
  /// In en, this message translates to:
  /// **'Next Challenge'**
  String get next_challenge;

  /// learn > block > challenge > *complete challenge* > pass panel
  ///
  /// In en, this message translates to:
  /// **'Passed'**
  String get passed;

  /// learn > block > challenge > *fail challenge* > hint panel
  ///
  /// In en, this message translates to:
  /// **'Hint'**
  String get hint;

  /// No description provided for @try_again.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get try_again;

  /// learn > python cert > challenge
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} Questions'**
  String questions(int completed, int total);

  /// No description provided for @questions_check.
  ///
  /// In en, this message translates to:
  /// **'Check your Answer'**
  String get questions_check;

  /// learn > python cert > project
  ///
  /// In en, this message translates to:
  /// **'Solution Link'**
  String get solution_link;

  /// learn > python cert > project
  ///
  /// In en, this message translates to:
  /// **'Check Link'**
  String get solution_link_check;

  /// No description provided for @solution_link_submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get solution_link_submit;

  /// No description provided for @ask_for_help.
  ///
  /// In en, this message translates to:
  /// **'Ask for Help'**
  String get ask_for_help;

  /// learn > block > challenge > *fail challenge* > hint panel
  ///
  /// In en, this message translates to:
  /// **'Reset Code'**
  String get reset_code;

  /// learn > block > challenge > *fail challenge* > hint panel
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// learn > block > challenge > *fail challenge* > hint panel
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset your code?'**
  String get reset_description;

  /// ladning view
  ///
  /// In en, this message translates to:
  /// **'Continue Where You Left Off'**
  String get continue_left_off;

  /// news > click author image
  ///
  /// In en, this message translates to:
  /// **'Tutorials from {author}'**
  String tutorials_from(String author);

  /// news > *click author image*
  ///
  /// In en, this message translates to:
  /// **'AUTHOR PROFILE'**
  String get tutorial_author_title;

  /// news > *click author image*
  ///
  /// In en, this message translates to:
  /// **'Show more tutorials'**
  String get tutorial_show_more;

  /// news > click subject (#javascript)
  ///
  /// In en, this message translates to:
  /// **'Tutorials about {subject}'**
  String tutorials_about(String subject);

  /// news > tutorial
  ///
  /// In en, this message translates to:
  /// **'Written by {author}'**
  String tutorial_written_by(String author);

  /// news view
  ///
  /// In en, this message translates to:
  /// **'There was an error loading tutorials'**
  String get tutorial_load_error;

  /// news view
  ///
  /// In en, this message translates to:
  /// **'Read tutorials online'**
  String get tutorial_read_online;

  /// news > tutorial
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get tutorial_bookmark;

  /// news > tutorial
  ///
  /// In en, this message translates to:
  /// **'Bookmarked'**
  String get tutorial_bookmarked;

  /// news > bookmarks > bookmarked tutorial
  ///
  /// In en, this message translates to:
  /// **'BOOKMARKED TUTORIAL'**
  String get tutorial_bookmark_title;

  /// news > bookmarks
  ///
  /// In en, this message translates to:
  /// **'Bookmark tutorials to view them here'**
  String get tutorial_no_bookmarks;

  /// news > search
  ///
  /// In en, this message translates to:
  /// **'No Tutorials Found'**
  String get tutorial_search_no_results;

  /// news > search
  ///
  /// In en, this message translates to:
  /// **'There was an error loading tutorials \n please try again'**
  String get tutorial_search_error;

  /// news > search
  ///
  /// In en, this message translates to:
  /// **'SEARCH TUTORIALS...'**
  String get tutorial_search_placeholder;

  /// news > bookmarks
  ///
  /// In en, this message translates to:
  /// **'BOOKMARKED TUTORIALS'**
  String get tutorial_bookmarks_title;

  /// news > search
  ///
  /// In en, this message translates to:
  /// **'SEARCH TUTORIALS'**
  String get tutorial_search_title;

  /// news view
  ///
  /// In en, this message translates to:
  /// **'Tutorials'**
  String get tutorial_nav_tutorials;

  /// news view
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get tutorial_nav_bookmarks;

  /// news view
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get tutorial_nav_search;

  /// podcasts view
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get podcasts_browse;

  /// podcasts view
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get podcasts_downloads;

  /// podcasts view
  ///
  /// In en, this message translates to:
  /// **'PODCASTS'**
  String get podcasts_title;

  /// podcasts > downloads
  ///
  /// In en, this message translates to:
  /// **'DOWNLOADED PODCASTS'**
  String get podcast_download_title;

  /// podcasts > downloads
  ///
  /// In en, this message translates to:
  /// **'No Downloaded Episodes'**
  String get podcast_no_downloads;

  /// podcasts > podcast
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get podcast_description;

  /// podcasts > podcast
  ///
  /// In en, this message translates to:
  /// **'{hours} hrs {minutes} min'**
  String podcast_duration_hours(String hours, String minutes);

  /// podcasts > podcast
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String podcast_duration_minutes(String minutes);

  /// podcasts > podcast
  ///
  /// In en, this message translates to:
  /// **'Show More'**
  String get podcast_show_more;

  /// podcasts > podcast
  ///
  /// In en, this message translates to:
  /// **'Show Less'**
  String get podcast_show_less;

  /// podcasts > podcast
  ///
  /// In en, this message translates to:
  /// **'Unable to load podcasts \n please try again.'**
  String get podcast_unable_to_load_podcasts;

  /// settings view
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get settings_title;

  /// settings view
  ///
  /// In en, this message translates to:
  /// **'Reset Cache'**
  String get settings_reset_cache;

  /// settings view > *click reset cache*
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear the cache? - this resets all your progress and local data'**
  String get settings_reset_cache_message;

  /// settings view > *click reset cache*
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get settings_reset_cache_confirm;

  /// settings view
  ///
  /// In en, this message translates to:
  /// **'Clears all local data and progress'**
  String get settings_reset_cache_description;

  /// settings view
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settings_privacy_policy;

  /// settings view
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get settings_delete_account;

  /// settings view
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_language;

  /// settings view > *click delete account*
  ///
  /// In en, this message translates to:
  /// **'This will really delete all your data, including all your progress and account information.'**
  String get delete_account_message_one;

  /// No description provided for @delete_account_message_two.
  ///
  /// In en, this message translates to:
  /// **'We won\'t be able to recover any of it for you later, even if you change your mind.'**
  String get delete_account_message_two;

  /// No description provided for @delete_account_message_three.
  ///
  /// In en, this message translates to:
  /// **'If there\'s something we could do better, send us an email instead and we\'ll do our best:'**
  String get delete_account_message_three;

  /// No description provided for @delete_account_message_four.
  ///
  /// In en, this message translates to:
  /// **'I am 100% certain. Delete everything related to this account'**
  String get delete_account_message_four;

  /// settings view > *click delete account*
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? - this deletes everything related to your account'**
  String get delete_account_are_you_sure;

  /// No description provided for @delete_account_deleting.
  ///
  /// In en, this message translates to:
  /// **'Deleting account...'**
  String get delete_account_deleting;

  /// No description provided for @delete_success.
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get delete_success;

  /// No description provided for @delete_failed.
  ///
  /// In en, this message translates to:
  /// **'Account deletion failed. Please try again later.'**
  String get delete_failed;

  /// settings view
  ///
  /// In en, this message translates to:
  /// **'Delete your freeCodeCamp account'**
  String get settings_delete_account_description;

  /// settings view
  ///
  /// In en, this message translates to:
  /// **'Read our privacy policy'**
  String get settings_privacy_policy_description;

  /// coderadio view
  ///
  /// In en, this message translates to:
  /// **'Unable to load coderadio \n please try again.'**
  String get coderadio_unable_to_load;

  /// coderadio view (only on Android)
  ///
  /// In en, this message translates to:
  /// **'Next Song'**
  String get coderadio_next_song;

  /// coderadio view
  ///
  /// In en, this message translates to:
  /// **'{listeners} listening right now'**
  String coderadio_listening(String listeners);

  /// No description provided for @coderadio_play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get coderadio_play;

  /// No description provided for @coderadio_pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get coderadio_pause;

  /// drawer > profile (signed in)
  ///
  /// In en, this message translates to:
  /// **'View {certification}'**
  String profile_view_cert(String certification);

  /// drawer > profile (signed in)
  ///
  /// In en, this message translates to:
  /// **'{certification} Certification'**
  String profile_cert(String certification);

  /// drawer > profile (signed in)
  ///
  /// In en, this message translates to:
  /// **'Joined {date}'**
  String profile_join_date(String date);

  /// drawer > profile (signed in)
  ///
  /// In en, this message translates to:
  /// **'{points} points'**
  String profile_points(String points);

  /// drawer > profile (signed in)
  ///
  /// In en, this message translates to:
  /// **'{point, plural, =0{0 points on {date}} =1{1 point on {date}} other{{point} points on {date}}}'**
  String profile_points_on_date(int point, String date);

  /// drawer > profile (signed in)
  ///
  /// In en, this message translates to:
  /// **'Longest Streak: {streak}'**
  String profile_longest_streak(int streak);

  /// drawer > profile (signed in)
  ///
  /// In en, this message translates to:
  /// **'Current Streak: {streak}'**
  String profile_current_streak(int streak);

  /// drawer > profile (signed in)
  ///
  /// In en, this message translates to:
  /// **'Supporter'**
  String get profile_supporter;

  /// drawer > profile (signed in)
  ///
  /// In en, this message translates to:
  /// **'PROFILE'**
  String get profile_title;

  /// drawer > profile (signed in)
  ///
  /// In en, this message translates to:
  /// **'freeCodeCamp Certifications'**
  String get profile_certifications;

  /// drawer > profile (signed in)
  ///
  /// In en, this message translates to:
  /// **'No user data found'**
  String get profile_no_userdata;

  /// drawer > profile (signed in)
  ///
  /// In en, this message translates to:
  /// **'No certifications have been earned under the current curriculum'**
  String get profile_no_modern_certs;

  /// drawer > profile (signed in)
  ///
  /// In en, this message translates to:
  /// **'Legacy Certifications'**
  String get profile_legacy_certs;

  /// drawer > profile (signed in)
  ///
  /// In en, this message translates to:
  /// **'Portfolio'**
  String get profile_portfolio;

  /// No description provided for @quincy_email_signup.
  ///
  /// In en, this message translates to:
  /// **'Email Signup'**
  String get quincy_email_signup;

  /// No description provided for @quincy_email_part_one.
  ///
  /// In en, this message translates to:
  /// **'Please slow down and read this.'**
  String get quincy_email_part_one;

  /// No description provided for @quincy_email_part_two.
  ///
  /// In en, this message translates to:
  /// **'freeCodeCamp is a proven path to your first software developer job.'**
  String get quincy_email_part_two;

  /// No description provided for @quincy_email_part_three.
  ///
  /// In en, this message translates to:
  /// **'More than 40,000 people have gotten developer jobs after completing this — including at big companies like Google and Microsoft.'**
  String get quincy_email_part_three;

  /// No description provided for @quincy_email_part_four.
  ///
  /// In en, this message translates to:
  /// **'If you are new to programming, we recommend you start at the beginning and earn these certifications in order.'**
  String get quincy_email_part_four;

  /// No description provided for @quincy_email_part_five.
  ///
  /// In en, this message translates to:
  /// **'To earn each certification, build its 5 required projects and get all their tests to pass.'**
  String get quincy_email_part_five;

  /// No description provided for @quincy_email_part_six.
  ///
  /// In en, this message translates to:
  /// **'You can add these certifications to your résumé or LinkedIn. But more important than the certifications is the practice you get along the way.'**
  String get quincy_email_part_six;

  /// No description provided for @quincy_email_part_seven.
  ///
  /// In en, this message translates to:
  /// **'If you feel overwhelmed, that is normal. Programming is hard.'**
  String get quincy_email_part_seven;

  /// No description provided for @quincy_email_part_eight.
  ///
  /// In en, this message translates to:
  /// **'Practice is the key. Practice, practice, practice.'**
  String get quincy_email_part_eight;

  /// No description provided for @quincy_email_part_nine.
  ///
  /// In en, this message translates to:
  /// **'And this curriculum will give you thousands of hours of hands-on programming practice.'**
  String get quincy_email_part_nine;

  /// No description provided for @quincy_email_part_ten.
  ///
  /// In en, this message translates to:
  /// **'And if you want to learn more math and computer science theory, we also have thousands of hours of video courses on freeCodeCamp\\\'s YouTube channel.'**
  String get quincy_email_part_ten;

  /// No description provided for @quincy_email_part_eleven.
  ///
  /// In en, this message translates to:
  /// **'If you want to get a developer job or freelance clients, programming skills will be just part of the puzzle. You also need to build your personal network and your reputation as a developer.'**
  String get quincy_email_part_eleven;

  /// No description provided for @quincy_email_part_twelve.
  ///
  /// In en, this message translates to:
  /// **'You can do this on LinkedIn and GitHub, and also on the freeCodeCamp forum.'**
  String get quincy_email_part_twelve;

  /// No description provided for @quincy_email_part_thirteen.
  ///
  /// In en, this message translates to:
  /// **'Happy coding!'**
  String get quincy_email_part_thirteen;

  /// No description provided for @quincy_email_part_fourteen.
  ///
  /// In en, this message translates to:
  /// **'- Quincy Larson, the teacher who founded freeCodeCamp.org'**
  String get quincy_email_part_fourteen;

  /// No description provided for @quincy_email_part_fifteen.
  ///
  /// In en, this message translates to:
  /// **'By the way, each Friday I send an email with 5 links about programming and computer science. I send these to about 4 million people. Would you like me to send this to you, too?'**
  String get quincy_email_part_fifteen;

  /// No description provided for @quincy_email_confirm.
  ///
  /// In en, this message translates to:
  /// **'Yes Please'**
  String get quincy_email_confirm;

  /// No description provided for @quincy_email_no_thanks.
  ///
  /// In en, this message translates to:
  /// **'No Thanks'**
  String get quincy_email_no_thanks;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @email_error.
  ///
  /// In en, this message translates to:
  /// **'Email Error'**
  String get email_error;

  /// No description provided for @login_email_error_subject.
  ///
  /// In en, this message translates to:
  /// **'Error logging in to mobile app'**
  String get login_email_error_subject;

  /// No description provided for @login_email_error_message.
  ///
  /// In en, this message translates to:
  /// **'Please email the below error to {supportEmail}:\n\n{error}\n\n{stackTrace}'**
  String login_email_error_message(
      String supportEmail, String error, String stackTrace);

  /// No description provided for @quick_action_daily_challenges.
  ///
  /// In en, this message translates to:
  /// **'Daily Challenges'**
  String get quick_action_daily_challenges;

  /// No description provided for @code_radio.
  ///
  /// In en, this message translates to:
  /// **'CODE RADIO'**
  String get code_radio;

  /// No description provided for @no_blocks_available.
  ///
  /// In en, this message translates to:
  /// **'No blocks available right now.'**
  String get no_blocks_available;

  /// No description provided for @coming_soon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get coming_soon;

  /// No description provided for @temporarily_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Temporarily unavailable, come back soon.'**
  String get temporarily_unavailable;

  /// No description provided for @login_coming_soon.
  ///
  /// In en, this message translates to:
  /// **'Login will soon be available!'**
  String get login_coming_soon;

  /// No description provided for @coming_soon_web.
  ///
  /// In en, this message translates to:
  /// **'Coming soon - use the web version'**
  String get coming_soon_web;

  /// No description provided for @daily_coding_challenges.
  ///
  /// In en, this message translates to:
  /// **'Daily Coding Challenges'**
  String get daily_coding_challenges;

  /// No description provided for @daily_challenge_empty.
  ///
  /// In en, this message translates to:
  /// **'No challenges available at the moment.'**
  String get daily_challenge_empty;

  /// No description provided for @daily_challenge_completed.
  ///
  /// In en, this message translates to:
  /// **'Today\'s challenge completed!'**
  String get daily_challenge_completed;

  /// No description provided for @daily_challenge_countdown_label.
  ///
  /// In en, this message translates to:
  /// **'Countdown timer. Next challenge in {timeLeft}'**
  String daily_challenge_countdown_label(String timeLeft);

  /// No description provided for @daily_challenge_next_in.
  ///
  /// In en, this message translates to:
  /// **'Next challenge in: {timeLeft}'**
  String daily_challenge_next_in(String timeLeft);

  /// No description provided for @daily_challenge_view_past_tooltip.
  ///
  /// In en, this message translates to:
  /// **'View past daily challenges'**
  String get daily_challenge_view_past_tooltip;

  /// No description provided for @daily_challenge_view_past.
  ///
  /// In en, this message translates to:
  /// **'View past challenges'**
  String get daily_challenge_view_past;

  /// No description provided for @daily_challenge_today.
  ///
  /// In en, this message translates to:
  /// **'Today\'s challenge'**
  String get daily_challenge_today;

  /// No description provided for @daily_challenge_prompt.
  ///
  /// In en, this message translates to:
  /// **'Do you have the skills to complete this challenge?'**
  String get daily_challenge_prompt;

  /// No description provided for @daily_challenge_start_tooltip.
  ///
  /// In en, this message translates to:
  /// **'Start the daily challenge now'**
  String get daily_challenge_start_tooltip;

  /// No description provided for @daily_challenge_go_to_challenge.
  ///
  /// In en, this message translates to:
  /// **'Go to challenge'**
  String get daily_challenge_go_to_challenge;

  /// No description provided for @daily_challenge_start.
  ///
  /// In en, this message translates to:
  /// **'Start the challenge'**
  String get daily_challenge_start;

  /// No description provided for @daily_challenge_completed_semantics.
  ///
  /// In en, this message translates to:
  /// **'Daily challenge completed. View past challenges.'**
  String get daily_challenge_completed_semantics;

  /// No description provided for @daily_challenge_card_semantics.
  ///
  /// In en, this message translates to:
  /// **'Daily challenge card'**
  String get daily_challenge_card_semantics;

  /// No description provided for @download_complete.
  ///
  /// In en, this message translates to:
  /// **'Download complete'**
  String get download_complete;

  /// No description provided for @download_episode.
  ///
  /// In en, this message translates to:
  /// **'Download episode'**
  String get download_episode;

  /// No description provided for @challenge_card_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get challenge_card_description;

  /// No description provided for @challenge_card_video.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get challenge_card_video;

  /// No description provided for @challenge_card_watch_video.
  ///
  /// In en, this message translates to:
  /// **'Watch the Video'**
  String get challenge_card_watch_video;

  /// No description provided for @challenge_card_transcript.
  ///
  /// In en, this message translates to:
  /// **'Transcript'**
  String get challenge_card_transcript;

  /// No description provided for @challenge_card_scene.
  ///
  /// In en, this message translates to:
  /// **'Scene'**
  String get challenge_card_scene;

  /// No description provided for @challenge_card_listen_audio.
  ///
  /// In en, this message translates to:
  /// **'Listen to the Audio'**
  String get challenge_card_listen_audio;

  /// No description provided for @challenge_card_assignments.
  ///
  /// In en, this message translates to:
  /// **'Assignments'**
  String get challenge_card_assignments;

  /// No description provided for @challenge_card_explanation.
  ///
  /// In en, this message translates to:
  /// **'Explanation'**
  String get challenge_card_explanation;

  /// No description provided for @challenge_card_fill_blank.
  ///
  /// In en, this message translates to:
  /// **'Fill in the Blank'**
  String get challenge_card_fill_blank;

  /// No description provided for @challenge_card_feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get challenge_card_feedback;

  /// No description provided for @challenge_card_lesson.
  ///
  /// In en, this message translates to:
  /// **'Lesson'**
  String get challenge_card_lesson;

  /// No description provided for @tap_to_expand.
  ///
  /// In en, this message translates to:
  /// **'Tap to expand'**
  String get tap_to_expand;

  /// No description provided for @tests.
  ///
  /// In en, this message translates to:
  /// **'Tests'**
  String get tests;

  /// No description provided for @quiz_leave_title.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get quiz_leave_title;

  /// No description provided for @quiz_leave_message.
  ///
  /// In en, this message translates to:
  /// **'Do you want to leave this quiz? Your progress will be lost.'**
  String get quiz_leave_message;

  /// No description provided for @quiz_question.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get quiz_question;

  /// No description provided for @quiz_question_number.
  ///
  /// In en, this message translates to:
  /// **'Question {questionNumber}'**
  String quiz_question_number(int questionNumber);

  /// No description provided for @quiz_correct.
  ///
  /// In en, this message translates to:
  /// **'Correct!'**
  String get quiz_correct;

  /// No description provided for @quiz_incorrect.
  ///
  /// In en, this message translates to:
  /// **'Incorrect!'**
  String get quiz_incorrect;

  /// No description provided for @quiz_unanswered_questions.
  ///
  /// In en, this message translates to:
  /// **'The following questions are unanswered: {questions}. You must answer all questions.'**
  String quiz_unanswered_questions(String questions);

  /// No description provided for @quiz_passed.
  ///
  /// In en, this message translates to:
  /// **'You have {correctQuestionsCount} out of {totalQuestions} questions correct. You have passed.'**
  String quiz_passed(int correctQuestionsCount, int totalQuestions);

  /// No description provided for @quiz_failed.
  ///
  /// In en, this message translates to:
  /// **'You have {correctQuestionsCount} out of {totalQuestions} questions correct. You did not pass.'**
  String quiz_failed(int correctQuestionsCount, int totalQuestions);

  /// No description provided for @some_answers_are_incorrect.
  ///
  /// In en, this message translates to:
  /// **'Some answers are incorrect.'**
  String get some_answers_are_incorrect;

  /// No description provided for @show_transcript.
  ///
  /// In en, this message translates to:
  /// **'Show transcript'**
  String get show_transcript;

  /// No description provided for @audio_load_error.
  ///
  /// In en, this message translates to:
  /// **'Error loading audio'**
  String get audio_load_error;

  /// No description provided for @project_link_hint.
  ///
  /// In en, this message translates to:
  /// **'ex: https://replit.com/@camperbot/hello'**
  String get project_link_hint;

  /// No description provided for @project_link_invalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid link.'**
  String get project_link_invalid;

  /// No description provided for @project_link_own_work.
  ///
  /// In en, this message translates to:
  /// **'Remember to submit your own work.'**
  String get project_link_own_work;

  /// No description provided for @project_link_insecure.
  ///
  /// In en, this message translates to:
  /// **'An unsecure (http) URL cannot be used.'**
  String get project_link_insecure;

  /// No description provided for @project_link_public_url.
  ///
  /// In en, this message translates to:
  /// **'Remember to submit a publicly visible app URL.'**
  String get project_link_public_url;

  /// No description provided for @forum_create_post.
  ///
  /// In en, this message translates to:
  /// **'Create a post'**
  String get forum_create_post;

  /// No description provided for @forum_help_description.
  ///
  /// In en, this message translates to:
  /// **'If you\'ve already tried the Read-Search-Ask method, then you can try asking for help on the freeCodeCamp forum.'**
  String get forum_help_description;

  /// No description provided for @forum_confirm_description.
  ///
  /// In en, this message translates to:
  /// **'You must confirm the following statements before you can submit your post to the forum.'**
  String get forum_confirm_description;

  /// No description provided for @forum_tell_us_heading.
  ///
  /// In en, this message translates to:
  /// **'Tell us what\'s happening:'**
  String get forum_tell_us_heading;

  /// No description provided for @forum_describe_issue.
  ///
  /// In en, this message translates to:
  /// **'Describe your issue in detail here.'**
  String get forum_describe_issue;

  /// No description provided for @forum_code_so_far.
  ///
  /// In en, this message translates to:
  /// **'Your code so far'**
  String get forum_code_so_far;

  /// No description provided for @forum_mobile_info.
  ///
  /// In en, this message translates to:
  /// **'Your mobile information:'**
  String get forum_mobile_info;

  /// No description provided for @forum_challenge.
  ///
  /// In en, this message translates to:
  /// **'Challenge:'**
  String get forum_challenge;

  /// No description provided for @forum_challenge_link.
  ///
  /// In en, this message translates to:
  /// **'Link to the challenge:'**
  String get forum_challenge_link;

  /// No description provided for @forum_warning.
  ///
  /// In en, this message translates to:
  /// **'WARNING'**
  String get forum_warning;

  /// No description provided for @forum_code_too_long.
  ///
  /// In en, this message translates to:
  /// **'The challenge seed code and/or your solution exceeded the maximum length we can port over from the challenge.'**
  String get forum_code_too_long;

  /// No description provided for @forum_additional_step.
  ///
  /// In en, this message translates to:
  /// **'You will need to take an additional step here so the code you wrote presents in an easy to read format.'**
  String get forum_additional_step;

  /// No description provided for @forum_copy_editor_code.
  ///
  /// In en, this message translates to:
  /// **'Please copy/paste all the editor code showing in the challenge from where you just linked.'**
  String get forum_copy_editor_code;

  /// No description provided for @forum_replace_code.
  ///
  /// In en, this message translates to:
  /// **'Replace these two sentences with your copied code.\nPlease leave the ``` line above and the ``` line below,\nbecause they allow your code to properly format in the post.'**
  String get forum_replace_code;

  /// No description provided for @forum_tried.
  ///
  /// In en, this message translates to:
  /// **'I have tried the '**
  String get forum_tried;

  /// No description provided for @forum_read_search_ask.
  ///
  /// In en, this message translates to:
  /// **'Read-Search-Ask'**
  String get forum_read_search_ask;

  /// No description provided for @forum_method.
  ///
  /// In en, this message translates to:
  /// **' method'**
  String get forum_method;

  /// No description provided for @forum_searched_for.
  ///
  /// In en, this message translates to:
  /// **'I have searched for '**
  String get forum_searched_for;

  /// No description provided for @forum_similar_questions.
  ///
  /// In en, this message translates to:
  /// **'similar questions that have already been answered on the forum'**
  String get forum_similar_questions;

  /// No description provided for @forum_enter_more_chars.
  ///
  /// In en, this message translates to:
  /// **'Please enter at least {characterCount} more characters.'**
  String forum_enter_more_chars(int characterCount);

  /// No description provided for @forum_issue_hint.
  ///
  /// In en, this message translates to:
  /// **'Describe your issue in detail here...'**
  String get forum_issue_hint;

  /// No description provided for @forum_help_dialog_prefix.
  ///
  /// In en, this message translates to:
  /// **'If you\'ve already tried the '**
  String get forum_help_dialog_prefix;

  /// No description provided for @forum_help_dialog_suffix.
  ///
  /// In en, this message translates to:
  /// **' method, then you can ask for help on the freeCodeCamp forum.'**
  String get forum_help_dialog_suffix;

  /// No description provided for @forum_before_post.
  ///
  /// In en, this message translates to:
  /// **'Before making a new post please '**
  String get forum_before_post;

  /// No description provided for @forum_check_answered.
  ///
  /// In en, this message translates to:
  /// **'check if your question has already been answered on the forum'**
  String get forum_check_answered;

  /// No description provided for @go_to_next_challenge.
  ///
  /// In en, this message translates to:
  /// **'Go to Next Challenge'**
  String get go_to_next_challenge;

  /// No description provided for @check_answers.
  ///
  /// In en, this message translates to:
  /// **'Check Answers'**
  String get check_answers;

  /// No description provided for @tutorial_written_by_colon.
  ///
  /// In en, this message translates to:
  /// **'Written by: {author}'**
  String tutorial_written_by_colon(String author);

  /// No description provided for @error_loading_chapters.
  ///
  /// In en, this message translates to:
  /// **'Error loading chapters: {error} {stackTrace}'**
  String error_loading_chapters(String error, String stackTrace);

  /// No description provided for @syntax_error_line.
  ///
  /// In en, this message translates to:
  /// **'There is a syntax error on line {line}. Please check for missing brackets, quotes, or other syntax issues.'**
  String syntax_error_line(int line);

  /// No description provided for @syntax_error_general.
  ///
  /// In en, this message translates to:
  /// **'There is a syntax error in your code. Please check for missing brackets, quotes, or other syntax issues.'**
  String get syntax_error_general;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong!'**
  String get error;

  /// No description provided for @error_two.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error_two;

  /// No description provided for @error_three.
  ///
  /// In en, this message translates to:
  /// **'Oops! Something went wrong. Please try again in a moment.'**
  String get error_three;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @unrecognized_device.
  ///
  /// In en, this message translates to:
  /// **'Unrecognized Device'**
  String get unrecognized_device;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
