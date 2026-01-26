import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/hive_service.dart';
import '../data/settings_model.dart';
import 'timer_provider.dart';

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsModel>(
  SettingsNotifier.new,
);

class SettingsNotifier extends Notifier<SettingsModel> {
  @override
  SettingsModel build() {
    return HiveService.getSettings();
  }

  void updateFocusDuration(int minutes) {
    state.focusDuration = minutes * 60;
    state.save();
    ref.notifyListeners(); // Force update if necessary
    ref.read(timerProvider.notifier).reset();
  }

  void updateShortBreakDuration(int minutes) {
    state.shortBreakDuration = minutes * 60;
    state.save();
    ref.notifyListeners();
  }

  void updateLongBreakDuration(int minutes) {
    state.longBreakDuration = minutes * 60;
    state.save();
    ref.notifyListeners();
  }

  void toggleAutoQuest(bool value) {
    state.autoQuest = value;
    state.save();
    ref.notifyListeners();
  }

  void toggleSound(bool value) {
    state.isSoundEnabled = value;
    state.save();
    ref.notifyListeners();
  }
}
