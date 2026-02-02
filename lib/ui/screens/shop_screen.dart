import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
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
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, coins),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 100,
                ),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200, // Responsive cards
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int coins) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildGlassButton(
            icon: Icons.arrow_back_rounded,
            onTap: () =>
                context.go('/'), // Though usually bottom nav controlled
          ),

          Text(
            'ARCADE SHOP',
            style: GoogleFonts.pressStart2p(
              fontSize: 12,
              color: AppColors.neonFuchsia,
              shadows: [
                BoxShadow(
                  color: AppColors.neonFuchsia.withOpacity(0.5),
                  blurRadius: 10,
                ),
              ],
              letterSpacing: 2,
            ),
          ),

          _buildCoinBadge(context, coins),
        ],
      ),
    );
  }

  Widget _buildGlassButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    // Reusing the style from Settings/Home for consistency
    // Ideally this would be a shared widget
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Icon(icon, color: Colors.white.withOpacity(0.8), size: 20),
      ),
    );
  }

  Widget _buildCoinBadge(BuildContext context, int coins) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.neonFuchsia.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonFuchsia.withOpacity(0.2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('💎', style: TextStyle(fontSize: 12)),
          const SizedBox(width: 6),
          Text(
            '$coins',
            style: GoogleFonts.pressStart2p(fontSize: 10, color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _showPurchaseDialog(BuildContext context, WidgetRef ref, ShopItem item) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.neonFuchsia),
            boxShadow: [
              BoxShadow(
                color: AppColors.neonFuchsia.withOpacity(0.2),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'UNLOCK ITEM?',
                style: GoogleFonts.pressStart2p(
                  fontSize: 12,
                  color: AppColors.neonFuchsia,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                item.name.toUpperCase(),
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Cost: ${item.price} Gems',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'CANCEL',
                        style: GoogleFonts.pressStart2p(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final success = ref
                            .read(shopProvider.notifier)
                            .buyItem(item);
                        Navigator.pop(context);
                        if (!success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Not enough gems!')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.neonFuchsia,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'BUY',
                        style: GoogleFonts.pressStart2p(fontSize: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceDark.withOpacity(0.6),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isUnlocked ? AppColors.electricBlue : AppColors.glassBorder,
            width: isUnlocked ? 2 : 1,
          ),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: AppColors.electricBlue.withOpacity(0.2),
                    blurRadius: 15,
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isUnlocked
                    ? AppColors.electricBlue.withOpacity(0.1)
                    : Colors.black.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isUnlocked ? Icons.check : Icons.lock_outline,
                color: isUnlocked ? AppColors.electricBlue : Colors.grey,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              item.name.toUpperCase(),
              textAlign: TextAlign.center,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            if (!isUnlocked)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.neonFuchsia.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.neonFuchsia.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  '${item.price} 💎',
                  style: GoogleFonts.pressStart2p(
                    fontSize: 8,
                    color: AppColors.neonFuchsia,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
