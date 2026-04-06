import 'dart:convert';
import 'dart:developer';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:freecodecamp/utils/upgrade_controller.dart';
import 'package:upgrader/upgrader.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();

  static final remoteConfig = FirebaseRemoteConfig.instance;
  static const _activationOverridesKey = 'activation_overrides';
  final String Function(String key) _getConfigString;

  factory RemoteConfigService() {
    return _instance;
  }

  @visibleForTesting
  factory RemoteConfigService.withConfigReader(
    String Function(String key) getConfigString,
  ) {
    return RemoteConfigService._internal(getConfigString: getConfigString);
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
        'min_app_version': '7.4.0',
        _activationOverridesKey: '{}',
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

  RemoteConfigService._internal({
    String Function(String key)? getConfigString,
  }) : _getConfigString = getConfigString ?? remoteConfig.getString;

  bool isActive({
    required String superBlockDashedName,
    String? blockDashedName,
    required bool fallbackValue,
  }) {
    final override = getActivationOverride(
      superBlockDashedName: superBlockDashedName,
      blockDashedName: blockDashedName,
    );
    return override ?? fallbackValue;
  }

  bool? getActivationOverride({
    required String superBlockDashedName,
    String? blockDashedName,
  }) {
    final overrideKey = blockDashedName == null
        ? superBlockDashedName
        : '$superBlockDashedName/$blockDashedName';
    return _getOverrideValue(key: overrideKey);
  }

  bool? _getOverrideValue({
    required String key,
  }) {
    final overrides = _getOverridesMap();
    if (overrides == null) {
      return null;
    }

    final overrideValue = overrides[key];
    if (overrideValue is bool) {
      return overrideValue;
    }

    return null;
  }

  Map<String, dynamic>? _getOverridesMap() {
    try {
      final String rawConfig = _getConfigString(_activationOverridesKey);
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
        'Invalid remote config for $_activationOverridesKey. '
        'Ignoring overrides: $exception',
      );
      return null;
    }
  }
}
