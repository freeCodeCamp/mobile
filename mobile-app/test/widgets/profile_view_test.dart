import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/enums/theme_type.dart';
import 'package:freecodecamp/models/main/profile_ui_model.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/ui/views/profile/profile_view.dart';
import 'package:mockito/mockito.dart';

import '../helpers/test_helpers.dart';

Future<void> main() async {
  setupLocator();
  await AuthenticationService().init();

  group('ProfileViewModel', () {
    setUp(() => registerServices());
    tearDown(() => unregisterService());

    testWidgets('MyWidget has a title and message', (tester) async {
      const mockUser = {
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
        'progressTimestamps': []
      };

      final authenticationService = getAndRegisterAuthenticationService();

      when(authenticationService.parseUserModel(mockUser)).thenReturn(
          Future.value(FccUserModel(
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
                  showTimeLine: true))));

      await tester.pumpWidget(const ProfileView());
      final titleFinder = find.text('freeCodeCamp Certifications');

      expect(titleFinder, findsOneWidget);
    });
  });
}
