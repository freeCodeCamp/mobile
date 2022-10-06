import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/enums/ext_type.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/service/learn_file_service.dart';
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
      slug: 'make-your-first-header',
      superBlock: '2022/responsive-web-design',
      challengeType: 1,
      tests: [],
      files: [
        ChallengeFile(
            ext: Ext.html,
            name: 'index',
            editableRegionBoundaries: [],
            contents: 'this is the html file content',
            history: [],
            fileKey: 'index.html'),
        ChallengeFile(
            ext: Ext.css,
            name: 'styles',
            editableRegionBoundaries: [1, 5],
            contents: 'this is the css file content',
            history: [],
            fileKey: 'styles.css')
      ]);

  group('getExactFileFromCache function', () {
    test(
      'with testing it should return the exact file',
      () async {
        String content = await service.getExactFileFromCache(
          challenge,
          challenge.files[1],
          testing: true,
        );

        expect(content, 'this is the css file content');
      },
    );
  });

  group('saveFileInCache function', () {
    test(
      'It will save the file in the cache',
      () async {
        SharedPreferences.setMockInitialValues({});
        SharedPreferences prefs = await SharedPreferences.getInstance();

        service.saveFileInCache(
          challenge,
          challenge.files[0].name,
          'this is the html file content',
        );

        Future.delayed(const Duration(seconds: 5), () {});

        expect(
            prefs.getString(
              '${challenge.title}.${challenge.files[0].name}',
            ),
            'this is the html file content');
      },
    );
  });

  group('getFirstFileFromCache function', () {
    test('it should give priority for html files over css files', () async {
      String value = await service.getFirstFileFromCache(
        challenge,
        Ext.css,
        testing: true,
      );

      expect(value, 'this is the html file content');
    });
  });

  group('getCurrentEditedFileFromCache function', () {
    test('it should get the file with the editable region', () async {
      String value = await service.getCurrentEditedFileFromCache(challenge);

      expect(value, 'this is the css file content');
    });

    test('if there is no editable region it should return the first file',
        () async {
      Challenge newChallenge = challenge;
      newChallenge.files[1].editableRegionBoundaries = [];

      String value = await service.getCurrentEditedFileFromCache(newChallenge);

      expect(value, 'this is the html file content');
    });
  });

  group('cssFileLinked function', () {
    test('it should return false if the file is not linked', () async {
      bool value = await service.cssFileIsLinked(
        challenge.files[0].contents,
        challenge.files[1].name,
      );

      expect(value, false);
    });

    test('it should return true if the file is linked', () async {
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

    test('it should return true if the file in a folder and is linked',
        () async {
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
}
