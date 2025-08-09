import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/learn/daily_challenge_service.dart';
import 'package:freecodecamp/service/news/bookmark_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_services/stacked_services.dart';
// @stacked-import

import 'test_helpers.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<NavigationService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<DialogService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<AuthenticationService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<DailyChallengeService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<FlutterLocalNotificationsPlugin>(
      onMissingStub: OnMissingStub.returnDefault),
  MockSpec<SharedPreferences>(onMissingStub: OnMissingStub.returnDefault),
// @stacked-mock-spec
])
void registerServices() {
  getAndRegisterNavigationService();
  getAndRegisterDialogService();
  getAndRegisterNewsBookmarkService();
  getAndRegisterAuthenticationService();
  getAndRegisterDailyChallengeService();
// @stacked-mock-register
}

MockNavigationService getAndRegisterNavigationService() {
  _removeRegistrationIfExists<NavigationService>();
  final service = MockNavigationService();
  locator.registerSingleton<NavigationService>(service);
  return service;
}

MockDialogService getAndRegisterDialogService() {
  _removeRegistrationIfExists<DialogService>();
  final service = MockDialogService();
  locator.registerSingleton<DialogService>(service);
  return service;
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
// @stacked-mock-create

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
