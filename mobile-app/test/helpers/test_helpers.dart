import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/learn/daily_challenge_service.dart';
import 'package:freecodecamp/service/news/bookmark_service.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'test_helpers.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<AuthenticationService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<DailyChallengeService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<FlutterLocalNotificationsPlugin>(
    onMissingStub: OnMissingStub.returnDefault,
  ),
  MockSpec<SharedPreferences>(onMissingStub: OnMissingStub.returnDefault),
])
void registerServices() {
  getAndRegisterNewsBookmarkService();
  getAndRegisterAuthenticationService();
  getAndRegisterDailyChallengeService();
}

BookmarksDatabaseService getAndRegisterNewsBookmarkService() {
  _removeRegistrationIfExists<BookmarksDatabaseService>();
  final service = BookmarksDatabaseService();
  locator.registerSingleton<BookmarksDatabaseService>(service);
  return service;
}

MockAuthenticationService getAndRegisterAuthenticationService() {
  _removeRegistrationIfExists<AuthenticationService>();
  final service = MockAuthenticationService();
  locator.registerSingleton<AuthenticationService>(service);
  return service;
}

MockDailyChallengeService getAndRegisterDailyChallengeService() {
  _removeRegistrationIfExists<DailyChallengeService>();
  final service = MockDailyChallengeService();
  locator.registerSingleton<DailyChallengeService>(service);
  return service;
}

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
