import 'dart:async';

import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:freecodecamp/services/analytics_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'experiment_service.g.dart';

// NOTE: Users outside an experiment get this in-app default; A/B Testing overrides it per arm.
const controlVariant = 'control';

enum Experiment {
  // NOTE: AA test, every arm must behave identically.
  aaTest('exp_aa_test');

  // NOTE: Event names are capped at 40 characters, and `_exposure` takes 9 of them.
  const Experiment(this.remoteConfigKey)
    : assert(remoteConfigKey.length <= 31, 'Experiment key too long');

  // NOTE: Must match the parameter name in the Firebase console.
  final String remoteConfigKey;

  // NOTE: Must match the activation event in the Firebase A/B Testing console.
  String get exposureEvent => '${remoteConfigKey}_exposure';
}

@Riverpod(keepAlive: true)
class ExperimentsNotifier extends _$ExperimentsNotifier {
  final _exposed = <Experiment>{};

  // NOTE: Read once and never rebuilt, so a Remote Config update mid-session can't switch a user's arm. New values apply on the next launch.
  @override
  Map<Experiment, String> build() {
    final config = FirebaseRemoteConfig.instance;
    return {
      for (final experiment in Experiment.values)
        experiment: _armOrControl(config.getString(experiment.remoteConfigKey)),
    };
  }

  String variant(Experiment experiment) => state[experiment] ?? controlVariant;

  // NOTE: Call where the user first sees the experiment. Logs once per app session.
  void logExposure(Experiment experiment) {
    if (!_exposed.add(experiment)) return;

    unawaited(
      ref
          .read(analyticsProvider)
          .experimentExposure(
            experiment.exposureEvent,
            variant: variant(experiment),
          ),
    );
  }

  // NOTE: A key missing from the Remote Config template reads as an empty string.
  String _armOrControl(String value) => value.isEmpty ? controlVariant : value;
}

// NOTE: Add this ID as a test device in the Firebase A/B Testing console to force an arm. Printed in release builds too, because only release builds send analytics.
Future<void> logInstallationIdForTesting() async {
  try {
    debugPrint(
      'Firebase installation ID: ${await FirebaseInstallations.instance.getId()}',
    );
  } catch (e) {
    debugPrint('Unable to read Firebase installation ID: $e');
  }
}
