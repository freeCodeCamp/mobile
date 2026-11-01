// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_editor_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProfileEditorNotifier)
final profileEditorProvider = ProfileEditorNotifierProvider._();

final class ProfileEditorNotifierProvider
    extends $NotifierProvider<ProfileEditorNotifier, ProfileEditorState?> {
  ProfileEditorNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: noRetry,
        name: r'profileEditorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileEditorNotifierHash();

  @$internal
  @override
  ProfileEditorNotifier create() => ProfileEditorNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileEditorState? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileEditorState?>(value),
    );
  }
}

String _$profileEditorNotifierHash() =>
    r'9799580587dadfcdc8786d59eb8a48dd7812aba9';

abstract class _$ProfileEditorNotifier extends $Notifier<ProfileEditorState?> {
  ProfileEditorState? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ProfileEditorState?, ProfileEditorState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ProfileEditorState?, ProfileEditorState?>,
              ProfileEditorState?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
