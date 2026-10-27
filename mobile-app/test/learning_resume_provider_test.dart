import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/auth/models/user_model.dart';
import 'package:freecodecamp/learn/controllers/curriculum_controller.dart';
import 'package:freecodecamp/learn/models/curriculum_model.dart';
import 'package:freecodecamp/learn/ui/landing/learning_resume.dart';
import 'package:freecodecamp/services/auth_service.dart';

const _first = SuperBlockSummary(
  dashedName: 'first',
  title: 'First course',
  isPublic: true,
);
const _current = SuperBlockSummary(
  dashedName: 'current',
  title: 'Current course',
  isPublic: true,
);
final _user = FccUserModel(
  id: 'camper',
  email: 'camper@example.com',
  username: 'camper',
  joinDate: DateTime(2020),
  currentChallengeId: 'current-step',
);
SuperBlock _curriculum(String name) => SuperBlock.blocks([
  Block(
    superBlock: name,
    dashedName: '$name-block',
    name: '$name workshop',
    layout: BlockLayout.challengeGrid,
    label: BlockLabel.workshop,
    description: [],
    challenges: [ChallengeOrder(id: '$name-step', title: 'Step 1')],
  ),
]);

class _Auth extends AuthNotifier {
  _Auth(this.result);
  final Future<FccUserModel?> result;
  @override
  Future<FccUserModel?> build() => result;
}

class _Sources {
  int firstReads = 0;
  int currentReads = 0;
  bool failCurrent = false;
  ProviderContainer container(Future<FccUserModel?> user) => ProviderContainer(
    retry: (_, _) => null,
    overrides: [
      authProvider.overrideWith(() => _Auth(user)),
      curriculumStagesProvider.overrideWith(
        (ref) async => [
          (key: 'core', title: 'Courses', superBlocks: [_first, _current]),
        ],
      ),
      superBlockProvider('first').overrideWith((ref) async {
        firstReads++;
        return _curriculum('first');
      }),
      superBlockProvider('current').overrideWith((ref) async {
        currentReads++;
        if (failCurrent) throw StateError('Current course unavailable');
        return _curriculum('current');
      }),
    ],
  );
}

class _ResumeHarness extends ConsumerWidget {
  const _ResumeHarness();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resume = ref.watch(learningResumeProvider);
    return Scaffold(
      body: resume.when(
        data: (value) => Text(value?.challenge.id ?? 'No next step'),
        loading: () => const Text('Loading next step'),
        error: (_, _) => TextButton(
          onPressed: () => retryLearningResume(ref),
          child: const Text('Retry next step'),
        ),
      ),
    );
  }
}

void main() {
  test(
    'pending authentication cannot resolve to a guest start target',
    () async {
      final auth = Completer<FccUserModel?>();
      final sources = _Sources();
      final container = sources.container(auth.future);
      addTearDown(container.dispose);
      final subscription = container.listen(learningResumeProvider, (_, _) {});
      addTearDown(subscription.close);
      await container.pump();
      expect(container.read(learningResumeProvider).isLoading, isTrue);
      expect(container.read(learningResumeProvider).value, isNull);
      expect(sources.firstReads, 0);
      expect(sources.currentReads, 0);
      auth.complete(_user);
      final result = await container.read(learningResumeProvider.future);
      expect(result?.challenge.id, 'current-step');
      expect(result?.isReturning, isTrue);
    },
  );
  test(
    'a current-course failure cannot silently offer a different loaded course',
    () async {
      final sources = _Sources()..failCurrent = true;
      final container = sources.container(Future.value(_user));
      addTearDown(container.dispose);
      final subscription = container.listen(learningResumeProvider, (_, _) {});
      addTearDown(subscription.close);
      await expectLater(
        container.read(learningResumeProvider.future),
        throwsStateError,
      );
      expect(sources.firstReads, 1);
      expect(sources.currentReads, 1);
      expect(container.read(learningResumeProvider).hasError, isTrue);
      expect(container.read(learningResumeProvider).value, isNull);
    },
  );
  testWidgets(
    'the retry action re-fetches failed course dependencies and resumes the current course',
    (tester) async {
      final sources = _Sources()..failCurrent = true;
      final container = sources.container(Future.value(_user));
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: _ResumeHarness()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Retry next step'), findsOneWidget);
      expect(find.text('first-step'), findsNothing);
      expect(sources.currentReads, 1);
      sources.failCurrent = false;
      await tester.tap(find.text('Retry next step'));
      await tester.pumpAndSettle();
      expect(sources.currentReads, 2);
      expect(sources.firstReads, 2);
      expect(find.text('current-step'), findsOneWidget);
      expect(find.text('Retry next step'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
