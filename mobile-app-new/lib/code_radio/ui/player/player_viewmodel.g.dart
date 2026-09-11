// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(codeRadioNowPlaying)
final codeRadioNowPlayingProvider = CodeRadioNowPlayingProvider._();

final class CodeRadioNowPlayingProvider
    extends
        $FunctionalProvider<AsyncValue<CodeRadio>, CodeRadio, Stream<CodeRadio>>
    with $FutureModifier<CodeRadio>, $StreamProvider<CodeRadio> {
  CodeRadioNowPlayingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'codeRadioNowPlayingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$codeRadioNowPlayingHash();

  @$internal
  @override
  $StreamProviderElement<CodeRadio> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<CodeRadio> create(Ref ref) {
    return codeRadioNowPlaying(ref);
  }
}

String _$codeRadioNowPlayingHash() =>
    r'642ff517d7359e73249732ea7ccbedfa1c04e48f';

@ProviderFor(codeRadioElapsed)
final codeRadioElapsedProvider = CodeRadioElapsedProvider._();

final class CodeRadioElapsedProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  CodeRadioElapsedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'codeRadioElapsedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$codeRadioElapsedHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    return codeRadioElapsed(ref);
  }
}

String _$codeRadioElapsedHash() => r'c6a4ff9ba016e2d41f91b2df0ad0505a4cac9251';

@ProviderFor(CodeRadioPlayerNotifier)
final codeRadioPlayerProvider = CodeRadioPlayerNotifierProvider._();

final class CodeRadioPlayerNotifierProvider
    extends $NotifierProvider<CodeRadioPlayerNotifier, bool> {
  CodeRadioPlayerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'codeRadioPlayerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$codeRadioPlayerNotifierHash();

  @$internal
  @override
  CodeRadioPlayerNotifier create() => CodeRadioPlayerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$codeRadioPlayerNotifierHash() =>
    r'763710fdaf1ee286a50a7d40ccad330245da1e2a';

abstract class _$CodeRadioPlayerNotifier extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
