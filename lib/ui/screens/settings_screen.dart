import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_provider.dart';
import '../../core/constants.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SETTINGS',
          style: Theme.of(
            context,
          ).textTheme.displayLarge?.copyWith(fontSize: 20),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionHeader(context, 'TIMER'),
          _buildSlider(
            context,
            'Focus Duration',
            (settings.focusDuration / 60).round(),
            5,
            60,
            (val) => notifier.updateFocusDuration(val.round()),
          ),
          _buildSlider(
            context,
            'Short Break',
            (settings.shortBreakDuration / 60).round(),
            1,
            30,
            (val) => notifier.updateShortBreakDuration(val.round()),
          ),
          _buildSlider(
            context,
            'Long Break',
            (settings.longBreakDuration / 60).round(),
            5,
            60,
            (val) => notifier.updateLongBreakDuration(val.round()),
          ),
          const SizedBox(height: 20),
          _buildSectionHeader(context, 'PREFERENCES'),
          _buildSwitch(
            context,
            'Auto-Quest (Auto Start)',
            settings.autoQuest,
            (val) => notifier.toggleAutoQuest(val),
          ),
          _buildSwitch(
            context,
            'Sound Effects',
            settings.isSoundEnabled,
            (val) => notifier.toggleSound(val),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.electricBlue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSlider(
    BuildContext context,
    String label,
    int value,
    double min,
    double max,
    Function(double) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodyLarge),
              Text('$value min', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          Slider(
            value: value.toDouble(),
            min: min,
            max: max,
            divisions: (max - min).toInt(),
            activeColor: AppColors.electricBlue,
            inactiveColor: AppColors.glassBorder,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitch(
    BuildContext context,
    String label,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(label, style: Theme.of(context).textTheme.bodyLarge),
        value: value,
        activeThumbColor: AppColors.electricBlue,
        onChanged: onChanged,
      ),
    );
  }
}
