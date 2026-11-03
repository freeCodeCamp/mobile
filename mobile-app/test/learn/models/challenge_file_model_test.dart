import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/learn/models/challenge_file_model.dart';

ChallengeFile _file(Ext ext) =>
    ChallengeFile(ext: ext, name: 'file', contents: '', fileKey: 'file');

void main() {
  group('ChallengeFile.isScript', () {
    test('should be true for js, jsx and python files', () {
      expect(_file(Ext.js).isScript, isTrue);
      expect(_file(Ext.jsx).isScript, isTrue);
      expect(_file(Ext.py).isScript, isTrue);
    });

    test('should be false for html and css files', () {
      expect(_file(Ext.html).isScript, isFalse);
      expect(_file(Ext.css).isScript, isFalse);
    });
  });
}
