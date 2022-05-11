import 'dart:convert';
import 'dart:io';
import 'package:freecodecamp/models/main/user_model.dart';

void main() async {
  File file = File('./lib/scripts/schema-keys.txt');

  Map<String, dynamic> schema = await FccUserModel.returnSchemaKeys();

  if (!await file.exists()) {
    await file.create(recursive: true);
  }

  List userModelKeys = [];

  schema.forEach((key, value) {
    userModelKeys.add(key);
  });

  file.writeAsString(userModelKeys.toString());
}
