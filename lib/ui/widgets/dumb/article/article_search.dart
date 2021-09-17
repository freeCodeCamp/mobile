// // ignore: file_names
// import 'package:flutter/material.dart';
// import 'package:algolia/algolia.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'dart:developer' as dev;

// import '../../../views/news/news-feed/news_feed.dart';
// import 'article_view.dart';

// class ArticleSearch extends StatefulWidget {
//   const ArticleSearch({Key? key}) : super(key: key);

//   @override
//   _ArticleSearchState createState() => _ArticleSearchState();
// }

// class _ArticleSearchState extends State<ArticleSearch> {
//   bool hasSearched = false;
//   String _searchTerm = '';

//   @override
//   void initState() {
//     super.initState();
//   }

//   final searchbarController = TextEditingController();

//   Future<List<AlgoliaObjectSnapshot>> _search(String inputQuery) async {
//     await dotenv.load(fileName: ".env");

//     final Algolia algoliaInit = Algolia.init(
//       applicationId: dotenv.env['ALGOLIAAPPID'] as String,
//       apiKey: dotenv.env['ALGOLIAKEY'] as String,
//     );

//     Algolia algolia = algoliaInit;

//     AlgoliaQuery query = algolia.instance.index('news').query(inputQuery);

//     AlgoliaQuerySnapshot snap = await query.getObjects();

//     List<AlgoliaObjectSnapshot> results = snap.hits;

//     return results;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: TextField(
//             controller: searchbarController,
//             decoration: const InputDecoration(
//                 hintText: "SEARCH ARTICLE...",
//                 hintStyle: TextStyle(color: Colors.white),
//                 fillColor: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
//                 filled: true),
//             style: const TextStyle(color: Colors.white),
//             onChanged: (value) {
//               setState(() {
//                 _searchTerm = value;
//               });
//             },
//           ),
//           centerTitle: true,
//           backgroundColor: const Color(0xFF0a0a23),
//         ),
//         backgroundColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
//         body: StreamBuilder<List<AlgoliaObjectSnapshot>>(
//           stream: Stream.fromFuture(_search(_searchTerm)),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }

//             if (snapshot.hasError) return Text('Error: ${snapshot.error}');

//             List<AlgoliaObjectSnapshot>? current = snapshot.data;
//             dev.log(current![0].data['title'].toString());
//             dev.log(current.length.toString());

//             return Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                       itemCount: current.length,
//                       itemBuilder: (context, index) {
//                         return Container(
//                           height: 75,
//                           decoration: const BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(
//                                       width: 2, color: Colors.white))),
//                           child: Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: InkWell(
//                               child: Text(
//                                 truncateStr(current[index].data['title']),
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               onTap: () => {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => ArticleViewTemplate(
//                                         articleId:
//                                             current[index].data["objectID"]),
//                                   ),
//                                 ),
//                               },
//                             ),
//                           ),
//                         );
//                       }),
//                 )
//               ],
//             );
//           },
//         ));
//   }
// }
