import 'dart:convert';
import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_config_service.freezed.dart';
part 'remote_config_service.g.dart';

const _activationOverridesKey = 'activation_overrides';

@freezed
abstract class RemoteConfig with _$RemoteConfig {
  const factory RemoteConfig({
    @Default({}) Map<String, bool> activationOverrides,
  }) = _RemoteConfig;

  const RemoteConfig._();

  bool? activationOverride(String superBlock, [String? block]) =>
      activationOverrides[block == null ? superBlock : '$superBlock/$block'];
}

Duration? _noRetry(int retryCount, Object error) => null;

@Riverpod(keepAlive: true, retry: _noRetry)
class RemoteConfigNotifier extends _$RemoteConfigNotifier {
  @override
  Future<RemoteConfig> build() async {
    final config = FirebaseRemoteConfig.instance;

    try {
      await config.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );
      await config.setDefaults(const {_activationOverridesKey: '{}'});
      await config.fetchAndActivate();
    } catch (e) {
      log('Unable to fetch remote config, using cached or default values: $e');
    }

    final sub = config.onConfigUpdated.listen((_) async {
      await config.activate();
      if (ref.mounted) state = AsyncData(_read(config));
    }, onError: (Object e) => log('Remote config updates failed: $e'));
    ref.onDispose(sub.cancel);

    return _read(config);
  }

  RemoteConfig _read(FirebaseRemoteConfig config) =>
      RemoteConfig(activationOverrides: _activationOverrides(config));

  Map<String, bool> _activationOverrides(FirebaseRemoteConfig config) {
    try {
      final decoded = jsonDecode(config.getString(_activationOverridesKey));
      if (decoded is! Map<String, dynamic>) return const {};

      return {
        for (final MapEntry(:key, :value) in decoded.entries)
          if (value is bool) key: value,
      };
    } catch (e) {
      log('Invalid $_activationOverridesKey, ignoring overrides: $e');
      return const {};
    }
  }
}
