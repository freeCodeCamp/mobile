// To parse this JSON data, do
//
//     final cardModel = cardModelFromMap(jsonString);

import 'dart:convert';

CardModel cardModelFromMap(String str) => CardModel.fromMap(json.decode(str));

String cardModelToMap(CardModel data) => json.encode(data.toMap());

class CardModel {
  CardModel({
    required this.id,
    required this.type,
    required this.front,
    required this.back,
    required this.known,
  });

  int id;
  int type;
  String front;
  String back;
  bool known;

  factory CardModel.fromMap(Map<String, dynamic> json) => CardModel(
        id: json["id"],
        type: json["type"],
        front: json["front"],
        back: json["back"],
        known: json["known"] == 0 ? false : true,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "type": type,
        "front": front,
        "back": back,
        "known": known == false ? 0 : 1,
      };
}
