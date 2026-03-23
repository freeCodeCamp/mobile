import 'dart:convert';
import 'dart:developer';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:freecodecamp/utils/upgrade_controller.dart';
import 'package:upgrader/upgrader.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();

  static final remoteConfig = FirebaseRemoteConfig.instance;
  static const _superblockActivationKey = 'superblock_activation_overrides';
  static const _blockActivationKey = 'block_activation_overrides';

  factory RemoteConfigService() {
    return _instance;
  }

  Future<void> init() async {
    try {
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );
      await remoteConfig.setDefaults({
        'min_app_version': '7.3.0',
        _superblockActivationKey: '{}',
        _blockActivationKey: '{}',
      });

      await remoteConfig.fetchAndActivate();

      remoteConfig.onConfigUpdated.listen((event) async {
        await remoteConfig.activate();

        // Update the min app version
        UpgraderState currUpgradeState = upgraderController.state;
        upgraderController.updateState(currUpgradeState.copyWith(
          minAppVersion: Upgrader.parseVersion(
            remoteConfig.getString('min_app_version'),
            'minAppVersion',
            false,
          ),
        ));
      });
    } on PlatformException catch (exception, stack) {
      log('Platform exception - $exception');
      await FirebaseCrashlytics.instance.recordError(
        exception,
        stack,
        reason: 'Remote Config Platform Exception',
      );
    } catch (exception) {
      log('Unable to fetch remote config. Cached or default values will be used $exception');
    }
  }

  RemoteConfigService._internal();

  bool isSuperBlockActive(
    String dashedName, {
    required bool fallbackValue,
  }) {
    final override = getSuperBlockActivationOverride(dashedName);
    return override ?? fallbackValue;
  }

  bool? getSuperBlockActivationOverride(String dashedName) {
    return _getOverrideValue(
      configKey: _superblockActivationKey,
      key: dashedName,
    );
  }

  bool isBlockActive({
    required String superBlockDashedName,
    required String blockDashedName,
    bool fallbackValue = true,
  }) {
    final override = getBlockActivationOverride(
      superBlockDashedName: superBlockDashedName,
      blockDashedName: blockDashedName,
    );
    return override ?? fallbackValue;
  }

  bool? getBlockActivationOverride({
    required String superBlockDashedName,
    required String blockDashedName,
  }) {
    final superBlockScopedKey = '$superBlockDashedName/$blockDashedName';
    return _getOverrideValue(
      configKey: _blockActivationKey,
      key: superBlockScopedKey,
    );
  }

  bool? _getOverrideValue({
    required String configKey,
    required String key,
  }) {
    final overrides = _getOverridesMap(configKey);
    if (overrides == null) {
      return null;
    }

    final overrideValue = overrides[key];
    if (overrideValue is bool) {
      return overrideValue;
    }

    return null;
  }

  Map<String, dynamic>? _getOverridesMap(String configKey) {
    try {
      final String rawConfig = remoteConfig.getString(configKey);
      if (rawConfig.trim().isEmpty) {
        return null;
      }

      final dynamic decoded = jsonDecode(rawConfig);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }
      return decoded;
    } catch (exception) {
      log(
        'Invalid remote config for $configKey. '
        'Ignoring overrides: $exception',
      );
      return null;
    }
  }
}
