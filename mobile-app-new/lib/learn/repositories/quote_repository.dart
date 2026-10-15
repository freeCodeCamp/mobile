import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quote_repository.g.dart';

@riverpod
LearnQuoteRepository learnQuoteRepository(Ref ref) => LearnQuoteRepository();

class LearnQuoteRepository {
  Future<List<Map<String, dynamic>>> getQuotes() async {
    final file = await rootBundle.loadString(
      'assets/learn/motivational-quotes.json',
    );
    final quotes =
        (jsonDecode(file) as Map<String, dynamic>)['motivationalQuotes'];

    return [
      for (final entry in quotes is List ? quotes : const [])
        if (entry is Map<String, dynamic>) entry,
    ];
  }
}
