import 'dart:math';

import 'package:mobile_app_new/learn/repositories/quote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quote_service.g.dart';

typedef MotivationalQuote = ({String quote, String author});

@riverpod
LearnQuoteService learnQuoteService(Ref ref) =>
    LearnQuoteService(ref.watch(learnQuoteRepositoryProvider));

class LearnQuoteService {
  LearnQuoteService(this._repo);

  final LearnQuoteRepository _repo;

  Future<MotivationalQuote> getRandomQuote() async {
    final quotes = await _repo.getQuotes();
    final quote = quotes[Random().nextInt(quotes.length)];

    return (quote: quote['quote'] as String, author: quote['author'] as String);
  }
}
