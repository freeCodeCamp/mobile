import 'dart:convert';
import 'dart:developer';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/enums/ext_type.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/service/learn/learn_file_service.dart';
import 'package:html/parser.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:html/dom.dart' as dom;

class TestRunner extends BaseViewModel {
  String _testDocument = '';
  String get testDocument => _testDocument;

  set setTestDocument(String document) {
    _testDocument = document;
    notifyListeners();
  }

  final LearnFileService fileService = locator<LearnFileService>();

  // This function sets the webview content, and parses the document accordingly.
  // It will create a new empty document. (There is no content set from
  // the actual user as this is imported in the script that tests inside the document)

  Future<String> setWebViewContent(
    Challenge challenge, {
    WebViewController? webviewController,
    bool testing = false,
  }) async {
    dom.Document document = dom.Document();
    document = parse('');

    List<String> imports = [
      '<script src="https://unpkg.com/chai/chai.js"></script>',
      '<script src="https://unpkg.com/mocha/mocha.js"></script>',
      '<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>',
      '<link rel="stylesheet" href="https://unpkg.com/mocha/mocha.css" />'
    ];

    for (String import in imports) {
      dom.Document importToNode = parse(import);

      dom.Node node =
          importToNode.getElementsByTagName('HEAD')[0].children.first;

      document.getElementsByTagName('HEAD')[0].append(node);
    }

    String? script = await returnScript(
      challenge.files[0].ext,
      challenge,
      testing: testing,
    );

    if (script == null) {
      throwError(challenge, 'an empty script was returned');
    }

    dom.Document scriptToNode = parse(script);

    dom.Node bodyNode =
        scriptToNode.getElementsByTagName('BODY').first.children.isNotEmpty
            ? scriptToNode.getElementsByTagName('BODY').first.children.first
            : scriptToNode.getElementsByTagName('HEAD').first.children.first;

    document.body!.append(bodyNode);
    if (!testing) {
      webviewController!.loadUrl(Uri.dataFromString(
        document.outerHtml,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ).toString());
    }

    return document.outerHtml;
  }

  // The parse test function will parse RegEx's and Comments and more for the eval function.
  // Cause the code is going through runtime twice, the already escaped '\\' need to be escaped
  // again.

  List<String> parseTest(List<ChallengeTest> test) {
    List<String> parsedTest = test
        .map((e) =>
            """`${e.javaScript.replaceAll('\\', '\\\\').replaceAll('`', '\\`').replaceAll('\$', r'\$')}`""")
        .toList();

    return parsedTest;
  }

  // This function is used in the returnScript function to correctly parse
  // HTML challenge (user code) it will firstly get the file from the cache, (it returns the first challenge file if in testing mode)
  // Otherwise it will return the first instance of that challenge in the cache. Next will be adding the style tags (only if
  // linked)

  Future<String> htmlFlow(
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

    return parsedWithStyleTags;
  }

  // This function parses the JavaScript code so that it has a head and tail (code)
  // It is used in the returnScript function to correctly parse JavaScript.

  Future<String> javaScritpFlow(
    Challenge challenge,
    Ext ext, {
    bool testing = false,
  }) async {
    var content = testing
        ? challenge.files[0].contents
        : await fileService.getFirstFileFromCache(challenge, Ext.js);

    return content
        .replaceAll('\\', '\\\\')
        .replaceAll('`', '\\`')
        .replaceAll('\$', r'\$');
  }

  // This is a debug function, it can be used to display a custom message in the test runner.

  void throwError(Challenge challenge, String message) {
    throw Exception(
      '''$message, debug info: ${challenge.superBlock}, ${challenge.block}, id: ${challenge.id},
         slug: ${challenge.slug.isEmpty ? 'empty' : challenge.slug},
         extension: ${challenge.files.map((e) => e.ext.name).toString()}''',
    );
  }

  // This returns the script that needs to be run in the DOM. If the test in the document fail it will
  // log the failed test to the console. If the test have been completed, it will return "completed" in a
  // console.log

