import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database_service.dart';
import '../data/settings_model.dart';
import 'timer_provider.dart';

final settingsProvider = AsyncNotifierProvider<SettingsNotifier, SettingsModel>(
  SettingsNotifier.new,
);

class SettingsNotifier extends AsyncNotifier<SettingsModel> {
  @override
  Future<SettingsModel> build() async {
    return await DatabaseService.getSettings();
  }

  Future<void> updateFocusDuration(int minutes) async {
    final current = await future;
    current.focusDuration = minutes * 60;
    await DatabaseService.updateSettings(current);
    state = AsyncData(current);
    ref.read(timerProvider.notifier).reset();
  }

  Future<void> updateShortBreakDuration(int minutes) async {
    final current = await future;
    current.shortBreakDuration = minutes * 60;
    await DatabaseService.updateSettings(current);
    state = AsyncData(current);
  }

  Future<void> updateLongBreakDuration(int minutes) async {
    final current = await future;
    current.longBreakDuration = minutes * 60;
    await DatabaseService.updateSettings(current);
    state = AsyncData(current);
  }

  Future<void> toggleAutoQuest(bool value) async {
    final current = await future;
    current.autoQuest = value;
    await DatabaseService.updateSettings(current);
    state = AsyncData(current);
  }

  Future<void> toggleSound(bool value) async {
    final current = await future;
    current.isSoundEnabled = value;
    await DatabaseService.updateSettings(current);
    state = AsyncData(current);
  }
}
