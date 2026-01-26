import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/hive_service.dart';
import 'currency_provider.dart';

class ShopItem {
  final String id;
  final String name;
  final int price;
  final String imagePath;

  ShopItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imagePath,
  });
}

final shopItems = [
  ShopItem(
    id: 'skin_classic',
    name: 'Classic Mpus',
    price: 0,
    imagePath: 'assets/skins/classic.png',
  ),
  ShopItem(
    id: 'skin_cyber',
    name: 'Cyber Mpus',
    price: 50,
    imagePath: 'assets/skins/classic.png',
  ),
  ShopItem(
    id: 'skin_gold',
    name: 'Golden Mpus',
    price: 150,
    imagePath: 'assets/skins/classic.png',
  ),
  ShopItem(
    id: 'hat_pixel',
    name: 'Pixel Cap',
    price: 30,
    imagePath: 'assets/skins/classic.png',
  ),
];
// The original snippet had a syntax error here: `];  ),`
// I'm correcting it to just `];` to maintain valid syntax.

final shopProvider = NotifierProvider<ShopNotifier, List<String>>(
  ShopNotifier.new,
);

class ShopNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    final progress = HiveService.getUserProgress();
    final items = progress.unlockedItems;
    if (!items.contains('skin_classic')) {
      final newItems = [...items, 'skin_classic'];
      progress.unlockedItems = newItems;
      progress.save();
      return newItems;
    }
    return items;
  }

  bool buyItem(ShopItem item) {
    if (state.contains(item.id)) return false;

    final success = ref.read(currencyProvider.notifier).spendCoins(item.price);
    if (success) {
      state = [...state, item.id];
      final progress = HiveService.getUserProgress();
      progress.unlockedItems = state;
      progress.save();
      return true;
    }
    return false;
  }
}
