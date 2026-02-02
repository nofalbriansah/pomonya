import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.darkBg,
      body: navigationShell,
      bottomNavigationBar: _buildGlassBottomNav(context),
    );
  }

  Widget _buildGlassBottomNav(BuildContext context) {
    return Container(
      height: 100, // Includes content + safe area padding
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.surfaceDark.withOpacity(0.8),
            AppColors.surfaceDark,
          ],
        ),
        border: const Border(top: BorderSide(color: AppColors.glassBorder)),
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
                  'Home',
                  Colors.greenAccent,
                ),
                _buildNavItem(
                  context,
                  1,
                  Icons.storefront_rounded,
                  'Shop',
                  Colors.blueAccent,
                ),
                _buildNavItem(
                  context,
                  2,
                  Icons.leaderboard_rounded,
                  'Stats',
                  Colors.amberAccent,
                ),
                _buildNavItem(
                  context,
                  3,
                  Icons.settings_rounded,
                  'Config',
                  Colors.purpleAccent,
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
  ) {
    final isSelected = navigationShell.currentIndex == index;
    final activeColor = color;
    final inactiveColor = Colors.grey.withOpacity(0.5);

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
