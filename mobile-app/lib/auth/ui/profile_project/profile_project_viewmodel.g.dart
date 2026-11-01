// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_project_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProfileProjectNotifier)
final profileProjectProvider = ProfileProjectNotifierFamily._();

final class ProfileProjectNotifierProvider
    extends $NotifierProvider<ProfileProjectNotifier, ProfileProjectState?> {
  ProfileProjectNotifierProvider._({
    required ProfileProjectNotifierFamily super.from,
    required String? super.argument,
  }) : super(
         retry: noRetry,
         name: r'profileProjectProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$profileProjectNotifierHash();

  @override
  String toString() {
    return r'profileProjectProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ProfileProjectNotifier create() => ProfileProjectNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileProjectState? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileProjectState?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ProfileProjectNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$profileProjectNotifierHash() =>
    r'70a4704ae5975228c9c65abe222d60dee31569de';

final class ProfileProjectNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          ProfileProjectNotifier,
          ProfileProjectState?,
          ProfileProjectState?,
          ProfileProjectState?,
          String?
        > {
  ProfileProjectNotifierFamily._()
    : super(
        retry: noRetry,
        name: r'profileProjectProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProfileProjectNotifierProvider call(String? projectId) =>
      ProfileProjectNotifierProvider._(argument: projectId, from: this);

  @override
  String toString() => r'profileProjectProvider';
}

abstract class _$ProfileProjectNotifier
    extends $Notifier<ProfileProjectState?> {
  late final _$args = ref.$arg as String?;
  String? get projectId => _$args;

  ProfileProjectState? build(String? projectId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ProfileProjectState?, ProfileProjectState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ProfileProjectState?, ProfileProjectState?>,
              ProfileProjectState?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
