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

  Future<String> getFirstHTMLfileFromCache(
    Challenge challenge,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<ChallengeFile> firstHtmlChallenge =
        challenge.files.where((file) => file.ext == Ext.html).toList();

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

  void setWebViewContent(
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

    List<String> bodyScripts = [
      '''
  <script type="module">
    import * as __helpers from "https://unpkg.com/@freecodecamp/curriculum-helpers@1.1.0/dist/index.js";

    const code = `${await parseCssDocmentsAsStyleTags(challenge, await getFirstHTMLfileFromCache(challenge))}`;
    const doc = new DOMParser().parseFromString(code, 'text/html')

    const assert = chai.assert;
    const tests = ${parseTest(challenge.tests)};
    const testText = ${challenge.tests.map((e) => '''`${e.instruction}`''').toList().toString()}; 



  const completed = [];

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
    } finally {
      if(!error){
        completed.push(true);
        if(completed.length === testString.length){
          Print.postMessage('completed');
        }
      } 
    }

    doc.__runTest(tests);
  </script>
      '''
    ];

    for (String import in imports) {
      dom.Document importToNode = parse(import);

      dom.Node node =
          importToNode.getElementsByTagName('HEAD')[0].children.first;

      document.getElementsByTagName('HEAD')[0].append(node);
    }

    for (String bodyScript in bodyScripts) {
      dom.Document scriptToNode = parse(bodyScript);

      dom.Node bodyNode =
          scriptToNode.getElementsByTagName('BODY').first.children.isNotEmpty
              ? scriptToNode.getElementsByTagName('BODY').first.children.first
              : scriptToNode.getElementsByTagName('HEAD').first.children.first;
      document.body!.append(bodyNode);
    }

    webviewController.loadUrl(Uri.dataFromString(document.outerHtml,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
    //log(document.outerHtml);
  }

  List<String> parseTest(List<ChallengeTest> test) {
    List<String> parsedTest = test
        .map((e) =>
            """`${e.javaScript.replaceAll('document', 'doc').replaceAll('\\', '\\\\')}`""")
        .toList();

    return parsedTest;
  }
}
