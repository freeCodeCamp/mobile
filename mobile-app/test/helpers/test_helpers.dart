import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/news/bookmark_service.dart';
import 'package:mockito/annotations.dart';
import 'package:stacked_services/stacked_services.dart';
// @stacked-import

import './test_helpers.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<NavigationService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<DialogService>(onMissingStub: OnMissingStub.returnDefault),
// @stacked-mock-spec
])
void registerServices() {
  getAndRegisterNavigationService();
  getAndRegisterDialogService();
  getAndRegisterNewsBookmarkService();
  getAndRegisterAuthenticationService();
  getAndRegisterSnackbarService();
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

AuthenticationService getAndRegisterAuthenticationService() {
  _removeRegistrationIfExists<AuthenticationService>();
  final service = AuthenticationService();
  locator.registerLazySingleton<AuthenticationService>(() => service);
  return service;
}

SnackbarService getAndRegisterSnackbarService() {
  _removeRegistrationIfExists<SnackbarService>();
  final service = SnackbarService();
  locator.registerLazySingleton<SnackbarService>(() => service);
  return service;
}
// @stacked-mock-create

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}

void unregisterService() {
  locator.unregister<MockDialogService>();
  locator.unregister<MockNavigationService>();
  locator.unregister<BookmarksDatabaseService>();
  locator.unregister<AuthenticationService>();
  locator.unregister<SnackbarService>();
}
