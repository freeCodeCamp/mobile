import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/enums/ext_type.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/service/learn/learn_file_service.dart';

class ScriptBuilder {
  ScriptBuilder({
    required this.challenge,
  });

  final LearnFileService fileService = locator<LearnFileService>();
  final Challenge challenge;

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

    firstHTMlfile = fileService.removeExcessiveScriptsInHTMLdocument(
      firstHTMlfile,
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

  Future<String> combinedCode() async {
    String combinedCode = '';

    for (ChallengeFile file in challenge.files) {
      combinedCode += await fileService.getExactFileFromCache(challenge, file);
    }

    return combinedCode;
  }

  Future<String> runnerScript() async {
    String userCode = await buildUserCode(challenge, Ext.html);

    String testRunner = '''
        await import("http://localhost:8080/index.js");
        window.testRunner = await window.FCCSandbox.createTestRunner({
          source: `<!DOCTYPE html>$hideFccHeaderStyle$userCode`,
          type: "${getWorkerType(challenge.challengeType)}",
          assetPath: "/",
          code: {
            contents: `${await combinedCode()}`,
          },
        })''';

    return testRunner;
  }
}
