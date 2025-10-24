import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/enums/ext_type.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/service/learn/learn_file_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  LearnFileService service = LearnFileService();

  Challenge challenge = Challenge(
    id: '1',
    block: 'basic html',
    title: 'hello-world',
    description: 'this is the description',
    instructions: 'make your first header',
    transcript: 'this is the transcript',
    dashedName: 'hello-world',
    superBlock: '2022/responsive-web-design',
    challengeType: ChallengeType.js,
    helpCategory: HelpCategory.htmlCss,
    tests: [],
    hooks: Hooks(beforeAll: '', beforeEach: '', afterEach: ''),
    files: [
      ChallengeFile(
        ext: Ext.html,
        name: 'index',
        editableRegionBoundaries: [],
        contents: 'this is the html file content',
        history: [],
        fileKey: 'index.html',
      ),
      ChallengeFile(
        ext: Ext.css,
        name: 'styles',
        editableRegionBoundaries: [1, 5],
        contents: 'this is the css file content',
        history: [],
        fileKey: 'styles.css',
      )
    ],
  );

  group('getExactFileFromCache function', () {
    testWidgets(
      'with testing it should return the exact file',
      (tester) async {
        String content = await service.getExactFileFromCache(
          challenge,
          challenge.files[1],
          testing: true,
        );

        expect(content, 'this is the css file content');
      },
    );
  });

  group('getFirstFileFromCache function', () {
    testWidgets('it should give priority for html files over css files',
        (tester) async {
      String value = await service.getFirstFileFromCache(
        challenge,
        Ext.css,
        testing: true,
      );

      expect(value, 'this is the html file content');
    });
  });

  group('getCurrentEditedFileFromCache function', () {
    testWidgets('it should get the file with the editable region',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      String value =
          (await service.getCurrentEditedFileFromCache(challenge)).contents;

      expect(value, 'this is the css file content');
    });

    testWidgets(
        'if there is no editable region it should return the first file',
        (tester) async {
      Challenge newChallenge = challenge;
      newChallenge.files[1].editableRegionBoundaries = [];

      String value =
          (await service.getCurrentEditedFileFromCache(newChallenge)).contents;

      expect(value, 'this is the html file content');
    });
  });

  group('cssFileLinked function', () {
    testWidgets('it should return false if the file is not linked',
        (tester) async {
      bool value = await service.cssFileIsLinked(
        challenge.files[0].contents,
        challenge.files[1].name,
      );

      expect(value, false);
    });

    testWidgets('it should return true if the file is linked', (tester) async {
      String document = '''
      <html>
        <head>
          <title> Document </title>
          <link href="styles.css">
        </head>
      </html>
      ''';

      bool value = await service.cssFileIsLinked(
        document,
        challenge.files[1].fileKey,
      );

      expect(value, true);
    });

    testWidgets('it should return true if the file in a folder and is linked',
        (tester) async {
      String document = '''
      <html>
        <head>
          <title> Document </title>
          <link href="./src/styles.css">
        </head>
      </html>
      ''';

      bool value = await service.cssFileIsLinked(
        document,
        challenge.files[1].fileKey,
      );

      expect(value, true);
    });
  });

  group('jsFileIsLinked function', () {
    testWidgets(
        'it should return false if the JS file is not linked in the HTML document',
        (tester) async {
      String document = '''
      <html>
        <head></head>
        <body>
          <script src="different-script.js"></script>
        </body>
      </html>
      ''';
      bool value = await service.jsFileIsLinked(document, 'script.js');
      expect(value, false);
    });

    testWidgets(
        'it should return true if the JS file is linked in the HTML document',
        (tester) async {
      String document = '''
      <html>
        <head></head>
        <body>
          <script src="script.js"></script>
        </body>
      </html>
      ''';
      bool value = await service.jsFileIsLinked(document, 'script.js');
      expect(value, true);
    });

    testWidgets(
        'it should return true if the JS file is in a folder and is linked in the HTML document',
        (tester) async {
      String document = '''
      <html>
        <head></head>
        <body>
          <script src="./src/script.js"></script>
        </body>
      </html>
      ''';
      bool value = await service.jsFileIsLinked(document, 'script.js');
      expect(value, true);
    });
  });

  group('parseCssDocumentsAsStyleTags function', () {
    testWidgets('it should inject style tag if CSS file is linked',
        (tester) async {
      Challenge cssChallenge = Challenge(
        id: '2',
        block: 'css block',
        title: 'css-test',
        description: '',
        instructions: '',
        transcript: '',
        dashedName: 'css-test',
        superBlock: 'super block',
        challengeType: ChallengeType.js,
        helpCategory: HelpCategory.htmlCss,
        tests: [],
        hooks: Hooks(beforeAll: '', beforeEach: '', afterEach: ''),
        files: [
          ChallengeFile(
            ext: Ext.html,
            name: 'index',
            editableRegionBoundaries: [],
            contents:
                '''<html><head><link href="styles.css"></head><body></body></html>''',
            history: [],
            fileKey: 'index.html',
          ),
          ChallengeFile(
            ext: Ext.css,
            name: 'styles',
            editableRegionBoundaries: [1, 5],
            contents: 'body { color: red; }',
            history: [],
            fileKey: 'styles.css',
          )
        ],
      );
      String html = cssChallenge.files[0].contents;
      String result = await service
          .parseCssDocumentsAsStyleTags(cssChallenge, html, testing: true);
      expect(
          result,
          contains(
              '<style class="fcc-injected-styles"> body { color: red; } </style>'));
    });

    testWidgets('it should not inject style tag if CSS file is not linked',
        (tester) async {
      Challenge cssChallenge = Challenge(
        id: '3',
        block: 'css block',
        title: 'css-test',
        description: '',
        instructions: '',
        transcript: '',
        dashedName: 'css-test',
        superBlock: 'super block',
        challengeType: ChallengeType.js,
        helpCategory: HelpCategory.htmlCss,
        tests: [],
        hooks: Hooks(beforeAll: '', beforeEach: '', afterEach: ''),
        files: [
          ChallengeFile(
            ext: Ext.html,
            name: 'index',
            editableRegionBoundaries: [],
            contents: '''<html><head></head><body></body></html>''',
            history: [],
            fileKey: 'index.html',
          ),
          ChallengeFile(
            ext: Ext.css,
            name: 'styles',
            editableRegionBoundaries: [1, 5],
            contents: 'body { color: blue; }',
            history: [],
            fileKey: 'styles.css',
          )
        ],
      );
      String html = cssChallenge.files[0].contents;
      String result = await service
          .parseCssDocumentsAsStyleTags(cssChallenge, html, testing: true);
      expect(result, isNot(contains('fcc-injected-styles')));
    });
  });

  group('parseJsDocumentsAsScriptTags function', () {
    testWidgets(
        'it should throw an error if JS file is linked when babelController is null',
        (tester) async {
      Challenge jsChallenge = Challenge(
        id: '4',
        block: 'js block',
        title: 'js-test',
        description: '',
        instructions: '',
        transcript: '',
        dashedName: 'js-test',
        superBlock: 'super block',
        challengeType: ChallengeType.js,
        helpCategory: HelpCategory.htmlCss,
        tests: [],
        hooks: Hooks(beforeAll: '', beforeEach: '', afterEach: ''),
        files: [
          ChallengeFile(
            ext: Ext.html,
            name: 'index',
            editableRegionBoundaries: [],
            contents:
                '''<html><head></head><body><script src="script.js"></script></body></html>''',
            history: [],
            fileKey: 'index.html',
          ),
          ChallengeFile(
            ext: Ext.js,
            name: 'script',
            editableRegionBoundaries: [1, 5],
            contents: 'console.log("hello");',
            history: [],
            fileKey: 'script.js',
          )
        ],
      );
      String html = jsChallenge.files[0].contents;
      expect(
        () async => await service.parseJsDocumentsAsScriptTags(jsChallenge, html, null, testing: true),
        throwsA(isA<Exception>().having((e) => e.toString(), 'description', contains('Babel controller is required to transpile JS code.'))),
      );
    });
  });

  group('changeActiveFileLinks function', () {
    test('it should replace href/src with data-href/data-src for known files',
        () {
      String html = '''
      <html>
        <head>
          <link href="styles.css">
          <script src="script.js"></script>
        </head>
        <body></body>
      </html>
      ''';

      const expectedHtml = '''
      <html>
        <head>
          <link data-href="styles.css">
          <script data-src="script.js"></script>
        </head>
        <body></body>
      </html>
      ''';

      String result = service.changeActiveFileLinks(html);
      String stripWhitespace(String s) => s.replaceAll(RegExp(r'\s+'), '');

      expect(stripWhitespace(result), stripWhitespace(expectedHtml));
    });

    test('it should not change unrelated links/scripts', () {
      String html = '''
      <html>
        <head>
          <link href="other.css">
          <script src="other.js"></script>
        </head>
        <body></body>
      </html>
      ''';

      String result = service.changeActiveFileLinks(html);
      String stripWhitespace(String s) => s.replaceAll(RegExp(r'\s+'), '');

      expect(stripWhitespace(result), stripWhitespace(html));
    });
  });
}
