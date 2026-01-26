import 'package:hive/hive.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 0)
class SettingsModel extends HiveObject {
  @HiveField(0)
  int focusDuration;

  @HiveField(1)
  int shortBreakDuration;

  @HiveField(2)
  int longBreakDuration;

  @HiveField(3)
  bool autoQuest;

  @HiveField(4)
  bool isSoundEnabled;

  @HiveField(5)
  bool isDarkMode;

  SettingsModel({
    this.focusDuration = 25 * 60,
    this.shortBreakDuration = 5 * 60,
    this.longBreakDuration = 15 * 60,
    this.autoQuest = false,
    this.isSoundEnabled = true,
    this.isDarkMode = true,
  });
}
