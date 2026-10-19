import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_new/learn/ui/challenge/challenge_view.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/ui/daily_challenge/daily_challenge_view.dart';
import 'package:mobile_app_new/learn/ui/daily_challenge_archive/daily_challenge_archive_view.dart';
import 'package:mobile_app_new/learn/ui/landing/landing_view.dart';
import 'package:mobile_app_new/learn/ui/module/module_view.dart';
import 'package:mobile_app_new/learn/ui/scene_fullscreen/scene_fullscreen_view.dart';
import 'package:mobile_app_new/learn/ui/superblock/superblock_view.dart';

part 'learn.g.dart';

const learnLandingPath = '/learn';
const learnDailyChallengeArchivePath = '/learn/daily-challenges';
const learnDailyChallengePath = '/learn/daily-challenges/:day';
const learnSceneFullscreenPath = '/learn/scene-fullscreen';
const learnSuperBlockPath = '/learn/:superBlock';
const learnModulePath = '/learn/:superBlock/:module';
const learnChallengePath = '/learn/:superBlock/:block/:challengeId';

@TypedGoRoute<LearnLandingRoute>(path: learnLandingPath)
class LearnLandingRoute extends GoRouteData with $LearnLandingRoute {
  const LearnLandingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LearnLandingView();
}

@TypedGoRoute<LearnDailyChallengeArchiveRoute>(
  path: learnDailyChallengeArchivePath,
)
class LearnDailyChallengeArchiveRoute extends GoRouteData
    with $LearnDailyChallengeArchiveRoute {
  const LearnDailyChallengeArchiveRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const DailyChallengeArchiveView();
}

@TypedGoRoute<LearnDailyChallengeRoute>(path: learnDailyChallengePath)
class LearnDailyChallengeRoute extends GoRouteData
    with $LearnDailyChallengeRoute {
  const LearnDailyChallengeRoute({required this.day});

  // NOTE: MM-DD
  final String day;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      DailyChallengeView(day: day);
}

@TypedGoRoute<LearnSceneFullscreenRoute>(path: learnSceneFullscreenPath)
class LearnSceneFullscreenRoute extends GoRouteData
    with $LearnSceneFullscreenRoute {
  const LearnSceneFullscreenRoute({required this.$extra});

  final (Scene, String) $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
        key: state.pageKey,
        opaque: false,
        child: SceneFullscreenView(scene: $extra.$1, title: $extra.$2),
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      );
}

@TypedGoRoute<LearnSuperBlockRoute>(path: learnSuperBlockPath)
class LearnSuperBlockRoute extends GoRouteData with $LearnSuperBlockRoute {
  const LearnSuperBlockRoute({required this.superBlock});

  final String superBlock;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      SuperBlockView(dashedName: superBlock);
}

@TypedGoRoute<LearnModuleRoute>(path: learnModulePath)
class LearnModuleRoute extends GoRouteData with $LearnModuleRoute {
  const LearnModuleRoute({required this.superBlock, required this.module});

  final String superBlock;
  final String module;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ModuleView(superBlock: superBlock, module: module);
}

@TypedGoRoute<LearnChallengeRoute>(path: learnChallengePath)
class LearnChallengeRoute extends GoRouteData with $LearnChallengeRoute {
  const LearnChallengeRoute({
    required this.superBlock,
    required this.block,
    required this.challengeId,
  });

  final String superBlock;
  final String block;
  final String challengeId;

  @override
  Widget build(BuildContext context, GoRouterState state) => ChallengeView(
    superBlock: superBlock,
    block: block,
    challengeId: challengeId,
  );
}
