import 'dart:convert';
import 'dart:io';

typedef JsonMap = Map<String, dynamic>;

class JsonFileStore {
  JsonFileStore({required this.file, required JsonMap defaultValue})
      : _defaultValue = defaultValue;

  final File file;
  final JsonMap _defaultValue;

  Future<void> ensureExists() async {
    if (await file.exists()) return;
    await file.parent.create(recursive: true);
    await _atomicWrite(_defaultValue);
  }

  Future<JsonMap> read() async {
    await ensureExists();
    final contents = await file.readAsString();
    if (contents.trim().isEmpty) {
      return Map<String, dynamic>.from(_defaultValue);
    }

    final decoded = jsonDecode(contents);
    if (decoded is JsonMap) {
      return decoded;
    }

    return Map<String, dynamic>.from(_defaultValue);
  }

  Future<void> write(JsonMap value) async {
    await ensureExists();
    await _atomicWrite(value);
  }

  Future<T> update<T>(Future<T> Function(JsonMap current) updater) {
    return _synchronized(() async {
      final current = await read();
      final result = await updater(current);
      return result;
    });
  }

  Future<void> updateAndWrite(
      Future<JsonMap> Function(JsonMap current) updater) {
    return _synchronized(() async {
      final current = await read();
      final updated = await updater(current);
      await write(updated);
    });
  }

  Future<void> _atomicWrite(JsonMap value) async {
    await file.parent.create(recursive: true);

    final temp = File('${file.path}.tmp');
    final encoded = const JsonEncoder.withIndent('  ').convert(value);
    await temp.writeAsString(encoded, flush: true);

    if (await file.exists()) {
      await file.delete();
    }
    await temp.rename(file.path);
  }

  Future<void> _tail = Future<void>.value();

  Future<T> _synchronized<T>(Future<T> Function() action) {
    final next = _tail.then((_) => action());
    _tail = next.then((_) {}).catchError((_) {});
    return next;
  }
}
