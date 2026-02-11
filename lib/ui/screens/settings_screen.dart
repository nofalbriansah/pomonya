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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSquircleBackButton(context, theme),
          Text(
            l10n.settingsTitle.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.onSurface,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(width: 40), // Symmetric spacer
        ],
      ),
    );
  }

  Widget _buildSquircleBackButton(BuildContext context, ThemeData theme) {
    return GestureDetector(
      onTap: () => context.go('/'),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: theme.colorScheme.onSurface,
          size: 18,
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
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Text(
            title.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: color,
              letterSpacing: 1.2,
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
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSlider(
            context,
            l10n.settingsFocus,
            (settings.focusDuration / 60).round(),
            5,
            60,
            theme.colorScheme.primary,
            (val) => notifier.updateFocusDuration(val.round()),
            theme,
          ),
          const Divider(height: 32),
          _buildSlider(
            context,
            l10n.settingsShortBreak,
            (settings.shortBreakDuration / 60).round(),
            1,
            15,
            theme.colorScheme.secondary,
            (val) => notifier.updateShortBreakDuration(val.round()),
            theme,
          ),
          const Divider(height: 32),
          _buildSlider(
            context,
            l10n.settingsLongBreak,
            (settings.longBreakDuration / 60).round(),
            5,
            45,
            theme.colorScheme.tertiary,
            (val) => notifier.updateLongBreakDuration(val.round()),
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
    ThemeData theme,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                color: theme.colorScheme.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${value}m',
                style: GoogleFonts.inter(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: color,
            inactiveTrackColor: color.withValues(alpha: 0.1),
            thumbColor: Colors.white,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 10,
              elevation: 4,
            ),
            overlayColor: color.withValues(alpha: 0.1),
            trackHeight: 6,
          ),
          child: Slider(
            value: value.toDouble(),
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settingsAutoQuest,
                  style: GoogleFonts.inter(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                Text(
                  l10n.settingsAutoQuestDesc,
                  style: GoogleFonts.inter(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: settings.autoQuest,
            onChanged: (val) => notifier.toggleAutoQuest(val),
            activeThumbColor: theme.colorScheme.primary,
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
    final currentMode = themeModeAsync.asData?.value ?? ThemeMode.system;

    return Row(
      children: [
        Expanded(
          child: _buildThemeOption(
            context,
            ref,
            l10n.settingsThemeDark,
            Icons.dark_mode_rounded,
            currentMode == ThemeMode.dark,
            ThemeMode.dark,
            theme,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildThemeOption(
            context,
            ref,
            l10n.settingsThemeLight,
            Icons.light_mode_rounded,
            currentMode == ThemeMode.light || currentMode == ThemeMode.system,
            ThemeMode.light,
            theme,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    WidgetRef ref,
    String label,
    IconData icon,
    bool isSelected,
    ThemeMode mode,
    ThemeData theme,
  ) {
    final activeColor = theme.colorScheme.primary;
    return GestureDetector(
      onTap: () => ref.read(themeProvider.notifier).setTheme(mode),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? activeColor : theme.colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: activeColor.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: isSelected ? activeColor : Colors.grey),
            const SizedBox(height: 12),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: isSelected ? activeColor : Colors.grey,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
      ),
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
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ENABLE SOUND',
                style: GoogleFonts.inter(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              Switch(
                value: settings.isSoundEnabled ?? true,
                onChanged: (val) => notifier.toggleSound(val),
                activeThumbColor: theme.colorScheme.primary,
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
    final color = selected ? theme.colorScheme.primary : Colors.grey;
    final bgColor = selected
        ? theme.colorScheme.primary.withValues(alpha: 0.1)
        : Colors.transparent;
    final borderColor = selected
        ? theme.colorScheme.primary
        : theme.colorScheme.outline;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: selected ? 2 : 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: color,
            ),
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
    final activeColor = theme.colorScheme.primary;
    return GestureDetector(
      onTap: () => ref.read(localeProvider.notifier).setLocale(code),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? activeColor : theme.colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: activeColor.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          children: [
            Text(flag, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 12),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: isSelected ? activeColor : Colors.grey,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
