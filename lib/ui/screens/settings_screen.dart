import 'package:flutter/material.dart';
import '../../providers/settings_provider.dart';
import '../../providers/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:pomonya/l10n/generated/app_localizations.dart';
import '../../providers/locale_provider.dart';
import '../../data/settings_model.dart';
import '../../core/constants.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, theme, l10n),
            Expanded(
              child: settingsAsync.when(
                data: (settings) => ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.l,
                    AppSpacing.m,
                    AppSpacing.l,
                    100,
                  ),
                  children: [
                    _buildSectionHeader(
                      l10n.settingsFocus,
                      Icons.timer_outlined,
                      Colors.cyan,
                      theme,
                    ),
                    _buildTimerSettings(
                      context,
                      settings,
                      notifier,
                      theme,
                      l10n,
                    ),

                    const SizedBox(height: 32),

                    _buildSectionHeader(
                      l10n.settingsAutoQuest,
                      Icons.sports_esports_outlined,
                      Colors.purpleAccent,
                      theme,
                    ),
                    _buildGameplaySettings(
                      context,
                      settings,
                      notifier,
                      theme,
                      l10n,
                    ),

                    const SizedBox(height: 32),

                    _buildSectionHeader(
                      l10n.settingsTheme,
                      Icons.palette_outlined,
                      Colors.cyan,
                      theme,
                    ),
                    _buildThemeSettings(context, ref, theme, l10n),

                    const SizedBox(height: 32),

                    _buildSectionHeader(
                      l10n.settingsSound,
                      Icons.graphic_eq,
                      Colors.cyan,
                      theme,
                    ),
                    _buildSoundSettings(context, settings, notifier, theme),

                    const SizedBox(height: 32),

                    _buildSectionHeader(
                      l10n.settingsLanguage,
                      Icons.language,
                      Colors.orangeAccent,
                      theme,
                    ),
                    _buildLanguageSettings(context, ref, theme),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
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
            onTap: () => context.go('/'),
            theme: theme,
          ),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                l10n.settingsTitle,
                style: GoogleFonts.pressStart2p(
                  fontSize: 12,
                  color: theme.colorScheme.primary,
                  shadows: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.5),
                      blurRadius: 10,
                    ),
                  ],
                  letterSpacing: 2,
                ),
              ),
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
    required ThemeData theme,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: theme.cardTheme.color?.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.cardTheme.shape is RoundedRectangleBorder
                ? (theme.cardTheme.shape as RoundedRectangleBorder).side.color
                : AppColors.glassBorder,
          ),
        ),
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

  Widget _buildSectionHeader(
    String title,
    IconData icon,
    Color color,
    ThemeData theme,
  ) {
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
    SettingsModel settings,
    SettingsNotifier notifier,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardTheme.color?.withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.cardTheme.shape is RoundedRectangleBorder
              ? (theme.cardTheme.shape as RoundedRectangleBorder).side.color ??
                    AppColors.glassBorder
              : AppColors.glassBorder,
        ),
      ),
      child: Column(
        children: [
          _buildSlider(
            context,
            l10n.settingsFocus,
            (settings.focusDuration / 60).round(),
            5,
            60,
            theme.brightness == Brightness.dark
                ? theme.colorScheme.onSurface
                : theme.colorScheme.primary,
            (val) => notifier.updateFocusDuration(val.round()),
            '25m',
            theme,
          ),
          _buildSlider(
            context,
            l10n.settingsShortBreak,
            (settings.shortBreakDuration / 60).round(),
            1,
            15,
            AppColors.neonFuchsia,
            (val) => notifier.updateShortBreakDuration(val.round()),
            '05m',
            theme,
          ),
          _buildSlider(
            context,
            l10n.settingsLongBreak,
            (settings.longBreakDuration / 60).round(),
            5,
            45,
            Colors.greenAccent,
            (val) => notifier.updateLongBreakDuration(val.round()),
            '15m',
            theme,
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
    ThemeData theme,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.spaceGrotesk(
                color:
                    theme.textTheme.bodyMedium?.color?.withOpacity(0.7) ??
                    Colors.white.withOpacity(0.7),
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
            inactiveTrackColor: theme.dividerColor.withOpacity(0.2),
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
    SettingsModel settings,
    SettingsNotifier notifier,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color?.withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.cardTheme.shape is RoundedRectangleBorder
              ? (theme.cardTheme.shape as RoundedRectangleBorder).side.color ??
                    AppColors.glassBorder
              : AppColors.glassBorder,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.settingsAutoQuest,
                style: TextStyle(
                  color: theme.textTheme.bodyLarge?.color ?? Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                l10n.settingsAutoQuestDesc,
                style: TextStyle(
                  color:
                      theme.textTheme.bodyMedium?.color?.withOpacity(0.5) ??
                      Colors.white.withOpacity(0.5),
                  fontSize: 10,
                ),
              ),
            ],
          ),
          Switch(
            value: settings.autoQuest,
            onChanged: (val) => notifier.toggleAutoQuest(val),
            activeThumbColor: theme.colorScheme.secondary,
            activeTrackColor: theme.colorScheme.secondary.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSettings(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    final themeModeAsync = ref.watch(themeProvider);
    final isDark = themeModeAsync.asData?.value == ThemeMode.dark;

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              ref.read(themeProvider.notifier).setTheme(ThemeMode.dark);
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
                      ? theme.colorScheme.primary
                      : theme.dividerColor.withOpacity(0.1),
                ),
                boxShadow: isDark
                    ? [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.2),
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
                        l10n.settingsThemeDark,
                        style: GoogleFonts.pressStart2p(
                          fontSize: 8,
                          color: isDark
                              ? theme.colorScheme.primary
                              : theme.textTheme.bodySmall?.color,
                        ),
                      ),
                      if (isDark)
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
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
              ref.read(themeProvider.notifier).setTheme(ThemeMode.light);
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
                          l10n.settingsThemeLight,
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
    SettingsModel settings,
    SettingsNotifier notifier,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardTheme.color?.withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.cardTheme.shape is RoundedRectangleBorder
              ? (theme.cardTheme.shape as RoundedRectangleBorder).side.color ??
                    AppColors.glassBorder
              : AppColors.glassBorder,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ENABLE SOUND',
                style: TextStyle(
                  color: theme.textTheme.bodyLarge?.color ?? Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Switch(
                value: settings.isSoundEnabled ?? true,
                onChanged: (val) => notifier.toggleSound(val),
                activeThumbColor: theme.colorScheme.primary,
                activeTrackColor: theme.colorScheme.primary.withOpacity(0.3),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.volume_mute,
                size: 20,
                color: theme.iconTheme.color?.withOpacity(0.5) ?? Colors.grey,
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: theme.colorScheme.primary,
                    inactiveTrackColor: theme.dividerColor.withOpacity(0.2),
                    thumbColor: theme.colorScheme.primary,
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
                  color:
                      theme.cardTheme.color?.withOpacity(0.5) ??
                      Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.cyan.withOpacity(0.3)),
                ),
                child: Icon(
                  Icons.volume_up,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSoundOption(
                  '8-BIT',
                  Icons.videogame_asset,
                  true,
                  theme,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSoundOption('LOFI', Icons.headset, false, theme),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSoundOption('ZEN', Icons.landscape, false, theme),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSoundOption(
    String label,
    IconData icon,
    bool selected,
    ThemeData theme,
  ) {
    final color = selected
        ? theme.colorScheme.primary
        : theme.textTheme.bodyMedium?.color?.withOpacity(0.5) ??
              Colors.white.withOpacity(0.5);
    final bgColor = selected
        ? theme.colorScheme.primary.withOpacity(0.1)
        : Colors.transparent;
    final borderColor = selected
        ? theme.colorScheme.primary.withOpacity(0.5)
        : theme.dividerColor.withOpacity(0.1);

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

  Widget _buildLanguageSettings(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
  ) {
    final localeAsync = ref.watch(localeProvider);
    final String languageCode = localeAsync.asData?.value.languageCode ?? 'en';
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: _buildLanguageOption(
            context,
            ref,
            l10n.settingsLanguageEn,
            '🇺🇸',
            languageCode == 'en',
            'en',
            theme,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildLanguageOption(
            context,
            ref,
            l10n.settingsLanguageId,
            '🇮🇩',
            languageCode == 'id',
            'id',
            theme,
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    WidgetRef ref,
    String label,
    String flag,
    bool isSelected,
    String code,
    ThemeData theme,
  ) {
    return GestureDetector(
      onTap: () {
        ref.read(localeProvider.notifier).setLocale(code);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.1)
              : theme.cardTheme.color?.withOpacity(0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.dividerColor.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.2),
                    blurRadius: 8,
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Constrain height
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(flag, style: const TextStyle(fontSize: 24)),
            ),
            const SizedBox(height: AppSpacing.s),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.pressStart2p(
                  fontSize: 8,
                  color: isSelected
                      ? theme.primaryColor
                      : theme.textTheme.bodyMedium?.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
