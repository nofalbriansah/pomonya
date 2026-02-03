import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:pomonya/l10n/generated/app_localizations.dart';
import '../../core/constants.dart';
import '../../providers/currency_provider.dart';
import '../../providers/shop_provider.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coinsAsync = ref.watch(currencyProvider);
    final unlockedItemsAsync = ref.watch(shopProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            coinsAsync.when(
              data: (coins) => _buildHeader(context, coins, theme, l10n),
              loading: () =>
                  _buildHeader(context, 0, theme, l10n), // Fallback header
              error: (_, __) => _buildHeader(context, 0, theme, l10n),
            ),
            Expanded(
              child: unlockedItemsAsync.when(
                data: (unlockedItems) => GridView.builder(
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
                          _showPurchaseDialog(context, ref, item, theme, l10n);
                        }
                      },
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    int coins,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildGlassButton(
            icon: Icons.arrow_back_rounded,
            onTap: () =>
                context.go('/'), // Though usually bottom nav controlled
            theme: theme,
          ),

          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                l10n.shopTitle,
                style: GoogleFonts.pressStart2p(
                  fontSize: 12,
                  color: theme.colorScheme.secondary,
                  shadows: [
                    BoxShadow(
                      color: theme.colorScheme.secondary.withOpacity(0.5),
                      blurRadius: 10,
                    ),
                  ],
                  letterSpacing: 2,
                ),
              ),
            ),
          ),

          _buildCoinBadge(context, coins, theme),
        ],
      ),
    );
  }

  Widget _buildGlassButton({
    required IconData icon,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    // Reusing the style from Settings/Home for consistency
    // Ideally this would be a shared widget
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: theme.cardTheme.color?.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.cardTheme.shape is RoundedRectangleBorder
              ? (theme.cardTheme.shape as RoundedRectangleBorder).side.color ??
                    AppColors.glassBorder
              : AppColors.glassBorder,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Icon(
          icon,
          color:
              theme.iconTheme.color?.withOpacity(0.8) ??
              Colors.white.withOpacity(0.8),
          size: 20,
        ),
      ),
    );
  }

  Widget _buildCoinBadge(BuildContext context, int coins, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.secondary.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.secondary.withOpacity(0.2),
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
            style: GoogleFonts.pressStart2p(
              fontSize: 10,
              color: theme.textTheme.bodyLarge?.color ?? Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showPurchaseDialog(
    BuildContext context,
    WidgetRef ref,
    ShopItem item,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: theme.colorScheme.secondary),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.secondary.withOpacity(0.2),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.shopUnlockItem,
                style: GoogleFonts.pressStart2p(
                  fontSize: 12,
                  color: theme.colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                item.name.toUpperCase(),
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge?.color ?? Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.shopCost(item.price),
                style: GoogleFonts.spaceGrotesk(
                  color:
                      theme.textTheme.bodyMedium?.color?.withOpacity(0.7) ??
                      Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        l10n.shopCancel,
                        style: GoogleFonts.pressStart2p(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final success = await ref
                            .read(shopProvider.notifier)
                            .buyItem(item);
                        if (context.mounted) Navigator.pop(context);
                        if (!success) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.shopNotEnoughGems)),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.secondary,
                        foregroundColor: theme.colorScheme.onSecondary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.borderRadiusS,
                          ),
                        ),
                      ),
                      child: Text(
                        l10n.shopBuy,
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
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardTheme.color?.withOpacity(0.6),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isUnlocked
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
            width: isUnlocked ? 2 : 1,
          ),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.2),
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
                    : theme.disabledColor.withOpacity(0.2), // Darker grey
                shape: BoxShape.circle,
              ),
              child: Icon(
                isUnlocked ? Icons.check : Icons.lock_outline,
                color: isUnlocked ? theme.colorScheme.primary : Colors.grey,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40, // Fixed height for two lines
              child: Text(
                item.name.toUpperCase(),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge?.color ?? Colors.white,
                ),
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
                  color: theme.colorScheme.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                  border: Border.all(
                    color: theme.colorScheme.secondary.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  '${item.price} 💎',
                  style: GoogleFonts.pressStart2p(
                    fontSize: 8,
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
