import 'dart:convert';
import 'dart:developer';
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

  Future<String> getExactFileFromCache(
    Challenge challenge,
    ChallengeFile file, {
    bool testing = false,
  }) async {
    String? cache;

    if (testing) {
      cache = challenge.files
          .firstWhere((element) => element.name == file.name)
          .contents;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      cache = prefs.getString('${challenge.title}.${file.name}');
    }

    return cache ?? '';
  }

  Future<String> getFirstFileFromCache(
    Challenge challenge,
    Ext ext, {
    bool testing = false,
  }) async {
    String fileContent = '';

    if (testing) {
      List<ChallengeFile> firstHtmlChallenge = challenge.files
          .where((file) => (file.ext == Ext.css || file.ext == Ext.html)
              ? file.ext == Ext.html
              : file.ext == ext)
          .toList();
      fileContent = firstHtmlChallenge[0].contents;
    } else {
      List<ChallengeFile> firstHtmlChallenge = challenge.files
          .where((file) => (file.ext == Ext.css || file.ext == Ext.html)
              ? file.ext == Ext.html
              : file.ext == ext)
          .toList();
      SharedPreferences prefs = await SharedPreferences.getInstance();

      fileContent =
          prefs.getString('${challenge.title}.${firstHtmlChallenge[0].name}') ??
              firstHtmlChallenge[0].contents;
    }

    return fileContent;
  }

  Future<bool> cssFileIsLinked(
    String document,
    String cssFileName,
  ) async {
    dom.Document doc = parse(document);

    List<dom.Node> links = doc.getElementsByTagName('LINK');

    List<String> linkedFileNames = [];

    if (links.isNotEmpty) {
      for (dom.Node node in links) {
        if (node.attributes['href'] == null) continue;

        if (node.attributes['href']!.contains('/')) {
          linkedFileNames.add(node.attributes['href']!.split('/').last);
        } else if (node.attributes['href']!.isNotEmpty) {
          linkedFileNames.add(node.attributes['href'] as String);
        }
      }
    }

    return linkedFileNames.contains(cssFileName);
  }

  Future<String> parseCssDocmentsAsStyleTags(
    Challenge challenge,
    String content, {
    bool testing = false,
  }) async {
    List<ChallengeFile> cssFiles =
        challenge.files.where((element) => element.ext == Ext.css).toList();
    List<String> cssFilesWithCache = [];
    List<String> tags = [];

    if (cssFiles.isNotEmpty) {
      for (ChallengeFile file in cssFiles) {
        String? cache = await getExactFileFromCache(
          challenge,
          file,
          testing: testing,
        );

        if (!await cssFileIsLinked(
          content,
          '${file.name}.${file.ext.name}',
        )) {
          continue;
        }

        String handledFile = cache;

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

    dom.Document scriptToNode = parse(await returnScript(
      challenge.files[0].ext,
      challenge,
      testing: testing,
    ));

    dom.Node bodyNode =
        scriptToNode.getElementsByTagName('BODY').first.children.isNotEmpty
            ? scriptToNode.getElementsByTagName('BODY').first.children.first
            : scriptToNode.getElementsByTagName('HEAD').first.children.first;
    document.body!.append(bodyNode);

    if (!testing) {
      webviewController!.loadUrl(Uri.dataFromString(document.outerHtml,
              mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
          .toString());
    }
    log(document.outerHtml);
    return document.outerHtml;
  }

  List<String> parseTest(List<ChallengeTest> test, bool getComputedStyleFlag) {
    List<String> parsedTest = test
        .map((e) =>
            """`${e.javaScript.replaceAll('document', getComputedStyleFlag ? 'document' : 'doc').replaceAll('\\', '\\\\').replaceAll('`', '\\`').replaceAllMapped(RegExp(r'(\$\(.+?)\)'), (match) {
              return '${match.group(1)}, ${getComputedStyleFlag ? 'document' : 'doc'})';
            })}`""")
        .toList();

    return parsedTest;
  }

  String parseJavaScript(
    ChallengeFile file,
    String cacheContent, {
    bool testing = false,
  }) {
    if (file.ext == Ext.js) {
      String head = file.head ?? '';
      String tail = file.tail ?? '';

      return '$head\n$cacheContent\n$tail';
    } else {
      return '''${testing ? 'console.log' : 'Print.postMessage'}("That is funny, this is an interal error, please report to the dev")''';
    }
  }

  Future<String?> returnScript(
    Ext ext,
    Challenge challenge, {
    bool testing = false,
  }) async {
    String logFunction = testing ? 'console.log' : 'Print.postMessage';
    bool getComputedStyleFlag = false;

    for (var t in challenge.tests) {
      if (t.javaScript.contains('window.getComputedStyle')) {
        getComputedStyleFlag = true;
        break;
      }
    }

    if (ext == Ext.html || ext == Ext.css) {
      return '''  <script type="module">
    import * as __helpers from "https://unpkg.com/@freecodecamp/curriculum-helpers@1.1.0/dist/index.js";

    const code = `${await parseCssDocmentsAsStyleTags(challenge, await getFirstFileFromCache(challenge, ext, testing: testing), testing: testing)}`;
    const doc = new DOMParser().parseFromString(code, 'text/html')

    const assert = chai.assert;
    const tests = ${parseTest(challenge.tests, getComputedStyleFlag)};
    const testText = ${challenge.tests.map((e) => '''"${e.instruction.replaceAll('"', '\\"')}"''').toList().toString()};

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
       $logFunction(testText[i]);
       break;
      } finally {
        if(!error && testString.length -1 == i){
          $logFunction('completed');
        }
      }
      }
    };

    ${getComputedStyleFlag ? "document.querySelector('*').innerHTML = code;" : ''}
    doc.__runTest(tests);
  </script>''';
    } else if (ext == Ext.js) {
      return '''<script type="module">
      import * as __helpers from "https://unpkg.com/@freecodecamp/curriculum-helpers@1.1.0/dist/index.js";

      const assert = chai.assert;

      let code = `${parseJavaScript(challenge.files[0], await getFirstFileFromCache(challenge, ext, testing: testing))}`;


      let tests = ${parseTest(challenge.tests, getComputedStyleFlag)};

      const testText = ${challenge.tests.map((e) => '''"${e.instruction}"''').toList().toString()};

      try {
        for (let i = 0; i < tests.length; i++) {
          try {
            tests[i] = tests[i]
            console.log(tests[i]);
            await eval(code +  tests[i]);
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
