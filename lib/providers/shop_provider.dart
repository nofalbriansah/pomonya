import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database_service.dart';
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

final shopProvider = AsyncNotifierProvider<ShopNotifier, List<String>>(
  ShopNotifier.new,
);

class ShopNotifier extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() async {
    final progress = await DatabaseService.getUserProgress();
    final items = progress.unlockedItems;
    if (!items.contains('skin_classic')) {
      await DatabaseService.addUnlockedItem('skin_classic');
      return [...items, 'skin_classic'];
    }
    return items;
  }

  Future<bool> buyItem(ShopItem item) async {
    final currentItems = await future;
    if (currentItems.contains(item.id)) return false;

    final success = await ref
        .read(currencyProvider.notifier)
        .spendCoins(item.price);
    if (success) {
      await DatabaseService.addUnlockedItem(item.id);
      state = AsyncData([...currentItems, item.id]);
      return true;
    }
    return false;
  }
}
