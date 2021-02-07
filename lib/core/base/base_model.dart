import 'package:equatable/equatable.dart';

abstract class BaseModel with EquatableMixin {
  Map<String, Object> toMap();
  Map<String, String> get userValues;
  Map<String, String> get userKeys;

  @override
  String toString() => toMap().toString();
}
