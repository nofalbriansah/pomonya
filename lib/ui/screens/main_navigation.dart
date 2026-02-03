import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      height: 100, // Includes content + safe area padding
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.surfaceContainer.withOpacity(0.8),
            theme.colorScheme.surfaceContainer,
          ],
        ),
        border: Border(
          top: BorderSide(color: theme.colorScheme.outline.withOpacity(0.1)),
        ), // gentle border
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context,
                  0,
                  Icons.home_rounded,
                  l10n.navHome,
                  Colors.greenAccent,
                  theme,
                ),
                _buildNavItem(
                  context,
                  1,
                  Icons.storefront_rounded,
                  l10n.navShop,
                  Colors.blueAccent,
                  theme,
                ),
                _buildNavItem(
                  context,
                  2,
                  Icons.leaderboard_rounded,
                  l10n.navStats,
                  Colors.amberAccent,
                  theme,
                ),
                _buildNavItem(
                  context,
                  3,
                  Icons.settings_rounded,
                  l10n.navSettings,
                  Colors.purpleAccent,
                  theme,
                ),
              ],
            ),
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
    Color color,
    ThemeData theme,
  ) {
    final isSelected = navigationShell.currentIndex == index;
    final activeColor = color;
    // Adapt inactive color based on theme brightness
    final inactiveColor = theme.brightness == Brightness.dark
        ? Colors.grey.withOpacity(0.5)
        : Colors.grey.shade600;

    return GestureDetector(
      onTap: () {
        navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        );
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                if (isSelected)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: activeColor.withOpacity(0.4),
                            blurRadius: 15,
                            spreadRadius: -2,
                          ),
                        ],
                      ),
                    ),
                  ),
                Icon(
                  icon,
                  size: 28,
                  color: isSelected ? activeColor : inactiveColor,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.pressStart2p(
                fontSize: 8,
                color: isSelected ? activeColor : inactiveColor,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
