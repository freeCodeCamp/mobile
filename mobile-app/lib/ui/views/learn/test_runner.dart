import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/enums/ext_type.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/service/learn/learn_file_service.dart';

class ScriptBuilder {
  final LearnFileService fileService = locator<LearnFileService>();

  static const transpileScript =
      'return Babel.transform(code, { presets: ["env"] }).code';

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
await import("http://localhost:8080/dist/index.js");
window.TestRunner = await window.FCCTestRunner.createTestRunner({
  source: userCode,
  type: workerType,
  assetPath: "/dist",
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
    InAppWebViewController? babelController, {
    bool testing = false,
  }) async {
    String challengeFile = await fileService.getFirstFileFromCache(
      challenge,
      getChallengeExt(challenge.challengeType),
      testing: testing,
    );

    switch (challenge.challengeType) {
      // JS-only challenges
      case ChallengeType.js:
      case ChallengeType.jsLab:
      case ChallengeType.dailyChallengeJs:
        // TODO: Move to learn file service
        if (babelController == null) {
          throw Exception('Babel controller is required to transpile JS code.');
        }

        final babelRes = await babelController.callAsyncJavaScript(
          functionBody: ScriptBuilder.transpileScript,
          arguments: {'code': challengeFile},
        );

        if (babelRes?.error != null) {
          throw Exception('Babel transpilation failed: ${babelRes?.error}');
        }

        return babelRes?.value ?? challengeFile;
      case ChallengeType.python:
      case ChallengeType.multifilePythonCertProject:
      case ChallengeType.pyLab:
      case ChallengeType.dailyChallengePy:
        // Python challenges do not require transpilation, return the file as is.
        return challengeFile;
      default:
        String parsedWithStyleTags =
            await fileService.parseCssDocumentsAsStyleTags(
          challenge,
          challengeFile,
          testing: testing,
        );

        String parsedWithScriptTags =
            await fileService.parseJsDocumentsAsScriptTags(
          challenge,
          parsedWithStyleTags,
          babelController,
          testing: testing,
        );

        challengeFile = fileService.changeActiveFileLinks(
          parsedWithScriptTags,
        );

        return challengeFile;
    }
  }

  String getWorkerType(ChallengeType challengeType) {
    switch (challengeType) {
      case ChallengeType.html:
      case ChallengeType.multifileCertProject:
      case ChallengeType.lab:
        return 'dom';
      case ChallengeType.js:
      case ChallengeType.jsLab:
      case ChallengeType.dailyChallengeJs:
        return 'javascript';
      case ChallengeType.python:
      case ChallengeType.multifilePythonCertProject:
      case ChallengeType.pyLab:
      case ChallengeType.dailyChallengePy:
        return 'python';
      default:
        return 'dom';
    }
  }

  Ext getChallengeExt(ChallengeType challengeType) {
    switch (challengeType) {
      // JS-only challenges
      case ChallengeType.js:
      case ChallengeType.jsLab:
      case ChallengeType.dailyChallengeJs:
        return Ext.js;
      case ChallengeType.python:
      case ChallengeType.multifilePythonCertProject:
      case ChallengeType.pyLab:
      case ChallengeType.dailyChallengePy:
        return Ext.py;
      default:
        return Ext.html;
    }
  }

  Future<String> combinedCode(Challenge challenge) async {
    String combinedCode = '';

    for (ChallengeFile file in challenge.files) {
      combinedCode += await fileService.getExactFileFromCache(challenge, file);
    }

    return combinedCode;
  }
}
