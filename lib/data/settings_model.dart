class SettingsModel {
  int focusDuration;
  int shortBreakDuration;
  int longBreakDuration;
  bool autoQuest;
  bool? isSoundEnabled;
  bool? isDarkMode;
  String? languageCode;

  SettingsModel({
    this.focusDuration = 25 * 60,
    this.shortBreakDuration = 5 * 60,
    this.longBreakDuration = 15 * 60,
    this.autoQuest = false,
    this.isSoundEnabled = true,
    this.isDarkMode = true,
    this.languageCode = 'en',
  });
}
