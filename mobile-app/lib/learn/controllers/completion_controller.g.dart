// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completion_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CompletedChallengeIdsNotifier)
final completedChallengeIdsProvider = CompletedChallengeIdsNotifierProvider._();

final class CompletedChallengeIdsNotifierProvider
    extends $NotifierProvider<CompletedChallengeIdsNotifier, Set<String>> {
  CompletedChallengeIdsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'completedChallengeIdsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$completedChallengeIdsNotifierHash();

  @$internal
  @override
  CompletedChallengeIdsNotifier create() => CompletedChallengeIdsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$completedChallengeIdsNotifierHash() =>
    r'32c2dc84060c33c440f162e3355d962a9528a488';

abstract class _$CompletedChallengeIdsNotifier extends $Notifier<Set<String>> {
  Set<String> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<String>, Set<String>>,
              Set<String>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(CompletedDailyChallengeIdsNotifier)
final completedDailyChallengeIdsProvider =
    CompletedDailyChallengeIdsNotifierProvider._();

final class CompletedDailyChallengeIdsNotifierProvider
    extends $NotifierProvider<CompletedDailyChallengeIdsNotifier, Set<String>> {
  CompletedDailyChallengeIdsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'completedDailyChallengeIdsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$completedDailyChallengeIdsNotifierHash();

  @$internal
  @override
  CompletedDailyChallengeIdsNotifier create() =>
      CompletedDailyChallengeIdsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$completedDailyChallengeIdsNotifierHash() =>
    r'464d42342d0e44beafd5446add0df70b0fbacedb';

abstract class _$CompletedDailyChallengeIdsNotifier
    extends $Notifier<Set<String>> {
  Set<String> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<String>, Set<String>>,
              Set<String>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
