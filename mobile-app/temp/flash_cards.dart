// import 'package:flutter/material.dart';
// import 'database_service.dart';

// class FlashCards extends StatefulWidget {
//   @override
//   _FlashCardsState createState() => _FlashCardsState();
// }

// class _FlashCardsState extends State<FlashCards> {
//   DatabaseService databaseService = new DatabaseService();
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: databaseService.init(),
//       builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//         return DefaultTabController(
//           length: 1,
//           child: Scaffold(
//             appBar: AppBar(
//               backgroundColor: Color(0xFF0a0a23),
//               bottom: TabBar(
//                 indicatorColor: Colors.white,
//                 tabs: [
//                   Tab(text: "Cards"),
//                   // Tab(text: "General"),
//                   // Tab(text: "Code"),
//                 ],
//               ),
//               title: Text('Flash Cards'),
//             ),
//             body: TabBarView(
//               children: [
//                 // CardsTabWidget(databaseService: databaseService),
//                 // ShowFlashCardWidget(databaseService: databaseService, type: 5),
//                 // ShowFlashCardWidget(databaseService: databaseService, type: 6),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
