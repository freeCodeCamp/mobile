import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/enums/ext_type.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/service/learn_file_service.dart';

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
