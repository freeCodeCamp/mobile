import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  String? clipboardText;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    clipboardText = null;

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
      switch (call.method) {
        case 'Clipboard.setData':
          clipboardText = call.arguments['text'] as String?;
          return null;
        case 'Clipboard.getData':
          return {'text': clipboardText};
      }

      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  Widget htmlParserFixture(String html) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            final parser = HTMLParser(context: context);

            return Column(
              children: parser.parse(html),
            );
          },
        ),
      ),
    );
  }

  testWidgets('copies the contents of a pre code block', (tester) async {
    const code = '<p>Hello</p>\nconst answer = 42;';

    await tester.pumpWidget(
      htmlParserFixture(
        '<pre><code class="language-html">&lt;p&gt;Hello&lt;/p&gt;\nconst answer = 42;</code></pre>',
      ),
    );
    await tester.pump();

    expect(find.byTooltip('Copy code'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.copy));
    await tester.pump();

    expect(clipboardText, code);
    expect(find.text('Code copied to clipboard!'), findsOneWidget);
  });
}
