import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants.dart';
import '../../providers/currency_provider.dart';
import '../../providers/shop_provider.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coins = ref.watch(currencyProvider);
    final unlockedItems = ref.watch(shopProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ARCADE SHOP',
          style: Theme.of(
            context,
          ).textTheme.displayLarge?.copyWith(fontSize: 20),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [_buildCoinBadge(context, coins), const SizedBox(width: 16)],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: shopItems.length,
        itemBuilder: (context, index) {
          final item = shopItems[index];
          final isUnlocked = unlockedItems.contains(item.id);

          return _ShopItemCard(
            item: item,
            isUnlocked: isUnlocked,
            onTap: () {
              if (!isUnlocked) {
                _showPurchaseDialog(context, ref, item);
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildCoinBadge(BuildContext context, int coins) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.neonFuchsia, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonFuchsia.withValues(alpha: 0.3),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.monetization_on,
            color: AppColors.neonFuchsia,
            size: 18,
          ),
          const SizedBox(width: 4),
          Text(
            '$coins',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.neonFuchsia,
              fontWeight: FontWeight.bold,
              fontFamily: 'Press Start 2P',
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  void _showPurchaseDialog(BuildContext context, WidgetRef ref, ShopItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.glassBorder),
        ),
        title: Text(
          'BUY ${item.name.toUpperCase()}?',
          style: Theme.of(
            context,
          ).textTheme.displayMedium?.copyWith(fontSize: 14),
        ),
        content: Text(
          'This item costs ${item.price} coins.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.electricBlue,
            ),
            onPressed: () {
              final success = ref.read(shopProvider.notifier).buyItem(item);
              Navigator.pop(context);
              if (!success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Not enough coins!')),
                );
              }
            },
            child: const Text(
              'PURCHASE',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShopItemCard extends StatelessWidget {
  final ShopItem item;
  final bool isUnlocked;
  final VoidCallback onTap;

  const _ShopItemCard({
    required this.item,
    required this.isUnlocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnlocked ? AppColors.electricBlue : AppColors.glassBorder,
            width: isUnlocked ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isUnlocked ? Icons.check_circle : Icons.lock,
              color: isUnlocked ? AppColors.electricBlue : Colors.grey,
            ),
            const SizedBox(height: 10),
            Text(
              item.name,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            if (!isUnlocked)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.monetization_on,
                    color: AppColors.neonFuchsia,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${item.price}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.neonFuchsia,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            else
              Text(
                'UNLOCKED',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.electricBlue),
              ),
          ],
        ),
      ),
    );
  }
}