  Future<String?> returnScript(
    Ext ext,
    Challenge challenge, {
    bool testing = false,
  }) async {
    String logFunction = testing ? 'console.log' : 'Print.postMessage';

    // List<ChallengeFile>? indexFile =
    //     challenge.files.where((element) => element.name == 'index').toList();
    List<ChallengeFile>? scriptFile =
        challenge.files.where((element) => element.name == 'script').toList();

    bool hasRegion = challenge.files
        .map((e) => e.editableRegionBoundaries.isNotEmpty)
        .isNotEmpty;

    String? code;

    if (ext == Ext.html || ext == Ext.css) {
      code = await htmlFlow(
        challenge,
        ext,
        testing: testing,
      );
    } else if (ext == Ext.js) {
      code = await javaScritpFlow(
        challenge,
        ext,
        testing: testing,
      );
    } else {
      throwError(
        challenge,
        'this extension is not supported',
      );
    }

    if (ext == Ext.html || ext == Ext.css) {
      String? tail = challenge.files[0].tail ?? '';

      String wut = '''<script type="module">
    import * as __helpers from "https://unpkg.com/@freecodecamp/curriculum-helpers@1.1.0/dist/index.js";

    const code = `$code`;
    const doc = new DOMParser().parseFromString(code, 'text/html');

    ${tail.isNotEmpty ? """
    const parseTail  = new DOMParser().parseFromString(`${tail.replaceAll('/', '\\/')}`,'text/html');
    const tail = parseTail.getElementsByTagName('SCRIPT')[0].innerHTML;
    """ : ''}

    const assert = chai.assert;
    const tests = ${parseTest(challenge.tests)};
    const testText = ${challenge.tests.map((e) => '''"${e.instruction.replaceAll('"', '\\"').replaceAll('\n', ' ')}"''').toList().toString()};

    function getUserInput(returnCase){
      switch(returnCase){
        case 'index':
          return `${(await fileService.getCurrentEditedFileFromCache(challenge, testing: testing)).replaceAll('\\', '\\\\').replaceAll('`', '\\`').replaceAll('\$', r'\$')}`;
        case 'editableContents':
        return `${(await fileService.getCurrentEditedFileFromCache(challenge, testing: testing)).replaceAll('\\', '\\\\').replaceAll('`', '\\`').replaceAll('\$', r'\$')}`;
        default:
          return code;
      }
     }

    doc.__runTest = async function runtTests(testString) {
      let error = false;
      for(let i = 0; i < testString.length; i++){

        try {
        const testPromise = new Promise((resolve, reject) => {
          try {
            if(`${code?.replaceAll(' ', '').trim()}` === ''){
              error = true;
            }

            let regionContent = `${(await fileService.getCurrentEditedFileFromCache(challenge, testing: testing)).replaceAll('\\', '\\\\').replaceAll('`', '\\`').replaceAll('\$', r'\$')}`;

            if(regionContent === 'nothing' && true === $hasRegion){
              error = true;
            }

            const test = eval(${tail.isNotEmpty ? 'tail + "\\n" +' : ""} testString[i]);
            resolve(test);
          } catch (e) {
            reject(e);
          }
        });

        const test = await testPromise;
      } catch (e) {
        $logFunction(testText[i]);
        break;
      } finally {
        if(!error && testString.length -1 == i){
          $logFunction('completed');
        }
      }
      }
    };

    document.querySelector('*').innerHTML = code;
    doc.__runTest(tests);
  </script>''';
      log(wut);
      return wut;
    } else if (ext == Ext.js) {
      String? head = challenge.files[0].head ?? '';
      String? tail = (challenge.files[0].tail ?? '').replaceAll('\\', '\\\\');

      return '''<script type="module">
      import * as __helpers from "https://unpkg.com/@freecodecamp/curriculum-helpers@1.1.0/dist/index.js";

      const assert = chai.assert;

      let code = `$code`;
      let head = `$head`;
      let tail = `$tail`;
      let tests = ${parseTest(challenge.tests)};

      const testText = ${challenge.tests.map((e) => '''`${e.instruction.replaceAll('`', '\\`')}`''').toList().toString()};
      function getUserInput(returnCase){
        switch(returnCase){
          case 'index':
            return `${scriptFile.isNotEmpty ? (await fileService.getExactFileFromCache(challenge, scriptFile[0], testing: testing)).replaceAll('\\', '\\\\').replaceAll('`', '\\`').replaceAll('\$', r'\$') : "empty string"}`;
          case 'editableContents':
            return `${scriptFile.isNotEmpty ? (await fileService.getExactFileFromCache(challenge, scriptFile[0], testing: testing)).replaceAll('\\', '\\\\').replaceAll('`', '\\`').replaceAll('\$', r'\$') : "empty string"}`;
          default:
            return code;
        }
      }

      try {
        for (let i = 0; i < tests.length; i++) {
          try {
            await eval(head + '\\n' + code + '\\n' + tail + '\\n' + tests[i]);
          } catch (e) {
            $logFunction(testText[i]);

            break;
          }

          if(i == tests.length - 1){
            $logFunction('completed');
          }

        }
      } catch (e) {
        $logFunction(e);
      }''';
    }
    return null;
  }
}
