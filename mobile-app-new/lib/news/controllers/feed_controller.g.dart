// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NewsFeedNotifier)
final newsFeedProvider = NewsFeedNotifierFamily._();

final class NewsFeedNotifierProvider
    extends $AsyncNotifierProvider<NewsFeedNotifier, NewsFeedState> {
  NewsFeedNotifierProvider._({
    required NewsFeedNotifierFamily super.from,
    required NewsFeedSource super.argument,
  }) : super(
         retry: null,
         name: r'newsFeedProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$newsFeedNotifierHash();

  @override
  String toString() {
    return r'newsFeedProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  NewsFeedNotifier create() => NewsFeedNotifier();

  @override
  bool operator ==(Object other) {
    return other is NewsFeedNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$newsFeedNotifierHash() => r'7365cd1e53036b584af9c460c278883f8ad28e85';

final class NewsFeedNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          NewsFeedNotifier,
          AsyncValue<NewsFeedState>,
          NewsFeedState,
          FutureOr<NewsFeedState>,
          NewsFeedSource
        > {
  NewsFeedNotifierFamily._()
    : super(
        retry: null,
        name: r'newsFeedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  NewsFeedNotifierProvider call(NewsFeedSource source) =>
      NewsFeedNotifierProvider._(argument: source, from: this);

  @override
  String toString() => r'newsFeedProvider';
}

abstract class _$NewsFeedNotifier extends $AsyncNotifier<NewsFeedState> {
  late final _$args = ref.$arg as NewsFeedSource;
  NewsFeedSource get source => _$args;

  FutureOr<NewsFeedState> build(NewsFeedSource source);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<NewsFeedState>, NewsFeedState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<NewsFeedState>, NewsFeedState>,
              AsyncValue<NewsFeedState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
