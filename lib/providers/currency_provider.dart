import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database_service.dart';

final currencyProvider = AsyncNotifierProvider<CurrencyNotifier, int>(
  CurrencyNotifier.new,
);

class CurrencyNotifier extends AsyncNotifier<int> {
  @override
  Future<int> build() async {
    final progress = await DatabaseService.getUserProgress();
    return progress.coins;
  }

  Future<void> addCoins(int amount) async {
    final currentCoins = await future;
    final newCoins = currentCoins + amount;
    await DatabaseService.updateCoins(newCoins);
    state = AsyncData(newCoins);
  }

  Future<bool> spendCoins(int amount) async {
    final currentCoins = await future;
    if (currentCoins >= amount) {
      final newCoins = currentCoins - amount;
      await DatabaseService.updateCoins(newCoins);
      state = AsyncData(newCoins);
      return true;
    }
    return false;
  }
}
