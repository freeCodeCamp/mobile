import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freecodecamp/learn/models/location_model.dart';
import 'package:freecodecamp/learn/repositories/prefs_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_service.g.dart';

@riverpod
LearnLocationService learnLocationService(Ref ref) => LearnLocationService(
  ref.watch(learnPrefsRepositoryProvider),
  developmentMode:
      dotenv.isInitialized &&
      dotenv.getBool('DEVELOPMENT_MODE', fallback: false),
);

class LearnLocationService {
  LearnLocationService(this._prefs, {required bool developmentMode})
    : _environment = developmentMode ? 'dev' : 'org';

  final LearnPrefsRepository _prefs;
  final String _environment;
  final _locations = <String, LearnLocation?>{};
  final _reads = <String, Future<LearnLocation?>>{};
  final _writes = <String, Future<void>>{};
  final _visits = <String, int>{};

  String _key(String userId) =>
      'learn_location.v1.$_environment.${Uri.encodeComponent(userId)}';

  LearnLocation? current(String userId) => _locations[_key(userId)];

  int beginVisit(String userId) {
    final key = _key(userId);
    return _visits[key] = (_visits[key] ?? 0) + 1;
  }

  Future<LearnLocation?> load(String userId) async {
    if (userId.trim().isEmpty) return null;
    final key = _key(userId);
    if (_locations.containsKey(key)) return _locations[key];
    return _reads.putIfAbsent(key, () => _read(key));
  }

  Future<LearnLocation?> _read(String key) async {
    LearnLocation? saved;
    try {
      final raw = await _prefs.read(key);
      if (raw != null) {
        final location = LearnLocation.fromJson(
          jsonDecode(raw) as Map<String, dynamic>,
        );
        if (_valid(location)) saved = location;
      }
    } catch (_) {
      // A damaged preference must not prevent opening a lesson.
    }
    // A lesson opened while this read was pending is more recent than disk.
    _locations.putIfAbsent(key, () => saved);
    _reads.remove(key);
    return _locations[key];
  }

  Future<void> remember(
    String userId,
    LearnLocation location, {
    int? visitToken,
  }) async {
    if (userId.trim().isEmpty || !_valid(location)) return;
    final key = _key(userId);
    if (visitToken != null && _visits[key] != visitToken) return;
    if (_locations[key] == location) return;
    _locations[key] = location;
    final pending = (_writes[key] ?? Future<void>.value()).then((_) async {
      try {
        await _prefs.write(key, jsonEncode(location.toJson()));
      } catch (_) {
        // Keep the in-memory location when local persistence is unavailable.
      }
    });
    _writes[key] = pending;
    await pending;
    if (identical(_writes[key], pending)) _writes.remove(key);
  }

  Future<void> rememberIfUnchanged(
    String userId,
    LearnLocation location,
    LearnLocation? previous,
  ) async {
    if (current(userId) != previous) return;
    await remember(userId, location);
  }

  bool _valid(LearnLocation location) =>
      location.superBlock.trim().isNotEmpty &&
      location.block.trim().isNotEmpty &&
      location.challengeId.trim().isNotEmpty;
}
