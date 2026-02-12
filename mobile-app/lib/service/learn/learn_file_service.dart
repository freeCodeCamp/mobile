import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:freecodecamp/enums/ext_type.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/ui/views/learn/test_runner.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LearnFileService {
  String getFullFileName(ChallengeFile file) {
    return '${file.name}.${file.ext.value}';
  }

  // This function returns a specific file content from the cache.
  // If testing is enabled on the function it will return
  // the first file with the given file name.

  Future<String> getExactFileFromCache(
    Challenge challenge,
    ChallengeFile file, {
    bool testing = false,
  }) async {
    String? cache;

    if (testing) {
      cache = challenge.files
          .firstWhere(
              (element) => getFullFileName(element) == getFullFileName(file))
          .contents;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      cache = prefs.getString('${challenge.id}.${getFullFileName(file)}');
    }

    return cache ?? file.contents;
  }

  void saveFileInCache(
    Challenge challenge,
    String currentSelectedFile,
    String value,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('${challenge.id}.$currentSelectedFile', value);
  }

  // This function returns the first file content with the given extension from the
  // cache. If testing is enabled it will return the file directly from the challenge.
  // If a CSS extension is put as a parameter it will return the first HTML file instead.

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
      List<ChallengeFile> firstChallenge = challenge.files
          .where((file) => (file.ext == Ext.css || file.ext == Ext.html)
              ? file.ext == Ext.html
              : file.ext == ext)
          .toList();
      SharedPreferences prefs = await SharedPreferences.getInstance();

      fileContent = prefs.getString(
            '${challenge.id}.${getFullFileName(firstChallenge[0])}',
          ) ??
          firstChallenge[0].contents;
    }

    return fileContent;
  }

  // this function will get the current file which is being edited.
  // otherwise we can not detect which file is currently being worked on. This is only for the new RWD.

  Future<ChallengeFile> getCurrentEditedFileFromCache(
    Challenge challenge, {
    bool testing = false,
  }) async {
    List<ChallengeFile>? fileWithEditableRegion = challenge.files
        .where((file) => file.editableRegionBoundaries.isNotEmpty)
        .toList();

    String? cache;

    if (testing) {
      return fileWithEditableRegion.isNotEmpty
          ? fileWithEditableRegion[0]
          : challenge.files[0];
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (fileWithEditableRegion.isNotEmpty) {
      cache = prefs.getString(
            '${challenge.id}.${getFullFileName(fileWithEditableRegion[0])}',
          ) ??
          '';

      if (cache.isNotEmpty) {
        ChallengeFile file = fileWithEditableRegion[0];

        return ChallengeFile(
          ext: file.ext,
          name: file.name,
          editableRegionBoundaries: file.editableRegionBoundaries,
          contents: cache,
          history: file.history,
          fileKey: file.fileKey,
        );
      } else {
        return fileWithEditableRegion[0];
      }
    } else {
      return challenge.files[0];
    }
  }

  // This function checks if the given document contains any link elements.
  // If so check if the css file name corresponds with the names put in the array.
  // If the file is linked return true.

  Future<bool> cssFileIsLinked(
    String document,
    String cssFileName,
  ) async {
    Document doc = parse(document);

    List<Node> links = doc.getElementsByTagName('LINK');

    List<String> linkedFileNames = [];

    if (links.isNotEmpty) {
      for (Node node in links) {
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

  // This function checks if the given document contains any script elements.
  // If so check if the js file name corresponds with the names put in the array.
  // If the file is linked return true.

  Future<bool> jsFileIsLinked(
    String document,
    String jsFileName,
  ) async {
    Document doc = parse(document);

    List<Node> scripts = doc.getElementsByTagName('SCRIPT');

    List<String> linkedFileNames = [];

    if (scripts.isNotEmpty) {
      for (Node node in scripts) {
        if (node.attributes['src'] == null) continue;

        if (node.attributes['src']!.contains('/')) {
          linkedFileNames.add(node.attributes['src']!.split('/').last);
        } else if (node.attributes['src']!.isNotEmpty) {
          linkedFileNames.add(node.attributes['src'] as String);
        }
      }
    }

    return linkedFileNames.contains(jsFileName);
  }

  // This function puts the given css content in the same file as the HTML content.
  // It will parse the current CSS content into style tags only if it is linked.
  // If there is nothing to parse it will return the plain content document.

  Future<String> parseCssDocumentsAsStyleTags(
    Challenge challenge,
    String content, {
    bool testing = false,
  }) async {
    List<ChallengeFile> cssFiles = challenge.files
        .where(
          (element) => element.ext == Ext.css,
        )
        .toList();
    List<String> cssFilesWithCache = [];
    List<String> tags = [];

    if (cssFiles.isNotEmpty) {
      for (ChallengeFile file in cssFiles) {
        String? cache = await getExactFileFromCache(
          challenge,
          file,
          testing: testing,
        );

        if (!await cssFileIsLinked(content, getFullFileName(file))) {
          continue;
        }

        String handledFile = cache;

        cssFilesWithCache.add(handledFile);
      }

      for (String contents in cssFilesWithCache) {
        String tag = '<style class="fcc-injected-styles"> $contents </style>';
        tags.add(tag);
      }

      for (String tag in tags) {
        content += tag;
      }

      return content;
    }

    return content;
  }

  // This function puts the given js content in the same file as the HTML content.
  // It will parse the current JS content into script tags only if it is linked.
  // If there is nothing to parse it will return the plain content document.

  Future<String> parseJsDocumentsAsScriptTags(
    Challenge challenge,
    String challengeContent,
    InAppWebViewController? babelController, {
    bool testing = false,
  }) async {
    List<ChallengeFile> jsFiles = challenge.files
        .where(
          (element) => element.ext == Ext.js,
        )
        .toList();

    if (jsFiles.isNotEmpty) {
      for (ChallengeFile file in jsFiles) {
        String filename = getFullFileName(file);
        String? fileContents = await getExactFileFromCache(
          challenge,
          file,
          testing: testing,
        );

        if (!await jsFileIsLinked(challengeContent, filename)) {
          continue;
        }

        if (babelController == null) {
          throw Exception('Babel controller is required to transpile JS code.');
        }

        final babelRes = await babelController.callAsyncJavaScript(
          functionBody: ScriptBuilder.transpileScript,
          arguments: {'code': fileContents},
        );

        if (babelRes?.error != null) {
          throw Exception('Babel transpilation failed: ${babelRes?.error}');
        }

        final result = babelRes?.value as Map<dynamic, dynamic>?;
        if (result?['success'] == false) {
          throw Exception('Babel transpilation failed: ${result?['error']}');
        }
        fileContents = result?['code'];

        Document document = parse(challengeContent);

        Element scriptElement =
            document.querySelector('script[src\$="$filename"]')!;

        scriptElement.text = fileContents;

        challengeContent = document.outerHtml;
      }
    }

    return challengeContent;
  }

  String changeActiveFileLinks(String file) {
    Document document = parse(file);

    List<Element> linkElements = document.querySelectorAll('LINK');
    List<Element> scripElements = document.querySelectorAll('SCRIPT');

    if (scripElements.isEmpty && linkElements.isEmpty) return file;

    for (int i = 0; i < linkElements.length; i++) {
      String? hrefValue = linkElements[i].attributes['href'];

      if (hrefValue == null) continue;

      if (hrefValue == 'styles.css' || hrefValue == './styles.css') {
        linkElements[i].attributes.remove('href');

        linkElements[i].attributes['data-href'] = 'styles.css';
      }
    }

    for (int i = 0; i < scripElements.length; i++) {
      String? srcValue = scripElements[i].attributes['src'];

      if (srcValue == null) continue;

      if (srcValue == 'script.js' || srcValue == './script.js') {
        scripElements[i].attributes.remove('src');

        scripElements[i].attributes['data-src'] = 'script.js';
      }
    }
    return document.outerHtml;
  }
}
