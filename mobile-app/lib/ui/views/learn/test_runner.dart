import 'dart:convert';
import 'package:freecodecamp/enums/ext_type.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  Future<String?> getExactFileFromCache(
    Challenge challenge,
    ChallengeFile file,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cache = prefs.getString('${challenge.title}.${file.name}');

    return cache;
  }

  Future<String> getFirstFileFromCache(Challenge challenge, Ext ext) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<ChallengeFile> firstHtmlChallenge = challenge.files
        .where(
            (file) => file.ext == Ext.css ? ext == Ext.html : file.ext == ext)
        .toList();

    String fileContent =
        prefs.getString('${challenge.title}.${firstHtmlChallenge[0].name}') ??
            firstHtmlChallenge[0].contents;

    return fileContent;
  }

  Future<String> parseCssDocmentsAsStyleTags(
    Challenge challenge,
    String content,
  ) async {
    List<ChallengeFile> cssFiles =
        challenge.files.where((element) => element.ext == Ext.css).toList();
    List<String> cssFilesWithCache = [];
    List<String> tags = [];

    if (cssFiles.isNotEmpty) {
      for (ChallengeFile file in cssFiles) {
        String? cache = await getExactFileFromCache(challenge, file);
        String handledFile = cache ?? file.contents;

        cssFilesWithCache.add(handledFile);
      }

      for (String contents in cssFilesWithCache) {
        String tag = '<style> $contents </style>';
        tags.add(tag);
      }

      for (String tag in tags) {
        content += tag;
      }

      return content;
    }

    return content;
  }

  Future<bool> setWebViewContent(
    Challenge challenge,
    WebViewController webviewController,
  ) async {
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

    dom.Document scriptToNode =
        parse(await returnScript(challenge.files[0].ext, challenge));

    dom.Node bodyNode =
        scriptToNode.getElementsByTagName('BODY').first.children.isNotEmpty
            ? scriptToNode.getElementsByTagName('BODY').first.children.first
            : scriptToNode.getElementsByTagName('HEAD').first.children.first;
    document.body!.append(bodyNode);

    webviewController.loadUrl(Uri.dataFromString(document.outerHtml,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
    return true;
  }

  List<String> parseTest(List<ChallengeTest> test) {
    List<String> parsedTest = test
        .map((e) =>
            """`${e.javaScript.replaceAll('document', 'doc').replaceAll('\\', '\\\\').replaceAllMapped(RegExp(r'(\$\(.+?)\)'), (match) {
              return '${match.group(1)}, doc)';
            })}`""")
        .toList();

    return parsedTest;
  }

  String parseJavaScript(ChallengeFile file, String cacheContent) {
    if (file.ext == Ext.js) {
      String head = file.head ?? '';
      String tail = file.tail ?? '';

      return '$head\n$cacheContent\n$tail';
    } else {
      return '''Print.postMessage("That is funny, this is an interal error, please report to the dev")''';
    }
  }

  Future<String?> returnScript(Ext ext, Challenge challenge) async {
    if (ext == Ext.html || ext == Ext.css) {
      return '''  <script type="module">
    import * as __helpers from "https://unpkg.com/@freecodecamp/curriculum-helpers@1.1.0/dist/index.js";

    const code = `${await parseCssDocmentsAsStyleTags(challenge, await getFirstFileFromCache(challenge, ext))}`;
    const doc = new DOMParser().parseFromString(code, 'text/html')

    const assert = chai.assert;
    const tests = ${parseTest(challenge.tests)};
    const testText = ${challenge.tests.map((e) => '''"${e.instruction}"''').toList().toString()};

    doc.__runTest = async function runtTests(testString) {
      let error = false;
      for(let i = 0; i < testString.length; i++){

        try {
        const testPromise = new Promise((resolve, reject) => {
          try {
            const test = eval(testString[i]);
            resolve(test);
          } catch (e) {
            reject(e);
          }
        });

        const test = await testPromise;
        if (typeof test === "function") {
          await test(testString[i]);
        }
      } catch (e) {
       Print.postMessage(testText[i]);
       break;
      } finally {
        if(!error && testString.length -1 == i){
          Print.postMessage('completed');
        }
      }
      }
    };

    doc.__runTest(tests);
  </script>''';
    } else if (ext == Ext.js) {
      return '''<script type="module">
      import * as __helpers from "https://unpkg.com/@freecodecamp/curriculum-helpers@1.1.0/dist/index.js";

      const assert = chai.assert;

      let code = `${parseJavaScript(challenge.files[0], await getFirstFileFromCache(challenge, ext))}`;


      let tests = ${parseTest(challenge.tests)};

      const testText = ${challenge.tests.map((e) => '''"${e.instruction}"''').toList().toString()};

      try {
        for (let i = 0; i < tests.length; i++) {
          try {
            tests[i] = tests[i]
            console.log(tests[i]);
            await eval(code +  tests[i]);
          } catch (e) {
            Print.postMessage(testText[i]);
            break;
          }

          if(i == tests.length - 1){
            Print.postMessage('completed');
          }

        }
      } catch (e) {
        Print.postMessage(e);
      }''';
    }

    return null;
  }
}
