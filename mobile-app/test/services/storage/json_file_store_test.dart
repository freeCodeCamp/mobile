import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/service/storage/json_file_store.dart';
import 'package:path/path.dart' as path;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('JsonFileStore', () {
    late Directory tempDir;
    late File storeFile;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('fcc_json_store_test_');
      storeFile = File(path.join(tempDir.path, 'storage', 'store.json'));
    });

    tearDown(() {
      try {
        tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    test('ensureExists creates file with default value', () async {
      final store = JsonFileStore<int>(
        file: storeFile,
        defaultValue: 7,
        fromJson: (json) => json['value'],
        toJson: (value) => {'value': value},
      );

      expect(await storeFile.exists(), isFalse);
      await store.ensureExists();
      expect(await storeFile.exists(), isTrue);

      final readBack = await store.read();
      expect(readBack, 7);
    });

    test('write/read round trips typed value', () async {
      final store = JsonFileStore<List<String>>(
        file: storeFile,
        defaultValue: [],
        fromJson: (json) {
          final raw = json['items'];
          if (raw is! List) return [];
          return raw.map((e) => e.toString()).toList();
        },
        toJson: (value) => {'items': value},
      );

      await store.write(const ['a', 'b']);
      final readBack = await store.read();
      expect(readBack, ['a', 'b']);
    });

    test('read returns default when file contains invalid JSON', () async {
      final store = JsonFileStore<String>(
        file: storeFile,
        defaultValue: 'default',
        fromJson: (json) => json['value'],
        toJson: (value) => {'value': value},
      );

      await store.ensureExists();
      await storeFile.writeAsString('{not json', flush: true);

      final readBack = await store.read();
      expect(readBack, 'default');
    });

    test('updateAndWrite persists updater result', () async {
      final store = JsonFileStore<int>(
        file: storeFile,
        defaultValue: 0,
        fromJson: (json) => json['value'],
        toJson: (value) => {'value': value},
      );

      await store.updateAndWrite((current) async => current + 1);
      await store.updateAndWrite((current) async => current + 2);

      final readBack = await store.read();
      expect(readBack, 3);
    });

    test('updateAndWrite serializes concurrent updates', () async {
      final store = JsonFileStore<int>(
        file: storeFile,
        defaultValue: 0,
        fromJson: (json) => json['value'],
        toJson: (value) => {'value': value},
      );

      await Future.wait(
        List.generate(
          25,
          (_) => store.updateAndWrite((current) async => current + 1),
        ),
      );

      final readBack = await store.read();
      expect(readBack, 25);
    });

    test('does not leave .tmp file after write', () async {
      final store = JsonFileStore<int>(
        file: storeFile,
        defaultValue: 0,
        fromJson: (json) => json['value'],
        toJson: (value) => {'value': value},
      );

      await store.write(1);

      final tmpFile = File('${storeFile.path}.tmp');
      expect(await tmpFile.exists(), isFalse);
    });
  });
}
