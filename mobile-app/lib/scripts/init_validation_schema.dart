import 'dart:convert';
import 'dart:io';
import 'package:freecodecamp/models/main/user_model.dart';

void main() async {
  File file = File('./lib/scripts/schema-keys.json');

  Map<String, dynamic> schema = await FccUserModel.returnSchemaKeys();

  if (!await file.exists()) {
    await file.create(recursive: true);
  }

  file.writeAsString(jsonEncode(schema));
}
