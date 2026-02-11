import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomonya/l10n/generated/app_localizations.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      extendBody: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      body: navigationShell,
      bottomNavigationBar: _buildGlassBottomNav(context, theme, l10n),
    );
  }

  Widget _buildGlassBottomNav(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(color: theme.colorScheme.outline, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                0,
                Icons.home_rounded,
                l10n.navHome.toUpperCase(),
                theme.colorScheme.primary,
                theme,
              ),
              _buildNavItem(
                context,
                1,
                Icons.storefront_rounded,
                l10n.navShop.toUpperCase(),
                theme.colorScheme.primary,
                theme,
              ),
              _buildNavItem(
                context,
                2,
                Icons.bar_chart_rounded,
                l10n.navStats.toUpperCase(),
                theme.colorScheme.primary,
                theme,
              ),
              _buildNavItem(
                context,
                3,
                Icons.settings_rounded,
                l10n.navSettings.toUpperCase(),
                theme.colorScheme.primary,
                theme,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData icon,
    String label,
    Color activeColor,
    ThemeData theme,
  ) {
    final isSelected = navigationShell.currentIndex == index;
    final color = isSelected ? activeColor : theme.textTheme.bodySmall?.color;

    return InkWell(
      onTap: () {
        navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        );
      },
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: color,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
