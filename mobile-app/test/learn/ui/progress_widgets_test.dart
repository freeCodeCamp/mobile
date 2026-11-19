import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/auth/models/user_model.dart';
import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/learn/models/curriculum_model.dart';
import 'package:freecodecamp/learn/ui/editor_challenge/editor_panels.dart';
import 'package:freecodecamp/learn/ui/widgets/block_card.dart';
import 'package:freecodecamp/services/auth_service.dart';

class FakeAuthNotifier extends AuthNotifier {
  FakeAuthNotifier(this._user);
  final FccUserModel? _user;

  @override
  Future<FccUserModel?> build() {
    state = AsyncData(_user);
    return Future.value(_user);
  }
}

void main() {
  final now = DateTime.now();

  Block createBlock({required List<ChallengeOrder> challenges}) {
    return Block(
      superBlock: 'test-superblock',
      dashedName: 'test-block',
      name: 'Test Block',
      layout: BlockLayout.challengeGrid,
      label: BlockLabel.workshop,
      description: const ['Description'],
      challenges: challenges,
    );
  }

  Challenge createChallenge({required String id}) {
    return Challenge(
      id: id,
      block: 'test-block',
      superBlock: 'test-superblock',
      title: 'Step 1',
      dashedName: 'step-1',
      challengeType: 0,
    );
  }

  FccUserModel createUser({required List<String> completedIds}) {
    return FccUserModel(
      id: 'user-1',
      email: 'test@example.com',
      username: 'tester',
      joinDate: now,
      completedChallenges: [
        for (final id in completedIds)
          CompletedChallenge(id: id, completedDate: now),
      ],
    );
  }

  group('PassPanel Workshop Progress Widget Behavior', () {
    testWidgets('zero completed out of zero total renders 0% without error', (
      tester,
    ) async {
      final block = createBlock(challenges: []);
      final challenge = createChallenge(id: 'c1');
      final user = createUser(completedIds: []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [authProvider.overrideWith(() => FakeAuthNotifier(user))],
          child: MaterialApp(
            home: Scaffold(
              body: PassPanel(challenge: challenge, block: block),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('0% Completed'), findsOneWidget);
      final indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(indicator.value, 0.0);
    });

    testWidgets('zero completed out of positive total renders 0%', (
      tester,
    ) async {
      final block = createBlock(
        challenges: [
          const ChallengeOrder(id: 'step-1', title: 'Step 1'),
          const ChallengeOrder(id: 'step-2', title: 'Step 2'),
        ],
      );
      final challenge = createChallenge(id: 'outside-challenge');
      final user = createUser(completedIds: []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [authProvider.overrideWith(() => FakeAuthNotifier(user))],
          child: MaterialApp(
            home: Scaffold(
              body: PassPanel(challenge: challenge, block: block),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('0% Completed'), findsOneWidget);
      final indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(indicator.value, 0.0);
    });

    testWidgets('partial progress (1 of 2) renders 50%', (tester) async {
      final block = createBlock(
        challenges: [
          const ChallengeOrder(id: 'step-1', title: 'Step 1'),
          const ChallengeOrder(id: 'step-2', title: 'Step 2'),
        ],
      );
      final challenge = createChallenge(id: 'step-1');
      final user = createUser(completedIds: []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [authProvider.overrideWith(() => FakeAuthNotifier(user))],
          child: MaterialApp(
            home: Scaffold(
              body: PassPanel(challenge: challenge, block: block),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('50% Completed'), findsOneWidget);
      final indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(indicator.value, 0.5);
    });

    testWidgets('fully completed progress (2 of 2) renders 100%', (
      tester,
    ) async {
      final block = createBlock(
        challenges: [
          const ChallengeOrder(id: 'step-1', title: 'Step 1'),
          const ChallengeOrder(id: 'step-2', title: 'Step 2'),
        ],
      );
      final challenge = createChallenge(id: 'step-2');
      final user = createUser(completedIds: ['step-1']);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [authProvider.overrideWith(() => FakeAuthNotifier(user))],
          child: MaterialApp(
            home: Scaffold(
              body: PassPanel(challenge: challenge, block: block),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('100% Completed'), findsOneWidget);
      final indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(indicator.value, 1.0);
    });
  });

  group('BlockCard Overview Progress Widget Behavior', () {
    testWidgets('zero total does not render completed label', (tester) async {
      final block = createBlock(challenges: []);
      final user = createUser(completedIds: []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [authProvider.overrideWith(() => FakeAuthNotifier(user))],
          child: MaterialApp(
            home: Scaffold(
              body: BlockCard(block: block, isOpen: false, onToggle: () {}),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Completed'), findsNothing);
      final indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(indicator.value, 0.01);
    });

    testWidgets('zero completed renders minimum visible progress 0.01', (
      tester,
    ) async {
      final block = createBlock(
        challenges: [const ChallengeOrder(id: 'step-1', title: 'Step 1')],
      );
      final user = createUser(completedIds: []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [authProvider.overrideWith(() => FakeAuthNotifier(user))],
          child: MaterialApp(
            home: Scaffold(
              body: BlockCard(block: block, isOpen: false, onToggle: () {}),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Completed'), findsNothing);
      final indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(indicator.value, 0.01);
    });

    testWidgets('partial progress renders clamped fraction', (tester) async {
      final block = createBlock(
        challenges: [
          const ChallengeOrder(id: 'step-1', title: 'Step 1'),
          const ChallengeOrder(id: 'step-2', title: 'Step 2'),
        ],
      );
      final user = createUser(completedIds: ['step-1']);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [authProvider.overrideWith(() => FakeAuthNotifier(user))],
          child: MaterialApp(
            home: Scaffold(
              body: BlockCard(block: block, isOpen: false, onToggle: () {}),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Completed'), findsNothing);
      final indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(indicator.value, 0.5);
    });

    testWidgets('fully completed renders completed label', (tester) async {
      final block = createBlock(
        challenges: [
          const ChallengeOrder(id: 'step-1', title: 'Step 1'),
          const ChallengeOrder(id: 'step-2', title: 'Step 2'),
        ],
      );
      final user = createUser(completedIds: ['step-1', 'step-2']);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [authProvider.overrideWith(() => FakeAuthNotifier(user))],
          child: MaterialApp(
            home: Scaffold(
              body: BlockCard(block: block, isOpen: false, onToggle: () {}),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Completed'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsNothing);
    });
  });
}
