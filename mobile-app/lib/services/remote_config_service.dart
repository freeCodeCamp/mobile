import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_config_service.freezed.dart';
part 'remote_config_service.g.dart';

const _activationOverridesKey = 'activation_overrides';
const _minAppVersionKey = 'min_app_version';

@freezed
abstract class RemoteConfig with _$RemoteConfig {
  const factory RemoteConfig({
    required Map<String, bool> activationOverrides,
    required String minAppVersion,
  }) = _RemoteConfig;

  const RemoteConfig._();

  bool? activationOverride(String superBlock, [String? block]) =>
      activationOverrides[block == null ? superBlock : '$superBlock/$block'];
}

Future<void> initRemoteConfig() async {
  final config = FirebaseRemoteConfig.instance;

  try {
    await config.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );
    final packageInfo = await PackageInfo.fromPlatform();
    await config.setDefaults({
      _activationOverridesKey: '{}',
      _minAppVersionKey: packageInfo.version,
    });
    await config.fetchAndActivate();
  } catch (e, stack) {
    log('Unable to fetch remote config, using cached or default values: $e');
    unawaited(
      FirebaseCrashlytics.instance.recordError(
        e,
        stack,
        reason: 'while fetching Remote Config',
      ),
    );
  }
}

@Riverpod(keepAlive: true)
class RemoteConfigNotifier extends _$RemoteConfigNotifier {
  @override
  RemoteConfig build() {
    final config = FirebaseRemoteConfig.instance;

    final sub = config.onConfigUpdated.listen(
      (_) async {
        await config.activate();
        if (ref.mounted) state = _read(config);
      },
      onError: (Object e, StackTrace stack) {
        log('Remote config updates failed: $e');
        unawaited(
          FirebaseCrashlytics.instance.recordError(
            e,
            stack,
            reason: 'while listening for Remote Config updates',
          ),
        );
      },
    );
    ref.onDispose(sub.cancel);

    return _read(config);
  }

  RemoteConfig _read(FirebaseRemoteConfig config) => RemoteConfig(
    activationOverrides: _activationOverrides(config),
    minAppVersion: config.getString(_minAppVersionKey),
  );

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
