import 'package:mobile_app_new/learn/services/daily_challenge_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'daily_challenge_archive_viewmodel.g.dart';

@riverpod
Future<List<DailyChallengeMonth>> dailyChallengeArchive(Ref ref) =>
    ref.watch(learnDailyChallengeServiceProvider).getArchive();
