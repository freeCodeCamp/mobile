// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scene_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sceneAssets)
final sceneAssetsProvider = SceneAssetsProvider._();

final class SceneAssetsProvider
    extends
        $FunctionalProvider<
          AsyncValue<SceneAssets>,
          SceneAssets,
          FutureOr<SceneAssets>
        >
    with $FutureModifier<SceneAssets>, $FutureProvider<SceneAssets> {
  SceneAssetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sceneAssetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sceneAssetsHash();

  @$internal
  @override
  $FutureProviderElement<SceneAssets> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SceneAssets> create(Ref ref) {
    return sceneAssets(ref);
  }
}

String _$sceneAssetsHash() => r'9a145ce15f3d4c4f8804542aa944b475e0a3ec7b';

@ProviderFor(SceneNotifier)
final sceneProvider = SceneNotifierFamily._();

final class SceneNotifierProvider
    extends $NotifierProvider<SceneNotifier, SceneState> {
  SceneNotifierProvider._({
    required SceneNotifierFamily super.from,
    required (Scene, String) super.argument,
  }) : super(
         retry: null,
         name: r'sceneProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sceneNotifierHash();

  @override
  String toString() {
    return r'sceneProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  SceneNotifier create() => SceneNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SceneState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SceneState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SceneNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sceneNotifierHash() => r'c18ab33636b696c31d3b0687ac5ce3d407c01326';

final class SceneNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          SceneNotifier,
          SceneState,
          SceneState,
          SceneState,
          (Scene, String)
        > {
  SceneNotifierFamily._()
    : super(
        retry: null,
        name: r'sceneProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SceneNotifierProvider call(Scene scene, String title) =>
      SceneNotifierProvider._(argument: (scene, title), from: this);

  @override
  String toString() => r'sceneProvider';
}

abstract class _$SceneNotifier extends $Notifier<SceneState> {
  late final _$args = ref.$arg as (Scene, String);
  Scene get scene => _$args.$1;
  String get title => _$args.$2;

  SceneState build(Scene scene, String title);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SceneState, SceneState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SceneState, SceneState>,
              SceneState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
