import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants.dart';
import '../../providers/timer_provider.dart';
import '../widgets/mpus_animation.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Timer Display
            Text(
              _formatTime(timerState.remainingSeconds),
              style: Theme.of(
                context,
              ).textTheme.displayLarge?.copyWith(fontSize: 48),
            ),
            const SizedBox(height: 20),
            // Status
            Text(
              _getStatusText(timerState.type),
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.electricBlue),
            ),
            const SizedBox(height: 40),
            // Character Area
            MpusAnimation(
              isWorking:
                  timerState.status == TimerStatus.running &&
                  timerState.type == TimerType.focus,
              isBreak:
                  timerState.status == TimerStatus.running &&
                  timerState.type != TimerType.focus,
            ),
            const SizedBox(height: 40),
            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ControlButton(
                  icon: timerState.status == TimerStatus.running
                      ? Icons.pause
                      : Icons.play_arrow,
                  onPressed: () {
                    if (timerState.status == TimerStatus.running) {
                      ref.read(timerProvider.notifier).pause();
                    } else {
                      ref.read(timerProvider.notifier).start();
                    }
                  },
                ),
                const SizedBox(width: 20),
                _ControlButton(
                  icon: Icons.refresh,
                  onPressed: () {
                    ref.read(timerProvider.notifier).reset();
                  },
                ),
                const SizedBox(width: 20),
                _ControlButton(
                  icon: Icons.skip_next,
                  onPressed: () {
                    ref.read(timerProvider.notifier).skip();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _getStatusText(TimerType type) {
    switch (type) {
      case TimerType.focus:
        return 'FOCUS TIME';
      case TimerType.shortBreak:
        return 'SHORT BREAK';
      case TimerType.longBreak:
        return 'LONG BREAK';
    }
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _ControlButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.electricBlue),
        iconSize: 32,
        onPressed: onPressed,
      ),
    );
  }
}
