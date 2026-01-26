import 'package:hive_flutter/hive_flutter.dart';
import '../core/constants.dart';
import 'settings_model.dart';
import 'user_progress_model.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters
    Hive.registerAdapter(SettingsModelAdapter());
    Hive.registerAdapter(UserProgressModelAdapter());

    // Open Boxes
    await Hive.openBox<SettingsModel>(AppConstants.settingsBox);
    await Hive.openBox<UserProgressModel>(AppConstants.userBox);
  }

  static Box<SettingsModel> get settingsBox =>
      Hive.box<SettingsModel>(AppConstants.settingsBox);
  static Box<UserProgressModel> get userBox =>
      Hive.box<UserProgressModel>(AppConstants.userBox);

  // Helper to get or create initial settings
  static SettingsModel getSettings() {
    final box = settingsBox;
    if (box.isEmpty) {
      final defaultSettings = SettingsModel();
      box.add(defaultSettings);
      return defaultSettings;
    }
    return box.getAt(0)!;
  }

  // Helper to get or create initial user progress
  static UserProgressModel getUserProgress() {
    final box = userBox;
    if (box.isEmpty) {
      final defaultProgress = UserProgressModel();
      box.add(defaultProgress);
      return defaultProgress;
    }
    return box.getAt(0)!;
  }
}
