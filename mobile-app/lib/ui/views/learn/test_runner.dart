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

    log(document.outerHtml);
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

  Future<String> parseCodeVariable(
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
        testing: testing,
      );

      firstHTMlfile += file;
    }

    List<ChallengeFile> jsFiles =
        challenge.files.where((file) => file.ext == Ext.js).toList();

    if (jsFiles.isNotEmpty) {
      String file = await fileService.getExactFileFromCache(
        challenge,
        jsFiles[0],
        testing: testing,
      );

      firstHTMlfile += file;
    }

    return firstHTMlfile;
  }

  // parsed frame document (also now as Iframe) this will be the document that
  // is tested against. Meaning the __runtTest function is assigned to the document
  // object.

  Future<String> parseFrameDocument(
    Challenge challenge,
    Ext ext, {
    testing = false,
  }) async {
    String html = await fileService.getFirstFileFromCache(
      challenge,
      ext,
      testing: testing,
    );

    Document document = parse(html);

    List<ChallengeFile> cssFiles =
        challenge.files.where((file) => file.ext == Ext.css).toList();
    List<ChallengeFile> jsFiles =
        challenge.files.where((file) => file.ext == Ext.js).toList();

    if (cssFiles.isNotEmpty) {
      String css = await fileService.getExactFileFromCache(
        challenge,
        cssFiles[0],
        testing: testing,
      );

      List<Element> styleElements = document.getElementsByTagName('link');

      for (Element element in styleElements) {
        if (element.attributes.containsKey('href')) {
          if (element.attributes['href'] == 'styles.css') {
            element.attributes.removeWhere((key, value) => key == 'href');
            element.attributes.addAll({'data-href': 'styles.css'});
          } else if (element.attributes['href'] == './styles.css') {
            element.attributes.removeWhere((key, value) => key == 'href');
            element.attributes.addAll({'data-href': './styles.css'});
          }
        }
      }

      Element style = document.createElement('style');
      style.innerHtml = css;
      style.id = 'fcc-injected-styles';

      log(style.attributes.entries.toString());

      document.head!.append(style);
    }

    if (jsFiles.isNotEmpty) {
      String js = await fileService.getExactFileFromCache(
        challenge,
        jsFiles[0],
        testing: testing,
      );

      List<Element> scripts = document.getElementsByTagName('script');

      for (Element script in scripts) {
        script.remove();
      }
      // We need to create a custom named tag instead of using the default script
      // tag as the Dart html parser breaks when parsing script tags that are inside
      // JavaScript strig variables. E.g. for variable "doc".
      Element script = document.createElement('custom-inject');
      script.innerHtml = js;
      script.attributes.addAll({'data-src': './script.js'});

      document.body!.append(script);
    }

    return document.outerHtml.toString();
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

    // TODO: Have to update code generation to handle only JS files
    // if (ext == Ext.html || ext == Ext.css) {
    code = await parseCodeVariable(
      challenge,
      ext,
      testing: testing,
    );
    // }

    // if (ext == Ext.html || ext == Ext.css) {
    String tail = challenge.files[0].tail ?? '';

    return '''<script type="module" id="fcc-script">
    import * as __helpers from "https://www.unpkg.com/@freecodecamp/curriculum-helpers@2.0.3/dist/index.mjs";

    const code = `$code`;
    const doc = new DOMParser().parseFromString(`${await parseFrameDocument(challenge, ext, testing: testing)}`, 'text/html');

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
      class CustomScriptElement extends HTMLElement {
        constructor() {
          super();
        }
      }
      customElements.define("custom-inject", CustomScriptElement);
      const contentOfCustomElement = doc.querySelector("custom-inject");
      const scriptElement = doc.createElement("script");

      scriptElement.innerHTML = contentOfCustomElement.innerHTML;
      contentOfCustomElement.replaceWith(scriptElement);

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

    document.querySelector('*').innerHTML = doc.querySelector('*').innerHTML;
    doc.__runTest(tests);
  </script>''';
    // }

    // return null;
  }
}
