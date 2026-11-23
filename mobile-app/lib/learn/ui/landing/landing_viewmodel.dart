import 'package:freecodecamp/learn/services/quote_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'landing_viewmodel.g.dart';

@riverpod
Future<MotivationalQuote> motivationalQuote(Ref ref) =>
    ref.watch(learnQuoteServiceProvider).getRandomQuote();
