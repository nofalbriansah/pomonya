import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/hive_service.dart';

final currencyProvider = NotifierProvider<CurrencyNotifier, int>(
  CurrencyNotifier.new,
);

class CurrencyNotifier extends Notifier<int> {
  @override
  int build() {
    final progress = HiveService.getUserProgress();
    return progress.coins;
  }

  void addCoins(int amount) {
    final progress = HiveService.getUserProgress();
    progress.coins += amount;
    progress.save();
    state = progress.coins;
  }

  bool spendCoins(int amount) {
    final progress = HiveService.getUserProgress();
    if (progress.coins >= amount) {
      progress.coins -= amount;
      progress.save();
      state = progress.coins;
      return true;
    }
    return false;
  }
}
