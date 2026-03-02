import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewsViewHandlerNotifier extends Notifier<int> {
  @override
  int build() => 1;

  void onTapped(int index) {
    state = index;
  }
}

final newsViewHandlerProvider =
    NotifierProvider<NewsViewHandlerNotifier, int>(
  NewsViewHandlerNotifier.new,
);
