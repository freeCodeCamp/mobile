import 'package:freecodecamp/learn/services/daily_challenge_service.dart';
import 'package:freecodecamp/utils/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'daily_challenge_archive_viewmodel.g.dart';

@Riverpod(retry: noRetry)
Future<List<DailyChallengeMonth>> dailyChallengeArchive(Ref ref) =>
    ref.watch(learnDailyChallengeServiceProvider).getArchive();
