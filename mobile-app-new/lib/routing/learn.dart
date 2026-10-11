import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_new/learn/ui/challenge/challenge_placeholder_view.dart';
import 'package:mobile_app_new/learn/ui/daily_challenge_archive/daily_challenge_archive_view.dart';
import 'package:mobile_app_new/learn/ui/landing/landing_view.dart';
import 'package:mobile_app_new/learn/ui/module/module_view.dart';
import 'package:mobile_app_new/learn/ui/superblock/superblock_view.dart';

part 'learn.g.dart';

const learnLandingPath = '/learn';
const learnDailyChallengeArchivePath = '/learn/daily-challenges';
const learnDailyChallengePath = '/learn/daily-challenges/:day';
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

// TODO: Iteration 4 replaces the placeholder with the daily challenge editor.
@TypedGoRoute<LearnDailyChallengeRoute>(path: learnDailyChallengePath)
class LearnDailyChallengeRoute extends GoRouteData
    with $LearnDailyChallengeRoute {
  const LearnDailyChallengeRoute({required this.day});

  // NOTE: MM-DD
  final String day;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ChallengePlaceholderView(details: 'Daily challenge $day');
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

// TODO: Iterations 3 and 4 replace the placeholder with the challenge views.
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
  Widget build(BuildContext context, GoRouterState state) =>
      ChallengePlaceholderView(details: '$superBlock/$block/$challengeId');
}
