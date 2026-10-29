// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experiment_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ExperimentsNotifier)
final experimentsProvider = ExperimentsNotifierProvider._();

final class ExperimentsNotifierProvider
    extends $NotifierProvider<ExperimentsNotifier, Map<Experiment, String>> {
  ExperimentsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'experimentsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$experimentsNotifierHash();

  @$internal
  @override
  ExperimentsNotifier create() => ExperimentsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<Experiment, String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<Experiment, String>>(value),
    );
  }
}

String _$experimentsNotifierHash() =>
    r'937a80b408778e974af3f449d6c7d6b9aeb15aeb';

abstract class _$ExperimentsNotifier
    extends $Notifier<Map<Experiment, String>> {
  Map<Experiment, String> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<Map<Experiment, String>, Map<Experiment, String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<Experiment, String>, Map<Experiment, String>>,
              Map<Experiment, String>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
