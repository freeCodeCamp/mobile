import 'package:freecodecamp/enums/ext_type.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:html/dom.dart' as dom;

class LearnFileService {
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
          .firstWhere((element) => element.name == file.name)
          .contents;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      cache = prefs.getString('${challenge.id}.${file.name}');
    }

    return cache ?? file.contents;
  }

  void saveFileInCache(
    Challenge challenge,
    String currentSelectedFile,
    String value,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('${challenge.id}.$currentSelectedFile', value);
  }

  // This funciton returns the first file content with the given extension from the
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
            '${challenge.id}.${firstChallenge[0].name}',
          ) ??
          firstChallenge[0].contents;
    }

    return fileContent;
  }

  // this function will get the current file which is being edited.
  // otherwise we can not detect which file is currently being worked on. This is only for the new RWD.

  Future<String> getCurrentEditedFileFromCache(
    Challenge challenge, {
    bool testing = false,
  }) async {
    List<ChallengeFile>? fileWithEditableRegion = challenge.files
        .where((file) => file.editableRegionBoundaries.isNotEmpty)
        .toList();

    String? cache;

    if (testing) {
      return fileWithEditableRegion.isNotEmpty
          ? fileWithEditableRegion[0].contents
          : challenge.files[0].contents;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (fileWithEditableRegion.isNotEmpty) {
      cache = prefs.getString(
            '${challenge.id}.${fileWithEditableRegion[0].name}',
          ) ??
          '';

      if (cache.isNotEmpty) {
        return removeExcessiveScriptsInHTMLdocument(cache);
      } else {
        return fileWithEditableRegion[0].contents;
      }
    } else {
      return challenge.files[0].contents;
    }
  }

  // This function checks if the given document contains any link elements.
  // If so check if the css file name corresponds with the names put in the array.
  // If the file is linked return true.

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

  // This function puts the given css content in the same file as the HTML content.
  // It will parse the current CSS content into style tags only if it is linked.
  // If there is nothing to parse it will return the plain content document.

  Future<String> parseCssDocmentsAsStyleTags(
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

        if (!await cssFileIsLinked(content, '${file.name}.${file.ext.name}')) {
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

  String removeExcessiveScriptsInHTMLdocument(String file) {
    dom.Document document = parse(file);
    List<dom.Element> elements = document.querySelectorAll('SCRIPT');

    for (int i = 0; i < elements.length; i++) {
      elements[i].remove();
    }

    file = document.outerHtml.toString();

    return file;
  }
}
