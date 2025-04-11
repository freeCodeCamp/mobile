import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/enums/theme_type.dart';
import 'package:freecodecamp/models/main/profile_ui_model.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/dio_service.dart';
import 'package:freecodecamp/service/news/bookmark_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:stacked_services/stacked_services.dart';
// @stacked-import

import './test_helpers.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<NavigationService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<DialogService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<AuthenticationService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<SnackbarService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<BookmarksDatabaseService>(
    onMissingStub: OnMissingStub.returnDefault,
  ),
  MockSpec<DioService>(onMissingStub: OnMissingStub.returnDefault),

// @stacked-mock-spec
])

// This is a mock user object that can be used in tests

var mockUser = {
  'id': '5bd30e0f1caf6ac3ddddddb5',
  'email': 'foo@bar.com',
  'emailVerified': true,
  'isBanned': false,
  'isCheater': false,
  'acceptedPrivacyTerms': false,
  'sendQuincyEmail': false,
  'username': 'username',
  'about': 'about',
  'name': 'name',
  'picture': 'picture',
  'currentChallengeId': '',
  'location': 'The Cloud',
  'joinDate': '2018-06-10T14:40:07.000Z',
  'points': 100,
  'isHonest': false,
  'isFrontEndCert': false,
  'isDataVisCert': false,
  'isBackEndCert': false,
  'isFullStackCert': false,
  'isRespWebDesignCert': false,
  'is2018DataVisCert': false,
  'isFrontEndLibsCert': false,
  'isJsAlgoDataStructCert': false,
  'isApisMicroservicesCert': false,
  'isInfosecQaCert': false,
  'isQaCertV7': false,
  'isInfosecCertV7': false,
  'is2018FullStackCert': false,
  'isSciCompPyCertV7': false,
  'isDataAnalysisPyCertV7': false,
  'isMachineLearningPyCertV7': false,
  'isRelationalDatabaseCertV8': false,
  'isEmailVerified': false,
  'profileUI': {
    'isLocked': false,
    'showAbout': false,
    'showCerts': false,
    'showDonation': false,
    'showHeatMap': false,
    'showLocation': false,
    'showName': false,
    'showPoints': false,
    'showPortfolio': false,
    'showTimeLine': false
  },
  'isDonating': false,
  'badges': [],
  'progressTimestamps': [],
  'calendar': {},
  'completedChallenges': [],
  'savedChallenges': [],
  'portfolio': [],
  'yearsTopContributor': [],
  'theme': 'night',
};

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

MockBookmarksDatabaseService getAndRegisterNewsBookmarkService() {
  _removeRegistrationIfExists<BookmarksDatabaseService>();
  final service = MockBookmarksDatabaseService();
  locator.registerSingleton<BookmarksDatabaseService>(service);
  return service;
}

MockAuthenticationService getAndRegisterAuthenticationService() {
  _removeRegistrationIfExists<AuthenticationService>();
  final service = MockAuthenticationService();

  when(service.userModel).thenAnswer(
    (_) => Future.value(
      FccUserModel(
        id: '5bd30e0f1caf6ac3ddddddb5',
        email: 'foo@bar.com',
        username: 'devuser',
        name: 'Development User',
        picture: '',
        currentChallengeId: '',
        emailVerified: true,
        isEmailVerified: true,
        acceptedPrivacyTerms: true,
        sendQuincyEmail: true,
        isCheater: false,
        isDonating: false,
        isHonest: true,
        isFrontEndCert: false,
        isDataVisCert: false,
        isBackEndCert: false,
        isFullStackCert: false,
        isRespWebDesignCert: false,
        is2018DataVisCert: false,
        isFrontEndLibsCert: false,
        isJsAlgoDataStructCert: false,
        isApisMicroservicesCert: false,
        isInfosecQaCert: false,
        isQaCertV7: false,
        isInfosecCertV7: false,
        isSciCompPyCertV7: false,
        isDataAnalysisPyCertV7: false,
        isMachineLearningPyCertV7: false,
        isRelationalDatabaseCertV8: false,
        joinDate: DateTime.parse('2025-01-01 06:00:00Z'),
        points: 100,
        calendar: {
          DateTime.parse('2025-01-02 06:00:00Z'): 1,
          DateTime.parse('2025-01-03 06:00:00Z'): 1
        },
        heatMapCal: {
          DateTime.parse('2025-01-02 06:00:00Z'): 1,
          DateTime.parse('2025-01-03 06:00:00Z'): 1
        },
        completedChallenges: [],
        savedChallenges: [],
        portfolio: [],
        yearsTopContributor: [],
        theme: Themes.defaultTheme,
        profileUI: ProfileUI(
            isLocked: false,
            showAbout: true,
            showCerts: true,
            showDonation: true,
            showHeatMap: true,
            showLocation: true,
            showName: true,
            showPoints: true,
            showPortfolio: true,
            showTimeLine: true),
      ),
    ),
  );

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
