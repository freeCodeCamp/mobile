class MotivationalQuote {
  final String quote;
  final String author;

  MotivationalQuote({required this.quote, required this.author});

  factory MotivationalQuote.fromJson(Map<String, dynamic> data) {
    return MotivationalQuote(quote: data['quote'], author: data['author']);
  }
}
