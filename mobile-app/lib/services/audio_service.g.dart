// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(audioHandler)
final audioHandlerProvider = AudioHandlerProvider._();

final class AudioHandlerProvider
    extends
        $FunctionalProvider<
          AudioPlayerHandler,
          AudioPlayerHandler,
          AudioPlayerHandler
        >
    with $Provider<AudioPlayerHandler> {
  AudioHandlerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'audioHandlerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$audioHandlerHash();

  @$internal
  @override
  $ProviderElement<AudioPlayerHandler> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AudioPlayerHandler create(Ref ref) {
    return audioHandler(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AudioPlayerHandler value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AudioPlayerHandler>(value),
    );
  }
}

String _$audioHandlerHash() => r'014f1951b3e255a5440d3a291bb0cf719c0a8e20';

@ProviderFor(codeRadioLoaded)
final codeRadioLoadedProvider = CodeRadioLoadedProvider._();

final class CodeRadioLoadedProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  CodeRadioLoadedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'codeRadioLoadedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$codeRadioLoadedHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return codeRadioLoaded(ref);
  }
}

String _$codeRadioLoadedHash() => r'02c6a570dd3358fae2a2b9ddd05e3b23aa4aad10';
