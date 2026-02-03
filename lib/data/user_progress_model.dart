class UserProgressModel {
  int coins;
  List<String> unlockedItems;
  Map<String, int> dailyFocusStats; // Date string (yyyy-MM-dd) -> Total seconds

  UserProgressModel({
    this.coins = 0,
    this.unlockedItems = const [],
    this.dailyFocusStats = const {},
  });
}
