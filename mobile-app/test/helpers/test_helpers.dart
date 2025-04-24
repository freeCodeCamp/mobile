import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/dio_service.dart';
import 'package:freecodecamp/service/news/bookmark_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:stacked_services/stacked_services.dart';
// @stacked-import

import '../__fixtures__/user.dart';
import './test_helpers.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<NavigationService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<DialogService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<AuthenticationService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<SnackbarService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<DioService>(onMissingStub: OnMissingStub.returnDefault),

// @stacked-mock-spec
])
void registerServices() {
  setupLocator();
  getAndRegisterNavigationService();
  getAndRegisterDialogService();
  getAndRegisterNewsBookmarkService();
  getAndRegisterDioService();
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

MockAuthenticationService getAndRegisterAuthenticationService({
  Map<String, Object>? user,
  bool isLoggedIn = false,
}) {
  _removeRegistrationIfExists<AuthenticationService>();
  final service = MockAuthenticationService();

  if (isLoggedIn) {
    when(service.userModel).thenAnswer(
      (_) {
        if (user != null) {
          return Future.value(FccUserModel.fromJson(user));
        }
        return Future.value(FccUserModel.fromJson(mockUser));
      },
    );
  }

  locator.registerLazySingleton<AuthenticationService>(() => service);
  return service;
}

MockSnackbarService getAndRegisterSnackbarService() {
  _removeRegistrationIfExists<SnackbarService>();
  final service = MockSnackbarService();
  locator.registerLazySingleton<SnackbarService>(() => service);
  return service;
}

MockDioService getAndRegisterDioService() {
  _removeRegistrationIfExists<DioService>();
  final service = MockDioService();
  locator.registerLazySingleton<DioService>(() => service);
  return service;
}

// @stacked-mock-create

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}

void unregisterService() {
  locator.unregister<NavigationService>();
  locator.unregister<DialogService>();
  locator.unregister<SnackbarService>();
  locator.unregister<BookmarksDatabaseService>();
  locator.unregister<DioService>();
  locator.unregister<AuthenticationService>();
}
