// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'downloaded_episodes_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PodcastDownloadedEpisodesNotifier)
final podcastDownloadedEpisodesProvider =
    PodcastDownloadedEpisodesNotifierFamily._();

final class PodcastDownloadedEpisodesNotifierProvider
    extends
        $AsyncNotifierProvider<
          PodcastDownloadedEpisodesNotifier,
          PodcastDownloadedEpisodesState
        > {
  PodcastDownloadedEpisodesNotifierProvider._({
    required PodcastDownloadedEpisodesNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: noRetry,
         name: r'podcastDownloadedEpisodesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() =>
      _$podcastDownloadedEpisodesNotifierHash();

  @override
  String toString() {
    return r'podcastDownloadedEpisodesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PodcastDownloadedEpisodesNotifier create() =>
      PodcastDownloadedEpisodesNotifier();

  @override
  bool operator ==(Object other) {
    return other is PodcastDownloadedEpisodesNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$podcastDownloadedEpisodesNotifierHash() =>
    r'360cb667d1dbb0a20e868bb8a61809aca7bbaafb';

final class PodcastDownloadedEpisodesNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          PodcastDownloadedEpisodesNotifier,
          AsyncValue<PodcastDownloadedEpisodesState>,
          PodcastDownloadedEpisodesState,
          FutureOr<PodcastDownloadedEpisodesState>,
          String
        > {
  PodcastDownloadedEpisodesNotifierFamily._()
    : super(
        retry: noRetry,
        name: r'podcastDownloadedEpisodesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PodcastDownloadedEpisodesNotifierProvider call(String podcastId) =>
      PodcastDownloadedEpisodesNotifierProvider._(
        argument: podcastId,
        from: this,
      );

  @override
  String toString() => r'podcastDownloadedEpisodesProvider';
}

abstract class _$PodcastDownloadedEpisodesNotifier
    extends $AsyncNotifier<PodcastDownloadedEpisodesState> {
  late final _$args = ref.$arg as String;
  String get podcastId => _$args;

  FutureOr<PodcastDownloadedEpisodesState> build(String podcastId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<PodcastDownloadedEpisodesState>,
              PodcastDownloadedEpisodesState
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PodcastDownloadedEpisodesState>,
                PodcastDownloadedEpisodesState
              >,
              AsyncValue<PodcastDownloadedEpisodesState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
