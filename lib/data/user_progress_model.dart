import 'package:hive/hive.dart';

part 'user_progress_model.g.dart';

@HiveType(typeId: 1)
class UserProgressModel extends HiveObject {
  @HiveField(0)
  int coins;

  @HiveField(1)
  List<String> unlockedItems;

  @HiveField(2)
  Map<String, int> dailyFocusStats; // Date string (yyyy-MM-dd) -> Total seconds

  UserProgressModel({
    this.coins = 0,
    this.unlockedItems = const [],
    this.dailyFocusStats = const {},
  });
}
