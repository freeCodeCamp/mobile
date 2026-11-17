// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_experience_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProfileExperienceNotifier)
final profileExperienceProvider = ProfileExperienceNotifierFamily._();

final class ProfileExperienceNotifierProvider
    extends
        $NotifierProvider<ProfileExperienceNotifier, ProfileExperienceState?> {
  ProfileExperienceNotifierProvider._({
    required ProfileExperienceNotifierFamily super.from,
    required String? super.argument,
  }) : super(
         retry: noRetry,
         name: r'profileExperienceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$profileExperienceNotifierHash();

  @override
  String toString() {
    return r'profileExperienceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ProfileExperienceNotifier create() => ProfileExperienceNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileExperienceState? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileExperienceState?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ProfileExperienceNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$profileExperienceNotifierHash() =>
    r'fc6d36a97cc48f9fc9da6415f58f032eb65ca593';

final class ProfileExperienceNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          ProfileExperienceNotifier,
          ProfileExperienceState?,
          ProfileExperienceState?,
          ProfileExperienceState?,
          String?
        > {
  ProfileExperienceNotifierFamily._()
    : super(
        retry: noRetry,
        name: r'profileExperienceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProfileExperienceNotifierProvider call(String? experienceId) =>
      ProfileExperienceNotifierProvider._(argument: experienceId, from: this);

  @override
  String toString() => r'profileExperienceProvider';
}

abstract class _$ProfileExperienceNotifier
    extends $Notifier<ProfileExperienceState?> {
  late final _$args = ref.$arg as String?;
  String? get experienceId => _$args;

  ProfileExperienceState? build(String? experienceId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<ProfileExperienceState?, ProfileExperienceState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ProfileExperienceState?, ProfileExperienceState?>,
              ProfileExperienceState?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
