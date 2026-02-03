import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database_service.dart';
import 'settings_provider.dart';

final themeProvider = AsyncNotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);

class ThemeNotifier extends AsyncNotifier<ThemeMode> {
  @override
  Future<ThemeMode> build() async {
    final settings = await ref.watch(settingsProvider.future);
    if (settings.isDarkMode == null) return ThemeMode.system;
    return settings.isDarkMode! ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggleTheme() async {
    final settings = await ref.read(settingsProvider.future);
    settings.isDarkMode = !(settings.isDarkMode ?? true);
    await DatabaseService.updateSettings(settings);
    // Refresh settings provider
    ref.invalidate(settingsProvider);
  }

  Future<void> setTheme(ThemeMode mode) async {
    final settings = await ref.read(settingsProvider.future);
    settings.isDarkMode = mode == ThemeMode.dark;
    await DatabaseService.updateSettings(settings);
    ref.invalidate(settingsProvider);
  }
}
