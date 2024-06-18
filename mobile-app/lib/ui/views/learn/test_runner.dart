import 'dart:convert';
import 'dart:developer';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/enums/ext_type.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/service/learn/learn_file_service.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:stacked/stacked.dart';

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
    InAppWebViewController? controller,
    bool testing = false,
  }) async {
    Document document = Document();
    document = parse('');

    List<String> imports = [
      '<script src="https://unpkg.com/chai@4.3.10/chai.js"></script>',
      '<script src="https://unpkg.com/mocha/mocha.js"></script>',
      '<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>',
      '<link rel="stylesheet" href="https://unpkg.com/mocha/mocha.css" />'
    ];

    for (String import in imports) {
      Document importToNode = parse(import);

      Node node = importToNode.getElementsByTagName('HEAD')[0].children.first;

      document.getElementsByTagName('HEAD')[0].append(node);
    }

    String script = await returnScript(
          challenge.files[0].ext,
          challenge,
          testing: testing,
        ) ??
        '';

    Document parsedScript = parse(script);
    Node scriptNode = parsedScript.getElementsByTagName('SCRIPT')[0];
    document.head!.append(scriptNode);

    log(document.outerHtml);

    if (!testing) {
      controller!.loadData(
        data: document.outerHtml,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8').toString(),
      );
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

  // This Function parses the CODE FROM THE USER into one HTML file. This function
  // itself has nothing to do with parsing the test-runner document.

  // CODE from the user is concatenated: HTML,CSS,JS and does not get executed;
  // meaning it is all text; Example: https://pastebin.com/v75dQ1xa

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

    firstHTMlfile = fileService.removeExcessiveScriptsInHTMLdocument(
      firstHTMlfile,
    );

    // Concatenate CSS
    List<ChallengeFile> cssFiles =
        challenge.files.where((file) => file.ext == Ext.css).toList();

    if (cssFiles.isNotEmpty) {
      String file = await fileService.getExactFileFromCache(
        challenge,
        cssFiles[0],
      );

      firstHTMlfile += file;
    }

    List<ChallengeFile> jsFiles =
        challenge.files.where((file) => file.ext == Ext.js).toList();

    if (jsFiles.isNotEmpty) {
      String file = await fileService.getExactFileFromCache(
        challenge,
        jsFiles[0],
      );

      firstHTMlfile += file;
    }

    return firstHTMlfile;
  }

  // This function parses the JavaScript code so that it has a head and tail (code)
  // It is used in the returnScript function to correctly parse JavaScript.
  // ONLY EXECUTES WHEN JAVASCRIPT ONLY CHALLENGE

  Future<String> javaScritpFlow(
    Challenge challenge,
    Ext ext, {
    bool testing = false,
  }) async {
    var content = testing
        ? challenge.files[0].contents
        : await fileService.getFirstFileFromCache(challenge, Ext.js);

    content = fileService.changeActiveFileLinks(
      content,
    );

    return content
        .replaceAll('\\', '\\\\')
        .replaceAll('`', '\\`')
        .replaceAll('\$', r'\$');
  }

  // This returns the script that needs to be run in the DOM. If the test in the document fail it will
  // log the failed test to the console. If the test have been completed, it will return "completed" in a
  // console.log

  Future<String?> returnScript(
    Ext ext,
    Challenge challenge, {
    bool testing = false,
  }) async {
    String? code;

    if (ext == Ext.html || ext == Ext.css) {
      code = await htmlFlow(
        challenge,
        ext,
        testing: testing,
      );
    }

    if (ext == Ext.html || ext == Ext.css) {
      String tail = challenge.files[0].tail ?? '';

      return '''<script type="module" id="fcc-script">
    import * as __helpers from "https://www.unpkg.com/@freecodecamp/curriculum-helpers@2.0.3/dist/index.mjs";

    const code = `$code`;
    const doc = new DOMParser().parseFromString(code, 'text/html');

    ${tail.isNotEmpty ? """
    const parseTail  = new DOMParser().parseFromString(`${tail.replaceAll('/', '\\/')}`,'text/html');
    const tail = parseTail.getElementsByTagName('SCRIPT')[0].innerHTML;
    """ : ''}

    const assert = chai.assert;
    const tests = ${parseTest(challenge.tests)};
    const testText = ${challenge.tests.map((e) => '''`${e.instruction.replaceAll('"', '\\"').replaceAll('\n', '')}`''').toList().toString()};

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
                const test = eval(${tail.isNotEmpty ? 'tail + "\\n" +' : ""} testString[i]);
                resolve(test);
              } catch (e) {
                reject(e);
              }
            });
            await testPromise;
        } catch (e) {
            error = true;
            console.log('testMSG: ' + testText[i]);
            break;
        }
      }
      if(!error){
        console.log('completed');
      }
    };

    document.querySelector('*').innerHTML = code;
    doc.__runTest(tests);
  </script>''';
    }

    return null;
  }
}
