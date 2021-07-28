import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;

/// This rss feed returns the articles
/// https://pub.dev/packages/webfeed
/// for examples use the link above

Future<dynamic> getRss() async {
  var data = await http.get(Uri.parse('https://www.freecodecamp.org/news/rss'),
      headers: {"Content-Type": "application/json"});

  RssFeed? rssFeed = new RssFeed.parse(data.body.toString());
  var arr = [];

  // filter the article items

  for (var i = 0; i < rssFeed.items!.length; i++) {
    arr.add([
      rssFeed.items![i].title,
      rssFeed.items![i].description,
      rssFeed.items![i].link,
      rssFeed.items![i].pubDate
    ]);
  }

  return arr;
}
