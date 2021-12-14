// import 'package:flutter/services.dart';
// import 'package:freecodecamp/models/card_model.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'dart:io';

// class DatabaseService {
//   late Database _db;

//   Future<void> init() async {
//     String dbPath = await getDatabasesPath();
//     String dbPathCards = join(dbPath, "cards-jwasham.db");
//     bool dbExistsCards = await databaseExists(dbPathCards);

//     if (!dbExistsCards) {
//       // Should happen only the first time you launch your application
//       print("Creating new copy from asset");
//       // Make sure the parent directory exists
//       try {
//         await Directory(dirname(dbPathCards)).create(recursive: true);
//       } catch (e) {
//         print(e);
//       }

//       // Copy from asset
//       ByteData data =
//           await rootBundle.load(join("assets", "database", "cards-jwasham.db"));
//       List<int> bytes =
//           data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
//       // Write and flush the bytes written
//       await File(dbPathCards).writeAsBytes(bytes, flush: true);
//     } else {
//       print("Opening existing database");
//     }
//     // open the database
//     this._db = await openDatabase(dbPathCards);
//   }

//   Future<void> insertCard(CardModel card) async {
//     Map<String, dynamic> cardMap = card.toMap();
//     cardMap.remove("id");
//     int result = await _db.insert(
//       'cards',
//       cardMap,
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//     print("result: " + result.toString());
//   }

//   /// get all the cards.type -> All - 0, General - 1, Code - 2, Known -3, Unknown - 4, General and Unknown - 5, Code and Unknown - 6
//   Future getCards(int type) async {
//     print("get cards of type $type called");
//     // Query the table for all The Dogs.
//     List<Map<String, dynamic>> cards = [];
//     if (type == 0) {
//       cards = await _db.query('cards');
//     } else if (type == 1 || type == 2) {
//       cards = await _db.query('cards', where: 'type = ?', whereArgs: [type]);
//     } else if (type == 3) {
//       cards = await _db.query('cards', where: 'known = ?', whereArgs: [1]);
//     } else if (type == 4) {
//       cards = await _db.query('cards', where: 'known = ?', whereArgs: [0]);
//     } else if (type == 5) {
//       cards = await _db
//           .query('cards', where: 'known = ? AND type = ?', whereArgs: [0, 1]);
//     } else if (type == 6) {
//       cards = await _db
//           .query('cards', where: 'known = ? AND type = ?', whereArgs: [0, 2]);
//     }
//     return List<Map<String, dynamic>>.from(cards);
//   }

//   Future<void> updateCard(CardModel card) async {
//     // Update the given card.
//     int result = await _db.update(
//       'cards',
//       card.toMap(),
//       // Ensure that the card has a matching id.
//       where: "id = ?",
//       // Pass the card's id as a whereArg to prevent SQL injection.
//       whereArgs: [card.id],
//     );
//     print("update card: $result");
//   }

//   Future<void> deleteCard(CardModel card) async {
//     int result =
//         await _db.delete('cards', where: 'id = ?', whereArgs: [card.id]);
//     print("deleteCard card: $result");
//   }
// }
