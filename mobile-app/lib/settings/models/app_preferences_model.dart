import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_preferences_model.freezed.dart';

@freezed
abstract class AppPreferences with _$AppPreferences {
  const factory AppPreferences({
    @Default(ThemeMode.dark) ThemeMode themeMode,
    @Default(false) bool dailyReminder,
  }) = _AppPreferences;
}
