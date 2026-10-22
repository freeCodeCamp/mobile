import 'dart:math';

import 'package:freecodecamp/learn/models/challenge_file_model.dart';
import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/learn/repositories/prefs_repository.dart';
import 'package:freecodecamp/learn/services/test_runner_service.dart';
import 'package:html/parser.dart' show parse;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'code_service.g.dart';

typedef Transpile = Future<String> Function(String code);

@riverpod
LearnCodeService learnCodeService(Ref ref) =>
    LearnCodeService(ref.watch(learnPrefsRepositoryProvider));

// NOTE: Keys match v7, so code saved before the update is restored.
class LearnCodeService {
  LearnCodeService(this._prefs);

  final LearnPrefsRepository _prefs;

  // NOTE: phone_ide stores the editable region under this key itself.
  static String editorPath(Challenge challenge, ChallengeFile file) =>
      '/${challenge.id}/${file.fileName}';

  String _key(Challenge challenge, ChallengeFile file) =>
      '${challenge.id}.${file.fileName}';

  Future<String> contents(Challenge challenge, ChallengeFile file) async =>
      await _prefs.read(_key(challenge, file)) ?? file.contents;

  Future<void> save(Challenge challenge, ChallengeFile file, String text) =>
      _prefs.write(_key(challenge, file), text);

  Future<void> reset(Challenge challenge) async {
    for (final file in challenge.challengeFiles) {
      await _prefs.remove(_key(challenge, file));
      await _prefs.remove(editorPath(challenge, file));
    }
  }

  // NOTE: Matches fCC's buildSourceMap: each file's region ('' without one), newline-joined.
  Future<String> editableContents(Challenge challenge) async => [
    for (final file in challenge.challengeFiles)
      await _editableLines(challenge, file),
  ].join('\n');

  // NOTE: Mirrors how phone_ide splits the file, using the region it saved.
  Future<String> _editableLines(Challenge challenge, ChallengeFile file) async {
    if (file.editableRegionBoundaries.isEmpty) return '';

    final saved = await _prefs.read(editorPath(challenge, file));
    final [start, end] =
        saved?.split(':').map(int.parse).toList() ??
        file.editableRegionBoundaries;
    final lines = (await contents(challenge, file)).split('\n');
    final from = min(start, lines.length);
    return lines
        .sublist(from, max(from, min(end - 1, lines.length)))
        .join('\n');
  }

  Future<List<Map<String, dynamic>>> filesPayload(Challenge challenge) async =>
      [
        for (final file in challenge.challengeFiles)
          {
            'contents': await contents(challenge, file),
            'ext': file.ext.name,
            'history': file.history,
            'key': file.fileKey,
            'name': file.name,
          },
      ];

  Future<String> combinedCode(Challenge challenge) async => [
    for (final file in challenge.challengeFiles)
      await contents(challenge, file),
  ].join('\n');

  Future<String> filesMarkdown(Challenge challenge) async {
    final many = challenge.challengeFiles.length > 1;
    final buffer = StringBuffer('\n');
    for (final file in challenge.challengeFiles) {
      final header = many ? '/* file: ${file.fileName} */\n' : '';
      buffer.write(
        '```${file.ext.name}\n$header${await contents(challenge, file)}\n```\n\n',
      );
    }
    return buffer.toString();
  }

  Future<String> userCode(Challenge challenge, Transpile transpile) async =>
      switch (workerTypeOf(challenge.challengeType)) {
        'javascript' => transpile(await _first(challenge, Ext.js)),
        'python' => _first(challenge, Ext.py),
        _ => _activateLinks(await _inlineLinked(challenge, transpile)),
      };

  Future<String> previewHtml(Challenge challenge, Transpile transpile) async {
    final document = parse(await _inlineLinked(challenge, transpile));
    document.head?.append(
      parse(
        '<meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport">',
      ).querySelector('meta')!,
    );
    return document.outerHtml;
  }

  Future<String> _first(Challenge challenge, Ext ext) => contents(
    challenge,
    challenge.challengeFiles.firstWhere((f) => f.ext == ext),
  );

  Future<String> _inlineLinked(Challenge challenge, Transpile transpile) async {
    var html = await _first(challenge, Ext.html);

    final linkedCss = _linked(html, 'link', 'href');
    for (final file in challenge.challengeFiles.where(
      (f) => f.ext == Ext.css,
    )) {
      if (!linkedCss.contains(file.fileName)) continue;
      html +=
          '<style class="fcc-injected-styles"> ${await contents(challenge, file)} </style>';
    }

    final linkedJs = _linked(html, 'script', 'src');
    for (final file in challenge.challengeFiles.where((f) => f.ext == Ext.js)) {
      final name = file.fileName;
      if (!linkedJs.contains(name)) continue;

      final document = parse(html);
      document.querySelector('script[src\$="$name"]')!.text = await transpile(
        await contents(challenge, file),
      );
      html = document.outerHtml;
    }

    return html;
  }

  Set<String> _linked(String html, String tag, String attribute) => {
    for (final element in parse(html).getElementsByTagName(tag))
      if (element.attributes[attribute] case final value? when value.isNotEmpty)
        value.split('/').last,
  };

  String _activateLinks(String html) {
    final document = parse(html);
    for (final (tag, attribute, name) in [
      ('link', 'href', 'styles.css'),
      ('script', 'src', 'script.js'),
    ]) {
      for (final element in document.querySelectorAll(tag)) {
        final value = element.attributes[attribute];
        if (value != name && value != './$name') continue;
        element.attributes
          ..remove(attribute)
          ..['data-$attribute'] = name;
      }
    }
    return document.outerHtml;
  }
}
