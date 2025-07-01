// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get tutorials => 'TUTORIALS';

  @override
  String get podcasts => 'PODCASTS';

  @override
  String get donate => 'DONATE';

  @override
  String get learn => 'LEARN';

  @override
  String get settings => 'SETTINGS';

  @override
  String get profile => 'PROFILE';

  @override
  String get logout => 'LOG OUT';

  @override
  String get login => 'LOG IN';

  @override
  String get login_title => 'LOGIN';

  @override
  String get anonymous_user => 'Anonymous User';

  @override
  String get coolest_camper => 'Our coolest Camper';

  @override
  String get login_save_progress => 'Sign in to save your progress';

  @override
  String get login_with_google => 'Continue with Google';

  @override
  String get login_with_github => 'Continue with GitHub';

  @override
  String get login_with_apple => 'Continue with Apple';

  @override
  String get email => 'Email';

  @override
  String get email_enter_sign_in_code => 'Enter sign in code';

  @override
  String get email_submit_code => 'Submit and sign in to freeCodeCamp';

  @override
  String get email_invalid_code => 'The code you entered is not valid. Please check the last OTP you received and try again.';

  @override
  String get login_data_message => 'freeCodeCamp is free and your account is private by default. We use your email address to connect you to your account.';

  @override
  String get login_load_message => 'Signing in...';

  @override
  String get login_cancelled => 'Login canceled';

  @override
  String get login_age_message => 'You must be at least 13 years old to create an account on freeCodeCamp.';

  @override
  String login_welcome_back(String username) {
    return 'Welcome back, $username';
  }

  @override
  String get challenge_download => 'Download All Challenges';

  @override
  String get challenge_download_starting => 'Starting Download...';

  @override
  String get challenge_download_cancel => 'Cancel Downloading Challenges';

  @override
  String get challenge_download_delete => 'Delete Downloaded Challenges';

  @override
  String get certification_project => 'Certification Project';

  @override
  String get instructions => 'Instructions';

  @override
  String get editor => 'Editor';

  @override
  String get preview => 'PREVIEW';

  @override
  String get console => 'CONSOLE';

  @override
  String step_count(String stepNumber, String totalSteps) {
    return 'Step $stepNumber of $totalSteps';
  }

  @override
  String completed_percent(String percent) {
    return '$percent% Completed';
  }

  @override
  String get next => 'Next';

  @override
  String get next_challenge => 'Next Challenge';

  @override
  String get passed => 'Passed';

  @override
  String get hint => 'Hint';

  @override
  String get try_again => 'Try Again';

  @override
  String questions(int completed, int total) {
    return '$completed of $total Questions';
  }

  @override
  String get questions_check => 'Check your Answer';

  @override
  String get solution_link => 'Solution Link';

  @override
  String get solution_link_check => 'Check Link';

  @override
  String get solution_link_submit => 'Submit';

  @override
  String get ask_for_help => 'Ask for Help';

  @override
  String get reset_code => 'Reset Code';

  @override
  String get reset => 'Reset';

  @override
  String get reset_description => 'Are you sure you want to reset your code?';

  @override
  String get continue_left_off => 'Continue Where You Left Off';

  @override
  String tutorials_from(String author) {
    return 'Tutorials from $author';
  }

  @override
  String get tutorial_author_title => 'AUTHOR PROFILE';

  @override
  String get tutorial_show_more => 'Show more tutorials';

  @override
  String tutorials_about(String subject) {
    return 'Tutorials about $subject';
  }

  @override
  String tutorial_written_by(String author) {
    return 'Written by $author';
  }

  @override
  String get tutorial_load_error => 'There was an error loading tutorials';

  @override
  String get tutorial_read_online => 'Read tutorials online';

  @override
  String get tutorial_bookmark => 'Bookmark';

  @override
  String get tutorial_bookmarked => 'Bookmarked';

  @override
  String get tutorial_bookmark_title => 'BOOKMARKED TUTORIAL';

  @override
  String get tutorial_no_bookmarks => 'Bookmark tutorials to view them here';

  @override
  String get tutorial_search_no_results => 'No Tutorials Found';

  @override
  String get tutorial_search_error => 'There was an error loading tutorials \n please try again';

  @override
  String get tutorial_search_placeholder => 'SEARCH TUTORIALS...';

  @override
  String get tutorial_bookmarks_title => 'BOOKMARKED TUTORIALS';

  @override
  String get tutorial_search_title => 'SEARCH TUTORIALS';

  @override
  String get tutorial_nav_tutorials => 'Tutorials';

  @override
  String get tutorial_nav_bookmarks => 'Bookmarks';

  @override
  String get tutorial_nav_search => 'Search';

  @override
  String get podcasts_browse => 'Browse';

  @override
  String get podcasts_downloads => 'Downloads';

  @override
  String get podcasts_title => 'PODCASTS';

  @override
  String get podcast_download_title => 'DOWNLOADED PODCASTS';

  @override
  String get podcast_no_downloads => 'No Downloaded Episodes';

  @override
  String get podcast_description => 'Description';

  @override
  String podcast_duration_hours(String hours, String minutes) {
    return '$hours hrs $minutes min';
  }

  @override
  String podcast_duration_minutes(String minutes) {
    return '$minutes min';
  }

  @override
  String get podcast_show_more => 'Show More';

  @override
  String get podcast_show_less => 'Show Less';

  @override
  String get podcast_unable_to_load_podcasts => 'Unable to load podcasts \n please try again.';

  @override
  String get settings_title => 'SETTINGS';

  @override
  String get settings_reset_cache => 'Reset Cache';

  @override
  String get settings_reset_cache_message => 'Are you sure you want to clear the cache? - this resets all your progress and local data';

  @override
  String get settings_reset_cache_confirm => 'Clear';

  @override
  String get settings_reset_cache_description => 'Clears all local data and progress';

  @override
  String get settings_privacy_policy => 'Privacy Policy';

  @override
  String get settings_delete_account => 'Delete Account';

  @override
  String get settings_language => 'Language';

  @override
  String get delete_account_message_one => 'This will really delete all your data, including all your progress and account information.';

  @override
  String get delete_account_message_two => 'We won\'t be able to recover any of it for you later, even if you change your mind.';

  @override
  String get delete_account_message_three => 'If there\'s something we could do better, send us an email instead and we\'ll do our best:';

  @override
  String get delete_account_message_four => 'I am 100% certain. Delete everything related to this account';

  @override
  String get delete_account_are_you_sure => 'Are you sure you want to delete your account? - this deletes everything related to your account';

  @override
  String get delete_account_deleting => 'Deleting account...';

  @override
  String get delete_success => 'Account deleted successfully';

  @override
  String get delete_failed => 'Account deletion failed. Please try again later.';

  @override
  String get settings_delete_account_description => 'Delete your freeCodeCamp account';

  @override
  String get settings_privacy_policy_description => 'Read our privacy policy';

  @override
  String get coderadio_unable_to_load => 'Unable to load coderadio \n please try again.';

  @override
  String get coderadio_next_song => 'Next Song';

  @override
  String coderadio_listening(String listeners) {
    return '$listeners listening right now';
  }

  @override
  String get coderadio_play => 'Play';

  @override
  String get coderadio_pause => 'Pause';

  @override
  String profile_view_cert(String certification) {
    return 'View $certification';
  }

  @override
  String profile_cert(String certification) {
    return '$certification Certification';
  }

  @override
  String profile_join_date(String date) {
    return 'Joined $date';
  }

  @override
  String profile_points(String points) {
    return '$points points';
  }

  @override
  String profile_points_on_date(int point, String date) {
    final intl.NumberFormat pointNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
      
    );
    final String pointString = pointNumberFormat.format(point);

    String _temp0 = intl.Intl.pluralLogic(
      point,
      locale: localeName,
      other: '$pointString points on $date',
      one: '1 point on $date',
      zero: '0 points on $date',
    );
    return '$_temp0';
  }

  @override
  String profile_longest_streak(int streak) {
    return 'Longest Streak: $streak';
  }

  @override
  String profile_current_streak(int streak) {
    return 'Current Streak: $streak';
  }

  @override
  String get profile_supporter => 'Supporter';

  @override
  String get profile_title => 'PROFILE';

  @override
  String get profile_certifications => 'freeCodeCamp Certifications';

  @override
  String get profile_no_userdata => 'No user data found';

  @override
  String get profile_no_modern_certs => 'No certifications have been earned under the current curriculum';

  @override
  String get profile_legacy_certs => 'Legacy Certifications';

  @override
  String get profile_portfolio => 'Portfolio';

  @override
  String get quincy_email_signup => 'Email Signup';

  @override
  String get quincy_email_part_one => 'Please slow down and read this.';

  @override
  String get quincy_email_part_two => 'freeCodeCamp is a proven path to your first software developer job.';

  @override
  String get quincy_email_part_three => 'More than 40,000 people have gotten developer jobs after completing this — including at big companies like Google and Microsoft.';

  @override
  String get quincy_email_part_four => 'If you are new to programming, we recommend you start at the beginning and earn these certifications in order.';

  @override
  String get quincy_email_part_five => 'To earn each certification, build its 5 required projects and get all their tests to pass.';

  @override
  String get quincy_email_part_six => 'You can add these certifications to your résumé or LinkedIn. But more important than the certifications is the practice you get along the way.';

  @override
  String get quincy_email_part_seven => 'If you feel overwhelmed, that is normal. Programming is hard.';

  @override
  String get quincy_email_part_eight => 'Practice is the key. Practice, practice, practice.';

  @override
  String get quincy_email_part_nine => 'And this curriculum will give you thousands of hours of hands-on programming practice.';

  @override
  String get quincy_email_part_ten => 'And if you want to learn more math and computer science theory, we also have thousands of hours of video courses on freeCodeCamp\\\'s YouTube channel.';

  @override
  String get quincy_email_part_eleven => 'If you want to get a developer job or freelance clients, programming skills will be just part of the puzzle. You also need to build your personal network and your reputation as a developer.';

  @override
  String get quincy_email_part_twelve => 'You can do this on LinkedIn and GitHub, and also on the freeCodeCamp forum.';

  @override
  String get quincy_email_part_thirteen => 'Happy coding!';

  @override
  String get quincy_email_part_fourteen => '- Quincy Larson, the teacher who founded freeCodeCamp.org';

  @override
  String get quincy_email_part_fifteen => 'By the way, each Friday I send an email with 5 links about programming and computer science. I send these to about 4 million people. Would you like me to send this to you, too?';

  @override
  String get quincy_email_confirm => 'Yes Please';

  @override
  String get quincy_email_no_thanks => 'No Thanks';

  @override
  String get error => 'Something went wrong!';

  @override
  String get error_two => 'Error';

  @override
  String get error_three => 'Oops! Something went wrong. Please try again in a moment.';

  @override
  String get loading => 'Loading';

  @override
  String get unrecognized_device => 'Unrecognized Device';

  @override
  String get help => 'Help';

  @override
  String get share => 'Share';

  @override
  String get close => 'Close';
}
