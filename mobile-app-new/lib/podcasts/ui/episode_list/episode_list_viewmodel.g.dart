// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode_list_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PodcastEpisodesNotifier)
final podcastEpisodesProvider = PodcastEpisodesNotifierFamily._();

final class PodcastEpisodesNotifierProvider
    extends
        $AsyncNotifierProvider<PodcastEpisodesNotifier, PodcastEpisodesState> {
  PodcastEpisodesNotifierProvider._({
    required PodcastEpisodesNotifierFamily super.from,
    required PodcastEpisodeSource super.argument,
  }) : super(
         retry: null,
         name: r'podcastEpisodesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$podcastEpisodesNotifierHash();

  @override
  String toString() {
    return r'podcastEpisodesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PodcastEpisodesNotifier create() => PodcastEpisodesNotifier();

  @override
  bool operator ==(Object other) {
    return other is PodcastEpisodesNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$podcastEpisodesNotifierHash() =>
    r'b217a22ee487c619a4b8ba10277a1ebf32c63a17';

final class PodcastEpisodesNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          PodcastEpisodesNotifier,
          AsyncValue<PodcastEpisodesState>,
          PodcastEpisodesState,
          FutureOr<PodcastEpisodesState>,
          PodcastEpisodeSource
        > {
  PodcastEpisodesNotifierFamily._()
    : super(
        retry: null,
        name: r'podcastEpisodesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PodcastEpisodesNotifierProvider call(PodcastEpisodeSource source) =>
      PodcastEpisodesNotifierProvider._(argument: source, from: this);

  @override
  String toString() => r'podcastEpisodesProvider';
}

abstract class _$PodcastEpisodesNotifier
    extends $AsyncNotifier<PodcastEpisodesState> {
  late final _$args = ref.$arg as PodcastEpisodeSource;
  PodcastEpisodeSource get source => _$args;

  FutureOr<PodcastEpisodesState> build(PodcastEpisodeSource source);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<PodcastEpisodesState>, PodcastEpisodesState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PodcastEpisodesState>,
                PodcastEpisodesState
              >,
              AsyncValue<PodcastEpisodesState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
