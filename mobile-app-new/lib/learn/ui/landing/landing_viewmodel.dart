import 'package:mobile_app_new/learn/models/daily_challenge_model.dart';
import 'package:mobile_app_new/learn/services/daily_challenge_service.dart';
import 'package:mobile_app_new/learn/services/quote_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'landing_viewmodel.g.dart';

@riverpod
Future<DailyChallengeOverview> dailyChallengeToday(Ref ref) =>
    ref.watch(learnDailyChallengeServiceProvider).getToday();

@riverpod
Future<MotivationalQuote> motivationalQuote(Ref ref) =>
    ref.watch(learnQuoteServiceProvider).getRandomQuote();
