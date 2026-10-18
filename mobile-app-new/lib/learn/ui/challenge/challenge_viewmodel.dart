import 'dart:async';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:mobile_app_new/learn/controllers/curriculum_controller.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/models/curriculum_model.dart';
import 'package:mobile_app_new/learn/services/code_service.dart';
import 'package:mobile_app_new/learn/services/curriculum_service.dart';
import 'package:mobile_app_new/learn/services/daily_challenge_reminder_service.dart';
import 'package:mobile_app_new/learn/services/daily_challenge_service.dart';
import 'package:mobile_app_new/services/auth_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'challenge_viewmodel.g.dart';

typedef ChallengeScreenData = ({Challenge challenge, Block block});

@riverpod
Future<ChallengeScreenData> challengeScreen(
  Ref ref,
  String superBlock,
  String block,
  String challengeId,
) async {
  final (challenge, curriculum) = await (
    ref
        .watch(learnCurriculumServiceProvider)
        .getChallenge(superBlock, block, challengeId),
    ref.watch(superBlockProvider(superBlock).future),
  ).wait;

  final blocks = switch (curriculum) {
    BlockSuperBlock(:final blocks) => blocks,
    ChapterSuperBlock(:final chapters) => [
      for (final chapter in chapters)
        for (final module in chapter.modules) ...module.blocks,
    ],
  };
  final found = blocks.firstWhereOrNull((b) => b.dashedName == block);
  if (found == null) throw StateError('Block $block not in $superBlock');

  return (challenge: challenge, block: found);
}

@riverpod
class ChallengeSubmitNotifier extends _$ChallengeSubmitNotifier {
  @override
  AsyncValue<void> build(String challengeId) => const AsyncData(null);

  Future<bool> submit(Challenge challenge, {String? solution}) async {
    if (!ref.read(authProvider).isLoggedIn) return true;

    final isDaily = const {28, 29}.contains(challenge.challengeType);
    state = const AsyncLoading();
    final link = ref.keepAlive();
    try {
      if (isDaily) {
        await ref.read(learnDailyChallengeServiceProvider).complete(challenge);
      } else {
        await ref
            .read(learnCurriculumServiceProvider)
            .submit(
              challenge,
              solution: solution,
              files: await ref
                  .read(learnCodeServiceProvider)
                  .filesPayload(challenge),
            );
      }
      await ref
          .read(authProvider.notifier)
          .refresh()
          .catchError((Object e) => log('submit: profile refresh failed: $e'));
      if (isDaily) {
        unawaited(
          ref
              .read(learnDailyChallengeReminderServiceProvider)
              .reschedule(ref.read(authProvider).value),
        );
      }
      if (ref.mounted) state = const AsyncData(null);
      return true;
    } catch (e, stack) {
      if (ref.mounted) state = AsyncError(e, stack);
      return false;
    } finally {
      link.close();
    }
  }
}

// NOTE: English tasks are titled "Task N"; dialogue headers and single-challenge blocks get no title.
String challengeTitle(Challenge challenge, Block block) {
  final total = block.challenges.length;
  if (total == 1 ||
      challenge.title.contains('Dialogue') ||
      challenge.title.contains('Step')) {
    return '';
  }

  if (challenge.title.contains('Task')) {
    final dialogues = block.challenges
        .where((c) => c.title.contains('Dialogue'))
        .length;
    return '${challenge.title} of ${total - dialogues}';
  }

  final step = block.challenges.indexWhere((c) => c.id == challenge.id) + 1;
  return 'Step $step of $total';
}
