import 'package:flutter/material.dart';
import '../../providers/settings_provider.dart';
import '../../providers/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
                children: [
                  _buildSectionHeader(
                    'TIMER SETTINGS',
                    Icons.timer_outlined,
                    Colors.cyan,
                  ),
                  _buildTimerSettings(context, settings, notifier),

                  const SizedBox(height: 32),

                  _buildSectionHeader(
                    'GAMEPLAY',
                    Icons.sports_esports_outlined,
                    Colors.purpleAccent,
                  ),
                  _buildGameplaySettings(context, settings, notifier),

                  const SizedBox(height: 32),

                  _buildSectionHeader(
                    'APP THEME',
                    Icons.palette_outlined,
                    Colors.cyan,
                  ),
                  _buildThemeSettings(context, ref),

                  const SizedBox(height: 32),

                  _buildSectionHeader(
                    'SOUND FX',
                    Icons.graphic_eq,
                    Colors.cyan,
                  ),
                  _buildSoundSettings(context, settings, notifier),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildGlassButton(
            icon: Icons.arrow_back_rounded,
            onTap: () => context.go('/'),
          ),
          Text(
            'SYSTEM CONFIG',
            style: GoogleFonts.pressStart2p(
              fontSize: 12,
              color: Colors.cyanAccent,
              shadows: [
                BoxShadow(color: Colors.cyan.withOpacity(0.5), blurRadius: 10),
              ],
              letterSpacing: 2,
            ),
          ),
          const SizedBox(width: 40), // Spacer
        ],
      ),
    );
  }

  Widget _buildGlassButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surfaceDark.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Icon(icon, color: Colors.white.withOpacity(0.8), size: 20),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: color.withOpacity(0.4), blurRadius: 10),
              ],
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.pressStart2p(
              fontSize: 10,
              color: color,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerSettings(
    BuildContext context,
    dynamic settings,
    dynamic notifier,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          _buildSlider(
            context,
            'FOCUS',
            (settings.focusDuration / 60).round(),
            5,
            60,
            Colors.white,
            (val) => notifier.updateFocusDuration(val.round()),
            '25m',
          ),
          _buildSlider(
            context,
            'SHORT BREAK',
            (settings.shortBreakDuration / 60).round(),
            1,
            15,
            AppColors.neonFuchsia,
            (val) => notifier.updateShortBreakDuration(val.round()),
            '05m',
          ),
          _buildSlider(
            context,
            'LONG BREAK',
            (settings.longBreakDuration / 60).round(),
            5,
            45,
            Colors.greenAccent, // Emerald replacement
            (val) => notifier.updateLongBreakDuration(val.round()),
            '15m',
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(
    BuildContext context,
    String label,
    int value,
    double min,
    double max,
    Color color,
    Function(double) onChanged,
    String displayValue,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.spaceGrotesk(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            Text(
              '${value}m',
              style: GoogleFonts.pressStart2p(color: color, fontSize: 12),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: color,
            inactiveTrackColor: Colors.white.withOpacity(0.1),
            thumbColor: Colors.white,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayColor: color.withOpacity(0.2),
            trackHeight: 4,
          ),
          child: Slider(
            value: value.toDouble(),
            min: min,
            max: max,
            onChanged: onChanged,
            // divisions: (max - min).toInt(), // Optional: steps
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildGameplaySettings(
    BuildContext context,
    dynamic settings,
    dynamic notifier,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Auto-Quest',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                'Auto-start next mission',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 10,
                ),
              ),
            ],
          ),
          Switch(
            value: settings.autoQuest,
            onChanged: (val) => notifier.toggleAutoQuest(val),
            activeThumbColor: AppColors.neonFuchsia,
            activeTrackColor: AppColors.neonFuchsia.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSettings(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              ref.read(themeProvider.notifier).setThemeMode(ThemeMode.dark);
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceDark.withOpacity(0.8)
                    : AppColors.surfaceDark.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? Colors.cyanAccent
                      : Colors.white.withOpacity(0.1),
                ),
                boxShadow: isDark
                    ? [
                        BoxShadow(
                          color: Colors.cyan.withOpacity(0.2),
                          blurRadius: 10,
                        ),
                      ]
                    : [],
              ),
              child: Column(
                children: [
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.darkBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.cyan.withOpacity(0.2),
                          border: Border.all(color: Colors.cyan, width: 1),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'DARK',
                        style: GoogleFonts.pressStart2p(
                          fontSize: 8,
                          color: isDark ? Colors.cyanAccent : Colors.grey,
                        ),
                      ),
                      if (isDark)
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.cyanAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () {
              ref.read(themeProvider.notifier).setThemeMode(ThemeMode.light);
            },
            child: Opacity(
              opacity: !isDark ? 1.0 : 0.5,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: !isDark
                      ? Colors.white.withOpacity(0.9)
                      : AppColors.surfaceDark.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: !isDark
                        ? Colors.purple
                        : Colors.white.withOpacity(0.1),
                  ),
                  boxShadow: !isDark
                      ? [
                          BoxShadow(
                            color: Colors.purple.withOpacity(0.2),
                            blurRadius: 10,
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Center(
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.purple.withOpacity(0.1),
                            border: Border.all(color: Colors.purple, width: 1),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'LIGHT',
                          style: GoogleFonts.pressStart2p(
                            fontSize: 8,
                            color: !isDark ? Colors.purple : Colors.grey,
                          ),
                        ),
                        if (!isDark)
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.purple,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSoundSettings(
    BuildContext context,
    dynamic settings,
    dynamic notifier,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.volume_mute, size: 20, color: Colors.grey),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: Colors.cyanAccent,
                    inactiveTrackColor: Colors.white.withOpacity(0.1),
                    thumbColor: Colors.cyanAccent,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6,
                    ),
                    trackHeight: 2,
                  ),
                  child: Slider(
                    value: 0.75, // Placeholder
                    onChanged: (val) {},
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.cyan.withOpacity(0.3)),
                ),
                child: const Icon(
                  Icons.volume_up,
                  size: 16,
                  color: Colors.cyanAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSoundOption('8-BIT', Icons.videogame_asset, true),
              ),
              const SizedBox(width: 8),
              Expanded(child: _buildSoundOption('LOFI', Icons.headset, false)),
              const SizedBox(width: 8),
              Expanded(child: _buildSoundOption('ZEN', Icons.landscape, false)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSoundOption(String label, IconData icon, bool selected) {
    final color = selected ? Colors.cyanAccent : Colors.white.withOpacity(0.5);
    final bgColor = selected
        ? Colors.cyan.withOpacity(0.1)
        : Colors.transparent;
    final borderColor = selected
        ? Colors.cyan.withOpacity(0.5)
        : Colors.white.withOpacity(0.05);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.pressStart2p(fontSize: 8, color: color),
          ),
        ],
      ),
    );
  }
}
