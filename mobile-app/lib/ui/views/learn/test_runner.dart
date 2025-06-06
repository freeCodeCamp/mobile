import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/enums/ext_type.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/service/learn/learn_file_service.dart';

class ScriptBuilder {
  final LearnFileService fileService = locator<LearnFileService>();

  static const hideFccHeaderStyle = '''
<style class="fcc-hide-header">
  head *,
  title,
  meta,
  link,
  script {
    display: none !important;
  }
</style>
''';

  static String runnerScript = '''
await import("http://localhost:8080/index.js");
window.TestRunner = await window.FCCSandbox.createTestRunner({
  source: userCode,
  type: workerType,
  assetPath: "/",
  code: {
    contents: combinedCode,
    editableContents: editableRegionContent,
  },
  hooks
});
''';

  static String testExecutionScript = '''
const testRes = await window.TestRunner.runTest(testStr);
return testRes;
''';

  Future<String> buildUserCode(
    Challenge challenge,
    Ext ext, {
    bool testing = false,
  }) async {
    String firstHTMlfile = await fileService.getFirstFileFromCache(
      challenge,
      ext,
      testing: testing,
    );

    String parsedWithStyleTags = await fileService.parseCssDocmentsAsStyleTags(
      challenge,
      firstHTMlfile,
      testing: testing,
    );

    firstHTMlfile = fileService.changeActiveFileLinks(
      parsedWithStyleTags,
    );

    return firstHTMlfile;
  }

  String getWorkerType(int challengeType) {
    switch (challengeType) {
      case 0:
      case 14:
      case 25:
        return 'dom';
      case 1:
      case 26:
        return 'javascript';
      case 20:
      case 23:
        return 'python';
    }

    return 'dom';
  }

  Future<String> combinedCode(Challenge challenge) async {
    String combinedCode = '';

    for (ChallengeFile file in challenge.files) {
      combinedCode += await fileService.getExactFileFromCache(challenge, file);
    }

    return combinedCode;
  }
}
