import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/hive_service.dart';

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final settings = HiveService.getSettings();
    return settings.isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme() {
    final settings = HiveService.getSettings();
    settings.isDarkMode = !settings.isDarkMode;
    settings.save();
    state = settings.isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  void setThemeMode(ThemeMode mode) {
    final settings = HiveService.getSettings();
    settings.isDarkMode = mode == ThemeMode.dark;
    settings.save();
    state = mode;
  }
}
