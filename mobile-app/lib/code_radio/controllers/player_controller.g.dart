// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_controller.dart';

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
        retry: noRetry,
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
    r'cd9c2cdc5fffc2ec92987f11106f837aa1681426';

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
