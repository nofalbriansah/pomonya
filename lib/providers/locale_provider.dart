import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database_service.dart';
import 'settings_provider.dart';

final localeProvider = AsyncNotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);

class LocaleNotifier extends AsyncNotifier<Locale> {
  @override
  Future<Locale> build() async {
    final settings = await ref.watch(settingsProvider.future);
    return Locale(settings.languageCode ?? 'en');
  }

  Future<void> setLocale(String languageCode) async {
    final settings = await ref.read(settingsProvider.future);
    settings.languageCode = languageCode;
    await DatabaseService.updateSettings(settings);
    ref.invalidate(settingsProvider);
  }
}
