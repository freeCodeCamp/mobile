// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_reminder_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(learningReminderService)
final learningReminderServiceProvider = LearningReminderServiceProvider._();

final class LearningReminderServiceProvider
    extends
        $FunctionalProvider<
          LearningReminderService,
          LearningReminderService,
          LearningReminderService
        >
    with $Provider<LearningReminderService> {
  LearningReminderServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'learningReminderServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$learningReminderServiceHash();

  @$internal
  @override
  $ProviderElement<LearningReminderService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LearningReminderService create(Ref ref) {
    return learningReminderService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LearningReminderService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LearningReminderService>(value),
    );
  }
}

String _$learningReminderServiceHash() =>
    r'824cc57b0e157a8599800776a539be74708c5f7d';
