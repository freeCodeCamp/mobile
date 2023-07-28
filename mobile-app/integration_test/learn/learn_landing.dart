import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/main.dart' as app;
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:freecodecamp/ui/views/learn/landing/landing_view.dart';
import 'package:http/http.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding();
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('LEARN - Learn Landing view', (WidgetTester tester) async {
    // Start app
    tester.printToConsole('Test starting');
    await app.main(testing: true);
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();
    await binding.takeScreenshot('learn/learn-landing');

    String baseUrl = LearnService.baseUrl;
    final Response res = await get(
      Uri.parse('$baseUrl/available-superblocks.json'),
    );
    List superBlocks = jsonDecode(res.body)['superblocks'];
    int publicSuperBlocks = 0;

    for (int i = 0; i < superBlocks.length; i++) {
      if (superBlocks[i]['public']) {
        publicSuperBlocks++;
      }
    }
    await tester.pumpAndSettle();

    // Check if all superblocks are displayed
    final superBlockButtons = find.byType(SuperBlockButton);
    final publicSuperBlockButtons = find.byWidgetPredicate(
      (widget) => widget is SuperBlockButton && widget.button.public == true,
    );
    expect(superBlockButtons, findsNWidgets(superBlocks.length));
    expect(publicSuperBlockButtons, findsNWidgets(publicSuperBlocks));

    // Check for login button
    expect(AuthenticationService.staticIsloggedIn, false);

    final loginButton = find.text('Sign in to save your progress');
    expect(loginButton, findsOneWidget);
  });
}
