import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database_service.dart';
import 'currency_provider.dart';

enum ItemRarity { none, epic, legendary }

class ShopItem {
  final String id;
  final String name;
  final int price;
  final String imagePath;
  final ItemRarity rarity;

  ShopItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    this.rarity = ItemRarity.none,
  });
}

final shopItems = [
  ShopItem(
    id: 'skin_classic',
    name: 'Standard Pomonya',
    price: 0,
    imagePath:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBwgk2-IAHH07UZbCkhxjWVZ9LRNlo7nf6T4WfGAV7_Tik4N9wcUNA7ecryiQ18kW9vLwU4T5FmUbkKMACebJim1zLW0ACJp5zfHTW0f6tWnZuuli2HXxgN-dVaHECPytsLBY7MgtIxhYRQmoQ4uRvKpxzr8MwGJ7378tJgyK4BOSEnnqRCH6KR5qz9_5q08RksXhl0-XGfzT4RwQUzpc1ng71ek4JM6QM2IifE0t-yhyhwmlOKxZMXi5nboBJoIzptjzhGESgB5ZAt',
    rarity: ItemRarity.none,
  ),
  ShopItem(
    id: 'skin_mecha',
    name: 'Mecha Pomonya',
    price: 200,
    imagePath:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCEFme9j2dZOwqduXkTCubdXIClFt_mXUz22D04Ucp89gJXhjrrAO6wXuzmS9whL4B0TSFJxCnzTxK5VPVSI8mJNakw9NLYmRHyQPWu5PVhz8QI6ihW5QT1OzyawNO8elwDDo-dcLrIxiX93mtG9INjlotqpZt-3mvQGgCUMVx9vN9xC8KOI2eSR5rHIj3ApuiI1cLH_rWuGq0iW75PuguwH8tIhWWiTc36h1PvCIzA6EN3ICdbRn1rDgMyVOuURD9Rpp92nqHNF35k',
    rarity: ItemRarity.none,
  ),
  ShopItem(
    id: 'skin_chef',
    name: 'Sushi Chef',
    price: 500,
    imagePath:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCCxJ3O2toVYVTTGPhMMEOZzRe4X4mCc15lZTvNeCYiPkAyiiP6Qvlj_zlbBRoKPAmCSqTOV_Huyo4lwKS6JnDQnp3lg2xPhmFRnGj3lMp1ezOrzomJY7b5V5yIF1IdL3Snjch2XgVA_hN0Vtlx3JJWLu5gTzJuURjuNcRXAhz7DTgCz_rQSHDHdMafOWvsP0niPpN8vpaRp4Myzf5WAzcRCOVT8ocAeCxRFFqybXW38yZGX2oq4iFf-zRTDpp5W4fNQZ4KVz_9yCzY',
    rarity: ItemRarity.epic,
  ),
  ShopItem(
    id: 'skin_neon',
    name: 'Neon Vibez',
    price: 1500,
    imagePath:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCXdi07D9ONkfrzJyaTV0mv-8Cmrjorl0PBXdDrIeYt3pe6491u-fas7haIRAXk7f5OubsZoj2R-bRSzvlCuhAz3IJN0BeFh_nV_zNPQRcft-rqEsIusdfZCJWF_ljDjAGquzkkWtRRoYn7TQWwCb472uHI05Mtdv7GynS3Rbazrs9j5aMnTM8OUFje04aiiuQYPoIlZ4_l2PQj58kHKK5Gw8CX7bflIJGGvJ9FQP-iKsmZN1RVAS9YqroC7mTFUwGpHtsm0fv3495j',
    rarity: ItemRarity.legendary,
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
