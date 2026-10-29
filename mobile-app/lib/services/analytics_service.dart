import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:freecodecamp/services/notification_service.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'analytics_service.g.dart';

// NOTE: Every event and user property goes through AnalyticsService. docs/ANALYTICS.md lists them, and test/services/analytics_service_test.dart fails when the two drift apart.
@Riverpod(keepAlive: true)
AnalyticsService analytics(Ref ref) =>
    AnalyticsService(FirebaseAnalyticsSink(FirebaseAnalytics.instance));

abstract interface class AnalyticsSink {
  Future<void> logEvent(String name, Map<String, Object> parameters);
  Future<void> logScreenView(String screenName, String screenClass);
  Future<void> setUserProperty(String name, String value);
}

class FirebaseAnalyticsSink implements AnalyticsSink {
  FirebaseAnalyticsSink(this._firebase);

  final FirebaseAnalytics _firebase;

  @override
  Future<void> logEvent(String name, Map<String, Object> parameters) =>
      _firebase.logEvent(name: name, parameters: parameters);

  @override
  Future<void> logScreenView(String screenName, String screenClass) =>
      _firebase.logScreenView(screenName: screenName, screenClass: screenClass);

  @override
  Future<void> setUserProperty(String name, String value) =>
      _firebase.setUserProperty(name: name, value: value);
}

enum LoginMethod {
  google,
  github,
  apple,
  email;

  // NOTE: Auth0 connection names, as passed by login_view.dart.
  static LoginMethod fromConnection(String connection) => switch (connection) {
    'google-oauth2' => google,
    'github' => github,
    'apple' => apple,
    _ => email,
  };
}

typedef ScreenView = ({String name, String screenClass});

// NOTE: An unmatched location has no matches, and router.state throws on it.
ScreenView screenViewOf(GoRouter router) {
  final config = router.routerDelegate.currentConfiguration;
  if (config.matches.isEmpty) {
    return (name: config.uri.path, screenClass: 'not_found');
  }
  final state = router.state;
  return (
    name: state.matchedLocation,
    screenClass: state.fullPath ?? state.matchedLocation,
  );
}

// NOTE: Firebase limits, see docs/ANALYTICS.md.
const maxNameLength = 40;
const maxUserPropertyNameLength = 24;
const maxUserPropertyValueLength = 36;
const maxParameterValueLength = 100;
const maxParameters = 25;
const _reservedPrefixes = ['firebase_', 'google_', 'ga_'];
final _snakeCase = RegExp(r'^[a-z][a-z0-9_]*$');

bool isValidAnalyticsName(String name, {int maxLength = maxNameLength}) =>
    name.length <= maxLength &&
    _snakeCase.hasMatch(name) &&
    !_reservedPrefixes.any(name.startsWith);

// NOTE: Booleans become 'true'/'false' so they read as text dimensions in GA, nulls are dropped, and strings are cut to Firebase's 100-character limit instead of being rejected.
Map<String, Object> normaliseParameters(Map<String, Object?> parameters) {
  assert(parameters.length <= maxParameters, 'Too many parameters');
  return {
    for (final MapEntry(:key, :value) in parameters.entries)
      if (value != null)
        key: switch (value) {
          bool() => '$value',
          String() when value.length > maxParameterValueLength =>
            value.substring(0, maxParameterValueLength),
          num() || String() => value,
          _ => throw ArgumentError.value(
            value,
            key,
            'Must be a String, num or bool',
          ),
        },
  };
}

const _notificationPermissionKey = 'analytics_notification_permission';

class AnalyticsService {
  AnalyticsService(this._sink);

  final AnalyticsSink _sink;

  // NOTE: Static event names. Experiment exposures are `<experiment key>_exposure` and come from the Experiment enum.
  static const eventNames = {
    'challenge_tests_run',
    'challenge_completed',
    'daily_challenge_completed',
    'code_reset',
    'help_requested',
    'login',
    'logout',
    'account_deleted',
    'notification_permission',
    'notification_opened',
  };

  static const userPropertyNames = {'signed_in', 'notifications_enabled'};

  Future<void> screenView(ScreenView screen) =>
      _sink.logScreenView(screen.name, screen.screenClass);

  Future<void> experimentExposure(
    String eventName, {
    required String variant,
  }) => _log(eventName, {'variant': variant});

  Future<void> challengeTestsRun({
    required String superBlock,
    required String block,
    required int challengeType,
    required bool passed,
    required int failedTests,
  }) => _log('challenge_tests_run', {
    'superblock': superBlock,
    'block': block,
    'challenge_type': challengeType,
    'passed': passed,
    'failed_tests': failedTests,
  });

  Future<void> challengeCompleted({
    required String superBlock,
    required String block,
    required int challengeType,
  }) => _log('challenge_completed', {
    'superblock': superBlock,
    'block': block,
    'challenge_type': challengeType,
  });

  Future<void> dailyChallengeCompleted({required String language}) =>
      _log('daily_challenge_completed', {'language': language});

  Future<void> codeReset({
    required String superBlock,
    required String block,
    required int challengeType,
  }) => _log('code_reset', {
    'superblock': superBlock,
    'block': block,
    'challenge_type': challengeType,
  });

  Future<void> helpRequested({
    required String superBlock,
    required String block,
    required int challengeType,
  }) => _log('help_requested', {
    'superblock': superBlock,
    'block': block,
    'challenge_type': challengeType,
  });

  Future<void> login(LoginMethod method) =>
      _log('login', {'method': method.name});

  Future<void> logout() => _log('logout', const {});

  Future<void> accountDeleted() => _log('account_deleted', const {});

  Future<void> notificationOpened(NotificationKind? kind) =>
      _log('notification_opened', {'type': kind?.payload ?? 'unknown'});

  Future<void> setSignedIn(bool signedIn) =>
      _setUserProperty('signed_in', '$signedIn');

  // NOTE: Called on every launch. The property is always set; the event only fires when the answer differs from the last one reported, so it counts real grants and revocations.
  Future<void> reportNotificationPermission({required bool granted}) async {
    await _setUserProperty('notifications_enabled', '$granted');

    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_notificationPermissionKey) == granted) return;
    await prefs.setBool(_notificationPermissionKey, granted);
    await _log('notification_permission', {'granted': granted});
  }

  // NOTE: async so a bad event fails its own future instead of throwing into the caller's flow.
  Future<void> _log(String name, Map<String, Object?> parameters) async {
    assert(isValidAnalyticsName(name), 'Invalid event name: $name');
    assert(
      parameters.keys.every(isValidAnalyticsName),
      'Invalid parameter name in $name: ${parameters.keys}',
    );
    return _sink.logEvent(name, normaliseParameters(parameters));
  }

  Future<void> _setUserProperty(String name, String value) {
    assert(
      isValidAnalyticsName(name, maxLength: maxUserPropertyNameLength),
      'Invalid user property name: $name',
    );
    assert(
      value.length <= maxUserPropertyValueLength,
      'Value too long: $value',
    );
    return _sink.setUserProperty(name, value);
  }
}
