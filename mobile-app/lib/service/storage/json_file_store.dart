import 'dart:convert';
import 'dart:io';

typedef JsonMap = Map<String, dynamic>;

class JsonFileStore<T> {
  JsonFileStore({
    required this.file,
    required T defaultValue,
    required T Function(JsonMap json) fromJson,
    required JsonMap Function(T value) toJson,
  })  : _defaultValue = defaultValue,
        _fromJson = fromJson,
        _toJson = toJson;

  final File file;
  final T _defaultValue;
  final T Function(JsonMap json) _fromJson;
  final JsonMap Function(T value) _toJson;

  Future<void> ensureExists() async {
    if (await file.exists()) return;
    await file.parent.create(recursive: true);
    await _atomicWrite(_toJson(_defaultValue));
  }

  Future<T> read() async {
    await ensureExists();
    final contents = await file.readAsString();
    if (contents.trim().isEmpty) {
      return _defaultValue;
    }

    try {
      final decoded = jsonDecode(contents);
      if (decoded is Map) {
        return _fromJson(JsonMap.from(decoded));
      }
    } catch (_) {
      // Ignore and return default.
    }

    return _defaultValue;
  }

  Future<void> write(T value) async {
    await ensureExists();
    await _atomicWrite(_toJson(value));
  }

  Future<void> updateAndWrite(Future<T> Function(T current) updater) {
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

  Future<void> _synchronized(Future<void> Function() action) {
    final next = _tail.then((_) => action());
    _tail = next.then((_) {}).catchError((_) {});
    return next;
  }
}
