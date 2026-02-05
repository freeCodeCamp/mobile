import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/enums/ext_type.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/service/learn/learn_file_service.dart';

class ScriptBuilder {
  final LearnFileService fileService = locator<LearnFileService>();

  static const transpileScript = '''
try {
  return { success: true, code: Babel.transform(code, { presets: ["env"] }).code };
} catch (e) {
  let errorMsg = e.message || e.toString();
  if (e.loc) {
    errorMsg = "SyntaxError: " + e.message + " (" + e.loc.line + ":" + e.loc.column + ")";
  }
  return { success: false, error: errorMsg };
}
''';

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
      case 1:
      case 26:
      case 28:
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

        final result = babelRes?.value as Map<dynamic, dynamic>?;
        if (result?['success'] == false) {
          throw Exception('Babel transpilation failed: ${result?['error']}');
        }

        return result?['code'] ?? challengeFile;
      case 20:
      case 23:
      case 27:
      case 29:
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

  String getWorkerType(int challengeType) {
    switch (challengeType) {
      case 0:
      case 14:
      case 25:
        return 'dom';
      case 1:
      case 26:
      case 28:
        return 'javascript';
      case 20:
      case 23:
      case 27:
      case 29:
        return 'python';
    }

    return 'dom';
  }

  Ext getChallengeExt(int challengeType) {
    switch (challengeType) {
      // JS-only challenges
      case 1:
      case 26:
      case 28:
        return Ext.js;
      case 20:
      case 23:
      case 27:
      case 29:
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
